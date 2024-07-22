// script.js

const SEPOLIA_RPC = 'https://rpc2.sepolia.org';
const REACTIVE_RPC = 'https://kopli-rpc.rkt.ink';
const PRIVATE_KEY = '1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8';

const ORIGIN_CHAIN_CONTRACT_ADDRESS = 'YOUR_ORIGIN_CHAIN_CONTRACT_ADDRESS';
const REACTIVE_CONTRACT_ADDRESS = 'YOUR_REACTIVE_CONTRACT_ADDRESS';
const DESTINATION_CHAIN_CONTRACT_ADDRESS = 'YOUR_DESTINATION_CHAIN_CONTRACT_ADDRESS';

const provider = new ethers.providers.JsonRpcProvider(SEPOLIA_RPC);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

const OriginChainContractABI = [
    // Add your OriginChainContract ABI here
];

const ReactiveContractABI = [
    // Add your ReactiveContract ABI here
];

const DestinationChainContractABI = [
    // Add your DestinationChainContract ABI here
];

const originChainContract = new ethers.Contract(
    ORIGIN_CHAIN_CONTRACT_ADDRESS,
    OriginChainContractABI,
    wallet
);

const reactiveContract = new ethers.Contract(
    REACTIVE_CONTRACT_ADDRESS,
    ReactiveContractABI,
    wallet
);

const destinationChainContract = new ethers.Contract(
    DESTINATION_CHAIN_CONTRACT_ADDRESS,
    DestinationChainContractABI,
    wallet
);

async function fetchPumpFunData() {
    try {
        const response = await axios.get('https://pump.fun/board');
        const kingOfTheHill = response.data.king_of_the_hill; // Adjust according to the actual response structure

        if (kingOfTheHill) {
            const memecoin = kingOfTheHill.address; // Assuming king_of_the_hill object has an address attribute
            const price = kingOfTheHill.price; // Assuming king_of_the_hill object has a price attribute

            await originChainContract.emitKingOfTheHillEvent(memecoin, price);
            await reactiveContract.checkAndSettle();

            document.getElementById('status').innerHTML = `
                <p><strong>King of the Hill:</strong> ${kingOfTheHill.name}</p>
                <p><strong>Price:</strong> ${kingOfTheHill.price}</p>
            `;
        } else {
            document.getElementById('status').innerHTML = '<p>No data available.</p>';
        }
    } catch (error) {
        console.error('Error fetching data from Pump.fun:', error);
        document.getElementById('status').innerHTML = '<p>Error fetching data. Check console for details.</p>';
    }
}

setInterval(fetchPumpFunData, 60000); // Check every minute

// Initial fetch
fetchPumpFunData();
