// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ICERC20.sol";

/// @author [Email](mailto:oluwafemialofe@yahoo.com) [Telegram](t.me/@DreWhyte)
contract DeFi{

    /// @dev Dia mainnet contract address
    address public underlyingAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    /// @dev cToken (cDai) mainnet contract address
    address public cTokenAddress = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;

    /// @dev 1 Dai
    uint public minimumDaiDeposit = 1 * 10 ** 18;

    /// @dev user Dia balances held in this protocol and not yet staked
    /// @dev string username BEP20/ERC20 address
    /// @dev uint user balance
    mapping (string => uint) public diaBalances;

    /// @param username P2P vendor name (UTF-8 bytes)
    /// @param balance Current liquidy of vendor
    /// @param buyRateMantissa vendors rate
    /// @param openOrders Any value greater than 0 means atleast 1 order is still active for this listing, therefore vendor can't remove ads
    struct listing {
      string username;
      uint value;
      uint buyRateMantissa;
      uint sellRateMantissa;
      uint minimumLimitMantissa;
      uint maximumLimitMantissa;
      uint[] openOrders;
    }

    struct order {
      string username;
      uint value;
      uint opened;
    }

    /// @param username Unique username (UTF-8 bytes)
    /// @param underlyingBal Total supplied to lending protocol
    /// @param substituteBal Total minted compilementary(cToken, vToken) tokens
    /// @param idleBal Total unused Dia balance, available to user anytime
    struct user {
      string username;
      uint underlyingBal;
      uint cTokenBal;
      uint registered;
      bool isUser;
    }

    mapping (string => user) public users;

    /// @dev address vendor
    /// @dev uint index in sellDaiListings
    mapping (address => uint) public sellDaiVendors;

    listing[] public sellDaiListings;

    order[] public orders;

    /// @dev Total liquidy available to savers
    uint public totalDiaLiquidity;

    /// @dev Total staked Dai via this contract till date
    uint public totalDaiSupplied;

    uint public exRateMantissa;

    event NewRegistration(string indexed username, uint indexed registered);

    event NewDaiListing(address indexed vendor, string indexed currency, string indexed order, uint _amount);

    event LiquidityAdded(address indexed vendor, uint amount);

    event DaiAdded(string indexed vendor, uint amount);

    event OrderApproved(string indexed vendor, string indexed username, uint amount);

    event ReserveBuy(address indexed vendor, string indexed username, uint amount);


    /// @dev New user registration
    /// @param _user struct consisting user registration
    function newUser(user memory _user) public returns (user memory _account) {
      require(users[_user.username].isUser != true, "Username already taken!");

      _user.registered  = block.timestamp;

      users[_user.username] = _user;

      emit NewRegistration(_user.username, block.timestamp);

      return users[_user.username];
    }

    /// @dev Called by vendor to add new listing to sell Dai
    function sellDiaAds(listing memory _listing, string memory _username) public {
      require(sellDaiVendors[msg.sender] >= 0, "You have an existing sell listing");
      require(diaBalances[_username] > _listing.value, "You dont have sufficient Dai to list ads");

      sellDaiListings.push(_listing);

      sellDaiVendors[msg.sender] = sellDaiListings.length - 1;

      emit NewDaiListing(msg.sender, 'dai', 'sell', _listing.value);
    }

    /// @dev Only call this function if approve token is already called
    /// @dev add Dai balance for vendor
    /// @param _amount In wei
    /// @dev Vendors sneds transactions using non-custodain wallet assigned during registration
    function addDiaLiquidity(string memory _username, uint _amount) public returns (bool) {
      require(msg.sender != address(0x0), "Invalid address");
      require(IERC20(underlyingAddress).allowance(msg.sender, address(this)) >= _amount, "First approve this contract to spend your Dai");
      require(_amount >= minimumDaiDeposit, "Minimum deposit of 1 Dai");

      bool _successful = IERC20(underlyingAddress).transferFrom(msg.sender, address(this), _amount);

      require(_successful, "Transfer unsuccessful!");

      diaBalances[_username] += _amount;
      totalDiaLiquidity += _amount;

      emit LiquidityAdded(msg.sender, _amount);

      return _successful;
    }

     /// @dev Lock some Dai on an Ad to be realse on approval or added back on reject
     /// @dev Function call by user performing P2P to get Dai
    function reserveBuy(address _adOwner, string memory _username, uint _amount) public returns(bool _status) {
        uint _index = sellDaiVendors[_adOwner];

        orders.push(order(_username,_amount,block.timestamp));

        sellDaiListings[_index].openOrders.push(orders.length - 1);

        //Reserve Dia for this trade
        sellDaiListings[_index].value -= _amount;

        emit ReserveBuy(_adOwner, _username, _amount);

        return true;
    }

    /// @dev Function call by vendor to approve buy.
    /// @dev Vendors sends transactions using non-custodain wallet assigned during registration
    function approveBuy(uint _orderIndex, uint _amount) public {
      uint _index = sellDaiVendors[msg.sender];
      listing memory _listing = sellDaiListings[_index];

      require(diaBalances[_listing.username] >= _amount, "Insufficient Balance");

      string memory _username = orders[_orderIndex].username;

      diaBalances[_listing.username] -= _amount;
      diaBalances[_username] += _amount;

      totalDiaLiquidity -= _amount;

      delete orders[_orderIndex];

      emit OrderApproved(_listing.username, _username, _amount);
    }

    function save(uint _amount, string memory _username) public returns(uint _exRate) {
      require(diaBalances[_username] >= _amount, "Insufficient Balance");

      uint _exRateMantissa = ICERC20(cTokenAddress).exchangeRateCurrent() * 1e10;

      // Approve transfer on the Dia contract
      IERC20(underlyingAddress).approve(cTokenAddress, _amount);

      // Mint cTokens
      assert(ICERC20(cTokenAddress).mint(_amount) == 0);

      user storage _user = users[_username];

      diaBalances[_username] -= _amount;
      _user.underlyingBal += _amount;
      _user.cTokenBal += _amount/_exRateMantissa;

      return _exRateMantissa;
    }

    function unsave(string memory _username)  public returns(uint _exRate) {
      user storage _user = users[_username];

      require(_user.underlyingBal > 0, "Insufficient Balance");

      uint _exRateMantissa = ICERC20(cTokenAddress).exchangeRateCurrent() * 1e10;

      assert(ICERC20(cTokenAddress).redeemUnderlying(_user.underlyingBal) == 0);

      diaBalances[_username] += _exRateMantissa * _user.underlyingBal;
      _user.underlyingBal = 0;
      _user.cTokenBal = 0;

      return _exRateMantissa;
    }

    function lookUpExRate() public returns (uint256 rate) {
      return ICERC20(cTokenAddress).exchangeRateCurrent();
    }

    function savingsInfo(string memory _username) public view returns(uint _redeemableBal, uint _rate, uint _ctokenBal)
    {
      user memory _user = users[_username];

      return(exRateMantissa * _user.underlyingBal, exRateMantissa, _user.cTokenBal);
    }
}
