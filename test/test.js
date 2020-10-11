const escrow = artifacts.require('./Escrow.sol')
let escrowInstance;

contract("Simple Escrow", (accounts)=>{
    context("Start to Finish",()=>{
        it("Contract Deploy",()=>{
            return escrow.deployed().then((instance)=>{
                escrowInstance = instance;
                assert(escrowInstance !== undefined, 'contract should be deployed');
            })
        })
        it("Deposits money as buyer", ()=>{
            return escrowInstance.deposit({from: accounts[1], value: web3.utils.toWei('10','ether')}).then(async ()=>{
                assert(escrowInstance.depositedAmount !== undefined  && web3.utils.fromWei(await escrowInstance.depositedAmount(),'ether') == '10')
            })
        })
        it("Releases funds to seller", async()=>{
            await escrowInstance.releaseFundsToSeller({from: accounts[1]})
            assert(await escrowInstance.allowFundsTransfer() === true)
        })
        it("Funds withdrawn by buyer", async() =>{
            const priorBalance = web3.utils.fromWei(await web3.eth.getBalance(accounts[2]), 'ether')
            await escrowInstance.withdrawFunds({from: accounts[2]})
            assert(web3.utils.fromWei(await web3.eth.getBalance(accounts[2]), 'ether')> priorBalance)
        })
    })
})