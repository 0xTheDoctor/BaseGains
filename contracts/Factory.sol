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
        uint totalRaised;
        address tokenAdd;
        address owner;
    }

    address[] public tokenAddresses;

    mapping(address => tokens) addressToTokenMap;

    uint constant Decimals = 10 ** 18;
    uint constant MaxSupply = 1000000 * Decimals;
    uint constant InitSupply = 20 * MaxSupply / 100;
    uint constant PlatformFee = 0.001 ether;

    uint constant fundingGoal = 25 ether;
    uint256 public constant InitialPrice = 30000000000000; 
    uint256 public constant K = 8 * 10**15;

     function calculateCost(uint256 currentSupply, uint256 tokensToBuy) public pure returns (uint256) {
        
        uint256 exponent1 = (K * (currentSupply + tokensToBuy)) / 10**18;
        uint256 exponent2 = (K * currentSupply) / 10**18;

        uint256 exp1 = exp(exponent1);
        uint256 exp2 = exp(exponent2);

        uint256 cost = (InitialPrice * 10**18 * (exp1 - exp2)) / K;  
        return cost;
    }

    function exp(uint256 x) internal pure returns (uint256) {
        uint256 sum = 10**18;  // Start with 1 * 10^18 for precision
        uint256 term = 10**18;  // Initial term = 1 * 10^18
        uint256 xPower = x;  // Initial power of x
        
        for (uint256 i = 1; i <= 20; i++) {  // Increase iterations for better accuracy
            term = (term * xPower) / (i * 10**18);  // x^i / i!
            sum += term;

            // Prevent overflow and unnecessary calculations
            if (term < 1) break;
        }

        return sum;
    }
    
    function createToken(string memory _name, string memory _symbol, string memory _desc, string memory _imageurl)public payable returns(address){
        require(msg.value >= PlatformFee,"Cant cover Platform Fee");
        Token newTokenContract = new Token(_name,_symbol, InitSupply);
        address newTokenContractAdd = address(newTokenContract);
        tokens memory newToken = tokens(_name,_symbol,_desc,_imageurl,0, newTokenContractAdd, msg.sender);
        addressToTokenMap[newTokenContractAdd] = newToken;
        tokenAddresses.push(newTokenContractAdd);
        console.log(newTokenContractAdd);
        return newTokenContractAdd;

    }

    function buyToken(address _token, uint _amount)public payable returns(uint){
        require(addressToTokenMap[_token].tokenAdd!=address(0), "Token doesnt exist");
        require(addressToTokenMap[_token].totalRaised<=fundingGoal,"Funding goal is completed");
        
        Token tokenContract = Token(_token);
        uint currSupply = tokenContract.totalSupply();
        uint AvailSupply = MaxSupply-currSupply;
        uint AvailSupplyScaled = AvailSupply / Decimals;
        uint BuyAmountScaled = _amount * Decimals; 
        
        require(_amount<=AvailSupplyScaled,"Buy amount exceeded");

        
        uint currSupplyScaled = (currSupply - InitSupply) / Decimals;
        uint requiredEth = calculateCost(currSupplyScaled, _amount);
        console.log(requiredEth);

        require(msg.value>=requiredEth,"amount more than required");
        //tokens storage listedToken = addressToTokenMap[_token];
        addressToTokenMap[_token].totalRaised += msg.value;
        tokenContract.mint(BuyAmountScaled,msg.sender);

        if(addressToTokenMap[_token].totalRaised>= fundingGoal){
            //Create Liq Pool
        }

        return requiredEth;
    }

}