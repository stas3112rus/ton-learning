
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "base/Debot.sol";
import "base/Terminal.sol";
import "base/Menu.sol";
import "base/AddressInput.sol";
import "base/ConfirmInput.sol";
import "base/Upgradable.sol";
import "base/Sdk.sol";

contract SquareDebot is Debot {
  
    int public numUser = -1;


    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi
    ) {
        name = "Square Debot";
        version = "0.1.0";
        publisher = "Stanislav Yudin";
        key = "square numbers";
        author = "Stanislav Yudin";
        support = address.makeAddrStd(0, 0x82b1770107503ee3746069daae259eab3ba4a034a99bc5af1cf1a14a8df8004f);
        hello = "I'm making squere numbers";
        language = "en";
        dabi = m_debotAbi.get();        
    }

    function start() public override {
        Terminal.input(tvm.functionId(takeNumAndPrintSquare),"Please enter your num",false);
    }

    function takeNumAndPrintSquare(string value) public{
        (uint256 temp,) = stoi(value);
        numUser = int(temp);

        int result = numUser * numUser;

        Terminal.print(0, format("Square from {} equel {}", numUser, result));

        _menu();        
    }

    function _menu() public {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                    "You enter in last: {}",
                   numUser
            ),
            sep,
            [                
                MenuItem("Enter number and I make squarere this number", "", tvm.functionId(takeNumAndPrintSquare))
            ]
        );
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }
}

// when I try starting debot, I get Error

//tonos-cli --url http://127.0.0.1 debot fetch 0:550c1358a05968a78474c48f44c7ea12b8ecc53c720111579c005e19a7ddabd5
// Error text:
// Config: default
// Connecting to http://127.0.0.1
// Error: Contract execution was terminated with error: Unknown error, exit code: 52
// Tip: If this error occurs in 100% cases then you specified the wrong ABI. If it appears occasionally then the contract supports timestamp-based replay protection and does not allow to call it so often (call it with 5 seconds timeout). (Replay protection exception). Try again.
// Tip: For more information about exit code check the contract source code or ask the contract developer
// Error: 1
