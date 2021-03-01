// SPDX-License-Identifier:MIT

pragma solidity ^0.8.1;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';

contract Artist {
    
    // Collection of artworks by this Artist
    mapping(uint => ArtWork) artworks;
    address artist;

    constructor() {
        artist = msg.sender;
    }
    
    function createArtwork(uint hashIPFS, string memory _name) public returns (ArtWork) {
        ArtWork artContract = new ArtWork(hashIPFS, _name);
        artworks[hashIPFS] = artContract;
        return artContract;
    }
    
    function checkArtwork(uint hashIPFS) public view returns(bool) {
        if (artworks[hashIPFS] == ArtWork(address(0x0))) {
            return true;
        }
        return false;
    }
}

contract ArtWork is ERC721 {
    
    // Detail of artwork
    address artist;
    string _name;
    uint hashIPFS;
    address owner;
    
    constructor(uint ipfsHash, string memory artName) ERC721(artName, artName) {
        artist = msg.sender;
        _name = artName;
        hashIPFS = ipfsHash;
        owner = artist;
        _mint(msg.sender, 0x0);
    }
    
    function setOwner(address newOwner) public {
        if (owner == msg.sender) {
            owner = newOwner;
        }
    }
    
    function transferToBuyer(uint _tokenId, address _to) public {
        safeTransferFrom(msg.sender, _to, _tokenId);
        setOwner(_to);
    }
}
