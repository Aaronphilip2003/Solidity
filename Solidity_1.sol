// SPDX-License-Identifier: UNLICENSED
pragma solidity >0.6.0 <0.9.0;

contract SimpleStorage{

    uint256 public favoriteNumber;
    
    function store(uint256 _favoriteNumber) public {
        favoriteNumber=_favoriteNumber;
    }

    function retieve() public view returns(uint256){
        return favoriteNumber;
    }

}
