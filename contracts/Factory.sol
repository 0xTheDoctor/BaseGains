// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;
import "./Token.sol";
import "hardhat/console.sol";

contract Factory{

    struct tokens{
        string name;
        string symbol;
        string desc;
        string imgurl;
    }

    mapping(address => tokens) addressToTokenMap;

    uint constant Decimals = 10 ** 18;
    uint constant MaxSupply = 1000000 * Decimals;
    uint constant InitSupply = 20 * MaxSupply / 100;
    uint constant PlatformFee = 0.001 ether;

    function createToken(string memory _name, string memory _symbol, string memory _desc, string memory _imageurl)public payable returns(address){
        require(msg.value >= PlatformFee,"Cant cover Platform Fee");
        Token newTokenContract = new Token(_name,_symbol, InitSupply);
        address newTokenContractAdd = address(newTokenContract);
        tokens memory newToken = tokens(_name,_symbol,_desc,_imageurl);
        addressToTokenMap[newTokenContractAdd] = newToken;
        console.log(newTokenContractAdd);
        return newTokenContractAdd;

    }

}