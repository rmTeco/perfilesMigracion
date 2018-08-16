@isTest
public class USComp_Extractor_test {
    
    public static integer USReference = 0;
    
    @testSetup static void setup() {
        List<copado__User_Story__c> tempUS = createCopadoUs(1);
		String attachmentWithPermissionSet = '[{"t":"PermissionSet","n":"PermissionSetTest","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"},{"t":"ApexClass","n":"IFS_S454_changeFriendsAndFamilyTest","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"}]';
 	 	createAttachmentWithJson(tempUS.get(0).ID,attachmentWithPermissionSet);    
        Funcionalidad__c funcionalidad = new Funcionalidad__c(Name='f1',C_digo_de_la_Funcionalidad__c='Code#1');
        insert funcionalidad;
    }
    
    @isTest
    static void integrityTest() {
        Test.startTest();
        USComp_Extractor.extractTest('Sprint18');
        createCopadoUs(5);
        USComp_Extractor.extractTest('Sprint18');
        createCopadoUs(10);
        USComp_Extractor.extractTest('Sprint18');
        USComp_Extractor.extractTest('Sprint18');
        createCopadoUs(10);
        USComp_Extractor.extractTest('Sprint18');
        USComp_Extractor.extractTest('Sprint18');
        USComp_Extractor.extractTest('Sprint18');
        
        integer countUS = [Select count() from Historias_de_Usuario__c];
        integer countComp = [Select count() from Componente__c];
        System.assertEquals(26,countUS);
        System.assertEquals(104,countComp);
        Test.stopTest();
    }
  
    @isTest
    static void loadTest() {
        Test.startTest();
        createCopadoUs(500);
        USComp_Extractor.extractTest('Sprint18');
        createCopadoUs(5);
        USComp_Extractor.extractTest('Sprint18');
        integer countUS = [Select count() from Historias_de_Usuario__c];
        integer countComp = [Select count() from Componente__c];
        System.assertEquals(506,countUS);
        System.assertEquals(2024,countComp);
        Test.stopTest();
    }
   

    public static List<copado__User_Story__c> createCopadoUs(integer numberOfCopadoUS) {
        
        copado__Sprint__c newSprint = new copado__Sprint__c(Name='Sprint18');
        copado__Team__c  newTeam = new copado__Team__c(Name='ATeam');
        insert newSprint;
        insert newTeam;
        List<copado__User_Story__c> newCopadoUS = new  List<copado__User_Story__c>();
      
        for(integer i = 0; i < numberOfCopadoUS; i++){
            String newTitle = 'PFTA-00' + USReference;
            String newCode = 'Code#' + USReference;
            copado__User_Story__c newUS = new copado__User_Story__c(copado__Sprint__c=newSprint.ID,copado__Team__c=newTeam.ID,copado__User_Story_Title__c=newTitle,C_digo_de_la_Funcionalidad__c=newCode);   
        	newCopadoUS.add(newUS);
            USReference++;
        }  
        insert newCopadoUS;
        
        List<Attachment> newAttachments = new  List<Attachment>();
        for(copado__User_Story__c copadoUS : newCopadoUS) {
           newAttachments.add(createAttachment(copadoUS.ID)); 
        }
        insert newAttachments; 
        return newCopadoUS;
    }
     public static Attachment createAttachmentWithJson(ID uSParentID, String data){
  		Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf(data);
  		attachment.Name = 'Git MetaData';
  		attachment.ParentId = uSParentID;
 	 	return attachment;
     }
    
    
    public static Attachment createAttachment(ID uSParentID){
  		String data = '[{"t":"ApexClass","n":"IFS_S454_changeFriendsAndFamily_cls","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"},{"t":"ApexClass","n":"IFS_S454_changeFriendsAndFamilyTest","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"},{"t":"ApexClass","n":"IFS_LogRecordTest","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"},{"t":"ApexClass","n":"IFS_LogRecord","cmm":"updated","snapshotCommitId":"a7A41000000TRUeEAO"}]';
 	 	return createAttachmentWithJson(uSParentID,data);
	}
    

}