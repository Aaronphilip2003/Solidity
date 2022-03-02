// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

     mapping(address=>uint256)public AddressToNumber;

    function fund() public payable{

        AddressToNumber[msg.sender]+=msg.value;
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        return priceFeed.version();      

    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        (,int price,,,) = priceFeed.latestRoundData();

        return uint256(price);       

    }


}
