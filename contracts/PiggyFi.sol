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

    uint public minimumFiatTnxAllowed = 100 * 10 ** 8;

    uint public maximumFiatTnxAllowed = 100000000 * 10 ** 8;

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

    mapping (bytes32 => user) public users;

    /// @dev address vendor
    /// @dev uint index in buyDiaListings
    mapping (address => uint) public buyDiaVendors;

    /// @dev address vendor
    /// @dev uint index in sellDiaListings
    mapping (address => uint) public sellDiaVendors;

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

    event NewListing(address indexed vendor, string indexed currency, string indexed order, uint listing);

    /// @dev contract constructor called only once
    function __PiggyFi_init() internal initializer{
      __Ownable_init();
    }

    function checkUsernameAvailablilty(string username) public returns (bool available) {
        return (users[_user.username] == 0);
    }

    /// @dev New user registration
    /// @param _user struct consisting user registration
    function newUser(user _user) public {
      require(users[_user.username] == 0, "Username already taken!");

      users[_user.username] = _user;
      users[_user.username].registered = block.timestamp;

      emit NewRegistration(_user.username, block.timestamp);
    }

    /// @dev Called by vendor to add new listing to sell Dai
    function sellDiaListing(listing _listing) public {
      require(sellDiaVendors[msg.sender] == 0, "You have an active listing");

      uint _index = sellDaiListings.push(_listing);

      sellDiaVendors[msg.sender] = _index;
      
      emit NewListing(msg.sender, 'Dai', 'Sell', _listing);
    }

}
