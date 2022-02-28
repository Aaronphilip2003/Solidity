// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SimpleStorage{

    uint256 public myNum;


    struct People{
        uint256 myFavNum;
        string name;
    }

    People[] public people;
    mapping(string=>uint256) public myFavNumber;

    function store(uint256 a) public{
        myNum=a;
    }

    function retrieve()public view returns(uint256){
        return myNum;
    }

    function addPerson(uint256 a, string memory b) public{
        people.push(People(a,b));
        myFavNumber[b]=a;
    }


}
