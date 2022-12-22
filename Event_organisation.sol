// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 <0.9.0;

contract EventOrg {
    struct Event{
        address organisation;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date, uint price, uint ticketCount) external{
        require(date>block.timestamp, "You can organise event for future date");
        require(ticketCount > 0, "You can organise event only if you have more than 0 tickets ");
        events[nextId] = Event(msg.sender,name,date,price, ticketCount, ticketCount);
        nextId++;
    }
    function BuyTicket(uint id,uint quantity) external payable {
        require(events[id].date != 0,"This Events does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity) ,"Ether is not enough.");
        require(_event.ticketRemain >= quantity,"Enough tickets is not available");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTicket(uint id ,uint quantity,address to ) external{
       require(events[id].date != 0,"This Events does not exist");
       require(events[id].date>block.timestamp,"Event has already occured"); 
       require(tickets[msg.sender][id]>= quantity,"YOu have not enough tickets.");
       tickets[msg.sender][id] -= quantity;
       tickets[to][id] += quantity;
    }
}