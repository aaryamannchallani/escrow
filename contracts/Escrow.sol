// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

contract Escrow {

    // Variable Declarations
    address payable buyer;
    address payable seller;
    address payable agent;
    uint256 public depositedAmount;
    bool public allowFundsTransfer = false;


    // Modifiers
    modifier onlyBuyer(){
        require(msg.sender == buyer, "Not the buyer.");
        _;
    }

    modifier onlySeller(){
        require(msg.sender == seller, "Not the seller.");
        _;
    }

    constructor(address payable _buyer, address payable _seller) public {
        buyer = _buyer;
        seller = _seller;
        agent = msg.sender;
    }

    function deposit() payable public virtual onlyBuyer {
        require(allowFundsTransfer == false, "Only while funds are locked, deposit is possible");
        uint256 depositedValue = msg.value;
        depositedAmount += depositedValue;
	    depositedValue = 0;
    }

    function releaseFundsToSeller() public virtual onlyBuyer {
        allowFundsTransfer = true;
    }

    function refundBuyer() public virtual {
        require(msg.sender == agent || msg.sender == seller, "Only Seller and Agent can Refund.");
        require(allowFundsTransfer == false && depositedAmount >= 0, "Invalid");
        uint256 escrowFee = depositedAmount / 100;
        uint256 sendingAmount = depositedAmount - escrowFee;
        allowFundsTransfer = false;
        depositedAmount = 0;
        buyer.transfer(sendingAmount);
        agent.transfer(escrowFee);
        escrowFee = 0;
    }

    function withdrawFunds() public virtual onlySeller {
        require(allowFundsTransfer == true, "Funds  must be transferable");
        uint256 escrowFee = depositedAmount / 100;
        uint256 sendingAmount = depositedAmount - escrowFee;
        depositedAmount = 0;
        allowFundsTransfer = false;
        seller.transfer(sendingAmount);
        agent.transfer(escrowFee);
        escrowFee = 0;

    }
}
