require('dotenv').config({ path: './.env.local' }); // Loading environment variables
const ethers = require('ethers'); // Importing ethers.js library

const MembershipNFT = require('../abi/MembershipNFT.json'); // Importing the MembershipNFT contract ABI
const ParticipationToken = require('../abi/ParticipationToken.json'); // Importing the ParticipationToken contract ABI
const VotingContract = require('../abi/VotingContract.json'); // Importing the VotingContract contract ABI

async function main() {
  // Extracting ABI and bytecode from imported JSON.
    const MembershipNFTAbi = MembershipNFT.abi;
    const MembershipNFTBytecode = MembershipNFT.bytecode;

    const ParticipationTokenAbi = ParticipationToken.abi;
    const ParticipationTokenBytecode = ParticipationToken.bytecode;

    const VotingContractAbi = VotingContract.abi;
    const VotingContractBytecode = VotingContract.bytecode;


  // Creating provider and wallet instances.
    const provider = new ethers.providers.JsonRpcProvider(process.env.NEXT_PUBLIC_INFURA_URL);
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Creating a ContractFactory instance to deploy the contract.
    const factory = new ethers.ContractFactory(
        MembershipNFTAbi,
        MembershipNFTBytecode,
        wallet
    );

    const factory2 = new ethers.ContractFactory(
        ParticipationTokenAbi,
        ParticipationTokenBytecode,
        wallet
    );

    const factory3 = new ethers.ContractFactory(
        VotingContractAbi,
        VotingContractBytecode,
        wallet
    );

    //deploy token
    const token = await factory2.deploy(10000);
    await token.deployed();
    console.log(`Token Contract deployed at address: ${token.address}`);

    //deploy voting
    const voting = await factory3.deploy(token.address);
    await voting.deployed();
    console.log(`Voting Contract deployed at address: ${voting.address}`);

    // deplopy nft 
    const nft = await factory.deploy();
    await nft.deployed();
    console.log(`NFT Contract deployed at address: ${nft.address}`);

    // testing voting contract
    const proposalDescription = "New Proposal Description";
    const createProposalTx = await voting.createProposal(proposalDescription);
    await createProposalTx.wait();
    console.log(`Proposal created: ${proposalDescription}`);

    const proposalCount = await voting.getProposalCount();
    const latestProposalIndex = proposalCount - 1;
    const voteTx = await voting.vote(latestProposalIndex);
    await voteTx.wait();
    console.log(`Voted on proposal index: ${latestProposalIndex}`);

    const votes = await voting.getProposalVotes(latestProposalIndex);
    console.log(`Votes for proposal index ${latestProposalIndex}: ${votes}`);




}

main()
  .then(() => process.exit(0)) // Exiting the process if the deployment is successful.
  .catch((error) => {
    console.error(error); // Logging any errors occurred during the deployment.
    process.exit(1); // Exiting the process with a non-zero status code.
  });