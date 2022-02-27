// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SimpleStorage{


    struct People{
        uint256 favNum;
        string name;
    }

    uint256 favNum;

    People public person1=People({favNum:2,name:"aaron"});

    function store(uint256 a) public{
        favNum=a;
    }

    function retrieve() public view returns(uint256){
        return favNum;
    }

}
