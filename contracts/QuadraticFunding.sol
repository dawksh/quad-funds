//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract QuadraticFunding {
    constructor(Project[] memory projectsArray) payable {
        for (uint256 i = 0; i < projectsArray.length; i++) {
            ownerToProject[projectsArray[i].owner] = projectsArray[i];
        }
        totalPool = msg.value;
    }

    uint256 totalPool;
    mapping(address => Project) public ownerToProject;
    bool publicContributionsPeriod;

    struct Project {
        string name;
        uint256 publicAmount;
        address owner;
        uint256[] contributions;
    }

    function addPublicContribution(address projectOwner) external payable {
        require(publicContributionsPeriod, "Public contributions are halted");
        ownerToProject[projectOwner].contributions.push(msg.value);
        ownerToProject[projectOwner].publicAmount += msg.value;
    }

    function calculateMatchedAmount(address projectOwner)
        external
        view
        returns (uint256)
    {
        uint256[] memory contributionsArray = ownerToProject[projectOwner]
            .contributions;
        uint256 sqrtSum = 0;
        for (uint256 i = 0; i < contributionsArray.length; i++) {
            sqrtSum += sqrt(contributionsArray[i]);
        }
        uint256 matchedAmount = sqrtSum**2 -
            ownerToProject[projectOwner].publicAmount;

        return matchedAmount;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// get a list of projects -> store it somewhere -> ask for contribution from public -> add ability to stop getting public contribution ->
// calculate matched amount -> disburse said amount
