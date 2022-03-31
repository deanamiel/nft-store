const Simple = artifacts.require('Database');
const express = require('express');

module.exports = async done => {
    const simple = Simple.deployed();
    const express = require('express');
    const app = express();

    app.get('/data', async (req, res) => {
        const data = await simple.getData();

        res.status(200).json({data: data});
    })

    app.listen(3000,() => {
        console.log("Server running on port 3000");
    })
}