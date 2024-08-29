# Reentrancy Attack Demonstration

This repository contains a Solidity-based demonstration of a classic blockchain vulnerability known as the Reentrancy Attack. The goal is to educate developers about this potential threat and show how it can be exploited.

## Table of Contents

- [Reentrancy Attack Demonstration](#reentrancy-attack-demonstration)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [How It Works](#how-it-works)
  - [Code Explanation](#code-explanation)
    - [VulnerableContract](#vulnerablecontract)
    - [AttackerContract](#attackercontract)
  - [Security Implications](#security-implications)
  - [License](#license)

## Project Overview

This project consists of two smart contracts within a single file (reentrancyAttack.sol):

1. `VulnerableContract`: A contract that simulates a simple bank-like functionality where users can deposit and withdraw Ether.
2. `AttackerContract`: A malicious contract designed to exploit the vulnerability in `VulnerableContract`.

The demonstration showcases how the attacker can drain all funds from the vulnerable contract using a reentrancy attack.

## How It Works

The reentrancy attack exploits the fact that external calls can execute arbitrary code before the current function finishes executing. In our case:

1. The `withdraw` function in `VulnerableContract` sends Ether to the caller before updating its internal balance.
2. The `AttackerContract` takes advantage of this by repeatedly calling `withdraw` through its fallback function.
3. This creates a recursive loop where the attacker drains the contract's funds without ever actually reducing their own balance.

## Code Explanation

### VulnerableContract

This contract has three main functions:

- `deposit()`: Allows users to deposit Ether into the contract.
- `withdraw(uint256 _amount)`: Withdraws specified amount of Ether. This function contains the vulnerability.
- `getBalance()`: Returns the contract's current balance.

The critical flaw is in the `withdraw` function, where it sends Ether to the caller before updating the balance.

### AttackerContract

This contract exploits the vulnerability:

- `fallback()` function: Automatically called when Ether is sent to the contract. It recursively calls `withdraw` on the vulnerable contract.
- `attack()` function: Initiates the attack sequence.
- `collect()` function: Transfers stolen funds to the owner.

## Security Implications

Reentrancy attacks can have severe consequences, potentially leading to loss of funds or control over a system. They highlight the importance of careful state management and input validation in smart contracts.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
