pragma solidity ^0.8.20;

interface IParticipationToken {
    function balanceOf(address account) external view returns (uint256);
}

contract VotingContract {
    IParticipationToken public token;

    struct Proposal {
        string description;
        uint voteCount;
    }

    Proposal[] public proposals;

    mapping(address => bool) public hasVoted;
    mapping(address => uint) public votes;

    constructor(address tokenAddress) {
        token = IParticipationToken(tokenAddress);
    }

    function createProposal(string memory description) public {
        proposals.push(Proposal({
            description: description,
            voteCount: 0
        }));
    }

    function vote(uint proposalIndex) public {
        require(!hasVoted[msg.sender], "Already voted");
        uint256 balance = token.balanceOf(msg.sender);
        require(balance > 0, "No tokens to vote");

        Proposal storage proposal = proposals[proposalIndex];
        proposal.voteCount += balance;
        hasVoted[msg.sender] = true;
        votes[msg.sender] = balance;
    }

    function getProposalCount() public view returns (uint) {
        return proposals.length;
    }
    
    function getProposalVotes(uint proposalIndex) public view returns (uint) {
        require(proposalIndex < proposals.length, "Invalid proposal index");
        return proposals[proposalIndex].voteCount;
    }


}
