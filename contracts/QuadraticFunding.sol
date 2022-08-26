//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract QuadraticFunding {
    struct Project {
        string name;
        address owner;
        string link;
        uint256[] contributions;
        uint256 publicAmount;
        uint256 rootSum;
        uint256 matchingSum;
        uint256 matchingShare;
    }

    Project[] public projects;
    mapping(uint256 => Project) public idToProjectMap;
    mapping(address => uint256[]) public addressToIdMap;

    function addProject(string calldata title, string calldata link) external {
        uint256[] memory array;
        Project memory tempProject = Project(
            title,
            msg.sender,
            link,
            array,
            0,
            0,
            0,
            0
        );
        uint256 id = projects.length;
        idToProjectMap[id] = tempProject;
        projects.push(tempProject);
        addressToIdMap[msg.sender].push(id);
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
