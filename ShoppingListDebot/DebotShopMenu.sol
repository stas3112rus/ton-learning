pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "DebotInitShoppingList.sol";

abstract contract DebotShopMenu is DebotInitShoppingList{
    
    uint32 private m_id;
    string private m_buyingName;

    function _menu() public virtual override;

     // Make Buying    

    function askIdToMakeBuying(uint32 index) public{
         index = index;
         Terminal.input(tvm.functionId(askTotalPrice), "Enter Id buying in your shop list ", false);   
    }

    function askTotalPrice(string value) public{
        (uint256 temp,) = stoi(value);
        m_id = uint32(temp);
        Terminal.input(tvm.functionId(makeBuying_), "Enter total price of buying ", false);
    }

    function makeBuying_(string value) public{
        (uint256 price,) = stoi(value);
        optional(uint256) pubkey = 0;

        IShoppingList(m_address).makeBuying{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showShoppingList),
            onErrorId: 0
        }(m_id, uint32(price));
    }

    // Set Buying in list

        function askBuyingName(uint32 index) public {
        index = index;
        Terminal.input(tvm.functionId(askBuyingQuntity), "Enter what you want to buy", false);
    }

    function askBuyingQuntity(string buyingName) public{
        m_buyingName = buyingName;
        Terminal.input(tvm.functionId(setBuyingInList_), "Enter quntity", false);
    }

    function setBuyingInList_(string quntity) public{
        (uint256 num,) = stoi(quntity);
        optional(uint256) pubkey = 0;

        IShoppingList(m_address).setBuyingInList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showShoppingList),
            onErrorId: 0
        }(m_buyingName, uint32(num));
    }

    // Show shop list

    function showShoppingList(uint32 index) public view{
        index = index;
        optional(uint256) none;
        IShoppingList(m_address).getMapIdBuying{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showShoppingList_),
            onErrorId: 0
        }();
    }

    function showShoppingList_(mapping (uint32=>Buying) shopList) public{
        for ((uint32 key, Buying buying) : shopList){
            string done = " ";
            if (buying.isBuying){
                done = '✓';
            }
            Terminal.print(0, format("{} {} name {} quantity {} created at: {} was payed: {}", done, buying.id, buying.nameBuying, buying.quantity, buying.createdAt, buying.totalPrice));
            
            _menu();
        }
    }

    // Delete buying in list by Id

    function deleteBuyingFromList(uint32 index) public {
        if (m_stat.itemsIsNotPayed + m_stat.itemsIsPayed > 0){
            Terminal.input(tvm.functionId(deleteBuyingFromList_), "Enter id buying:", false);
        } else {
            Terminal.print(0, "Sorry, you have no one byuing in your list to delete");
            _menu();  
        }
    }

    function deleteBuyingFromList_(string value) public view{
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).deleteBuyingFromList{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError) 
        }(uint32(num));
    }
}
