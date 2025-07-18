// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RewardDistributor.sol";
import "../src/mocks/MockERC20Token.sol";
import "../src/Staking.sol";

contract RewardDistributionTest is Test {
    RewardDistributor public distributor;
    MockERC20Token public stakingToken;
    MockERC20Token public rewardToken;
    Staking public staking;

    address user1 = address(1);
    address user2 = address(2);

    function setUp() public {
        stakingToken = new MockERC20Token("stakeToken", "STK");
        rewardToken = new MockERC20Token("RewardToken", "RWD");

        distributor = new RewardDistributor(
            address(rewardToken)
        );
        staking = new Staking(address(stakingToken),address(rewardToken));

        stakingToken.mint(user1, 1000e18);
        stakingToken.mint(user2, 1000e18);
        rewardToken.mint(address(distributor),1000e18);

        vm.startPrank(user1);
        stakingToken.approve(address(distributor), type(uint256).max);
        vm.stopPrank();

        vm.startPrank(user2);
        stakingToken.approve(address(distributor), type(uint256).max);
        vm.stopPrank();
    }


    function testStakeAndUnstake() public {
        vm.startPrank(user1);
        staking.stake(100e18);
        assertEq(staking.balances(user1), 100e18);
        staking.withdraw(50e18);
        assertEq(staking.balances(user1), 50e18);
        vm.stopPrank();

    }
    
}
