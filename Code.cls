public class VehicleOrderTriggerHandler {

    public static void handleTrigger(List<Vehicle_Order_c> newOrders, Map<Id, Vehicle_Order_c> oldOrders,
                                     Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate) {
        if (isBefore) {
            if (isInsert) {
                assignNearestDealer(newOrders);
            }
            preventOrderIfOutOfStock(newOrders, oldOrders);
        }
        if (isAfter) {
            updateStockOnConfirm(newOrders, oldOrders);
        }
    }

    // Auto-assign dealer: customer Address_c = dealer Dealer_Location_c
    private static void assignNearestDealer(List<Vehicle_Order__c> orders) {
        Set<Id> customerIds = new Set<Id>();
        for (Vehicle_Order__c o : orders) {
            if (o.Vehicle_Customer_c != null && o.Dealer_c == null) {
                customerIds.add(o.Vehicle_Customer__c);
            }
        }
        if (customerIds.isEmpty()) return;

        Map<Id, Vehicle_Customer_c> customers = new Map<Id, Vehicle_Customer_c>(
            [SELECT Id, Address_c FROM Vehicle_Customer_c WHERE Id IN :customerIds]);

        Set<String> addresses = new Set<String>();
        for (Vehicle_Customer__c c : customers.values()) {
            if (c.Address_c != null) addresses.add(c.Address_c);
        }

        Map<String, Id> dealerByLocation = new Map<String, Id>();
        for (Vehicle_Dealer_c d : [SELECT Id, Dealer_Locationc FROM Vehicle_Dealer_c
                                    WHERE Dealer_Location__c IN :addresses]) {
            dealerByLocation.put(d.Dealer_Location__c, d.Id);
        }

        for (Vehicle_Order__c o : orders) {
            if (o.Dealer_c == null && customers.containsKey(o.Vehicle_Customer_c)) {
                String addr = customers.get(o.Vehicle_Customer_c).Address_c;
                if (addr != null && dealerByLocation.containsKey(addr)) {
                    o.Dealer__c = dealerByLocation.get(addr);
                }
            }
        }
    }

    // Block the order when stock is 0
    private static void preventOrderIfOutOfStock(List<Vehicle_Order_c> orders, Map<Id, Vehicle_Order_c> oldOrders) {
        Set<Id> vehicleIds = new Set<Id>();
        List<Vehicle_Order_c> toCheck = new List<Vehicle_Order_c>();

        for (Vehicle_Order__c o : orders) {
            Boolean isNew = (oldOrders == null || !oldOrders.containsKey(o.Id));
            Boolean becameConfirmed = !isNew && o.Status__c == 'Confirmed'
                                      && oldOrders.get(o.Id).Status__c != 'Confirmed';
            if (o.Vehicle__c != null && (isNew || becameConfirmed)) {
                vehicleIds.add(o.Vehicle__c);
                toCheck.add(o);
            }
        }
        if (vehicleIds.isEmpty()) return;

        Map<Id, Vehicle_c> stockMap = new Map<Id, Vehicle_c>(
            [SELECT Id, Stock_Quantity_c FROM Vehicle_c WHERE Id IN :vehicleIds]);

        for (Vehicle_Order__c o : toCheck) {
            Vehicle_c v = stockMap.get(o.Vehicle_c);
            if (v != null && (v.Stock_Quantity_c == null || v.Stock_Quantity_c <= 0)) {
                o.addError('This vehicle is out of stock. Order cannot be placed.');
            }
        }
    }

    // Reduce stock once, when an order becomes Confirmed
    private static void updateStockOnConfirm(List<Vehicle_Order_c> orders, Map<Id, Vehicle_Order_c> oldOrders) {
        Set<Id> vehicleIds = new Set<Id>();
        List<Vehicle_Order_c> confirmed = new List<Vehicle_Order_c>();

        for (Vehicle_Order__c o : orders) {
            Boolean isNew = (oldOrders == null || !oldOrders.containsKey(o.Id));
            Boolean wasConfirmed = !isNew && oldOrders.get(o.Id).Status__c == 'Confirmed';
            if (o.Vehicle_c != null && o.Status_c == 'Confirmed' && !wasConfirmed) {
                vehicleIds.add(o.Vehicle__c);
                confirmed.add(o);
            }
        }
        if (vehicleIds.isEmpty()) return;

        Map<Id, Vehicle_c> stockMap = new Map<Id, Vehicle_c>(
            [SELECT Id, Stock_Quantity_c FROM Vehicle_c WHERE Id IN :vehicleIds]);

        Set<Id> changed = new Set<Id>();
        for (Vehicle_Order__c o : confirmed) {
            Vehicle_c v = stockMap.get(o.Vehicle_c);
            if (v != null && v.Stock_Quantity__c > 0) {
                v.Stock_Quantity__c -= 1;
                changed.add(v.Id);
            }
        }

        List<Vehicle_c> toUpdate = new List<Vehicle_c>();
        for (Id vid : changed) toUpdate.add(stockMap.get(vid));
        if (!toUpdate.isEmpty()) update toUpdate;
    }
}
