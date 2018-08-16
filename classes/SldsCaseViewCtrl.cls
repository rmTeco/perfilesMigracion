global class SldsCaseViewCtrl{
    
    public SldsCaseViewCtrl(){
    
    }
    
    @RemoteAction
    global static String getCase(String id){
        Case objCase = [SELECT id, Subject, CaseNumber, Account.Name, Status FROM Case WHERE id = :id];
        
        String srlzCase = JSON.Serialize(objCase );
        
        return srlzCase;
    }
    
    @RemoteAction
    global static String updateCase(String jsCase){
        try{
            Map<String, Object> cObjMapFurious = (Map<String, Object>) JSON.deserializeUntyped(jsCase);
            
            String cObjJsonDrunk = JSON.serialize(cObjMapFurious);
            
            Case objCase = (Case) JSON.deserialize(cObjJsonDrunk, Case.class);
            
            update objCase;
            
            return 'true';
        } catch(Exception ex) {
            return 'Error en apex: ' + ex.getMessage();
        }
    }

}