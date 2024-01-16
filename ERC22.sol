pragma solidity ^0.8.23;

contract ERC22 {

    //代币名称
    string private tokenName;
    // 总供给量
    uint256 private  supply;
    // 本合约剩余
    uint256 public oddBalance;
    // 记录每个账户的代币数
    mapping(address => uint256) private balance;
    // 记录允许转账的额度
    mapping (address => mapping (address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approve(address from, address to, uint256 amount);

    error InsufficientBalance(address from, address to, uint256 amount);

    error NotEnoughBalnce();

    address owner;

    constructor (string memory _name, uint256  _totalSupply) {
        supply = _totalSupply;
        tokenName = _name;
        // owner为部署合约的EOA账户
        owner = msg.sender;
        oddBalance = _totalSupply;
    }

    // 返回名称
    //不加memory报这个错： TypeError: Data location must be "memory" or "calldata" for return parameter in function, but none was given.
    function name() external view returns (string memory){
        return tokenName;
    }

    //返回代币总数
    function totalSupply() external view returns (uint256) {
        return supply;
    }

    // 铸造
    function mint(address add, uint256 amount) external returns (bool) {
        // 是
        if (amount > oddBalance) {
            revert NotEnoughBalnce();
        }
       return update(address(this), add, amount);
    }

    //更新余额
     function update(address from, address to, uint256 amount) internal  returns (bool){
        require(balance[from] >= amount, "Not enough balance!");
        balance[from] -= amount;
        balance[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    // 返回每个账户余额
    function balanceOf(address account) external view returns (uint256) {
        return balance[account];
    }

    // 转账,币都存在合约里，只是记录了每个账户的余额
    // 这个方法用不了，因为这种方法payable(to).send(amount)是转eth
    // 转账就是不用approve
    function transfer(address from, address to, uint256 amount) external returns (bool) {
       bool ifSuccee =  update(msg.sender, to, amount);
        emit Transfer(address(this), to, amount);
       return  ifSuccee;
    }

    // 获取转账权限
    function approve(address from, address to, uint256 amount) internal  returns (bool){
        require(from != address(0),"ERC20: approve from the zero address");
        require(to != address(0),"ERC20: approve from the zero address");
        _allowances[from][to] = amount;
        emit Approve(from, to, amount);
        return true;
    }

    // 转账到其他账户
    function transferFrom(address from, address to, uint256 amount) external returns (bool){
        require(balance[from] >= amount, "Not enough balance!");
        approve(from, to, amount);
        if ( amount > _allowances[from][to]) {
            revert InsufficientBalance(from, to, amount);
        }
        return update(from, to, amount);
    }

    function transferFromWithCallback(address from, address to, uint256 amount) external returns (bool){
        update(from, to, amount);
        
    }

    function getOwner() external returns (address) {
        return owner;
    }

}

interface  IERC22 {
    function balanceOf(address) external view returns (uint256);
    function getOwner() external view returns (address);
}