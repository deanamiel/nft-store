pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoKitties is ERC721 {
    uint256 private counter;
    address public owner;

    constructor() ERC721("CryptoKitties", "CRKT") {
        owner = msg.sender;
    }

    function mint(address _to) external {
        require(msg.sender == owner);

        _mint(_to, counter);
        counter++;
    }
}

contract BoredApes is ERC721 {
    uint256 private counter;
    address public owner;

    constructor() ERC721("Bored Apes", "BAPE") {
        owner = msg.sender;
    }

    function mint(address _to) external {
        require(msg.sender == owner);

        _mint(_to, counter);
        counter++;
    }
}

contract WorldOfWomen is ERC721 {
    uint256 private counter;
    address public owner;

    constructor() ERC721("World of Women", "WOW") {
        owner = msg.sender;
    }

    function mint(address _to) external {
        require(msg.sender == owner);

        _mint(_to, counter);
        counter++;
    }
}
