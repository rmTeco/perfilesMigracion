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
        try
        {
            //DateTime fechaIncio = DateTime.now() - 20;
            //String codSuscriptor =  '9900000352810001';
            String sDate, eDate;

            if((String.valueOf(inputMap.get('startDateFilter')) == null) && (String.valueOf(inputMap.get('endDateFilter')) == null))
            {
                DateTime fechaIncio = DateTime.now() - 5;
                DateTime fechaFin = DateTime.now() + 1;
                sDate = String.valueOf(fechaIncio);
                eDate = String.valueOf(fechaFin);

            } 
            else
            {
                sDate = String.valueOf(inputMap.get('startDateFilter'));
                eDate = String.valueOf(inputMap.get('endDateFilter'));
            }

            String codSuscriptor = String.valueOf(inputMap.get('codSuscriptor'));
            String cantidadMaxConsulta = String.valueOf(inputMap.get('cantidadMaxConsulta'));
            String referenciaItemPaginado = String.valueOf(inputMap.get('referenciaItemPaginado'));
            String cantidadItemsConsulta = String.valueOf(inputMap.get('cantidadItemsConsulta'));

            Map<String, Object> result2 = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();

            String jsonString = '{"body":{"cantidadItemsConsulta":'+cantidadItemsConsulta+',"cantidadMaxConsulta":'+cantidadMaxConsulta+',"cuenta":{"codigoAcceso":{"codSuscripcion":"'+codSuscriptor+'"}},"fechaDesde":"'+sDate+'","fechaHasta":"'+eDate+'","infoDetalle":{},"referenciaItemPaginado":'+referenciaItemPaginado+'}}';

            System.debug('Request jsonString: '+jsonString);
            Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            if(!Test.isRunningTest()){
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S138', input, outputMap, options);
                System.debug('Response S138: '+outputMap);
            }
            else
            {
                outputMap = outMap;
            }

            Map<String, Object> result = (Map<String, Object>)outputMap.get('IPResult');
            Map<String, Object> mapAjustes;

            List<Object> ajustments = (List<Object>)result.get('listaDetalleAjuste');
            List<Object> ajustments2 = new List<Object>();

            if(ajustments == null)
            {
                mapAjustes = new Map<String, Object>();
                mapAjustes.put('codError', '201');
                mapAjustes.put('descError', 'No hay registros en los ultimos 5 dias.');
                ajustments2.add(mapAjustes);
            }
            else
            {
                for (Object a : ajustments){
                    mapAjustes = new Map<String, Object>();
                    Map<string, object> aMap = ( Map<string, object>)a;
                    
                    mapAjustes.put('motivoAjuste', String.valueOf(aMap.get('codMotivoAjuste')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codMotivoAjuste')));
                    mapAjustes.put('codCanal', String.valueOf(aMap.get('codCanal')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codCanal')));
                    mapAjustes.put('fechaAjuste', String.valueOf(aMap.get('fechaAjuste')) == '' ? 'Sin datos' : String.valueOf(aMap.get('fechaAjuste')));
                    mapAjustes.put('codCuentaTasacion', String.valueOf(aMap.get('codCuentaTasacion')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codCuentaTasacion')));

                    List<Object> listaAjusteBalanceInfo = (List<Object>)aMap.get('listaAjusteBalanceInfo');
                    List<Object> listaInfoAjusteUnidadesLibres = (List<Object>)aMap.get('listaInfoAjusteUnidadesLibres');
                    
                    if(listaAjusteBalanceInfo != null)
                    {
                        mapAjustes.put('codigoAjuste', 'Balance');

                        for(Object b : listaAjusteBalanceInfo)
                        {
                            Map<string, object> bMap = ( Map<string, object>)b;

                            //Los ajustes realizados impactan sobre C_MAIN_ACCOUNT en el caso de Balance.
                            if(String.valueOf(bMap.get('codTipoBalance')) == 'C_MAIN_ACCOUNT')
                            {
                                mapAjustes.put('codMoneda', String.valueOf(bMap.get('codMoneda')) == null ? 'Sin datos' : String.valueOf(bMap.get('codMoneda')));
                                mapAjustes.put('montoAjuste', String.valueOf(bMap.get('montoAjuste')) == null ? 'Sin datos' : String.valueOf(bMap.get('montoAjuste')));
                                mapAjustes.put('tipoAjuste', String.valueOf(bMap.get('tipoAjuste')) == null ? 'Sin datos' : String.valueOf(bMap.get('tipoAjuste'))); 
                                mapAjustes.put('fechaExpiracionBalance', String.valueOf(bMap.get('fechaExpiracionBalance')) == null ? 'Sin datos' : String.valueOf(bMap.get('fechaExpiracionBalance')));
                                mapAjustes.put('codTipoBalance', String.valueOf(bMap.get('codTipoBalance'))); 
                            }
                        }
                        ajustments2.add(mapAjustes);
                    }
                    else
                    {
                        if(listaInfoAjusteUnidadesLibres != null)
                        {
                            mapAjustes.put('codigoAjuste', 'Libre');

                            for(Object c : listaInfoAjusteUnidadesLibres)
                            {
                                Map<string, object> cMap = ( Map<string, object>)c;
                                mapAjustes.put('codUnidadDeMedida', String.valueOf(cMap.get('codUnidadDeMedida')) == null ? 'Sin datos' : String.valueOf(cMap.get('codUnidadDeMedida')));
                                mapAjustes.put('montoAjuste', String.valueOf(cMap.get('montoAjuste')) == null ? 'Sin datos' : String.valueOf(cMap.get('montoAjuste')));
                                mapAjustes.put('tipoAjuste', String.valueOf(cMap.get('tipoAjuste')) == null ? 'Sin datos' : String.valueOf(cMap.get('tipoAjuste'))); 
                                mapAjustes.put('fechaAjusteVigenciaHasta', String.valueOf(cMap.get('fechaAjusteVigenciaHasta')) == null ? 'Sin datos' : String.valueOf(cMap.get('fechaAjusteVigenciaHasta')));
                            }
                            ajustments2.add(mapAjustes);
                        }
                    }
                }   
            }

        result2.put('listaDetalleAjuste', ajustments2);
        result2.put('cantidadMaxConsulta', result.get('cantidadMaxConsulta'));
        result2.put('referenciaItemPaginado', result.get('referenciaItemPaginado'));
        result2.put('cantidadItemsConsulta', result.get('cantidadItemsConsulta'));
        outMap.put('IPResult', result2);
        System.debug('outMap: '+outMap);
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
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