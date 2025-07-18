// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

interface IRewardDistributor {
    function updatedRewards(address user) external;
    function claimRewards(address user) external returns (uint256);
    function updateUserBalance(address user, uint256 amount) external;
}
