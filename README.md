---

# NFT Marketplace Smart Contract

This project implements a basic NFT (Non-Fungible Token) Marketplace using Solidity. The marketplace allows users to mint, list, and buy NFTs. It follows the ERC721 standard and includes functionality for listing NFTs for sale, buying them, and delisting them.

## Features

- **NFT Minting**: The contract owner can mint new NFTs and assign them to specific recipients.
- **Listing NFTs for Sale**: NFT owners can list their tokens for sale at a specified price.
- **Buying NFTs**: Users can buy NFTs that are listed for sale by paying the correct price.
- **Delisting NFTs**: Owners can remove their NFTs from the marketplace.
- **Ownership Transfer**: The contract owner can transfer ownership to another address.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v12.x or later)
- [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com/)
- [Hardhat](https://hardhat.org/) (for testing, deployment, and running a local Ethereum environment)

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/nft-marketplace.git
cd nft-marketplace
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Compile the Smart Contracts

Use Hardhat to compile the contracts:

```bash
npx hardhat compile
```

### 4. Run Tests

To run the test suite, execute:

```bash
npx hardhat test
```

### 5. Deploy the Contract

You can deploy the contract to a local blockchain or a testnet (e.g., Sepolia):

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

Replace `sepolia` with the network of your choice.

## Contract Overview

### Functions

- **`mintNFT(address recipient, string memory tokenURI) returns (uint256)`**: 
  - Mints a new NFT with metadata stored in the `tokenURI`.
  - Only the contract owner can mint NFTs.

- **`listNFT(uint256 tokenId, uint256 price)`**: 
  - Lists an NFT owned by the caller for sale at the specified price.
  - The NFT owner must be the caller.

- **`buyNFT(uint256 tokenId)`**: 
  - Allows a user to buy an NFT by sending the required price in ETH.
  - Transfers the ownership of the NFT to the buyer and sends the payment to the seller.

- **`delistNFT(uint256 tokenId)`**: 
  - Removes an NFT from being listed for sale.
  - Only the owner of the NFT can delist it.

- **`getListing(uint256 tokenId) returns (address seller, uint256 price, bool isListed)`**: 
  - Returns the listing details for a given token ID.

- **`isNFTListed(uint256 tokenId) returns (bool)`**: 
  - Returns whether the NFT is currently listed for sale.

- **`transferOwnership(address newOwner)`**: 
  - Transfers ownership of the contract to another address.

### Events

- **`NFTMinted(uint256 tokenId, address owner)`**: Emitted when an NFT is successfully minted.
- **`NFTListed(uint256 tokenId, uint256 price)`**: Emitted when an NFT is listed for sale.
- **`NFTBought(uint256 tokenId, address buyer, uint256 price)`**: Emitted when an NFT is purchased.

## Security Considerations

- **Reentrancy Protection**: If your marketplace grows more complex, consider adding protections like the `ReentrancyGuard` from OpenZeppelin to prevent potential reentrancy attacks.
- **Access Control**: Currently, only the contract owner can mint NFTs. You may want to consider more flexible role-based permissions using OpenZeppelin’s `AccessControl`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) for their ERC721 and other useful libraries.
- [Hardhat](https://hardhat.org/) for making Ethereum development easier.

---