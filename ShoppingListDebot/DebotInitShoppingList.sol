pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Debot.sol";
import "base/Terminal.sol";
import "base/Menu.sol";
import "base/AddressInput.sol";
import "base/ConfirmInput.sol";
import "base/Upgradable.sol";
import "base/Sdk.sol";

import "IShoppingList.sol";
import "HasConstructorWithPubKey.sol";
import "StructShoppingList.sol";
import "ShoppingList.sol";

abstract contract DebotInitShoppingList is Debot, Upgradable{

    TvmCell private m_ShoppingListCode;
    TvmCell private m_ShoppingListData;
    TvmCell private m_ShoppingListStateInit;
    uint256 m_masterPubKey;
    address m_address;  // Shoplist contract address

    summary m_stat;

    function _menu() public virtual {}

    int8 StatusContractIsActiveAndDeployed = 1;
    int8 StatusContractIsInactive = -1;
    int8 StatusContractIsUninitialized = 0;
    int8 StatusContractIsFreezen = 0;

    string internal m_hello;

    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey),"Please enter your public key",false);
    }

        function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi
    ) {
        name = "Shopping List DeBot";
        version = "0.1.0";
        publisher = "Stanislav Yudin";
        key = "Shopping List manager - Add buying";
        author = "Stanislav Yudin";
        support = address.makeAddrStd(0, 0x82b1770107503ee3746069daae259eab3ba4a034a99bc5af1cf1a14a8df8004f);
        hello = m_hello;
        language = "en";
        dabi = m_debotAbi.get();        
    }
    
    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function onSuccess() public view {
        _getStat(tvm.functionId(setStat));
    }

    function setShoppingListCode(TvmCell code, TvmCell data) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_ShoppingListCode = code;
        m_ShoppingListData = data;
        m_ShoppingListStateInit = tvm.buildStateInit(code, data);
    }

    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking if you already have a Shoping list ...");           
           
            TvmCell deployState = tvm.insertPubkey(m_ShoppingListStateInit, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your own Shopping list contract is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }

    function checkStatus(int8 acc_type) public {
        if (acc_type == StatusContractIsActiveAndDeployed) {
            _getStat(tvm.functionId(setStat));

        } else if (acc_type == StatusContractIsInactive || 
                   acc_type == StatusContractIsUninitialized)  {
            waitBeforeDeploy();       
            
        } else if (acc_type == StatusContractIsFreezen) { 
        Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
        }
    }

    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkContractContractIsUninitialized), m_address);
    }

    function checkContractContractIsUninitialized(int8 acc_type) public {
        if (acc_type ==  0) {
            deployShoppingListByOwnToken(m_ShoppingListStateInit, m_masterPubKey);
        } else {
            waitBeforeDeploy();
        }
    }

    function _getStat(uint32 answerId) internal view {
        optional(uint256) none;
        IShoppingList(m_address).getShoppingStatistis{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }


    function setStat(summary summaryShopping) public {
        m_stat = summaryShopping;
        _menu();
    }  

    function deployShoppingListByOwnToken(TvmCell stateInit, uint256 publicKey)
		private view		
	{ 		
		address newShoppingList = new  ShoppingList{
            stateInit: stateInit,
			// value sent to the new contract
			value: 0.2 ton
			}(publicKey); 		
	}

    

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }

    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }
}
