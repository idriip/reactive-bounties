const axios = require('axios');
const { ethers } = require('ethers');

const SEPOLIA_RPC = 'https://rpc2.sepolia.org';
const REACTIVE_RPC = 'https://kopli-rpc.rkt.ink';
const PRIVATE_KEY = '1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8';
const REACTIVE_CONTRACT_ADDRESS = 'YOUR_REACTIVE_CONTRACT_ADDRESS';
const MEMECOIN_CALLBACK_ADDRESS = 'YOUR_MEMECOIN_CALLBACK_ADDRESS';
const ORACLE_ADDRESS = 'YOUR_ORACLE_ADDRESS';

const provider = new ethers.providers.JsonRpcProvider(SEPOLIA_RPC);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const reactiveContract = new ethers.Contract(REACTIVE_CONTRACT_ADDRESS, ReactiveContractABI, wallet);

async function fetchMemecoinData() {
    try {
        const response = await axios.get('https://pump.fun/board');
        const kingOfTheHill = response.data.king_of_the_hill; // Adjust according to the actual response structure

        if (kingOfTheHill) {
            const finalPrice = kingOfTheHill.price; // Assuming king_of_the_hill object has a price attribute
            await reactiveContract.checkAndSettle(finalPrice);
        }
    } catch (error) {
        console.error('Error fetching data from Pump.fun:', error);
    }
}

setInterval(fetchMemecoinData, 60000); // Check every minute
