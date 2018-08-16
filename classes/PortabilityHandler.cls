public class PortabilityHandler {

    @future(callout=true) 
    public static void ProcessPortability(List<Id> cases){
        String methodName = 'ProcessPortability';
        List<Asset> lines;
        List<String> lineNos;
        //List<CaseComments> coms;
        Case caseObj;
        //Id caseId;
        Asset line;
        Integer linesize;
        Boolean nonstop = true;
        Map<String,Integer> markets;
        String auxMarket;
        Integer auxInt;
        Double montoRecarga;
        Double montoMinimo;
        String PortOutReject_POSbutPre, PortOutReject_NonTPLines, PortOutReject_StayLimit,PortOutReject_PREbutPos, PortOutReject_PREDontMeet, PortOutReject_StayLimitDays;
        //A03, A01, A02, A04, M58, 60
        Integer daysfrom, iStayLimitDays;
        Datetime dtFrom;
        Datetime dtToday;
        List<Case> casesProcess = new List<Case>();
        List<Asset> assetProcess = new List<Asset>();
        
        try{

            //Get CS values for Portout reject reason codes
            Map<String,Object> inMap = new Map<String,Object>();
            Map<String,Object> oMap = new Map<String,Object>();
            Map<String,Object> optMap = new Map<String,Object>();
            List<Object> csFields = new List<Object>();
            

            optMap.put('CSName','TASalesCodeValue__c');
            Map<String,Object> auxMap = new Map<String,Object>();
            auxMap.put('field', 'Value__c');
            csFields.add(auxMap); 
            optMap.put('CSFields',csFields);
            SaleManager sm = new SaleManager();

            optMap.put('CSAtribute','PortOutReject_NonTPLines');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            TASalesCodeValue__c cs = (TASalesCodeValue__c) oMap.get('CSValues');
            PortOutReject_NonTPLines = cs.Value__c;
            System.debug('PortOutReject_NonTPLines: ' + PortOutReject_NonTPLines);

            optMap.put('CSAtribute','PortOutReject_StayLimit');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            PortOutReject_StayLimit = cs.Value__c;
            System.debug('PortOutReject_StayLimit: ' + PortOutReject_StayLimit);

            optMap.put('CSAtribute','PortOutReject_PREbutPos');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            PortOutReject_PREbutPos = cs.Value__c;
            System.debug('PortOutReject_PREbutPos: ' + PortOutReject_PREbutPos);

            optMap.put('CSAtribute','PortOutReject_POSbutPre');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            PortOutReject_POSbutPre = cs.Value__c;
            System.debug('PortOutReject_POSbutPre: ' + PortOutReject_POSbutPre);

            optMap.put('CSAtribute','PortOutReject_PREDontMeet');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            PortOutReject_PREDontMeet = cs.Value__c;
            System.debug('PortOutReject_PREDontMeet: ' + PortOutReject_PREDontMeet);

            optMap.put('CSAtribute','PortOutReject_DaysFrom');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            daysfrom = Integer.valueOf(cs.Value__c);
            System.debug('PortOutReject_DaysFrom: ' + cs);
            daysFrom = daysFrom * -1;
            dtToday = Datetime.now();
            dtFrom = dtToday.addDays(daysfrom);
            System.debug('dtFrom : ' + dtFrom );

            optMap.put('CSAtribute','PortOutReject_StayLimitDays');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            iStayLimitDays = Integer.valueOf(cs.Value__c) * -1;
            System.debug('PortOutReject_StayLimitDays: ' + iStayLimitDays);

            optMap.put('CSAtribute','PortOutReject_MinBalance');
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            cs = (TASalesCodeValue__c) oMap.get('CSValues');
            montominimo = Double.valueOf(cs.Value__c);
            System.debug('PortOutReject_MinBalance: ' + montominimo);

            //Case ca = [Select (Select CommentBody From CaseComments) From Case Where Id = '5006C000001AUBS' LIMIT 1]

            //Process Case
            List<Case> caseList = [Select Id, Port_Market__c, Port_Rejection_Reason__c, Status, Subarea__c, ExternalCaseId__c, (Select CommentBody From CaseComments) From Case Where Id IN:cases];
            Map<Id,List<String>> mapListLines = new Map<Id,List<String>>();
            lineNos = new List<String>();
            for (case caseOb : caseList){
                List<String> lineNosAux = new List<String>();
                for (CaseComment com: caseOb.CaseComments){
                    lineNos.add(com.CommentBody);
                    lineNosAux.add(com.CommentBody);
                }
                mapListLines.put(caseOb.Id,lineNosAux);
            }
            lines = [SELECT vlocity_cmt__ActivationDate__c, Product2.vlocity_cmt__Type__c, MSISDN__c FROM Asset WHERE MSISDN__c in :lineNos AND Status = 'Active'];
            Map<String,Asset> mapLines = new Map<String,Asset>();
            for (Asset lineAux : lines){
                mapLines.put(lineAux.MSISDN__c, lineAux);
            }
            
            for(Case caseOb: CaseList) { 

                if (caseOb.Subarea__c == 'APSI'){
                    List<Asset> linesAux = new List<Asset>();
                    List<String> lineNosAux = new List<String>();
                    for (CaseComment com: caseOb.CaseComments){
                        linesAux.add(mapLines.get(com.CommentBody));
                    }
                    lineNosAux = mapListLines.get(caseOb.Id);
                    //create a mapping to count quantity of lines of each market family
                    markets = new Map<String,Integer>();
                    for (Asset lineObj: linesAux){
                        auxMarket = lineObj.Product2.vlocity_cmt__Type__c;
                        System.debug('auxMarket: '+auxMarket);
                        if(auxMarket == 'Plan Pospago' || auxMarket == 'Plan Hibrido')
                            auxMarket = 'POS';
                        else
                            auxMarket = 'PRE';
                        
                        if(markets.containsKey(auxMarket)){
                            auxInt = markets.get(auxMarket);
                            markets.put(auxMarket, auxInt++); 
                        }
                        else
                            markets.put(auxMarket, 1);
                        
                    } //end for assets
                    System.debug('markets: '+markets);

                    //If some of the lines are not in the CRM reject the request with the corresponding reason code
                    if (linesAux.size() != lineNosAux.size()){
                        System.debug('reject: linesAux.size()='+ linesAux.size()+ '!= lineNosAux.size()=' +lineNosAux.size());
                        caseOb.Port_Rejection_Reason__c = PortOutReject_NonTPLines;
                    }
                    else{
                        //Product2: 'Plan Prepago', 'Plan Pospago', 'Plan Hibrido'
                        //Every lines has to belong to the same market segment
                        linesize = linesAux.size();

                        if(caseOb.Port_Market__c == 'PRE'){
                            //Prepaid validations
                            System.debug('Case Port Market='+caseOb.Port_Market__c);
                            System.debug('markets.containsKey(POS) =' + markets.containsKey('POS'));
                            System.debug('lines[0].vlocity_cmt__ActivationDate__c =' +linesAux[0].vlocity_cmt__ActivationDate__c);
                            System.debug('date.today().addDays(iStayLimitDays) ='+ date.today().addDays(iStayLimitDays));
                            
                            if (lineNos.size() > 1){
                                //Prepaid port request could only have 1 line
                                caseOb.Port_Rejection_Reason__c = PortOutReject_PREDontMeet;
                                System.debug('reject: lineNos.size()='+ lineNos.size()+' > 1');
                            }
                            else if(linesAux[0].vlocity_cmt__ActivationDate__c > date.today().addDays(iStayLimitDays)){
                                //if the activation date is more recent than iStayLimitDays days as today, reject the request
                                caseOb.Port_Rejection_Reason__c = PortOutReject_StayLimit;
                                System.debug('reject: linesAux[0].vlocity_cmt__ActivationDate__c='+linesAux[0].vlocity_cmt__ActivationDate__c+ '< date.today().addDays(iStayLimitDays)='+date.today().addDays(iStayLimitDays));
                            }
                            else if(markets.containsKey('POS')){
                                //A PRE request doesn't has to have POS linesAux in the list
                                caseOb.Port_Rejection_Reason__c = PortOutReject_PREbutPos;
                                System.debug('reject: markets.get(POS)='+markets.get('POS')+ ' != null) ');
                            }
                            else{
                                montoRecarga = consultarMonto(linesAux[0].MSISDN__c, dtFrom, dtToday);
                                if (montoRecarga < montominimo){
                                    caseOb.Port_Rejection_Reason__c = PortOutReject_PREDontMeet;
                                    System.debug('reject: montoRecarga ='+montoRecarga+ '< montominimo='+montominimo);
                                }

                            }

                        }//end If PRE line
                        else if(caseOb.Port_Market__c == 'POS'){
                            System.debug('Case Port Market='+caseOb.Port_Market__c);
                            System.debug('markets.containsKey(PRE) =' + markets.containsKey('PRE'));
 
                            if(markets.containsKey('PRE')){
                                //A POS request doesn't has to have PRE lines in the list
                                caseOb.Port_Rejection_Reason__c = PortOutReject_POSbutPre;
                                System.debug('reject: markets.get(PRE)='+markets.get('PRE')+ ' != null) ');
                            } 
                        }
                    } //end id 
                        String aceptada;

                        if (caseOb.Port_Rejection_Reason__c != null){
                            aceptada = 'false';
                            caseOb.Status = 'Rechazada Pendiente ABD';
                        }        
                        else{
                            aceptada = 'true';
                            caseOb.Status = 'Aprobada Pendiente de Portación';
                            //List<Asset> auxAssets = new List<Asset>();
                            for (Asset lineObj: linesAux)
                                lineObj.PortOut__c = true;
                            //update lines;
                            assetProcess.addAll(linesAux);
                            
                        }
                    

                    //update caseOb;
                    casesProcess.add(caseOb);
                    String noSol = caseOb.ExternalCaseId__c;
                    String codInteraccion = 'ID1';
                    String codCausa = caseOb.Port_Rejection_Reason__c;

                    //invoke IF005
                    Integer resultBDO = informBDO(noSol,aceptada, codCausa, codInteraccion, '1', 'Luis');
                    System.debug('resultBDO='+resultBDO);

                }//end if
                else if (caseOb.Subarea__c == 'RESI'){
                    caseOb.Status = 'Rechazada Pendiente ABD';
                    casesProcess.add(caseOb);
                }
 
                
            }//end for
            update assetProcess;
            update casesProcess;

        }//end try

        catch(Exception e){
            System.debug(methodName+ ' Msg: ' + e.getMessage());
            System.debug(methodName+ ' Cause: ' + e.getCause());
            System.debug(methodName+ ' Stack Trace: ' + e.getStackTraceString());

        }
    }

    public static Double consultarMonto(String lineNo, Datetime desde, Datetime hasta){
        /*
        {
            "body": {
                "resultado": {
                    "codigoDeAcceso": {
                        "identificadorRecurso": "3435161523"
                    }
                },
                "cantidadItemsConsulta": "0",
                "referenciaItemPaginado": "0",
                "cantidadMaxConsulta": "5",
                "fechaDesde": "2017-10-10 00:00:00",
                "fechaHasta": "2017-11-08 00:00:00"
            }
        }
        */
        lineNo = '3435161523'; //borrar, solo para probar Mock

        String methodName = 'consultarMonto';

        String jsonString;
        Map<String, Object> outMap  = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> rmap;
        String recarga;
        Double monto = 0;
        try{
            jsonString = '{ '+
                        '"body": {'+
                            ' "resultado": {' +
                                '"codigoDeAcceso": {'+
                                    ' "identificadorRecurso": "'+ lineNo+ '"'+
                                '}'+
                            ' },' +
                            ' "cantidadItemsConsulta": "0",' +
                            ' "referenciaItemPaginado": "0",' +
                            ' "cantidadMaxConsulta": "5",' +
                            ' "fechaDesde": "'+desde+'",' +
                            ' "fechaHasta": "'+hasta+'" ' +
                        '}'+
                    '}';

            System.debug('jsonString: ' + jsonString);
    
            inputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
 
            //if(!Test.isRunningTest())
                integProcServ.invokeMethod('IFS_S141', inputMap, outMap, options);

            System.debug('IFS_S141_outMap: ' + outMap);
            Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
            System.debug('IFS_S141_result: ' + result);
            List<Object> refills = (List<Object>)result.get('ListInfoRecarga');
   
            for (Object r : refills){
                rmap = (Map<String, Object>)r;
                recarga = (String) rmap.get('montoRecarga');
                monto = monto + decimal.valueOf(recarga);
            }
            System.debug('Monto='+ monto);

        }
        catch(Exception e){
            System.debug(methodName+ ' Msg: ' + e.getMessage());
            System.debug(methodName+ ' Cause: ' + e.getCause());
            System.debug(methodName+ ' Stack Trace: ' + e.getStackTraceString());

        }
        return monto;

    }//end method

    public static Integer informBDO(String noSol, String aceptada, String codCausa, String codInteraccion, String codAplicacion, String codUsuario){
        /*
        {
            "body": {
                "revisionAlex": {
                    "nroSolicitudPortacion": 6576,
                    "aceptada": true,
                    "codCausaRechazoPortacion": "REC00ABD001"
                },
                "entidadLlamante": {
                    "codInteraccionNegocio": "ID1",
                    "codAplicacion": "1",
                    "codUsuario": "LUIS"
                }
            }
        }
        */

        String methodName = 'informBDO';

        String jsonString;
        Map<String, Object> outMap  = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> rmap;
        Integer nroSolicitudPortacion;
        try{
            jsonString= '{ '+
                            '"body": {'+
                                ' "revisionAlex": {' +
                                    ' "nroSolicitudPortacion": '+ noSol+ ','+
                                    ' "aceptada": '+ aceptada+ ','+
                                    ' "codCausaRechazoPortacion": "'+ codCausa+ '"'+
                                '},'+
                                ' "entidadLlamante": {' +
                                    ' "codInteraccionNegocio": "'+ codInteraccion + '",'+
                                    ' "codAplicacion": "'+ codAplicacion+ '",'+
                                    ' "codUsuario": "'+ codUsuario + '"'+
                                '}'+
                            '}'+
                        '}';

            System.debug('jsonString: ' + jsonString);
    
            inputMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
 
            //if(!Test.isRunningTest())
                integProcServ.invokeMethod('IFS_S005', inputMap, outMap, options);

            System.debug('IFS_S005_outMap: ' + outMap);
            Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
            System.debug('IFS_S005_result: ' + result);
            nroSolicitudPortacion = (Integer) result.get('nroSolicitudPortacion');

        }
        catch(Exception e){
            System.debug(methodName+ ' Msg: ' + e.getMessage());
            System.debug(methodName+ ' Cause: ' + e.getCause());
            System.debug(methodName+ ' Stack Trace: ' + e.getStackTraceString());

        }
        return nroSolicitudPortacion;

    }//end method

    @future
    public static void UpdatePortabilityCases(List<Id> cases){
        String methodName = 'UpdatePortabilityCases';
        List<Case> casesProcess = new List<Case>();

        try{

            //Process Cases
            List<Case> caseList = [Select Origin, Area__c, Subarea__c, Status From Case Where Id IN :cases];
            for(Case caseObj: caseList) { 
                if (caseObj.Origin == 'ALEX' && caseObj.Area__c == 'AREC' && caseObj.Subarea__c == 'NULL'){
                    //The ABD accept our reject and cancell the port out
                    caseObj.Status = 'Rechazada';
                    casesProcess.add(caseObj);
                }
                else if (caseObj.Origin == 'ALEX' && caseObj.Area__c == 'AACE' && caseObj.Subarea__c == 'RIMP'){
                    //The ABD reject our reject and has to send another port out request to restart the port out process
                    caseObj.Status = 'Aprobada Pendiente de Portación';
                    casesProcess.add(caseObj);
                }
                              
            }//end for
            update casesProcess;

        }//end try

        catch(Exception e){
            System.debug(methodName+ ' Msg: ' + e.getMessage());
            System.debug(methodName+ ' Cause: ' + e.getCause());
            System.debug(methodName+ ' Stack Trace: ' + e.getStackTraceString());

        }

    }

}