pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MembershipNFT is ERC721 {
    uint256 private _currentTokenId = 0;

    constructor() ERC721("MembershipNFT", "MNFT") {}

    function issueToken(address to) public returns (uint256) {
        _currentTokenId++;
        uint256 newItemId = _currentTokenId;
        _mint(to, newItemId);
        return newItemId;
    }
}
