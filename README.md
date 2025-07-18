# Staking & Reward Distribution Protocol

This repository contains a **production-ready staking and reward distribution protocol** implemented in Solidity. It is designed to provide users the ability to stake ERC20 tokens and earn rewards distributed proportionally over time.

---

## 🚀 Project Overview

This project implements the core smart contracts for a staking protocol where users can:

- Stake ERC20 tokens (e.g., LP tokens or other staking tokens).
- Accrue rewards over time based on their stake amount and duration.
- Claim their earned rewards securely.

The reward distribution mechanism uses a **reward rate** and tracks per-user accrued rewards efficiently, ensuring gas optimization and fairness.

---

## 📂 Repository Structure

```text
.
├── src/
│   ├── RewardDistributor.sol       # Core reward distribution contract
│   ├── Staking.sol                 # Staking contract managing stakes and balances
│   ├── mocks/
│   │   └── MockERC20Token.sol      # Mock ERC20 token for testing
├── test/
│   ├── RewardDistribution.t.sol   # Test suite for reward distribution contract
│   ├── Staking.t.sol              # Test suite for staking contract
├── script/
│   └── Deploy.s.sol               # Deployment script for contracts
├── foundry.toml                   # Foundry configuration
└── README.md                     # This file
⚙️ Key Contracts
RewardDistributor.sol
Handles calculation and distribution of rewards to stakers based on staking balances and reward rate. It integrates with the Staking contract to get user balances and updates rewards on stake/unstake actions.

Staking.sol
Manages staking and unstaking of ERC20 tokens by users, maintains balances, and interacts with RewardDistributor to update rewards accordingly.

MockERC20Token.sol
ERC20 token used for local testing to simulate staking and reward tokens.

📖 Features
Stake and unstake ERC20 tokens with balance tracking.

Proportional reward distribution with real-time accrual.

Secure reward claiming.

Access control with OpenZeppelin’s Ownable.

Gas optimized reward calculations using stored variables.

Comprehensive unit tests with Foundry.

🛠 Development Setup
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/staking-reward-protocol.git
cd staking-reward-protocol
Install Foundry (if not already installed):

bash
Copy code
curl -L https://foundry.paradigm.xyz | bash
foundryup
Run tests:

bash
Copy code
forge test
🔍 Testing
The project includes unit tests covering:

Stake and unstake flows.

Reward accrual over simulated time.

Reward claiming logic.

Edge cases like zero stake or claim without staking.

Run all tests with:

bash
Copy code
forge test
📝 Usage
Deploy the staking token and reward token (can use MockERC20Token for tests).

Deploy the RewardDistributor contract with the reward token address.

Deploy the Staking contract with the staking token and reward distributor addresses.

Users can stake tokens via the Staking contract.

Rewards accrue automatically and can be claimed through the Staking contract, which interacts with RewardDistributor.

📚 Learning Outcomes
By studying this project, you will learn:

Building production-grade staking and reward contracts.

Efficient reward calculation algorithms.

Secure contract design with OpenZeppelin.

Integration patterns between staking and reward distribution.

Writing comprehensive test suites in Foundry.

🤝 Contributions
Contributions and improvements are welcome! Please open issues or submit pull requests.

⚖️ License
This project is licensed under the MIT License.

Author
Sai Siddush Thungathurthy

Email: thungasaisiddush@gmail.com

GitHub: github.com/thungasaisiddush

Thank you for visiting the project! 🚀