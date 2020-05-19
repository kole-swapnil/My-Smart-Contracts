pragma solidity ^0.6.0;

contract Itm{
    uint public priceinwei;
    uint public indexy;
    
    ItemManager parentContract;
    constructor(ItemManager _parentContract,uint _priceinwei,uint _indexy)public{
        priceinwei = _priceinwei;
    }
    
    receive()external payable{
        
    }
    
}


contract ItemManager{
    
    
    enum Suppchainstate{created, paid, delivered}
    
    struct S_item {
        Itm _item;
        string identify;
        uint itempri;
        ItemManager.Suppchainstate _state;
        
    }
    
    mapping(uint => S_item) public items;
    event SupplyChainStep(uint _itemindex,uint _step);
    
    uint public itemindex;
    
    function CreateItem(string memory _identifier,uint _itemprice) public {
        Itm item = new Itm(this,_itemprice,itemindex);
        items[itemindex].identify = _identifier;
        items[itemindex]._item = item;
        items[itemindex].itempri = _itemprice;
        items[itemindex]._state = Suppchainstate.created;
        itemindex++;
        emit SupplyChainStep(itemindex,uint(items[itemindex]._state));
    }
    
    
    function triggerPayment(uint index)public payable{
        require(items[index].itempri  == msg.value,"Only full payments accepted");
        require(items[index]._state == Suppchainstate.created,"Item is further in the supply chain");
        items[index]._state = Suppchainstate.paid;
        emit SupplyChainStep(index,uint(items[index]._state));
    }
    
    function triggerDelivery(uint index) public{
        require(items[index]._state == Suppchainstate.paid,"Item is further in the supply chain");
        items[index]._state = Suppchainstate.delivered;        
        emit SupplyChainStep(index,uint(items[index]._state));
    }
}
