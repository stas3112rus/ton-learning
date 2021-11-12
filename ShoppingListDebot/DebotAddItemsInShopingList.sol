pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "DebotShopMenu.sol";

contract DebotAddItemsInShopingList is DebotShopMenu {

    constructor() public {
        tvm.accept();
        m_hello = "Hi, i'm a Shopping List DeBot. I'll Help you add buying in your shopping list";
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
                MenuItem("Add buying in ShopList", "", tvm.functionId(askBuyingName)),
                MenuItem("Show Shopping list","",tvm.functionId(showShoppingList)),
                MenuItem("Delete buying by id","",tvm.functionId(deleteBuyingFromList))
            ]
        );
    }
}

