// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import  "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import  "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./IBEP20.sol";
import "./IVBEP20.sol";

/// @author [Email](mailto:oluwafemialofe@yahoo.com) [Telegram](t.me/@DreWhyte)
contract PiggyFi is OwnableUpgradeable{

    /// @dev To take care of decimals during exchange
    uint public mantissa = 1e8;

    /// @dev Dia mainnet contract address
    address public underlying = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    /// @dev 1 Dai
    uint public minimumDaiDeposit = 1 * 10 ** 18;

    /// @dev Imitate statuses from Venus and Compoud Protocol
    /// @param OK implicity converted to 0 by the compiler, 0 = success in aformentioned protocols
    enum Statuses{ OK }

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
      uint substituteBal;
      uint idleBal;
      uint registered;
    }

    mapping (string => user) public users;

    /// @dev address vendor
    /// @dev uint index in buyDiaListings
    mapping (address => uint) public buyDaiVendors;

    /// @dev address vendor
    /// @dev uint index in sellDaiListings
    mapping (address => uint) public sellDaiVendors;

    /// @dev string vendor username
    /// @dev uint index in sellFiatListings
    mapping (string => uint) public buyFiatVendors;

    /// @dev string vendor username
    /// @dev uint index in sellFiatListings
    mapping (string => uint) public sellFiatVendors;

    listing[] public buyDaiListings;

    listing[] public sellDaiListings;

    listing[] public buyFiatListings;

    listing[] public sellFiatListings;

    order[] public orders;


    /// @dev Total liquidy available to savers
    uint public totalDiaLiquidity;

    /// @dev Total Fiat liquidy available to savers
    /// @dev decimals 8, where 1 NGN = 1e8
    uint public totalFiatLiquidityMantissa;

    /// @dev Total staked Dai via this contract till date
    uint public totalDaiSupplied;

    event NewRegistration(string indexed username, uint indexed registered);

    event NewDaiListing(address indexed vendor, string indexed currency, string indexed order, uint _amount);

    event NewFiatListing(string indexed vendor, string indexed currency, string indexed order, uint _amount);

    event LiquidityAdded(address indexed vendor, uint amount);

    event DaiAdded(address indexed vendor, uint amount);

    event ReserveBuy(address indexed vendor, string indexed username, uint amount);

    modifier registered(string memory _username) {
       require(users[_username].registered > 0, "Only registered users can perform this action");
       _;
    }

    /// @dev contract constructor called only once
    function __PiggyFi_init() internal initializer{
      __Ownable_init();
    }

    /// @dev Verify if username is still available
    function checkUsernameAvailablilty(string memory _username) public view returns (bool available) {
        return users[_username].registered > 0;
    }

    /// @dev New user registration
    /// @param _user struct consisting user registration
    function newUser(user memory _user) public returns (user memory _account) {
      require(users[_user.username].registered > 0, "Username already taken!");

      users[_user.username] = _user;
      users[_user.username].registered = block.timestamp;

      emit NewRegistration(_user.username, block.timestamp);

      return users[_user.username];
    }

    /// @dev Called by vendor to add new listing to sell Dai
    function sellDiaAds(listing memory _listing, string memory _username) public registered(_username) {
      require(sellDaiVendors[msg.sender] >= 0, "You have an existing sell listing");
      require(diaBalances[_username] >= _listing.value, "You dont have sufficient Dai to list ads");

      sellDaiListings.push(_listing);

      sellDaiVendors[msg.sender] = sellDaiListings.length;

      emit NewDaiListing(msg.sender, 'dai', 'sell', _listing.value);
    }

    /// @dev Called by vendor to add new listing to buy Dai
    function buyDiaAds(listing memory _listing, string memory _username) public registered(_username) {
      require(buyDaiVendors[msg.sender] >= 0, "You have an existing buy listing");

      buyDaiListings.push(_listing);

      buyDaiVendors[msg.sender] = buyDaiListings.length;

      emit NewDaiListing(msg.sender, 'dai', 'buy', _listing.value);
    }

    /// @dev Called by vendor to add new listing to sell Fiat
    function sellFiatAds(listing memory _listing, string memory _username) public registered(_username) {
      require(sellFiatVendors[_username] >= 0, "You have an existing sell listing");

      sellFiatListings.push(_listing);

      sellFiatVendors[_username] = sellDaiListings.length;

      emit NewFiatListing(_username, 'fiat', 'sell', _listing.value);
    }

    /// @dev Called by vendor to add new listing to buy Fiat
    /// @dev _listing.value is in mantissa (1e8) to take care of decimals
    function buyFiatAds(listing memory _listing, string memory _username) public registered(_username) {
      require(buyFiatVendors[_username] >= 0, "You have an existing buy listing");
      require(diaBalances[_username] >= _listing.value, "You dont have Dai to perform this action");

      buyFiatListings.push(_listing);

      buyFiatVendors[_username] = buyDaiListings.length;

      emit NewFiatListing(_username, 'fiat', 'buy', _listing.value);
    }

    /// @dev Only call this function if approve token is already called
    /// @dev add Dai balance for vendor
    /// @param _amount In wei
    /// @dev Vendors sneds transactions using non-custodain wallet assigned during registration
    function addDiaLiquidity(string memory _username, uint _amount) public registered(_username) returns (bool) {
      require(msg.sender != address(0x0), "Invalid address");
      require(IBEP20(underlying).allowance(msg.sender, address(this)) == _amount, "First approve this contract to spend your Dai");
      require(_amount >= minimumDaiDeposit, "Minimum deposit of 1 Dai");

      bool _successful = IBEP20(underlying).transfer(address(this), _amount);

      require(_successful, "Transfer unsuccessful!");

      diaBalances[_username] += _amount;
      totalDiaLiquidity += _amount;

      emit LiquidityAdded(msg.sender, _amount);

      return _successful;
    }

     /// @dev Lock some Dai on an Ad to be realse on approval or added back on reject
     /// @dev Function call by user performing P2P to get Dai
    function reserveBuy(address _adOwner, string memory _username, uint _amount) public registered(_username) returns(bool) {
        uint _index = buyDaiVendors[_adOwner];

        require(buyDaiListings[_index].value >= _amount,'Ads has been updated. Refresh page');
        require(keccak256(bytes(_username)) != keccak256(bytes(buyDaiListings[_index].username)), "You cannot reserve your own listing");

        orders.push(order({
          username: _username,
          value: _amount,
          opened: block.timestamp
        }));

        buyDaiListings[_index].openOrders.push(orders.length);

        //Reserve Dia for this trade
        buyDaiListings[_index].value -= _amount;

        emit ReserveBuy(_adOwner, _username, _amount);

        return true;
    }

    /// @dev Function call by vendor to approve buy.
    /// @dev Vendors sends transactions using non-custodain wallet assigned during registration
    function approveBuy(uint orderIndex, uint _amount) public {
      // assert(buyDaiListings[orderIndex].value >= _amount,'Ads was updated');
      uint _index = buyDaiVendors[msg.sender];
      require(buyDaiListings[_index].openOrders[orderIndex].value == _amount,'');

      string memory _username = buyDaiListings[_index].openOrders[orderIndex].username;

      diaBalances[_username] += _amount;

      delete buyDaiListings[_index].openOrders[orderIndex];

      emit DaiAdded(_username, _amount);
    }


    //approveBuy
    //Save
    //Withdraw
    //Write tests (add user, supply dia, reserveBuy, approveBuy, save, withdraw)
    //Write Nodejs version
}
