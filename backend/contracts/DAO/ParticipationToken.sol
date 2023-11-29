pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ParticipationToken is ERC20 {
    address public owner;

    constructor(uint256 initialSupply) ERC20("ParticipationToken", "PTK") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
        
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have the required privileges to do this"); //require statement
        _;
    }



    event Minted(address to, uint256 amount);

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }
}
