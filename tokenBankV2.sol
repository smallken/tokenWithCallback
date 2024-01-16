pragma solidity ^0.8.23;

// import "homework-tokencallback/tokenBank.sol";
import "tokenBank.sol";
import"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract tokenBankV2 is tokenBank{
    using SafeERC20 for IERC20;
    IERC20 tokenAddress;
    constructor (address _tokenAddress) tokenBank(_tokenAddress){
         tokenAddress = IERC20(_tokenAddress);
    }

    function tokenRecieved(address user, uint256 amount) public returns (bool) {
        if (msg.sender == address(tokenAddress)) {
            _balanceOf[user] += amount;
            return true;
        }else{
            return false;
        }
    }

    function safeTransef(uint256 amount) external {
        tokenAddress.safeTransferFrom(msg.sender, address(this), amount);
    }



}