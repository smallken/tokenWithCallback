pragma solidity ^0.8.23;

import "@openzeppelin/contracts/utils/Address.sol";
import"@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "homework-tokencallback/ERC22.sol";
import "ERC22.sol"

interface ITokenBankV2 {
    function tokenRecieved(address, uint256) external  returns (bool);
}
contract ERC23 is ERC20{
    constructor (string memory name, string memory symbol) ERC20(name, symbol){
    }

    error callBackError();

    function transfer(address to, uint256 amount) public override returns (bool) {
        uint balance = balanceOf(msg.sender);
        require(balance >= amount, "balance not enough");
        _update(msg.sender, to, amount);
        if(to.code.length > 0){
            bool callBack = ITokenBankV2(to).tokenRecieved(msg.sender, amount);
            if (callBack) {
                return true;
            } else {
                revert callBackError();
            }
        }
        return true;
    }

}