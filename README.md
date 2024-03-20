This Solidity contract implements a simple NFT marketplace for art exchange. Artists can mint new NFTs representing their artwork, and users can buy and sell these NFTs on the marketplace. Each NFT has metadata associated with it, describing the artwork.Code:// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ArtMarketplace is Ownable {
    uint256 public nextTokenId;
    mapping(uint256 => Artwork) public artworks;

    struct Artwork {
        string name;
        string artist;
        string metadataURI;
        uint256 price;
        address owner;
    }

    constructor() {}

    function createArtwork(string memory _name, string memory _artist, string memory _metadataURI, uint256 _price) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId++;
        artworks[tokenId] = Artwork(_name, _artist, _metadataURI, _price, owner());
        return tokenId;
    }

    function buyArtwork(uint256 _tokenId) external payable {
        Artwork storage artwork = artworks[_tokenId];
        require(artwork.owner != address(0), "Artwork does not exist");
        require(msg.value >= artwork.price, "Insufficient funds");
        
        payable(artwork.owner).transfer(msg.value);
        _transferArtwork(_tokenId, msg.sender);
    }

    function _transferArtwork(uint256 _tokenId, address _to) internal {
        Artwork storage artwork = artworks[_tokenId];
        artwork.owner = _to;
        emit Transfer(_tokenId, _to);
    }

    event Transfer(uint256 indexed tokenId, address indexed to);
}This contract allows the owner to create new artworks (NFTs) with specified metadata and prices. Users can buy these artworks by paying the specified price. Ownership of the artwork is transferred to the buyer upon purchase. This is a basic example and can be extended with additional features like auctions, royalties, and more robust metadata handling. Additionally, it uses OpenZeppelin's ERC721 implementation for NFT functionality. Make sure to install the necessary dependencies to compile and deploy this contract