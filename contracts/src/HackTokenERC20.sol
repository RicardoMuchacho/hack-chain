// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity 0.8.24;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";      
import "@openzeppelin/contracts/access/Ownable.sol";         
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title HackToken
 * @dev ERC20 token with pausable transfers, minting, burning, and ownership transfer.
 * Uses OpenZeppelin libraries for security and standard compliance.
 */
contract HackToken is ERC20, Pausable, Ownable {

    // --- Constructor ---

    /**
     * @dev Deploys the HackToken contract.
     * The token name and symbol are fixed in this implementation.
     * The deployer becomes the initial owner.
     */
    constructor() ERC20("Hack Chain Token", "HACK") Ownable(){}

    // --- Events ---
    
    /// @dev Emitted when ownership is transferred to a new address.
    event TransferNewOwner(address indexed previousOwner, address indexed newOwner);

    /// @dev Emitted when new tokens are minted.
    event TokenMinted(address to, uint256 amount);

    /// @dev Emitted when tokens are burned.
    event TokenBurned(address indexed from, uint256 amount);

    // --- External functions ---

    /**
     * @notice Mint (create) new tokens and assign them to a specified address.
     * @dev Only the owner can call this function.
     * @param to_ The address to receive the newly minted tokens.
     * @param amount_ The amount of tokens to mint (in smallest units, usually wei).
     */
    function mintTokens(address to_, uint256 amount_) public onlyOwner {
        require(to_ != address(0), "Invalid address");
        require(amount_ > 0, "Amount must be greater than zero");
        _mint(to_, amount_);
        emit TokenMinted(to_, amount_);
    }

    /**
     * @notice Transfer ownership of the contract to a new address.
     * @dev Emits a custom `TransferNewOwner` event before transferring.
     * @param newOwner_ The address that will become the new owner.
     */
    function transferOwnershipCustom(address newOwner_) public onlyOwner {
        emit TransferNewOwner(owner(), newOwner_);
        transferOwnership(newOwner_);
    }

    /**
     * @notice Burn (destroy) a specified amount of your own tokens.
     * @dev Reduces the total token supply.
     * @param amount_ The amount of tokens to burn (in smallest units, usually wei).
     */
    function burn(uint256 amount_) public {
        require(balanceOf(msg.sender) >= amount_, "Insufficient balance to burn");
        require(amount_ > 0, "Amount must be greater than zero");
        _burn(msg.sender, amount_);
        emit TokenBurned(msg.sender, amount_);
    }

    /**
     * @notice Pause all token transfers.
     * @dev Only callable by the owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @notice Unpause token transfers.
     * @dev Only callable by the owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }
}
