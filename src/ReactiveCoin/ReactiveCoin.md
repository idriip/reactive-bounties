### Reactive Coin Project ###


## Description of the project

This project implements a prediction market for memecoin investing with automated payouts using Reactive Smart Contracts. The system leverages data from the pump.fun leaderboard to identify the "king of the hill" memecoin and trigger investment actions. The project comprises three main contracts: the Origin Chain Contract, the Reactive Contract, and the Destination Chain Contract. The entire setup is orchestrated through a front-end webpage that interacts with these smart contracts.

Components
Origin Chain Contract (OriginChainContract.sol)

Purpose: This contract emits logs of interest, specifically when a new "king of the hill" memecoin is identified. In a real-world financial application, it could be a DEX or another financial service emitting relevant event logs.
Functionality:
Emits an event when a memecoin becomes the "king of the hill".
Stores basic information about the event, such as the memecoin's address and price.
Reactive Contract (ReactiveContract.sol)

Purpose: This contract monitors events emitted by the Origin Chain Contract. It subscribes to these events and initiates callback actions to other contracts based on predefined logic.
Functionality:
Subscribes to the Origin Chain Contract's events.
Triggers an action (e.g., investment or state update) when a new "king of the hill" is identified.
Ensures state consistency and manages dynamic event subscriptions and unsubscriptions.
Destination Chain Contract (PredictionMarket.sol)

The contract handles the business logic for the prediction market, including receiving and processing callback events from the Reactive Contract.
Functionality:
Receives callback events from the Reactive Contract.
Updates the state based on received events, such as recording the new "king of the hill" and handling payouts.
Front-End Webpage
A front-end webpage is created to interact with these smart contracts and display relevant data to the user. The webpage is built using HTML, CSS, and JavaScript, and it employs ethers.js and axios for Ethereum interaction and data fetching, respectively.

HTML (index.html): Provides the structure for the webpage.
CSS (style.css): Styles the webpage for a clean and user-friendly interface.
JavaScript (script.js): Contains logic to fetch data from pump.fun, interact with smart contracts, and periodically update the page.
Workflow
Data Fetching:

The JavaScript code fetches data from the pump.fun leaderboard every minute.
It identifies the "king of the hill" memecoin based on the fetched data.
Event Emission:

When a new "king of the hill" is identified, the Origin Chain Contract emits an event with the relevant information.
Event Handling:

The Reactive Contract, subscribed to the Origin Chain Contract, detects the event.
It processes the event and triggers the necessary actions, including making calls to the Destination Chain Contract.
State Update:

The Destination Chain Contract updates its state based on the information received from the Reactive Contract, such as recording the new "king of the hill" and handling any necessary payouts.
Deployment
To deploy the contracts and set up the system:

Deploy the Origin Chain Contract to the Sepolia testnet.
Deploy the Destination Chain Contract to the Sepolia testnet.
Deploy the Reactive Contract, configuring it to listen to the Origin Chain Contract's events and send callbacks to the Destination Chain Contract.
Set up the front-end webpage to interact with these contracts, providing real-time data and user interaction capabilities.
Environment Variables
SEPOLIA_RPC: The Sepolia Testnet RPC address.
SEPOLIA_PRIVATE_KEY: The private key to your Sepolia wallet.
REACTIVE_RPC: The Reactive Testnet RPC address.
REACTIVE_PRIVATE_KEY: The private key to your Reactive wallet.
SYSTEM_CONTRACT_ADDR: The system contract address on the Reactive testnet.
ORIGIN_CHAIN_CONTRACT_ADDRESS: The address of the deployed Origin Chain Contract.
REACTIVE_CONTRACT_ADDRESS: The address of the deployed Reactive Contract.
DESTINATION_CHAIN_CONTRACT_ADDRESS: The address of the deployed Destination Chain Contract.

## How I test.

* My Environment variables

  # Sepolia Testnet RPC address
SEPOLIA_RPC="https://rpc2.sepolia.org"

# Private key to your Sepolia wallet
SEPOLIA_PRIVATE_KEY="1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8"

# Reactive Testnet RPC address
REACTIVE_RPC="https://kopli-rpc.rkt.ink"

# Private key to your Reactive wallet
REACTIVE_PRIVATE_KEY="1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8"

# Address of your Reactive wallet
DEPLOYER_ADDR="0x9F637719B47c77B588015a85E766e8A90f0CeA03"

# System contract address on the Reactive testnet
SYSTEM_CONTRACT_ADDR="0x0000000000000000000000000000000000FFFFFF"

# Callback sender address (you may need to refer to the documentation for the exact address)
CALLBACK_SENDER_ADDR="0x0000000000000000000000000000000000FFFFFF"  # Placeholder, refer to the docs

Next:


1. Deploy the origin chain contract to Sepolia:

``` bash

forge create --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/demos/basic/BasicDemoL1Contract.sol:BasicDemoL1Contract
```
Result:
Deployer: 0x9F637719B47c77B588015a85E766e8A90f0CeA03
Deployed to: 0x0928BC48B145E98b27355F2E5E183ea05eE57a87
Transaction hash: 0xfce1fc43103be361ccd7f36776c2641753ddcfd5e9fcd148f8711aecdfd43e17

2. Assign the deployment address to the environment variable ORIGIN_ADDR.

Now deploy the callback contract to Sepolia:

``` bash
forge create --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/demos/basic/BasicDemoL1Callback.sol:BasicDemoL1Callback
```
Result: 
Deployer: 0x9F637719B47c77B588015a85E766e8A90f0CeA03
Deployed to: 0xA4Fd96Bd093E008E0D17Dfcd408DA311cA2dde96
Transaction hash: 0x002fcc55e032e0dabaa07cd8d67f5f3ab23971753a1da3751f16a18dfc95571b

3. Assign the deployment address to the environment variable CALLBACK_ADDR.

Finally, deploy the reactive contract, configuring it to listen to ORIGIN_ADDR, and to send callbacks to CALLBACK_ADDR.

``` bash

forge create --rpc-url $REACTIVE_RPC --private-key $REACTIVE_PRIVATE_KEY src/demos/basic/BasicDemoReactiveContract.sol:BasicDemoReactiveContract --constructor-args $SYSTEM_CONTRACT_ADDR $ORIGIN_ADDR 0x8cabf31d2b1b11ba52dbb302817a3c9c83e4b2a5194d35121ab1354d69f6a4cb $CALLBACK_ADDR
```
4. Test the whole setup by sending some SepETH to ORIGIN_ADDR:

``` bash

cast send $ORIGIN_ADDR --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY --value 0.11ether

```

## Instructions for Deployment

# Setup Foundry Project
First, install Foundry if you haven't already:
  
  ``` bash
  curl -L https://foundry.paradigm.xyz | bash
foundryup
```
* Next, initialize a new Foundry project:

``` bash
forge init reactive-memecoin-prediction
cd reactive-memecoin-prediction

```
# Install Dependencies
Install necessary dependencies:

``` bash
forge install foundry-rs/forge-std --no-commit

```
# Create Contract Files
In the src directory, create the contract files ( Add my provided contract code to these files.):

``` bash
mkdir src/demos
touch src/demos/OriginChainContract.sol
touch src/demos/ReactiveContract.sol
touch src/demos/DestinationChainContract.sol
```


# Create Deployment Script
- Create a script directory and add a deployment script Deploy.s.sol:

``` bash

mkdir script
touch script/Deploy.s.sol
```
- Add the following code to Deploy.s.sol:
``` bash
  // script/Deploy.s.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/demos/OriginChainContract.sol";
import "../src/demos/ReactiveContract.sol";
import "../src/demos/DestinationChainContract.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the OriginChainContract
        OriginChainContract originChainContract = new OriginChainContract();
        console.log("OriginChainContract deployed to:", address(originChainContract));

        // Deploy the DestinationChainContract
        DestinationChainContract destinationChainContract = new DestinationChainContract();
        console.log("DestinationChainContract deployed to:", address(destinationChainContract));

        // Deploy the ReactiveContract
        address SYSTEM_CONTRACT_ADDR = 0x0000000000000000000000000000000000FFFFFF;
        ReactiveContract reactiveContract = new ReactiveContract(
            SYSTEM_CONTRACT_ADDR,
            address(originChainContract),
            0x8cabf31d2b1b11ba52dbb302817a3c9c83e4b2a5194d35121ab1354d69f6a4cb, // Replace with actual event signature hash
            address(destinationChainContract)
        );
        console.log("ReactiveContract deployed to:", address(reactiveContract));

        vm.stopBroadcast();
    }

```
# Prepare Environment Variables
Create a .env file in the root directory:

``` bash
touch .env
```

# Add your environment variables to the .env file:

``` env
SEPOLIA_RPC=https://rpc2.sepolia.org
SEPOLIA_PRIVATE_KEY=1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8
REACTIVE_RPC=https://kopli-rpc.rkt.ink
REACTIVE_PRIVATE_KEY=1272fe556e254e03697c367010ef32a816cf8d60b7aae55ae70a0c4c872f61b8
```
# Deploy the Contracts
Run the deployment script:

``` bash
source .env
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY --broadcast
```
Repeat the deployment for the Reactive network:

``` bash

forge script script/Deploy.s.sol --rpc-url $REACTIVE_RPC --private-key $REACTIVE_PRIVATE_KEY --broadcast
```

# Summary of Instructions
- Set up a new Foundry project.
- Install the necessary dependencies.
- Create and add your contract code to the src directory.
- Create and add the deployment script to the script directory.
- Prepare your environment variables in a .env file.
- Run the deployment script to deploy the contracts to the Sepolia and Reactive networks.


## Impact

Implementing a prediction market for memecoin investing with automated payouts using Reactive Smart Contracts can significantly impact and potentially disrupt the memecoin market in several ways:

1. Increased Market Efficiency
Automated Trading: By automating the investment process based on real-time data from sources like pump.fun, the market can react much faster to changes. This can lead to more efficient price discovery as the smart contracts can execute trades instantly without human intervention.

Arbitrage Opportunities: The prediction market can quickly identify and exploit arbitrage opportunities, thereby reducing price discrepancies across different exchanges and platforms.

2. Enhanced Transparency and Trust
Immutable Records: All transactions and market activities are recorded on the blockchain, ensuring transparency. This can increase trust among participants as all trades and predictions are verifiable and cannot be altered.

Reduced Fraud: The use of smart contracts minimizes the risk of fraud and manipulation, which are common concerns in the memecoin market. Automated payouts and event-driven executions ensure that rules are followed without bias.

3. Lower Entry Barriers
Decentralization: By leveraging decentralized smart contracts, the prediction market becomes accessible to a global audience without the need for intermediaries. This democratizes access to investment opportunities in the memecoin market.

Ease of Use: The automated nature of the platform simplifies the process for users. Investors do not need in-depth knowledge of trading strategies or constant monitoring of the market, as the smart contracts handle these tasks.

4. Innovation and New Use Cases
New Financial Products: The combination of prediction markets and memecoins can lead to the creation of new financial products, such as derivatives based on prediction outcomes. This can attract more sophisticated investors to the memecoin market.

Incentivized Predictions: Participants can be incentivized to make accurate predictions about future memecoin prices or events, adding a layer of gamification and engagement to the market.

5. Market Volatility
Price Swings: The rapid execution of trades based on real-time data can lead to increased volatility, especially in the highly speculative memecoin market. This can result in significant price swings, both upwards and downwards.

Liquidity Fluctuations: Automated trading can lead to sudden changes in liquidity as large volumes of trades are executed instantly. This can impact smaller investors who may face slippage or unexpected price movements.

6. Regulatory Considerations
Compliance Challenges: The decentralized and automated nature of the platform may pose regulatory challenges, as authorities might find it difficult to oversee and control such systems. Compliance with local regulations will be essential to ensure the platform's longevity and acceptance.

Potential for Bans: In some regions, automated trading platforms and prediction markets may face stricter regulations or outright bans. This could limit the platform's reach and impact.

Conclusion
Implementing a prediction market for memecoin investing with automated payouts using Reactive Smart Contracts has the potential to significantly disrupt the memecoin market. It can lead to increased efficiency, transparency, and accessibility while fostering innovation. However, it also brings challenges such as increased volatility and regulatory hurdles. Careful consideration and strategic planning will be crucial to harnessing the benefits while mitigating the risks associated with this disruptive technology.

## Workflow on the Network.

# Workflow on Sepolia Network
1. Deploy Origin Chain Contract

Description: Deploy the OriginChainContract on the Sepolia network. This contract will emit logs that the Reactive Network will monitor.
Steps:
Write the contract code for OriginChainContract.sol.
Compile the contract using forge.
Deploy the contract using forge create --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/demos/OriginChainContract.sol:OriginChainContract.
Note the deployed contract address.
2. Deploy Destination Chain Contract

Description: Deploy the DestinationChainContract on the Sepolia network. This contract will receive callbacks from the Reactive Network.
Steps:
Write the contract code for DestinationChainContract.sol.
Compile the contract using forge.
Deploy the contract using forge create --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/demos/DestinationChainContract.sol:DestinationChainContract.
Note the deployed contract address.
Workflow on Reactive Network
3. Deploy Reactive Contract

Description: Deploy the ReactiveContract on the Reactive Network. This contract monitors events from the OriginChainContract and triggers actions on the DestinationChainContract.
Steps:
Write the contract code for ReactiveContract.sol.
Compile the contract using forge.
Deploy the contract using forge create --rpc-url $REACTIVE_RPC --private-key $REACTIVE_PRIVATE_KEY src/demos/ReactiveContract.sol:ReactiveContract --constructor-args $SYSTEM_CONTRACT_ADDR $ORIGIN_ADDR $EVENT_SIGNATURE_HASH $CALLBACK_ADDR.
Note the deployed contract address.
Combined Workflow Description
1. Monitor King of the Hill on pump.fun

Description: A JavaScript script periodically checks the pump.fun website to see which memecoin is currently the "king of the hill".
Steps:
Write a JavaScript script using axios to fetch data from pump.fun.
Set up a periodic check (e.g., every minute) using setInterval.
2. Update Price Feed

Description: When a memecoin becomes the "king of the hill", update the price feed on the ReactiveContract.
Steps:
In the JavaScript script, if a new "king of the hill" is detected, call the setPrice function on the priceFeedContract (this function should be part of the ReactiveContract).
3. Check and Settle

Description: After updating the price feed, trigger the checkAndSettle function on the ReactiveContract.


