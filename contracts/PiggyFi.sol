// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import  "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import  "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./IERC20.sol";
import "./ICERC20.sol";

/// @author [Email](mailto:oluwafemialofe@yahoo.com) [Telegram](t.me/@DreWhyte)
contract PiggyFi is OwnableUpgradeable{

    /// @dev To take care of decimals during exchange
    uint public mantissa = 1e8;

    /// @dev Dia mainnet contract address
    address public underlying = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    /// @dev 1 Dai
    uint public minimumDaiDeposit = 1e18;

    /// @dev Imitate statuses from Venus and Compoud Protocol
    /// @param OK implicity converted to 0 by the compiler, 0 = success in aformentioned protocols
    enum Statuses{ OK }

    enum OrderType { BUY, SELL }

    /// @dev user Dia balances held in this protocol and not yet staked
    /// @dev bytes32 username BEP20/ERC20 address
    /// @dev uint user balance
    mapping (bytes32 => uint) public diaBalances;

    /// @param username P2P vendor name (UTF-8 bytes)
    /// @param balance Current liquidy of vendor
    /// @param buyRateMantissa vendors rate
    /// @param orders Any value greater than 0 means atleast 1 order is still active for this listing, therefore vendor can't remove ads
    struct listing {
      string username;
      uint balance;
      uint buyRateMantissa;
      uint sellRateMantissa;
      uint minimumLimitMantissa;
      uint maximumLimitMantissa;
      uint orders;
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
    /// @dev uint index in sellDaiVendors
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

    /// @dev Total liquidy available to savers
    uint public totalDiaLiquidity;

    /// @dev Total Fiat liquidy available to savers
    /// @dev decimals 8, where 1 NGN = 1e8
    uint public totalFiatLiquidityMantissa;

    /// @dev Total staked Dai via this contract till date
    uint public totalDaiSupplied;

    event NewRegistration(string indexed username, uint indexed registered);

    event NewDiaListing(address indexed vendor, string indexed currency, string indexed order, listing _listing);

    event NewFiatListing(string indexed vendor, string indexed currency, string indexed order, listing _listing);

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
    function newUser(user memory _user) public {
      require(users[_user.username].registered > 0, "Username already taken!");

      users[_user.username] = _user;
      users[_user.username].registered = block.timestamp;

      emit NewRegistration(_user.username, block.timestamp);
    }

    /// @dev Called by vendor to add new listing to sell Dai
    function sellDiaAds(listing memory _listing, string memory _username) public registered(_username) {
      require(sellDaiVendors[msg.sender] >= 0, "You have an existing sell listing");

      sellDaiListings.push(_listing);

      sellDaiVendors[msg.sender] = sellDaiListings.length;

      emit NewDiaListing(msg.sender, 'dai', 'sell', _listing);
    }

    /// @dev Called by vendor to add new listing to buy Dai
    function buyDiaAds(listing memory _listing, string memory _username) public registered(_username) {
      require(buyDaiVendors[msg.sender] >= 0, "You have an existing buy listing");

      buyDaiListings.push(_listing);

      buyDaiVendors[msg.sender] = buyDaiListings.length;

      emit NewDiaListing(msg.sender, 'dai', 'buy', _listing);
    }

    /// @dev Called by vendor to add new listing to sell Fiat
    function sellFiatAds(listing memory _listing, string memory _username) public registered(_username) {
      require(sellFiatVendors[_username] >= 0, "You have an existing sell listing");

      sellFiatListings.push(_listing);

      sellFiatVendors[_username] = sellDaiListings.length;

      emit NewFiatListing(_username, 'fiat', 'sell', _listing);
    }

    /// @dev Called by vendor to add new listing to buy Fiat
    function buyFiatAds(listing memory _listing, string memory _username) public registered(_username) {
      require(buyFiatVendors[_username] >= 0, "You have an existing buy listing");

      buyFiatListings.push(_listing);

      buyFiatVendors[_username] = buyDaiListings.length;

      emit NewFiatListing(_username, 'fiat', 'buy', _listing);
    }

    /// @dev Only call this function if approve token is already called
    /// @param _amount In wei
    function addDiaLiquidity(string memory _username, uint _amount) public registered(_username) {
      require(msg.sender != 0, "Invalid address");
      require(IERC20(underlying).allowance(msg.sender, address(this)) == _amount, "First approve this contract to spend your Dai");
      require(amount >= minimumDaiDeposit, "Minimum deposit of 1 Dai");


    }
}
