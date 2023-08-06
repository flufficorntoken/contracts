// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FCORN {
    string public constant name = "Flufficorn Token";
    string public constant symbol = "FCORN";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        uint256 initialSupply = 1000000000000000;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        _balances[msg.sender] = totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "FCORN: transfer to the zero address");
        require(_balances[msg.sender] >= amount, "FCORN: transfer amount exceeds balance");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "FCORN: transfer to the zero address");
        require(_balances[sender] >= amount, "FCORN: transfer amount exceeds balance");
        require(_allowances[sender][msg.sender] >= amount, "FCORN: transfer amount exceeds allowance");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}