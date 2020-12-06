pragma solidity ^0.6.0; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract Betting is Ownable {
    
    // DECLARE VARIABLES  
    using SafeMath for uint;
    using SafeMath for int;
    using SafeMath for uint256;
    uint256 frozenBalance; 

    struct Bet {
        uint id_bet;
        uint id_challenger;
        uint id_accepter;
        address challenger;
        address accepter;
        string player_name_challenger;
        string player_name_accepter;
        uint256 price_challenger;
        uint256 price_accepter;
        bool challenger_pay; 
        bool accepter_pay;
    }

    // Save each Bet in a dictionary  
    mapping (uint => Bet) public all_bets;
      
    // How many bets so far? 
    uint betCounter;
      
    // Get the total number of bets in the contract
    function getNumberOfBets() public view returns (uint) {return betCounter;}
      
    // Publish Bet 
    event LogPublishBet(uint indexed _idBet, address indexed _addChall, address indexed _addAccept, uint256 _priceChall, uint256 _priceAccept);
    
    
    // FUNCTIONS 
    // Only GoodGame can publish a new bet (it is the first deployer of this contract) 
    function publishBet(uint _idC, uint _idA, address _challenge, address _accept, uint256 _priceC, uint256 _priceA, string memory _playerA, 
    string memory _playerC) public onlyOwner {
        betCounter++;
        
        // A and B must have enough funds in their wallets 
        require(_challenge.balance > _priceC && _accept.balance > _priceA);
    
        // Store this bet into the dictionary 
        all_bets[betCounter] = Bet(
            betCounter,
            _idC,
            _idA, 
            _challenge,
            _accept, 
            _playerC, 
            _playerA, 
            _priceC, 
            _priceA, 
            false, 
            false);
            
        // Trigger a log event
        emit LogPublishBet(betCounter, _challenge, _accept, _priceC, _priceA);
    }
    
    // B, the first challenger, must transfer ETH to this smart contract 
    function challengerTransfer(uint _idBet) public payable {
        require(msg.sender == all_bets[_idBet].challenger);
        if(msg.value != all_bets[_idBet].price_challenger) {
            revert();
        } else {all_bets[_idBet].challenger_pay = true;}
    }
    
    // A, the accepter, must transfer ETH to this smart contract 
    function accepterTransfer(uint _idBet) public payable {
        require(msg.sender == all_bets[_idBet].accepter);
        if(msg.value != all_bets[_idBet].price_accepter) {
            revert();
        } else {all_bets[_idBet].accepter_pay = true;}
    }
    
    // Only GoodGame can check the balance of this smart contract 
    function getBalanceBet() public view onlyOwner returns (uint) {
        return address(this).balance;
    }
    
    // Only GoodGame can check gamblers' balance
    function getBalanceGamblers(address _a, address _b) public view onlyOwner returns(uint256, uint256) {
        return (_a.balance, _b.balance);
    }
    
}
