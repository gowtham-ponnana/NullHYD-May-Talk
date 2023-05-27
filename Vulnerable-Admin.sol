//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Vouchers {

    mapping(address => uint)public balances;
    mapping(address => uint)public vouchers;
    address private owner;
    
    constructor(){
        owner = msg.sender;
    }

    modifier onlyAdmin(){
        require(msg.sender == owner, "Only Admin can resolve");
        _;
    }

    function depositETH()external payable{
        require(msg.value >= 0.001 ether, "You need atleast 0.001 ether");
        balances[msg.sender]+= msg.value;
        uint amount = 10 * msg.value;
        vouchers[msg.sender]+= amount;
    }

    function reedemVouchers(address _account)external{
        require(_account != address(0), "Address Must be a Contract and not NullAddress");
        uint value_send = vouchers[msg.sender];
        (bool success, ) = _account.call{value: value_send}("");
        require(success);
        vouchers[msg.sender]-= value_send;
    }


    function SensitiveAndRestrictive()external{
        selfdestruct(payable(owner));
    }

    receive()external payable{}

}