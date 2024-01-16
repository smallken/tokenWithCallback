pragma solidity ^0.8.23;

// import "homework1-14/ERC22.sol";
import "ERC22.sol";

contract tokenBank {
    // 存储每个账户对应的钱包数量
    mapping(address => uint) public _balanceOf;
    ERC22 private token;
    address public _owner;

    event Deposite(address indexed from, uint256 amount);

    constructor (address _tokenAddress) {
        token = ERC22(_tokenAddress);
        _owner = IERC22(_tokenAddress).getOwner();
        // owner = msg.sender;
        // 初始化该合约代币的总量
        // _balanceOf[address(this)] = IERC22(_tokenAddress).balanceOf(address(this));
    }

    // 获取合约的余额
    function getBalance(address _tokenAddress) external  returns (uint256){
        _balanceOf[address(this)] = IERC22(_tokenAddress).balanceOf(address(this));
        return IERC22(_tokenAddress).balanceOf(address(this));
    }

    // 记录每个用户存入的token数量，也就是用户存到tokenBank合约的数量
    // 是用户的地址，对应的是合约数量，然后把EOA的地址对应的数量转到给合约
    function save(uint256 amount) external   {
        require(token.transferFrom(msg.sender, address(this), amount));
        token.transfer(msg.sender, address(this), amount);
        emit Deposite(msg.sender, amount);
    }

    // 管理员提取所有token到管理员的账户
    function withdrawAllToken() payable public {
        require(msg.sender == _owner, "No access!");
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(msg.sender, address(this), balance));
        // require(token.Transfer(msg.sender, address(this), balance));
        // require(token.transferFrom(msg.sender, address(this), balance));
        emit Deposite(msg.sender, balance);
    }
}