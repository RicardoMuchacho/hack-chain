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

    // ------------------------------------------------------------------------
    //                          ADMIN-ONLY TESTS
    // ------------------------------------------------------------------------

    /// @notice Tests that only the owner can mint tokens.
    function testMintTokensOnlyAdmin() public {
        address recipient = vm.addr(4);
        uint256 amount = 50 ether;

        vm.prank(admin);
        _hacktoken.mintTokens(recipient, amount);
    }

    /// @notice Tests that only the owner can transfer ownership.
    function testTransferOwnerOnlyAdmin() public {
        address newAddress = vm.addr(6);

        vm.prank(randomUser);
        vm.expectRevert();
        _hacktoken.transferOwnershipCustom(newAddress);
    }

    /// @notice Tests that only the owner can pause the contract.
    function testPauseOwnerOnlyAdmin() public {
        vm.prank(admin);
        _hacktoken.pause();
    }

    /// @notice Tests that only the owner can unpause the contract.
    function testUnPauseOwnerOnlyAdmin() public {
        vm.prank(admin);
        _hacktoken.pause();

        vm.prank(admin);
        _hacktoken.unpause();
    }

   /// @notice Tests that minting tokens from a non-owner address reverts.
    function testMintTokensNotTheOwner() public {
        address recipient = vm.addr(5);
        uint256 amount = 10 ether;

        vm.prank(randomUser);
        vm.expectRevert();
        _hacktoken.mintTokens(recipient, amount);
    }


    // ------------------------------------------------------------------------
    //                              MINT TESTS
    // ------------------------------------------------------------------------

    /// @notice Tests that the owner can mint tokens to a recipient.
    function testMintTokens() public {
        address recipient = vm.addr(3);
        uint256 amount = 100 ether;

        vm.prank(admin);
        _hacktoken.mintTokens(recipient, amount);

        assertEq(_hacktoken.balanceOf(recipient), amount, "Recipient should have minted tokens");
        assertEq(_hacktoken.totalSupply(), amount, "Total supply should match minted amount");
    }

    /// @notice Tests that minting zero tokens reverts with the correct error message.
    function testMintTokensRevertsOnZeroAmount() public {
        address recipient = vm.addr(6);
        uint256 amount = 0;

        vm.prank(admin);
        vm.expectRevert();
        _hacktoken.mintTokens(recipient, amount);
    }

    function testMintTokensRevertsOnZeroAddress() public {
        vm.prank(admin);
        vm.expectRevert();
        _hacktoken.mintTokens(address(0), 13 ether);
    }

 
    // ------------------------------------------------------------------------
    //                              TRANSFER OWNER TESTS
    // ------------------------------------------------------------------------

    /// @notice Tests that the owner can transfer ownership successfully.
    function testTransferOwnerGood() public {
        address newAddress = vm.addr(6);

        vm.prank(admin);
        _hacktoken.transferOwnershipCustom(newAddress);
    }

    // ------------------------------------------------------------------------
    //                              BURN TESTS
    // ------------------------------------------------------------------------

    /// @notice Tests that only the owner can burn their own tokens and the total supply is updated.
    function testBurnTokensOnlyOwner() public {
        uint256 mintAmount = 10;
        uint256 burnAmount = 5;

        // Mint tokens to admin (owner)
        vm.prank(admin);
        _hacktoken.mintTokens(admin, mintAmount);

        // Burn tokens as admin (owner)
        vm.prank(admin);
        _hacktoken.burn(burnAmount);

        // Check that the balance and total supply are updated
        assertEq(_hacktoken.balanceOf(admin), mintAmount - burnAmount, "Owner's balance should decrease by burned amount");
        assertEq(_hacktoken.totalSupply(), mintAmount - burnAmount, "Total supply should decrease by burned amount");
    }

    /// @notice Tests that non-owners cannot burn tokens.
    function testBurnTokensNotOwnerReverts() public {
        uint256 mintAmount = 10;
        uint256 burnAmount = 5;

        // Mint tokens to randomUser
        vm.prank(admin);
        _hacktoken.mintTokens(randomUser, mintAmount);

        // Try to burn as randomUser (should revert)
        vm.prank(randomUser);
        vm.expectRevert();
        _hacktoken.burn(burnAmount);
    }

    /// @notice Tests that burning zero tokens reverts with the correct error message.
    function testBurnTokensRevertsOnZeroAmount() public {
        uint256 amount = 0;
        vm.expectRevert();
        _hacktoken.burn(amount);
    }

    /// @notice Tests that burning more tokens than balance reverts.
    function testBurnTokensInsufficientBalance() public {
        uint256 amount = 5;
        vm.expectRevert();
        _hacktoken.burn(amount);
    }


    // ------------------------------------------------------------------------
    //                            PAUSABLE TESTS
    // ------------------------------------------------------------------------

    function testPauseCorrectly() public {
        vm.prank(admin);
        _hacktoken.pause();
     }

    function testUnPauseCorrectly() public {
        vm.prank(admin);
        _hacktoken.pause();

        vm.prank(admin);
        _hacktoken.unpause();
     }

    /// @notice Tests that transfers are blocked when the contract is paused.
     function testTransferWhilePausedReverts() public {
         address recipient = vm.addr(7);
         uint256 amount = 10 ether;

         // Mint tokens to admin
         vm.prank(admin);
         _hacktoken.mintTokens(admin, amount);

         // Pause the contract
         vm.prank(admin);
         _hacktoken.pause();
            
         // Try to transfer while paused
         vm.prank(admin);
         vm.expectRevert();
         _hacktoken.transfer(recipient, amount);
     }


}