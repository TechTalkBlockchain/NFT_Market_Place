// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract marketPlace is ERC721URIStorage {
    uint256 private _tokenIdCounter;
    address private _owner;

    struct Advertising {
        address seller;
        uint256 price;
        bool isAdvert;
    }

    mapping(uint256 => Advertising) public adverts;

    event NFTBought(uint256 tokenId, address buyer, uint256 price);
    event NFTMinted(uint256 tokenId, address owner);
    event NFTAdvertised(uint256 tokenId, uint256 price);

    error NotOwner();
    error PriceZero();
    error NFTNotForSale();
    error IncorrectPrice();
    error ZeroAddress();
    error CallerNotOwner();

    modifier onlyOwner() {
        if (msg.sender != _owner) revert NotOwner();
        _;
    }

    constructor() ERC721("P_NFT_MARKETPLACE", "PNFTM") {
        _owner = msg.sender; 
    }

   function mintNFT(address recipient, string memory tokenURI) public payable onlyOwner returns (uint256) {
    if (recipient == address(0)) revert ZeroAddress();
    uint256 mintingFee = 0.01 ether; 


    if (msg.value != mintingFee) revert IncorrectPrice();

    _tokenIdCounter++;
    uint256 newTokenId = _tokenIdCounter;
    
    _mint(recipient, newTokenId);
    _setTokenURI(newTokenId, tokenURI);

    emit NFTMinted(newTokenId, recipient);
    return newTokenId;
    }

    function AdvertiseNFT(uint256 tokenId, uint256 price) public {
        if (ownerOf(tokenId) != msg.sender) revert NotOwner();
        if (price == 0) revert PriceZero();

        adverts[tokenId] = Advertising(msg.sender, price, true);

        emit NFTAdvertised(tokenId, price);
    }

    function buyNFT(uint256 tokenId) public payable {
        Advertising memory advertising = adverts[tokenId];

        if (!advertising.isAdvert) revert NFTNotForSale();
        if (msg.value != advertising.price) revert IncorrectPrice();

        address seller = advertising.seller;
        
        // Transfer the NFT to the buyer
        _transfer(seller, msg.sender, tokenId);

        // Transfer the payment to the seller
        (bool success, ) = seller.call{value: msg.value}("");
        require(success, "Payment transfer failed");

        // Remove the Advertising
        adverts[tokenId].isAdvert = false;

        emit NFTBought(tokenId, msg.sender, msg.value);
    }

    function getAdvert(uint256 tokenId) public view returns (address seller, uint256 price, bool isAdvert) {
        Advertising memory advertising = adverts[tokenId];
        return (advertising.seller, advertising.price, advertising.isAdvert);
    }

    function getAllAdverts() public view returns (Advertising[] memory) {
        uint256 numAdvertising = _tokenIdCounter;
        Advertising[] memory AdvertisingArray = new Advertising[](numAdvertising);
        for (uint256 i = 0; i < numAdvertising; i++) {
            AdvertisingArray[i] = adverts[i + 1];  
        }
        return AdvertisingArray;
    }

    function isNftOnAdvert(uint256 tokenId) public view returns (bool) {
        return adverts[tokenId].isAdvert;
    }

    function removeNFT(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) revert NotOwner();
        if (!adverts[tokenId].isAdvert) revert NFTNotForSale();

        adverts[tokenId].isAdvert = false;
    }

    function OwnershipTransfer(address newOwner) public onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        _owner = newOwner;
    }

    function owner() public view returns (address) {
        return _owner;
    }
}
