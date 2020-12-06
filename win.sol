pragma solidity ^0.6.0; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/francbianc/blockchain/blob/main/bet.sol";

contract Win is Betting {
    // NB: inheritance therefore same balance 
    
    // Set the commission fee of GoodGame (3%)
    uint commission_cost = 3;
    
    // Only GG can transfer ETH from loser to winner and charge the commission fee
    function payOutChallenger(uint _idBet, bool _winnC, address payable _C, address payable _A) public onlyOwner returns(bool success, string memory name_winner) {
        require(all_bets[_idBet].challenger == _C && all_bets[_idBet].accepter == _A);
        require(all_bets[_idBet].challenger_pay == true && all_bets[_idBet].accepter_pay == true);
        
        uint256 prize = all_bets[_idBet].price_challenger.add(all_bets[_idBet].price_accepter);
        uint256 commission = prize.mul(commission_cost)/100;
        uint256 netPrize = prize.sub(commission);
        
        msg.sender.transfer(commission);

        if (_winnC == true) {
            _C.transfer(netPrize);
            return (true, 'Challenger');} else {
                _A.transfer(netPrize);
                return (true, 'Accepter');}
    }
    
    // Double check to be sure the Inheritance has worked correctly 
    function getBalanceBet2() public view onlyOwner returns (uint) {
        return address(this).balance;}
    
    // GG may access its own balance 
    function getGoodGameBalance() public view onlyOwner returns (uint256) {
        return msg.sender.balance;
    }
    
}
