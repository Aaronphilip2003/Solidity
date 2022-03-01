// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage{

  SimpleStorage[] public storageArray;

  function createStorageContract() public{
    SimpleStorage s=new SimpleStorage();
    storageArray.push(s);

  }

  function sfStore(uint256 index,uint256 num)public{
    SimpleStorage simpleStorage=SimpleStorage(address(storageArray[index]));
    simpleStorage.store(num);
  }

  function sfGet(uint256 index)public view returns(uint256){
    SimpleStorage simpleStorage=SimpleStorage(address(storageArray[index]));
    return simpleStorage.retrieve();
  }

}
