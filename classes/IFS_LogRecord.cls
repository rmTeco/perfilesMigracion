global with sharing class  IFS_LogRecord
{
    /**
     * Objetivo: Recibe los datos necesarios para crear un registro en el objeto custom Log
     * Parametros: 
     * String timestamp: string con formato 'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'
     * String tipoLog: indica el tipo de log que se registra, para los servicios es 'SERVICIO'
     * String origen: indica quien genera el Log, para los servicios se informa el código del servicio. Ej 'S125'
     * String idUnico: contiene el identificador único de transacción
     * String reqResp: 'REQ'indica que es un registro de un request. 'RES' indica que es un registro de un response
     * String params: Si se ha informado atributos en params del request se informa aquí
     * String infoAdicional: cuando se registra un request va vacío. Si es un response se coloca el código de estado, la
     * descripción del estado separados por ';'. Si el servicio ha obtenido un response no se registra nada más, si no se ha obtenido
     * un response se agrega, también separado por  el separador anteriormente indiado, 'request to DPW  FAIL ; request body = ' + el body del request
     */
    public Static void record(String timestamp, String tipoLog, String origen,String reqRes, String idUnico, String params, String infoAdicional)
    { 
        System.debug('------------- Auto number seID : ' + 0);
        System.debug('--------------timesamp         : ' + timestamp);
        System.debug('--------------tipoLog          : ' + tipoLog);
        System.debug('--------------origen           : ' + origen );
        System.debug('--------------idUnico          : ' + idUnico );
        System.debug('--------------reqRes           : ' + reqRes );
        System.debug('--------------params           : ' + params );
        System.debug('--------------infoAdicional    : ' + infoAdicional ); 

        IntegrationLog__c logRec = new IntegrationLog__c();
        logRec.Adittional_Info__c = infoAdicional;
        logRec.Indicative__c = reqRes;
        logRec.Log_Type__c = tipoLog;
        logRec.Origin__c = origen;
        logRec.Paramts__c = params;
        logRec.Timestamp__c = timestamp; 
        logRec.Transaction_ID__c = idUnico;

        //Savepoint sp = Database.setSavepoint();  
         System.debug('--------------Antes de insert ' );
        try{
            insert logRec;
        } catch (Exception e) {
            throw(e);    
        }
        System.debug('--------------AL FINAL ' );
    }
    
}