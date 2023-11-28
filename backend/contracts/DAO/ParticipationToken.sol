pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ParticipationToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("ParticipationToken", "PTK") {
        _mint(msg.sender, initialSupply);
    }
}
