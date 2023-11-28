pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MembershipNFT is ERC721 {
    uint256 private _currentTokenId = 0;
    address public owner;

    constructor() ERC721("MembershipNFT", "MNFT") {
        owner = msg.sender;
    }

    event TokenIssued(address member, uint256 tokenId);

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have the required privileges to do this"); //require statement
        _;
    }

    function issueToken(address to) public onlyOwner returns (uint256) {
        _currentTokenId++;
        uint256 newItemId = _currentTokenId;
        _mint(to, newItemId);
        emit TokenIssued(to, newItemId);
        return newItemId;
    }
}
