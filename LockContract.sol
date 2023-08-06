// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract LockedFunds {
    address private _owner;
    address private _token;
    mapping(address => uint256) private _lockedFunds;
    mapping(address => uint256) private _unlockTimestamp;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    constructor(address tokenAddress) {
        _owner = msg.sender;
        _token = tokenAddress;
    }

    function deposit(uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be greater than 0");

        IERC20 token = IERC20(_token);
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        uint256 currentLockedFunds = _lockedFunds[_owner];
        uint256 newLockedFunds = currentLockedFunds + amount;
        _lockedFunds[_owner] = newLockedFunds;

        uint256 unlockTime = block.timestamp + 60 days;
        if (unlockTime > _unlockTimestamp[_owner]) {
            _unlockTimestamp[_owner] = unlockTime;
        }
    }

    function withdraw() external onlyOwner {
        require(_unlockTimestamp[_owner] > 0, "No funds to withdraw");
        require(block.timestamp >= _unlockTimestamp[_owner], "Funds are still locked");

        uint256 amount = _lockedFunds[_owner];
        _lockedFunds[_owner] = 0;
        _unlockTimestamp[_owner] = 0;

        IERC20 token = IERC20(_token);
        require(token.transfer(_owner, amount), "Token transfer failed");
    }

    function getLockedFunds() external view returns (uint256) {
        return _lockedFunds[_owner];
    }

    function getUnlockTimestamp() external view returns (uint256) {
        return _unlockTimestamp[_owner];
    }
}