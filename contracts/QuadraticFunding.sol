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
    }

    function addPublicContribution(address projectOwner) external payable {
        require(publicContributionsPeriod, "Public contributions are halted");
        ownerToProject[projectOwner].publicAmount += msg.value;
    }
}

// get a list of projects -> store it somewhere -> ask for contribution from public -> add ability to stop getting public contribution ->
// calculate matched amount -> disburse said amount
