pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MembershipNFT is ERC721 {
    uint256 private _currentTokenId = 0;
    address public owner;

    struct User {
        uint256 votes;
        uint256 participationAmount;
        bool exists; // Flag to check if the user struct has been initialized
    }

    // Mapping from user address to User struct
    mapping(address => User) private users;

    // Mapping to track if an address has been issued a token
    mapping(address => bool) private hasToken;

    constructor() ERC721("MembershipNFT", "MNFT") {
        owner = msg.sender;
    }

    event TokenIssued(address member, uint256 tokenId);
    event UserDataUpdated(address user, uint256 votes, uint256 participationAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "You do not have the required privileges to do this");
        _;
    }

    modifier onlyTokenHolder(address user) {
        require(hasToken[user], "User must own a token to update information");
        _;
    }

    function issueToken(address to) public onlyOwner returns (uint256) {
        _currentTokenId++;
        uint256 newItemId = _currentTokenId;
        _mint(to, newItemId);
        hasToken[to] = true;

        // Initialize user data to zero if not already set
        if (!users[to].exists) {
            users[to] = User({votes: 0, participationAmount: 0, exists: true});
        }

        emit TokenIssued(to, newItemId);
        return newItemId;
    }

    function updateUser(address user, uint256 newVotes, uint256 newParticipationAmount) public onlyTokenHolder(user) {
        users[user].votes = newVotes;
        users[user].participationAmount = newParticipationAmount;
        emit UserDataUpdated(user, newVotes, newParticipationAmount);
    }

    // Functions to get user data
    function getUserVotes(address user) public view returns (uint256) {
        require(users[user].exists, "User does not exist");
        return users[user].votes;
    }

    function getUserParticipationAmount(address user) public view returns (uint256) {
        require(users[user].exists, "User does not exist");
        return users[user].participationAmount;
    }
}
