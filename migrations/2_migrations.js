const CryptoKitties = artifacts.require("CryptoKitties");
const BoredApes = artifacts.require("BoredApes");
const WorldOfWomen = artifacts.require("WorldOfWomen");
const Store = artifacts.require("Store");
const Database = artifacts.require("Database");

module.exports = async function (deployer, network, addresses) {
    await deployer.deploy(CryptoKitties, {from: addresses[0]});
    await deployer.deploy(BoredApes, {from: addresses[1]});
    await deployer.deploy(WorldOfWomen, {from: addresses[2]});

    const nft1 = await CryptoKitties.deployed();
    await nft1.mint(addresses[0], {from: addresses[0]});

    const nft2 = await BoredApes.deployed();
    await nft2.mint(addresses[1], {from: addresses[1]});

    const nft3 = await WorldOfWomen.deployed();
    await nft3.mint(addresses[2], {from: addresses[2]});

    await deployer.deploy(Store);
};
