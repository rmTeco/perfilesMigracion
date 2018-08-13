/**
* Created by Kleytman Aular 22/11/2017
*
* Implements VlocityOpenInterface
* Provides the needed logic to support OS JSON VOI translation
*
* Objects: None - JSON translation for OS
*
* Important: The method uses a VlocityOpenInterface integration structure
*
* Version: 1.1
*
+ Modified by Federico Biaus 01/02/2019
* Add method GetWorkTeamHierarchy
* Version: 2.0
*
*/

global with sharing class ta_care_queryAdjustmentsHelper implements vlocity_cmt.VlocityOpenInterface {
    
    //Map<string, string> valoresMotivo {get; set;}
    
    global ta_care_queryAdjustmentsHelper(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('GetAdjustmentHistory')) {
                GetAdjustmentHistory(inputMap, outMap, options);
            }
            if (methodName.Equals('GetAdjustmentHistoryForOS')) {
                GetAdjustmentHistoryForOS(inputMap, outMap, options);
            }

            if(methodName.Equals('GetWorkTeamHierarchy'))
            {
                GetWorkTeamHierarchy(inputMap, outMap, options);
            }

            if(methodName.Equals('RecallApprovalProcess'))
            {
                RecallApprovalProcess(inputMap, outMap, options);
            }

            if(methodName.Equals('AmountLimitForUser'))
            {
                AmountLimitForUser(inputMap, outMap, options);
            }


        }
        catch(Exception ex) {outMap.put('error', ex.getStackTraceString());result = false;}return result;
    }

    global static void GetWorkTeamHierarchy(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        try
        {
            String approvalProfile = (String)options.get('approvalProfile');
            String workteamId = (String)options.get('workteamID');
            //String approvalProfile = 'TA - Gerente 2da Dependencia';
            //String workteamId = 'a4l6C0000000790';
            String finalManager;
            String parentTeamWork;
            Boolean flag = false;
            String strQuery = 'SELECT Id,Manager_Profile__c,Manager__c,Parent_Team__c FROM WorkTeam__c WHERE Id =:workteamId';
            Map<String,Object> result = new Map<String,Object>();
            result.put('approvalProfileR', '');

            if(String.isBlank(approvalProfile))
            {
                result.put('codError', '101');
                result.put('descError', 'El perfil no se encuentra correctamente configurado. Por favor, revise con el administrador la consulta y reintente nuevamente.');
                flag = true; 
            }
                
            if(String.isBlank(workteamId))
            {
                result.put('codError', '102');
                result.put('descError', 'El equipo de trabajo no se encuentra correctamente configurado. Por favor, revise con el administrador la consulta y reintente nuevamente.');
                flag = true; 
            }

            Id profileId = userinfo.getProfileId();
            String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;

            if(profileName == approvalProfile)
            {
                result.put('codError', '0');
                result.put('approvalProfileR', 'Representante');
                result.put('approvalId', profileId);
                flag = true; 
            }

           /* if(profileName == 'System Administrator'  )
            {
                result.put('codError', '0');
                result.put('approvalProfileR', 'FAN_Director');
                result.put('approvalId', '0056C000000xouc');
                flag = true; 
            }
            */

            while (!flag) 
            {
                List<WorkTeam__c> workTeams = (List<WorkTeam__c>)Database.query(strQuery);

                for(WorkTeam__c workTeam : workTeams)
                {
                    if((String)workTeam.get('Manager_Profile__c') == approvalProfile) 
                    { 
                        //Si el Manager profile es igual a approval profile quiere decir que encontre al manager
                        finalManager = (String)workTeam.get('Manager__c');
                        flag = true; 
                        result.put('codError', '0');
                        result.put('approvalId', finalManager);
                        break;
                    }

                    if(String.isBlank((String)workTeam.get('Parent_Team__c')))
                    { 
                        //Corto porque estoy en el padre (primero). Ver que hacer aca
                        result.put('codError', '103');
                        result.put('descError', 'El caso que intenta ejecutar no encuentra aprobador disponible. Por favor, revise con el administrador la consulta y reintente nuevamente.'); // Perfil: '+profileName + ' approvalProfile: '+ approvalProfile + ' workteamId: '+workteamId);
                        flag = true; 
                        break;
                    }
                                        
                    parentTeamWork = (String)workTeam.get('Parent_Team__c');
                    strQuery = 'SELECT Id,Manager_Profile__c,Manager__c,Parent_Team__c FROM WorkTeam__c WHERE Id =:parentTeamWork';
                }
            }

            outMap.put('result',result);

        }catch(Exception ex) { throw ex; }
    }
    
    global void GetAdjustmentHistory(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        // ***** *****  BUG  PFTA-10332 *********************** ////////////
        Map<String, Object> bodyNewMap = (Map<String,Object>) inputMap.get('body');
        System.debug('newBody_' + inputMap );
        String codSubcript = (String) inputMap.get('codSuscriptId');  
        Map<String, Object> resultNew = (Map<String,Object>) bodyNewMap.get('cuenta'); 
        
        
        Map<String, Object> codiT = (Map<String, Object>) resultNew.get('codigoAcceso');
        System.debug('result new_' + resultNew + '--' + codiT);
        
        codiT.put('codSuscripcion', codSubcript);
        
        bodyNewMap.put('cuenta',resultNew);
        bodyNewMap.put('fechaDesde', Date.today() - 5 );
        bodyNewMap.put('fechaHasta', Date.today());
        
        inputMap.put('body',bodyNewMap );
        System.debug('New Data' + inputMap);
        
        // ***** *****  //// ***********************
        
        //Getting S138 data from IP
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S138', inputMap, outMap, options);}
        //System.debug('inputMap: ' + inputMap);
        System.debug('outMap: ' + outMap);
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> ajustments = (List<Object>)result.get('listaDetalleAjuste');
        List<Object> ajustments2 = new List<Object>();
        for (Object a : ajustments){
            Map<string, object> aMap = ( Map<string, object>)a;
            aMap.put('motivoAjuste', getAdjustments_CBS__c.getInstance((string)aMap.get('codMotivoAjuste')).ServiceMessage__c);
            ajustments2.add(aMap);
        }
        result.put('listaDetalleAjuste', ajustments2);
        outMap.put('IPResult', result);
        //system.debug(json.serialize(outMap));
        
    }
    
    global void GetAdjustmentHistoryForOS(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        //Se llama al metodo GetAdjustmentHistory el cual usa custom settings para convertir los codMotivo a motivoAjuste
        GetAdjustmentHistory(inputMap, outMap, options);
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> ajustments = (List<Object>)result.get('listaDetalleAjuste');
        List<Object> ajustments2 = new List<Object>();
        //se transforma los elementos de la lista listaDetalleAjuste para ajustar la estructura a el template que los mostrará
        for (Object a : ajustments){
            Map<string, object> aMap = new Map<string, object>();
            Map<string, object> aMapAux = (Map<string, object>)a;
            //Se obtiene el monto del ajsute de la lista AjusteBalanceInfo, 
            //esto pudiera ser una sumatoria, pero por ahora solo se está tomando el primer elemento
            List<Object> BalanceInfo = (List<Object>)aMapAux.get('listaAjusteBalanceInfo');
            Map<string, object> BIMapAux = (Map<string, object>)BalanceInfo[0];
            
            aMap.put('Amount', BIMapAux.get('montoAjuste'));
            aMap.put('CaseNumber', '000011111');
            aMap.put('CreatedDate', aMapAux.get('fechaAjuste'));
            aMap.put('Id', 'ID11111111111');
            aMap.put('CaseStatus', 'Derivada');
            aMap.put('Tipo', aMapAux.get('motivoAjuste'));
            aMap.put('TipoConcepto', BIMapAux.get('tipoAjuste'));
            aMap.put('TipoItem', aMapAux.get('motivoAjuste'));
            ajustments2.add(aMap);
        }
        
        //Se intenta leer la lista de ajustes historias enviados como options a traves
        //de un remote action de un OmniScript
        List<Object> AdjustmentCases = new List<Object>();
        try{
            AdjustmentCases = (List<Object>)options.get('HistoricalAdjustments');
            
        }catch(Exception ex){ System.debug(ex.getMessage()); }
        
        //Si existen elementos se agregan al objeto, union de las dos listas
        for (object o : AdjustmentCases){
            ajustments2.add((Map<string, object>)o);
        }
        
        result.put('listaDetalleAjuste', ajustments2);
        outMap.put('IPResult', result);
        system.debug(json.serialize(outMap));
        
    } 

    global static void RecallApprovalProcess(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) 
    {
        try
        {
            String caseId = (String) options.get('id');

            ProcessInstanceWorkitem[] workItems = [
             SELECT Id
               FROM ProcessInstanceWorkitem 
              WHERE ProcessInstance.TargetObjectId =:caseId
                AND ProcessInstance.Status = 'Pending'];


             Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
             pwr.setAction('Removed');
             pwr.setWorkItemId(workItems[0].id);
             Approval.ProcessResult result = Approval.process(pwr);
        }
        catch(Exception ex)
        {
            System.debug('error: '+ ex.getMessage());
        }
    }

    /* Metodo utilizado para validar los montos maximos en ajustes para cada vendedor/cliente */
    global static void AmountLimitForUser(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Map<String,Object> result = new Map<String,Object>();
        String approvalProfile = (String) options.get('approvalProfile');
        try
        {
            Double newAmount = Double.valueOf(options.get('Amount'));
            
            String tipoSeleccion = (String) options.get('TipoSeleccion');
            //Id accountId = (Id) options.get('AccountId');
            Id serviceId = (Id) options.get('ServiceId');
            Id userId = UserInfo.getUserId();
            Id caseId = (Id) options.get('caseId');

            if(tipoSeleccion == 'Servicio')
            {
                System.debug('Nuevo monto: '+newAmount);           
                System.debug('Aprobador: '+approvalProfile);
                System.debug('Servicio: '+serviceId);
                System.debug('Usuario: '+userId);
                System.debug('Case: '+caseId);

                Double limitThreshold = 0;
                if(!Test.isRunningTest())
                {
                    RAV_Max_Amount__c objMaxAmount = RAV_Max_Amount__c.getValues(approvalProfile);
                    limitThreshold = Double.valueOf(objMaxAmount.get('Max_amount__c'));
                    System.debug('Limite: '+limitThreshold);
                }
                else
                {
                    limitThreshold = 2000;
                }

                List<AggregateResult> listObj = [SELECT SUM(vlocity_cmt__Amount__c) totalAmount FROM Case WHERE LastModifiedById=:userId AND vlocity_cmt__ServiceId__c=:serviceId AND Status='Realizada exitosa' AND CreatedDate=LAST_N_DAYS:30];
                
                //En base a lo arcordado en la demo 19, no se debe tener en cuenta esta validacion para cuentas.
                //listObj = [SELECT SUM(vlocity_cmt__Amount__c) totalAmount FROM Case WHERE LastModifiedById=:userId AND AccountId=:accountId AND Status='Realizada exitosa' AND CreatedDate=LAST_N_DAYS:30];

                Double currentTotalAmount;
                if(listObj[0].get('totalAmount') != null)
                     currentTotalAmount = Double.valueOf(listObj[0].get('totalAmount'));
                else
                    currentTotalAmount = 0;

                Double currentAmount = currentTotalAmount + newAmount;

                System.debug('Acumulado: ' +currentTotalAmount);
                System.debug('Total Amount: '+ currentAmount);

                //Si el monto a ajustar mas lo ya ajustado supera el umbral definido bloqueamos la operacion y se envia mail al gerente. 
                if(currentAmount > limitThreshold) {
                    result.put('codError', '101');
                    result.put('descError', 'El usuario '+UserInfo.getFirstName()+' '+ UserInfo.getLastName() +' ha superado el monto máximo de desdoblamiento para ajustar a la cuenta.'); //+' approvalProfile: '+approvalProfile+ ' limitThreshold: '+limitThreshold);
                    options.put('templateName', 'Send_Email_when_max_adjustment_amount_is_reached');
                   // options.put('caseOwner', options.get('caseOwner'));
                    options.put('caseOwner', userId);
                    options.put('caseId', caseId);
                    taEmails.sendEmailToWorkteamManager(inputMap, outMap, options);
                }
                else {
                    result.put('codError', '0');
                }

                outMap.put('result',result);
            }
            else //Cuando se trata de de un POSPAGO (Cuenta) no es necesario validar el monto maximo.
            {
                result.put('codError', '0');
            }
        }
        catch (Exception ex)
        {
            result.put('codError', '101');
            result.put('descError', 'Error al ejecutar AmountLimitForUser. DescError: ' + ex.getMessage());
            outMap.put('result',result);
        }
    }
}