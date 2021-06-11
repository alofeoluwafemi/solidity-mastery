// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import  "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import  "@openzeppelin/contracts-upgradeable/access/OwnableUpgradable.sol";
import "./IERC20.sol";
import "./ICERC20.sol";

contract PiggyFi is Initializable{

    /// @dev To take care of decimals during exchange
    uint public mantissa = 1e8;

    uint public minimumFiatTnxAllowed = 100 * 10 ** 8;

    uint public maximumFiatTnxAllowed = 100000000 * 10 ** 8

    /// @dev Imitate statuses from Venus and Compoud Protocol
    /// @param OK implicity converted to 0 by the compiler, 0 = success in aformentioned protocols
    enum internal Statuses { OK }

    /// @dev user Dia balances held in this protocol and not yet staked
    /// @param address user BEP20/ERC20 address
    /// @param uint user balance
    mapping (address => uint) public diaBalances;

    /// @param name P2P vendor name
    /// @param balance Current liquidy of vendor
    /// @param buyRateMantissa vendors rate
    struct listing {
      bytes32 name;
      uint balance;
      uint buyRateMantissa;
      uint sellRateMantissa;
      uint minimumLimitMantissa;
      uint maximumLimitMantissa
      bool locked;
    }

    /// @param address vendor
    /// @param uint index in buyDiaListings
    mapping (address => uint) public buyDiaVendors;

    /// @param address vendor
    /// @param uint index in sellDiaListings
    mapping (address => listing) public sellDiaVendors;

    /// @param address vendor
    /// @param uint index in sellFiatListings
    mapping (address => listing) public buyFiatVendors;

    /// @param address vendor
    /// @param uint index in sellFiatListings
    mapping (address => listing) public sellFiatVendors;

    listing[] public buyDaiListings;

    listing[] public sellDaiListings;

    listing[] public buyFiatListings;

    listing[] public sellFiatListings;


    /// @dev Total liquidy available to savers
    uint public totalDiaLiquidity

    /// @dev Total Fiat liquidy available to savers
    /// @dev decimals 8, where 1 NGN = 1e8
    uint public totalFiatLiquidityMantissa

    /// @dev Total staked Dai via this contract till date
    uint public totalDaiSupplied;

    function __PiggyFinance_init() internal initializer{
      __Ownable_init();
    }
}
