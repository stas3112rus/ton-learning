pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "DebotShopMenu.sol";

contract DebotWalkInShop is DebotShopMenu {

    
    
    constructor() public{
        tvm.accept();
        m_hello = "Hi, i'm a debot, which help you walk in shop and make buying";
    }

    function _menu() public override  {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have buyings are not payed: {} / buyings were payed: {} / Total sum of shopping: {}",
                    m_stat.itemsIsNotPayed,
                    m_stat.itemsIsPayed,
                    m_stat.totalSumBuyings
            ),
            sep,
            [                
                
                MenuItem("Show Shopping list","",tvm.functionId(showShoppingList)),
                MenuItem("Make buying in Shopping list by Id","",tvm.functionId(askIdToMakeBuying)),
                MenuItem("Delete buying by id","",tvm.functionId(deleteBuyingFromList))
            ]
        );
    }     
}

