// Solidity Version
pragma solidity ^0.8.0;

// Contract definition
contract SupplyChainFinancing {
    address public buyer;
    address public supplier;
    address public financier;
    uint public orderNumber;
    uint public orderAmount;
    uint public financiedAmount;

    enum OrderStatus { Placed, Approved, Completed }
    OrderStatus public status = OrderStatus.Placed;
    
    // Events to be emitted for specific actions
    event OrderPlaced(uint orderNumber, address buyer, address supplier, uint orderAmount);
    event OrderApproved(uint orderNumber, address financier, uint financedAmount);
    event OrderCompleted(uint orderNumber);

    // Modifier to restrict certain functions to the buyer only
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this function");
        _;
    }

    // Constructor function to set the buyer, supplier, and order details
    constructor(uint _orderNumber, address _buyer, address _supplier, uint _orderAmount) {
        buyer = _buyer;
        supplier = _supplier;
        orderNumber = _orderNumber;
        orderAmount = _orderAmount;
        emit OrderPlaced(orderNumber, buyer, supplier, orderAmount);
    }

    // Function for the financier to provide financing
    function approveOrder(uint _financiedAmount) public {
        require(status == OrderStatus.Placed, "Order has already been approved or completed");
        require(msg.sender != buyer && msg.sender != supplier, "Financier cannot be buyer or supplier");
        financier = msg.sender;
        financiedAmount = _financiedAmount;
        status = OrderStatus.Approved;
        emit OrderApproved(orderNumber, financier, financiedAmount);
    }

    // Function for the supplier to complete the order
    function completeOrder() public onlyBuyer {
        require(status == OrderStatus.Approved, "Order has not been financed yet");
        status = OrderStatus.Completed;
        emit OrderCompleted(orderNumber);
    }
}

