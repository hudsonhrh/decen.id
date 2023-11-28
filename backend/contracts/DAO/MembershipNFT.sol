pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MembershipNFT is ERC721, Ownable {
    uint256 private _currentTokenId = 0;

    constructor() ERC721("MembershipNFT", "MNFT") {}

    event TokenIssued(address indexed owner, uint256 tokenId);

    function issueToken(address to) public onlyOwner returns (uint256) {
        _currentTokenId++;
        uint256 newItemId = _currentTokenId;
        _mint(to, newItemId);
        emit TokenIssued(to, newItemId);
        return newItemId;
    }
}
