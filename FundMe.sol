// SPDX-License-Identifier: UNLICENSED

pragma solidity >0.6.6 <0.9.0;

contract FundMe {

     mapping(address=>uint256)public AddressToNumber;

    function fund() public payable{

        AddressToNumber[msg.sender]+=msg.value;
    }



}
