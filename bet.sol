pragma solidity ^0.6.0; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract Betting is Ownable {
    
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

    // Save each Bet in a list 
    mapping (uint => Bet) public all_bets;
      
    // How many bets so far? 
    uint betCounter;
      
    // Get the total number of bets in the contract
    function getNumberOfBets() public view returns (uint) {return betCounter;}
      
    // Publish Bet 
    event LogPublishBet(uint indexed _idBet, address indexed _addChall, address indexed _addAccept, uint256 _priceChall, uint256 _priceAccept);
    
    
    // FUNCTIONS 
    
    
    // Publish a new bet 
    function publishBet(uint _idC, uint _idA, address _challenge, address _accept, uint256 _priceC, uint256 _priceA, string memory _playerA, 
    string memory _playerC) public onlyOwner {
        // Only GoodGame, the first deployer, can invoke this contract 
        // Increase the bet counter
        betCounter++;
        
        // A and B must have enough funds in their wallets 
        require(_challenge.balance > _priceC && _accept.balance > _priceA);
    
        // Store this bet into the contract
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
    
    
    //function challengerTransfer() public view returns(address) {
        //return msg.sender;
    //}
    
    function challengerTransfer(uint _idBet) public payable {
        require(msg.sender == all_bets[_idBet].challenger);
        if(msg.value != all_bets[_idBet].price_challenger) {
            revert();
        } else {all_bets[_idBet].challenger_pay = true;}
    }
    
    function accepterTransfer(uint _idBet) public payable {
        require(msg.sender == all_bets[_idBet].accepter);
        if(msg.value != all_bets[_idBet].price_accepter) {
            revert();
        } else {all_bets[_idBet].accepter_pay = true;}
    }
    
    // Only GoodGame can get this smart contract's balance
    function getBalanceBet() public view onlyOwner returns (uint) {
        return address(this).balance;
    }
    
    // Only GoodGame can get gamblers' balance
    function getBalanceGamblers(address _a, address _b) public view onlyOwner returns(uint256, uint256) {
        return (_a.balance, _b.balance);
    }
    
}
