// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FreelanceEscrow {
    address public client;
    address payable public freelancer;
    uint256 public paymentAmount;
    bool public isWorkApproved;

    constructor(address payable _freelancer) payable {
        client = msg.sender;
        freelancer = _freelancer;
        paymentAmount = msg.value;
        isWorkApproved = false;
    }

    function approveWork() public {
        require(msg.sender == client, "Only client can approve");
        isWorkApproved = true;
    }

    function withdrawPayment() public {
        require(isWorkApproved, "Work is not approved yet");
        require(paymentAmount > 0, "Payment already withdrawn");

        uint256 amountToSend = paymentAmount;
        paymentAmount = 0;

        (bool success, ) = freelancer.call{value: amountToSend}("");
        require(success, "Transfer failed");
    }
}
