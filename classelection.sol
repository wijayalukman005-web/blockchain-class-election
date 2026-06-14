// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ClassElection {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    uint256 public candidateCount;

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(
        uint256 id,
        string name
    );

    event VoteCast(
        address voter,
        uint256 candidateId
    );

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner can perform this action"
        );
        _;
    }

    function addCandidate(
        string memory name
    ) public onlyOwner {

        candidateCount++;

        candidates[candidateCount] = Candidate(
            candidateCount,
            name,
            0
        );

        emit CandidateAdded(
            candidateCount,
            name
        );
    }

    function vote(
        uint256 candidateId
    ) public {

        require(
            !hasVoted[msg.sender],
            "You have already voted"
        );

        require(
            candidateId > 0 &&
            candidateId <= candidateCount,
            "Invalid candidate"
        );

        hasVoted[msg.sender] = true;

        candidates[candidateId].voteCount++;

        emit VoteCast(
            msg.sender,
            candidateId
        );
    }

    function getCandidate(
        uint256 candidateId
    )
        public
        view
        returns(
            uint256,
            string memory,
            uint256
        )
    {
        Candidate memory c =
            candidates[candidateId];

        return (
            c.id,
            c.name,
            c.voteCount
        );
    }
}