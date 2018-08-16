@IsTest
public class FerretLogGeneratorV1_Test {
    
    @IsTest static void logMethodEntry_Test(){
   
        String className = 'Vlocity_PostProcessor_Multi';
        String methodName = 'calculate';
        
        
       	System.debug('options_--'+ className);
        Test.startTest();
        FerretLogGeneratorV1.logMethodEntry(className,methodName);
        Test.stopTest();
    }  
    
    @IsTest static void logMethodEntry_Test2(){
   
        String className = 'Vlocity_PostProcessor_Multi';
        String methodName = 'calculate';
        
        
       	System.debug('options_--'+ className);
        Integer sequenceNumber = FerretLogGeneratorV1.getSequenceNumber();
        Test.startTest();
        FerretLogGeneratorV1.logMethodExit(className, methodName, sequenceNumber);
        Test.stopTest();
    }      
}