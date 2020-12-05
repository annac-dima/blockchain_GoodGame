pragma solidity ^0.6.0; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/francbianc/blockchain/blob/main/bet.sol";

contract Win is Betting {
    // NB: inheritance therefore same balance 
    
    //function vedo(uint _idBet) public view onlyOwner returns(address _a, bool _boola) {
       // return (all_bets[_idBet].challenger, all_bets[_idBet].challenger_pay);
    //}
    
    
    function payOutChallenger(uint _idBet, bool _winnC, address payable _C, address payable _A) public onlyOwner returns(bool success, string memory name_winner) {
        require(all_bets[_idBet].challenger == _C && all_bets[_idBet].accepter == _A);
        require(all_bets[_idBet].challenger_pay == true && all_bets[_idBet].accepter_pay == true);
        
        uint256 prize = all_bets[_idBet].price_challenger.add(all_bets[_idBet].price_accepter);
        if (_winnC == true) {
            //all_bets[_idBet].challenger.send(prize);
            _C.transfer(prize);
            return (true, 'Challenger');} else {
                //address payable winner = all_bets[_idBet].accepter;
                _A.transfer(prize);
                return (true, 'Accepter');}
    }
    
    function getBalanceBet2() public view onlyOwner returns (uint) {
        return address(this).balance;}
    
}
