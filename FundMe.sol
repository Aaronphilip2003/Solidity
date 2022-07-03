pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract fundMe{
    using SafeMathChainlink for uint256;

    // mapping address to the amount deposited
    mapping(address=>uint256) public addressToAmountFeed;
    address[] public funders; //address of the people who deposited ETH
    address public owner;// address of the owner ie the person who deployed the contract

    constructor() public{
        owner=msg.sender;
    }

    function fund() public payable{
        uint256 minimumUSD=50*10**18;
        require(getConversionRate(msg.value)>=minimumUSD,"You need to spend more ETH!");
        addressToAmountFeed[msg.sender]+=msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    return priceFeed.version();
    }

    function getPrice()public view returns(uint256){
        AggregatorV3Interface priceFeed=AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer*10000000000);
    }

    function getConversionRate(uint256 ethAmount)public view returns(uint256){
        uint256 ethPrice=getPrice();
        uint256 ethAmountInUSD=(ethPrice*ethAmount)/1000000000000000000;
        return ethAmountInUSD;
    }

    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }

    function withdraw() payable onlyOwner public{
        payable(msg.sender).transfer(address(this).balance);
        for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++)
        {
            address funder=funders[funderIndex];
            addressToAmountFeed[funder]=0;
        }
        funders=new address[](0);
    }


}
