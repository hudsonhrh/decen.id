pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ParticipationToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("ParticipationToken", "PTK") {
        _mint(msg.sender, initialSupply);
    }

    event Minted(address indexed to, uint256 amount);

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }
}
