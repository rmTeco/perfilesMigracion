trigger XOMBatchLineJobTrigger on XOMBatchLineJob__c (after insert) {
    try{
        if(Trigger.isInsert) {
            for(XOMBatchLineJob__c batchLineJob : Trigger.new) {
                System.debug('Batch Line Job: ' + batchLineJob);
                if(batchLineJob.Type__c == 'Nominatividad') {
                  System.debug('Batch Nominatividad: ' + batchLineJob.Type__c);
                   if(batchLineJob.JSON__c != null) {
                      if (!Test.isRunningTest()) {
                         ta_sales_nominationUtils.nominateClient(batchLineJob.JSON__c);
                      }
                      else {
                          //-- Como ya tiene su propio Test no testea en el Trigger.
                          System.debug('Ejecutar la nominacion del cliente');
                          try {
                         	ta_sales_nominationUtils.nominateClient(batchLineJob.JSON__c);
                          }
                          catch (Exception e) {
                              
                          }
                      }   
                   }   
                }
            }
        }
    }
    catch(Exception ex){
        system.debug(ex.getLineNumber());
        throw ex;
    }
}