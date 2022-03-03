// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

     mapping(address=>uint256)public AddressToNumber;
     address public owner;
     address[] public funders;

     constructor(){
         owner=msg.sender;
     }

     modifier onlyOwner{
         require(msg.sender==owner);
         _;
     }

    function fund() public payable{

        uint256 minValue=50*10**18;

        require(getConversionRate(msg.value)>=minValue,"You need to spend more ETH!");

        AddressToNumber[msg.sender]+=msg.value;
        funders.push(msg.sender);   
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

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 EthAmtinUSD = (ethPrice * ethAmount)/ 100000000;
        return EthAmtinUSD;
    }

    function withdraw() payable onlyOwner public{
        payable(msg.sender).transfer(address(this).balance);
        
        for(uint256 fundersIndex=0;fundersIndex<funders.length;fundersIndex++)
        {
            address funder = funders[fundersIndex]; // 0 funder --> 1st address 
            AddressToNumber[funder]=0; // AddressToNumber[1st address] = value
        }

        funders=new address[](0);
    }


}

// funders = [0x1234, 0x5678]
// funder= funder[0] // 0x1234
// AddressToNumber[0x1234] = 0
