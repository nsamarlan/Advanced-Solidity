##Create a file PupperCoin.sol, import ERC20 contracts from openzeplin and create a standard ERC20Mintable token.

pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";

contract PupperCoin is ERC20, ERC20Detailed, ERC20Mintable {
    constructor(
        string memory name,
        string memory symbol,
        uint initial_supply
    )
        ERC20Detailed(name, symbol, 18)
        public
    {
        // constructor can stay empty
    }
}
###Create another file Crowdsale.solo and bootstrap the contract by inheriting the Crowdsale,MintedCrowdsale,CappedCrowdsale,TimedCrowdsale

and RefundablePostDeliveryCrowdsale OpenZeppelin contracts.

Provide the rate, wallet, token, goal, open and close time parameters.

Rate,wallet and token is inherited from Crowdsale contract.

Cap Goal from CappedCrwodsale and start and end time from TimedCrowdsale contract.

  pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

  constructor(        
      uint rate, // rate in TKNbits        
      address payable wallet, // sale beneficiary       
      PupperCoin token, 
      uint goal,        
      uint open,        
      uint close    


  )
      Crowdsale(rate, wallet, token)
      CappedCrowdsale(goal)
      TimedCrowdsale(open,close)
      RefundableCrowdsale(goal)
      public
  {
      // constructor can stay empty
  }
}
####Create another contract PupperCoinSaleDeployer to model the deployment.

contract PupperCoinSaleDeployer {

address public token_sale_address;

address public token_address;

 constructor(       
    string memory name,
    
    string memory symbol, 
    
    address payable wallet, // this address will receive all Ether raised by the sale        
    uint goal
    
    )
    
    public   {        
    
    // create the PupperCoin and keep its address handy        
    PupperCoin token = new PupperCoin(name, symbol, 0);        
    token_address = address(token);
    
    // create the PupperCoinSale and tell it about the token        
    PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, goal, now, now + 24 weeks);        
    token_sale_address = address(token_sale);
    
    // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role        
    token.addMinter(token_sale_address);        
    token.renounceMinter();    

    }}