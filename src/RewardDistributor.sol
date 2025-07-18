// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IRewardDistributor.sol";
import "./utils/MathUtils.sol";

contract RewardDistributor is IRewardDistributor, Ownable {
    using MathUtils for uint256;

    IERC20 public immutable rewardToken;
    address public staking;

    uint256 public rewardRate;
    uint256 public lastUpdate;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public balances;

    error NotStakingContract();
    error InvalidAddress();

    modifier onlyStaking() {
        if (msg.sender != staking) revert NotStakingContract();
        _;
    }

    event RewardUpdated(uint256 rewardRate);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(address _rewardToken) Ownable(msg.sender) {
        if (_rewardToken == address(0)) revert InvalidAddress();
        rewardToken = IERC20(_rewardToken);
    }

    function setStakingContract(address _staking) external onlyOwner {
        if (_staking == address(0)) revert InvalidAddress();
        staking = _staking;
    }

    function updateUserBalance(address user, uint256 balance) external override onlyStaking {
        _updateReward(user);
        balances[user] = balance;
    }

    function updateRewards(address user) external onlyStaking {
        _updateReward(user);
    }

    function _updateReward(address user) internal {
        rewardPerTokenStored = rewardPerToken();
        lastUpdate = block.timestamp;

        if (user != address(0)) {
            rewards[user] += earned(user);
            userRewardPerTokenPaid[user] = rewardPerTokenStored;
        }
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply() == 0) return rewardPerTokenStored;
        return rewardPerTokenStored + (rewardRate * (block.timestamp - lastUpdate) * 1e18) / totalSupply();
    }

    function totalSupply() public view returns (uint256 supply) {
        return IERC20(staking).totalSupply();
    }

    function earned(address user) public view returns (uint256) {
        return (balances[user] * (rewardPerToken() - userRewardPerTokenPaid[user])) / 1e18 + rewards[user];
    }

    function claimRewards(address user) external override onlyStaking returns (uint256) {
        _updateReward(user);
        uint256 reward = rewards[user];
        if (reward > 0) {
            rewards[user] = 0;
            rewardToken.transfer(user, reward);
            emit RewardClaimed(user, reward);
        }
        return reward;
    }

    function notifyRewardAmount(uint256 amount, uint256 duration) external onlyOwner {
        rewardRate = amount / duration;
        lastUpdate = block.timestamp;
        rewardPerTokenStored = rewardPerToken();
        rewardToken.transferFrom(msg.sender, address(this), amount);
        emit RewardUpdated(rewardRate);
    }

    function updatedRewards(address user) external override {}
}
