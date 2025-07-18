// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IRewardDistributor.sol";

contract Staking is Ownable {
    IERC20 public immutable stakingToken;
    IRewardDistributor public rewardDistributor;

    mapping(address => uint256) public balances;
    uint256 public totalSupply;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 reward);

    error ZeroAmount();
    error InsufficientBalance();

    constructor(address _stakingToken, address _rewardDistributor) Ownable(msg.sender) {
        if (_stakingToken == address(0) || _rewardDistributor == address(0)) revert ZeroAmount();
        stakingToken = IERC20(_stakingToken);
        rewardDistributor = IRewardDistributor(_rewardDistributor);
    }

    function stake(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        rewardDistributor.updatedRewards(msg.sender);

        stakingToken.transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        totalSupply += amount;

        rewardDistributor.updateUserBalance(msg.sender, balances[msg.sender]);
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();
        if (balances[msg.sender] < amount) revert InsufficientBalance();

        rewardDistributor.updatedRewards(msg.sender);

        balances[msg.sender] -= amount;
        totalSupply -= amount;
        stakingToken.transfer(msg.sender, amount);

        rewardDistributor.updateUserBalance(msg.sender, balances[msg.sender]);
        emit Withdrawn(msg.sender, amount);
    }

    function claim() external {
        uint256 reward = rewardDistributor.claimRewards(msg.sender);
        emit RewardClaimed(msg.sender, reward);
    }
}
