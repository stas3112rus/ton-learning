
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {
    
    mapping (string=>uint16) flagsOfTransfer;
    
    //Send Value only existed accounts
    bool bounce = true;
  
    constructor() public {       
       tvm.accept();
       flagsOfTransfer["feeInValue"] = 0;
       flagsOfTransfer["feeSeparatlyFromValue"] = 1;
       flagsOfTransfer["sendAllMoney"] = 128;
       flagsOfTransfer["ignoreAllErrors"] = 2;
       flagsOfTransfer["destroyContract"] = 32;       
    }

    modifier checkOwnerAndAccept {
        // Check that inbound message was signed with owner's public key.
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    function sendTransDontPayFee(address dest, uint128 value) public view checkOwnerAndAccept {
        dest.transfer(value, bounce, flagsOfTransfer["feeInValue"]);
        tvm.accept();
    }

    function sendTransPayFee(address dest, uint128 value) public view checkOwnerAndAccept {
        dest.transfer(value, bounce, flagsOfTransfer["feeSeparatlyFromValue"]);
        tvm.accept();
    }

    function sendAllCrystalAndDestoyWallet(address dest) public view checkOwnerAndAccept {
        dest.transfer(1, bounce, flagsOfTransfer["sendAllMoney"] + flagsOfTransfer["destroyContract"]);
        tvm.accept();
    }  
}
