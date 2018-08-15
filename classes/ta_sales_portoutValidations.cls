global with sharing class ta_sales_portoutValidations implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
           Boolean result = true;
           try
           {
               if (methodName.equals('PortoutInProgressNomination')){ //Llamado desde OS NominateProcess
                   Boolean portoutFlag = PortoutInProgressNomination((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
                if (methodName.equals('PortoutInProgressVenta')){ //No aplicaria a nivel asset
                   Boolean portoutFlag = PortoutInProgressVenta((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 } 
                 if (methodName.equals('PortoutInProgressCompraDePack')){
                   Boolean portoutFlag = PortoutInProgressCompraDePack((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
                 if (methodName.equals('PortoutInProgressCambioDeSim')){ //Llamado desde OS SimCardChange
                   Boolean portoutFlag = PortoutInProgressCambioDeSim((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
                 if (methodName.equals('PortoutInProgressCambioDePlan')){ //No existe todavia
                   Boolean portoutFlag = PortoutInProgressCambioDePlan((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
                  if (methodName.equals('PortoutInProgressCambioDeEquipo')){ //No existe todavia
                   Boolean portoutFlag = PortoutInProgressCambioDeEquipo((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
                 if (methodName.equals('PortoutInProgressAltaBajaServicios')){
                   Boolean portoutFlag = PortoutInProgressAltaBajaServicios((Id) options.get('assetId'));
                   outMap.put('portoutFlag', portoutFlag);
                 }
            
           }
    
            catch(Exception e)
           
           {
             System.debug('taSalesPortoutValidations:invokeMethod -> exception: '+e);
              throw e;
             //result = false;
           }
           return result;
    }


    public Boolean PortoutInProgressNomination(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Nominacion'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
     public Boolean PortoutInProgressVenta(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Venta'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    public Boolean PortoutInProgressCompraDePack(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Compra de Pack'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    public Boolean PortoutInProgressCambioDeSim(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Cambio de Sim'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    public Boolean PortoutInProgressCambioDePlan(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Cambio de Plan'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    public Boolean PortoutInProgressCambioDeEquipo(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Cambio de Equipo'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    public Boolean PortoutInProgressAltaBajaServicios(Id assetId) {
            Boolean permite = true;
            
            RecordType recordT = [select id, name from RecordType where name = 'Portability'];
            
            Asset assetPO = [select id, MSISDN__c from Asset where id =: assetId];
            List<ConfiguracionPortout__c> customSetting = [select id, Permite__c from ConfiguracionPortout__c where name = 'Alta/Baja de servicio'];
            List<Case> casosPO = [Select id from Case where RecordTypeId =: recordT.id AND LineNumber__c =: assetPO.MSISDN__c];
            
            if(casosPO.size() >0 ){
                permite = customSetting[0].Permite__c;
            }
            
            return permite;
    }
    
    
}