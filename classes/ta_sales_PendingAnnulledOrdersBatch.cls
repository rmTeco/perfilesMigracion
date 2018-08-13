global with sharing class ta_sales_PendingAnnulledOrdersBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'SELECT AccountId, ContactId FROM Asset WHERE Contact.DocumentType__c = \'PAS\' AND Contact.PermanencyDueDate__c < TODAY';
        //String query = 'SELECT Id, Status, TrackingStatus__c FROM Order WHERE CreatedDate < YESTERDAY AND Status=\'Draft\'';
        //String query = 'SELECT Id, Status, TrackingStatus__c FROM Order WHERE Id =\'8016C0000008aoN\'';
        String query = 'SELECT Id, Status, TrackingStatus__c, CreatedDate FROM Order WHERE TrackingStatus__c = \'Pendiente de Anulacion\'';
        //TrackingStatus__c = \'Pendiente de Anulacion\' LIMIT 1';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {


        List<Order> orders = (List<Order>) scope;
        SalesOrderAnnulmentTimeout__c cs = SalesOrderAnnulmentTimeout__c.getInstance('DefaultTimeout');

        Decimal timeoutDays = cs.TimeoutDays__c;
        Decimal cantDays;
        Date orderDate;

        for(Order o: orders){
            system.debug('Orden Id ' + o.Id);
            try{
                orderDate = date.newinstance(o.CreatedDate.year(), o.CreatedDate.month(), o.CreatedDate.day());
                //cantDays = (orderDate).daysBetween(Date.valueOf(system.today()));
                cantDays = getWorkingDays(orderDate, system.today());

                system.debug('timeoutDays ' + timeoutDays);
                system.debug('orderDate ' + orderDate);
                system.debug('CantDays ' + cantDays);
                if (cantDays >= timeoutDays){
                    o.TrackingStatus__c = 'Cancelada - Timeout Validacion';
                }

            }
            catch(Exception e){
                System.debug('ta_sales_PendingAnnulledOrdersBatch Msg: ' + e.getMessage());
                System.debug('ta_sales_PendingAnnulledOrdersBatch Cause: ' + e.getCause());
                System.debug('ta_sales_PendingAnnulledOrdersBatch Trace: ' + e.getStackTraceString());
            }
        }

        system.debug('orders ' + orders);
        update orders;
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_PendingAnnulledOrdersBatch batch = new ta_sales_PendingAnnulledOrdersBatch();
        Database.executeBatch(batch);
    }

    //array of seven boolean indicating working days, Monday is index 0
    private static final List<Boolean> isWorkingDay;
    //count of the number of working days in the array
    private static final Integer workingDaysInWeek;
    static {
        //my real implementation uses the Salesforce BusinessHours Object to populate this array
        isWorkingDay = new List<Boolean> { true, true, true, true, true, false, false };
        //You will have real problems if this number does not match the number of true flags in the array
        workingDaysInWeek = 5;
    }

    private static final Date monday = Date.newInstance(1900, 1, 3);
    private static Integer getDayOfWeek(Date value) {
        return Math.mod(monday.daysBetween(value), 7);
    }

    public static Integer getWorkingDays(Date startDate, Date endDate) {
        //save some calculations when the number of working days is 0
        if(workingDaysInWeek == 0 || startDate == null || endDate == null) {
            return 0;
        } else {
            Integer difference = startDate.daysBetween(endDate);
            if(difference == 0) {
                //If the 2 dates are the same day check if the day is a working day or not
                return isWorkingDay[getDayOfWeek(startDate)] ? 1 : 0;
            } else if(workingDaysInWeek == 7) {
                //when every day is a working day return the difference
                return difference;
            } else {
                //The guts of the solution
                Integer wholeWeeks = Math.floor(difference / 7).intValue();
                Integer workingDays = wholeWeeks * workingDaysInWeek;
                Integer dayOfWeek = getDayOfWeek(endDate);
                for(Integer remainder = Math.mod(difference, 7); remainder >= 0; remainder--) {
                    if(isWorkingDay[dayOfWeek]) {
                        workingDays++;
                    }
                    dayOfWeek--;
                    if(dayOfWeek < 0) {
                        dayOfWeek = 6;
                    }
                }
                return workingDays;
            }
        }
    }
}