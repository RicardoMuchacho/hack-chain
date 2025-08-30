// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/HackTokenERC20.sol";

/// @title HackTokenERC20Test
/// @notice Unit tests for the HackTokenERC20 smart contract.
/// @dev Uses Foundry's forge-std Test utilities for setup, assertions, and cheatcodes.
contract HackTokenERC20Test is Test {

    HackToken _hacktoken;

    /// @notice The contract owner (admin).
    address public admin = vm.addr(1);

    /// @notice Random user (not the owner).
    address public randomUser = vm.addr(2);

    /// @notice Deploys the HackToken contract from the admin address before each test.
    function setUp() public {
        vm.startPrank(admin);
        _hacktoken = new HackToken();
        vm.stopPrank();
    }

    /// @notice Tests that the owner can mint tokens to a recipient.
    function testMintTokens() public {
        address recipient = vm.addr(3);
        uint256 amount = 100 ether;

        vm.prank(admin);
        _hacktoken.mintTokens(recipient, amount);

        assertEq(_hacktoken.balanceOf(recipient), amount, "Recipient should have minted tokens");
        assertEq(_hacktoken.totalSupply(), amount, "Total supply should match minted amount");
    }

    /// @notice Tests that only the owner can mint tokens.
    function testMintTokensOnlyOwner() public {
        address recipient = vm.addr(4);
        uint256 amount = 50 ether;

        vm.prank(admin);
        _hacktoken.mintTokens(recipient, amount);

        assertEq(_hacktoken.balanceOf(recipient), amount, "Only owner should be able to mint");
        assertEq(_hacktoken.totalSupply(), amount, "Total supply should match minted amount");
    }

    /// @notice Tests that minting tokens from a non-owner address reverts.
    function testMintTokensNotTheOwner() public {
        address recipient = vm.addr(5);
        uint256 amount = 10 ether;

        vm.prank(randomUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _hacktoken.mintTokens(recipient, amount);
    }

    /// @notice Tests that minting zero tokens reverts with the correct error message.
    function testMintTokensRevertsOnZeroAmount() public {
        address recipient = vm.addr(6);
        uint256 amount = 0;

        vm.prank(admin);
        vm.expectRevert("Amount must be greater than zero");
        _hacktoken.mintTokens(recipient, amount);
    }
}