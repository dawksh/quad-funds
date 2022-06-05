//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract QuadraticFunding {
    constructor(Project[] memory _projectsArray) payable {
        for (uint256 i = 0; i < _projectsArray.length; i++) {
            ownerToProject[_projectsArray[i].owner] = _projectsArray[i];
            ownersAddressArray.push(_projectsArray[i].owner);
        }
        totalPool = msg.value;
    }

    uint256 totalPool;
    mapping(address => Project) public ownerToProject;
    bool publicContributionsPeriod;
    address[] ownersAddressArray;
    uint256 totalMatched;

    struct Project {
        string name;
        uint256 publicAmount;
        address owner;
        uint256[] contributions;
        uint256 matchedAmount;
        uint256 proportionalMatchedAmount;
    }

    function addPublicContribution(address projectOwner) external payable {
        require(publicContributionsPeriod, "Public contributions are halted");
        ownerToProject[projectOwner].contributions.push(msg.value);
        ownerToProject[projectOwner].publicAmount += msg.value;
    }

    function calculateMatchedAmount(address projectOwner)
        external
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
        ownerToProject[projectOwner].matchedAmount = matchedAmount;
        return matchedAmount;
    }

    function calculateProportionalMatchedAmount(address projectOwner) external {
        require(totalMatched != 0, "Total amount not matched");
        uint256 matchAmount = ownerToProject[projectOwner].matchedAmount;
        uint256 proportionalMatchAmount = (matchAmount * totalPool) /
            totalMatched;
        ownerToProject[projectOwner]
            .proportionalMatchedAmount = proportionalMatchAmount;
    }

    function calculateTotalMatchedAmount() internal {
        for (uint256 i = 0; i < ownersAddressArray.length; i++) {
            uint256 matchAmount = ownerToProject[ownersAddressArray[i]]
                .matchedAmount;
            if (matchAmount == 0) {
                revert("Amounts not matched for all projects");
            }
            totalMatched += matchAmount;
        }
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
