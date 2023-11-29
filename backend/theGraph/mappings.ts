// Import necessary modules
import { Address, BigInt, log } from '@graphprotocol/graph-ts';
import {
  MembershipNFT as MembershipNFTContract,
  TokenIssued as TokenIssuedEvent,
} from './generated/MembershipNFT/MembershipNFT';
import {
  ParticipationToken as ParticipationTokenContract,
  Minted as MintedEvent,
} from './generated/ParticipationToken/ParticipationToken';
import {
  VotingContract as VotingContractContract,
  ProposalCreated as ProposalCreatedEvent,
  Voted as VotedEvent,
} from './generated/VotingContract/VotingContract';

// Import generated entities
import { MembershipNFT, ParticipationToken, Proposal, VotingEvent } from './generated/schema';

// Handle TokenIssued event from MembershipNFT contract
export function handleMembershipNFTTokenIssued(event: TokenIssuedEvent): void {
  let entity = new MembershipNFT(event.transaction.hash.toHex() + '-' + event.logIndex.toString());
  entity.owner = event.params.member;
  entity.tokenId = event.params.tokenId;
  entity.save();
}

// Handle Minted event from ParticipationToken contract
export function handleParticipationTokenMinted(event: MintedEvent): void {
  let entity = new ParticipationToken(event.transaction.hash.toHex() + '-' + event.logIndex.toString());
  entity.owner = event.params.to;
  entity.balance = event.params.amount;
  entity.save();
}

// Handle ProposalCreated event from VotingContract contract
export function handleVotingContractProposalCreated(event: ProposalCreatedEvent): void {
    let entity = new Proposal(event.params.proposalIndex.toString());
    entity.description = event.params.description;
    entity.voteCount = BigInt.fromI32(0);
    entity.save();
}

// Handle Voted event from VotingContract contract
export function handleVotingContractVoted(event: VotedEvent): void {
  let proposal = Proposal.load(event.params.proposalIndex.toString());
  if (proposal == null) {
    log.error('Attempted to vote on a non-existent proposal: {}', [event.params.proposalIndex.toString()]);
    return;
  }

  let voter = event.params.voter;
  let voteAmount = event.params.voteAmount;

  proposal.voteCount = proposal.voteCount.plus(voteAmount);
  proposal.save();

  let votingEvent = new VotingEvent(event.transaction.hash.toHex() + '-' + event.logIndex.toString());
  votingEvent.proposalIndex = event.params.proposalIndex;
  votingEvent.voter = voter;
  votingEvent.voteAmount = voteAmount;
  votingEvent.save();
  
}
