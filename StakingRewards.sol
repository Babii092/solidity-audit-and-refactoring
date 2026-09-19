// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StakingRewards {
    address public admin;
    address[] public stakers;
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public rewardBalances;
    mapping(address => bool) public isStakerRegistered;

    constructor() {
        admin = msg.sender;
    }

    function stake() public payable {
        require(msg.value > 0, "Must stake more than 0");
        
        stakedBalances[msg.sender] += msg.value;
        
        if (!isStakerRegistered[msg.sender]) {
            stakers.push(msg.sender);
            isStakerRegistered[msg.sender] = true;
        }
    }

    function distributeBonus() public payable {
        require(msg.sender == admin, "Only admin can distribute");
        require(stakers.length > 0, "No stakers");
        require(msg.value > 0, "No bonus ETH provided");

        uint256 bonusPerStaker = msg.value / stakers.length;

        for (uint256 i = 0; i < stakers.length; i++) {
            rewardBalances[stakers[i]] += bonusPerStaker;
        }
    }

    function claimReward() public {
        uint256 reward = rewardBalances[msg.sender];
        require(reward > 0, "No rewards to claim");

        rewardBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: reward}("");
        require(success, "Reward transfer failed");
    }
}
