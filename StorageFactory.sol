// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory{

  SimpleStorage[] public SimpleStorageArray;

    function createSimpleStorageContract() public{
         SimpleStorage simpleStorage = new SimpleStorage();
        SimpleStorageArray.push(simpleStorage);

    }





}
