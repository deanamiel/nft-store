// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract Store is ERC721Holder {
    struct listing {
        address payable owner;
        uint256 price;
        uint256 listDate;
    }

    uint256 totalSupply;

    mapping(address => mapping(uint256 => listing)) registry;

    event NewListing(address indexed owner, uint256 price);
    event RemoveListing(address indexed owner);
    event UpdateListing(
        address indexed owner,
        uint256 newPrice,
        address collection,
        uint256 tokenID
    );
    event BuyNFT(
        address indexed buyer,
        address indexed seller,
        uint256 sellPrice
    );

    function listNFT(
        address _collection,
        uint256 _tokenID,
        uint256 _price
    ) external {
        require(
            IERC721(_collection).supportsInterface(0x80ac58cd),
            "Collection address is not valid ERC721 address"
        );
        require(
            IERC721(_collection).isApprovedForAll(msg.sender, address(this)),
            "Approve Store to transfer your NFTs"
        );

        IERC721(_collection).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenID
        );
        registry[_collection][_tokenID] = listing(
            payable(msg.sender),
            _price,
            block.timestamp
        );
        totalSupply++;

        emit NewListing(msg.sender, _price);
    }

    function updateListing(
        address _collection,
        uint256 _tokenID,
        uint256 _newPrice
    ) external {
        require(
            IERC721(_collection).supportsInterface(0x80ac58cd),
            "Collection address is not valid ERC721 address"
        );
        require(
            msg.sender == registry[_collection][_tokenID].owner,
            "Only owner of listing can update listing"
        );

        registry[_collection][_tokenID].price = _newPrice;

        emit UpdateListing(msg.sender, _newPrice, _collection, _tokenID);
    }

    function removeListing(address _collection, uint256 _tokenID) external {
        require(
            IERC721(_collection).supportsInterface(0x80ac58cd),
            "Collection address is not valid ERC721 address"
        );
        require(
            msg.sender == registry[_collection][_tokenID].owner,
            "Only owner of listing can remove listing"
        );

        delete (registry[_collection][_tokenID]);
        totalSupply--;
        IERC721(_collection).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenID
        );

        emit RemoveListing(msg.sender);
    }

    function buyNFT(address _collection, uint256 _tokenID) external payable {
        require(
            IERC721(_collection).supportsInterface(0x80ac58cd),
            "Collection address is not valid ERC721 address"
        );
        require(
            registry[_collection][_tokenID].owner != address(0),
            "NFT listing does not exist"
        );
        require(
            msg.value >= registry[_collection][_tokenID].price,
            "Inadequate funds to buy NFT"
        );

        address payable owner = registry[_collection][_tokenID].owner;

        delete (registry[_collection][_tokenID]);
        totalSupply--;

        IERC721(_collection).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenID
        );
        owner.transfer(msg.value);

        emit BuyNFT(msg.sender, owner, msg.value);
    }
}
