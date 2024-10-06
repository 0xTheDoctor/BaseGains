// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{

    address owner;
    constructor(string memory name, string memory symbol, uint256 initMintValue) ERC20(name,symbol){
        _mint(msg.sender, initMintValue);
        owner = msg.sender;
    }

    function mint(uint _quantity, address _reciever) external returns(uint){
        require(msg.sender==owner,"you are not owner");
        _mint(_reciever, _quantity);
        return 1;
    }
}