global with sharing class ta_integration implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try{
            if(methodName.equals('getIPSessionInformation_CCIP')) getIPSessionInformation_CCIP(input, outMap, options);
            if(methodName.equals('MockS389')) MockS389(input, outMap, options);
            if(methodName.equals('MockS241')) MockS241(input, outMap, options);
            if(methodName.equals('MockDRMuletoAvailable')) MockDRMuletoAvailable(input,outMap,options);
            if(methodName.equals('MockGetPortStatus')) MockGetPortStatus(input,outMap,options);
            if(methodName.equals('MockGetSessionStatus')) MockGetSessionStatus(input,outMap,options);
            if(methodName.equals('MockS245')) MockS245(input,outMap,options);
            if(methodName.equals('MockGetServiceLatency')) MockGetServiceLatency(input,outMap,options);
            if(methodName.equals('MockModemReboot')) MockModemReboot(input,outMap,options);
            if(methodName.equals('MockBlackList')) MockBlackList(input,outMap,options);
            if(methodName.equals('MockGeoData')) MockGeoData(input, outMap, options);
            if(methodName.equals('MockValidateCardRefill')) MockValidateCardRefill(input, outMap, options);
            
            
        } catch(Exception ex){
            outMap.put('error', ex.getMessage());
            options.put('error', ex.getMessage());
            //options.put('errorTrace', ex.getStackTraceString());
        }
        
        return true;
    }

    private void getIPSessionInformation_CCIP(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options){

        String lineNumber = (String) options.get('nroLinea');
        System.debug('Número de líne recibido: ' + lineNumber);

        Map<String, Object> sessionList = new Map<String, Object>();

        if(lineNumber == '3743461848' || lineNumber == '1164646469'){
            sessionList.put('codPortalCautivo', '102');
        } else if(lineNumber == '1112121212'){
            sessionList.put('codPortalCautivo', '101');
        } else if(lineNumber == '1113131313'){
            sessionList.put('codPortalCautivo', '100');
        } else{
            sessionList.put('codPortalCautivo', '0');
        }

        outMap.put('listaSesion', sessionList);
    }

    public static boolean closeMasiveIncident(String incidentCode){
        try
        {
            Case masiveIncidentCase = [SELECT Id, Status FROM Case WHERE ExternalCaseId__c = :incidentCode];

            masiveIncidentCase.Status = 'Closed';

            update masiveIncidentCase;

            return true;
        }
        catch(Exception ex)
        {
            System.debug(ex);
            return false;
        }
    }
    
    @InvocableMethod(label='Disassociate Accounts to a masive incident' description='Update Accounts than have externalCaseId = Incident_Affected_By')
    public static void disassociateAccountsToMasiveIncident(List<String> externalCaseId){
        try
        {
            Account[] relatedAccountsToUpdate = new List<Account>();

            for (Account relatedAccount : [SELECT Id FROM Account WHERE Incident_Affected_By__c = :externalCaseId])
            {
                Account tempRelAcc = new Account();
                tempRelAcc.Id = relatedAccount.Id;
                tempRelAcc.Incident_Affected_By__c = '';
                relatedAccountsToUpdate.add(tempRelAcc);
            }

            update relatedAccountsToUpdate;
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }

    public static boolean createMassiveIncident(String incidentCode, String incType, String subType, String impact,
        String incident, String procedure, String speech, String incOrigin, String externalCaseType, List<String> accountsId)
    {
        try
        {
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incidente Masivo').getRecordTypeId();

            DateTime dueDate = DateTime.now();
            //DateTime modifDate = null;
            DateTime startDate = dueDate.addDays(-3);

            Case masiveIncidentCase = new Case();

            masiveIncidentCase.Subject = 'Incidente Masivo';
            
            masiveIncidentCase.ExternalCaseId__c = incidentCode;
            masiveIncidentCase.ExternalCaseType__c = externalCaseType;
            masiveIncidentCase.Impact__c = impact;
            masiveIncidentCase.Procedure__c = procedure;
            masiveIncidentCase.Speech__c = speech;
            masiveIncidentCase.Origin = incOrigin;
            masiveIncidentCase.Due_Date__c = dueDate;
            //masiveIncidentCase.Modified_Date__c = modifDate;
            masiveIncidentCase.RecordTypeId = recordTypeId;
            //masiveIncidentCase.IncidentDevice__c = null;

            masiveIncidentCase.Type = incType;
            masiveIncidentCase.SubType__c = subType;
            masiveIncidentCase.Incident__c = incident;

            insert masiveIncidentCase;
            
            for(String accountId : accountsId){
                Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId];
                
                acc.Incident_Affected_By__c = incidentCode;
                
                update acc;
            }
    
            return true;
        }
        catch(Exception ex)
        {
            System.debug(ex);
            return false;
        }
    }

    private void MockS389(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String LineNumber = (String)options.get('LineNumber');
            Integer configuredSpeed = 23552;
            Integer actualSpeed = 23552;
            String configuredSpeedUnit = 'Kb';
            String actualSpeedUnit = 'Kb';

            if(LineNumber == '1164646468'){
                configuredSpeed = 11776;
                actualSpeed = 11776;
            }

            System.debug('info: ' + LineNumber + configuredSpeed + actualSpeed + configuredSpeedUnit + actualSpeedUnit );

            Map<String,Object> response = new Map<String,Object>();

            response.put('LineNumber', LineNumber);
            response.put('ConfiguredSpeed', configuredSpeed);
            response.put('ConfiguredSpeedUnit', configuredSpeedUnit);
            response.put('ActualSpeed', actualSpeed);
            response.put('ActualSpeedUnit', actualSpeedUnit);

            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockS241(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service 241.
        Input:
            Line Number
        Output:
            Package Loss:
                - Si
                - No
         */

        try{
            String lineNumber = (String) options.get('nroLinea');

            //String Latency = '50';
            String PackageLoss = '60';

            if(lineNumber == '1164646468' || lineNumber == '1164646464'){
                //Latency = '3';
                PackageLoss = '3';
            }

            if(lineNumber == '1164646464'){
                PackageLoss = '50';
            }

            //System.debug('info: ' + lineNumber + 'Latencia: ' + Latency + 'Perdida de Paquetes: ' + PackageLoss );

            Map<String,Object> response = new Map<String,Object>();

            response.put('PackageLoss', PackageLoss);
            //response.put('Latency', Latency);


            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockDRMuletoAvailable(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        List<Object> muletosList = new List<Object>();
        Map<String,Object> muletosMap = new Map<String,Object>();

        Muletosmap.put('NMU','PNK0700NL');
        Muletosmap.put('Description','MOTOG2 - 3G');
        Muletosmap.put('Brand','MOTOROLA');
        Muletosmap.put('Stock','2');
        Muletosmap.put('Imei','545229703256586');
        muletosList.add(muletosMap);
        muletosMap = new Map<String,Object>();
        Muletosmap.put('NMU','PNK0800NL');
        Muletosmap.put('Description','LUMIA - 4G');
        Muletosmap.put('Brand','NOKIA');
        Muletosmap.put('Stock','1');
        Muletosmap.put('Imei','545229703256587');
        muletosList.add(muletosMap);
        muletosMap = new Map<String,Object>();
        Muletosmap.put('NMU','PNK0400NL');
        Muletosmap.put('Description','XPERIA - 4G');
        Muletosmap.put('Brand','SONY');
        Muletosmap.put('Stock','3');
        Muletosmap.put('Imei','545229703256588');
        muletosList.add(muletosMap);
        muletosMap = new Map<String,Object>();
        Muletosmap.put('NMU','PNK0900NL');
        Muletosmap.put('Description','J1 - 3G');
        Muletosmap.put('Brand','SAMSUNG');
        Muletosmap.put('Stock','5');
        Muletosmap.put('Imei','545229703256589');
        muletosList.add(muletosMap);



        Outmap.put('Muletos',muletosList);
    }

    private void MockGetPortStatus(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service GPON (Fiber Port) PFTA-5321.
        Input:
            Line Number
        Output:
            Result:
             - Initial/Initial
             - Active/Initial
             - Active/Normal
         */

        try{
            String lineNumber = (String) options.get('nroLinea');

            String result = 'Initial/Initial';

            if(lineNumber == '1164646468' || lineNumber == '1164646462' || lineNumber == '1164646460'){
                result = 'Active/Normal';
            } else if(lineNumber == '1164646466'){
                result = 'Active/Initial';
            }


            System.debug('info: ' + lineNumber + 'Resultado: ' + result );

            Map<String,Object> response = new Map<String,Object>();

            response.put('Status', result);


            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockGetSessionStatus(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service GetSessiinStatus.
        Input:
            Line Number
        Output:
            Result:
             - Sesión Activa
             - Sin Sesión
         */

        try{
            String lineNumber = (String) options.get('nroLinea');
            String flagSession = (String)options.get('flagSession');

            String result = 'Sin Sesión'; //1164646462

            if(lineNumber == '1164646462' && flagSession == '1') {
                result = 'Sesión Activa';
            }

            if(lineNumber == '1164646468' || lineNumber == '1164646469' || lineNumber == '1164646464' 
                || lineNumber == '1164646463' || lineNumber == '1164646465' || lineNumber == '1112121212'
                || lineNumber == '1113131313'){
                result = 'Sesión Activa';
            }

            System.debug('info: ' + lineNumber + 'Resultado: ' + result );

            Map<String,Object> response = new Map<String,Object>();

            response.put('Status', result);


            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockS245(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service GetHistoryServicesProblem
        Input:
            - TxId:         Identificador único de la transacción *Obligatorio*
            - nroLinea:     Número de Linea de Cliente
            - codServicio:  Código identificador único del servicio
            - dias:         Cantidad de días a consultar. Valores posibles: 1: para obtener el diagnóstico del día actual, 3:
                            para obtener el diagnóstico de los últimos tres días.  *Obligatorio*
        Output:
            Result:
             - TxId:
             - nroLinea:
             - codServicio:
             - fechaDesde: Fecha de inicio para el intervalo del diagnóstico de cortes.
             - fechaHasta: Fecha de fin para el intervalo del diagnóstico de cortes.
             - Resultado:  Resultado del diagnóstico de cortes.
                            -ESTABLE (La línea posee diagnóstico de sesiones estables.)
                            -INESTABLE (La línea posee diagnóstico de sesiones inestables.)
                            -SIN_SESION (La línea no posee sesiones activas o cerradas.)
         */

        try{
            //Input
            String TxId = (String) options.get('TxId');
            String nroLinea = (String) options.get('nroLinea');
            String codServicio = (String) options.get('codServicio');
            Integer dias = Integer.valueOf(options.get('dias'));

            //Output
            String resultTxId = TxId ;
            String resultNroLinea = nroLinea;
            String resultCodServicio = codServicio;
            String resultFechaDesde = String.valueOf(Date.today() - dias);
            String resultFechaHasta = String.valueOf(Date.today());
            String Resultado = 'SIN_SESION';


            if(nroLinea == '1164646468' || nroLinea == '1164646464'){
              if(dias == 1){
                resultTxId = TxId ;
                resultNroLinea = nroLinea;
                resultCodServicio = codServicio;
                resultFechaDesde = String.valueOf(Date.today() - dias);
                resultFechaHasta = String.valueOf(Date.today());
                Resultado = 'INESTABLE';
              }else{
                resultTxId = TxId ;
                resultNroLinea = nroLinea;
                resultCodServicio = codServicio;
                resultFechaDesde = String.valueOf(Date.today() - dias);
                resultFechaHasta = String.valueOf(Date.today());
                Resultado = 'ESTABLE';
              }

            }

            if(nroLinea == '1164646469' || nroLinea == '1164646465'){
              if(dias == 1){
                resultTxId = TxId ;
                resultNroLinea = nroLinea;
                resultCodServicio = codServicio;
                resultFechaDesde = String.valueOf(Date.today() - dias);
                resultFechaHasta = String.valueOf(Date.today());
                Resultado = 'ESTABLE';
              }else{
                resultTxId = TxId ;
                resultNroLinea = nroLinea;
                resultCodServicio = codServicio;
                resultFechaDesde = String.valueOf(Date.today() - dias);
                resultFechaHasta = String.valueOf(Date.today());
                Resultado = 'ESTABLE';
              }

            }


            Map<String,Object> response = new Map<String,Object>();

            response.put('TxId', resultTxId);
            response.put('NroLinea', resultNroLinea);
            response.put('CodServicio', resultCodServicio);
            response.put('FechaDesde', resultFechaDesde);
            response.put('FechaHasta', resultFechaHasta);
            response.put('Resultado', Resultado);

            System.debug('info: ' + nroLinea + 'Resultado: ' + response );

            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void TestInput(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        Outmap.put('Input', input);
    }

    private void MockGetServiceLatency(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service GetServiceLatency PFTA - 5315
        Input:
            - nroLinea:     Número de Linea de Cliente

        Output:
            Result:
             - DSLAM:
             - Latencia:
             - Provincia:
         */

        try{
            //Input
            String nroLinea = (String) options.get('nroLinea');

            //Output
            String DSLAM = 'VACG01' ;
            String Latencia = '';
            String Provincia = '';

            if(nroLinea == '1164646468' || nroLinea == '1164646464'){
                DSLAM = 'V8011C';
                Latencia = '13';
                Provincia = 'Buenos Aires';

            }

            if(nroLinea == '1164646469' || nroLinea == '1164646463' || nroLinea == '1164646465'){
                DSLAM = 'V9311C';
                Latencia = '45';
                Provincia = 'Chaco';

            }


            Map<String,Object> response = new Map<String,Object>();

            response.put('DSLAM', DSLAM);
            response.put('Latencia', Latencia);
            response.put('Provincia', Provincia);

            System.debug('info: ' + nroLinea + 'Resultado: ' + response );

            Outmap.put('Response',response);

        }catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockBlackList(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String docNumber = (String) options.get('docNumber');

            string result = 'false';

            if(docNumber == '37937937')
                result = 'true';

            Map<String,Object> response = new Map<String,Object>();

            response.put('onBlackList', result);

            Outmap.put('Response',response);

        } catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockModemReboot(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        /*
        Mock Class for Service Modem Reboot (S244) PFTA-5181.
        Input:
            cpeIdentifier (string)
        Output:
            Result:
             -
         */

        try{
            String cpeIdentifier = (String) options.get('cpeIdentifier');

            String result = 'ERROR';

            if(cpeIdentifier == '0003.0002')
                result = 'OK';

            Map<String,Object> response = new Map<String,Object>();

            response.put('Status', result);

            Outmap.put('Response',response);

        } catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    private void MockGeoData(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            Decimal inputLat = (Decimal) options.get('lat') ;
            Decimal inputLng = (Decimal) options.get('lng') ;

            Outmap.put('lat', inputLat);
            Outmap.put('lng', inputLng);

            List<Map<String, Object>> lstAntennas = new List<Map<String, Object>>();

            if(inputLat == -34.5636586 && inputLng == -58.4782851){
                lstAntennas.add(createAntenna('4PCGH1', '4G', 450, -34.563314, -58.475152, 'Operativo'));
                lstAntennas.add(createAntenna('4PCGH2', '4G', 200, -34.560478, -58.477266, 'Operativo'));
                lstAntennas.add(createAntenna('4PCGH3', '3G', 200, -34.565999, -58.479640, 'No Operativo', 'INC0077'));
                lstAntennas.add(createAntenna('4PCGH4', '3G', 400, -34.561748, -58.485320, 'No Operativo', 'INC0079'));
            } else if(inputLat == -34.56606379999999 && inputLng == -58.4723859){
                //lstAntennas.add(createAntenna('4PCGH4', '4G', 250, -34.564541, -58.472500, 'Operativo'));
                //lstAntennas.add(createAntenna('4PCGH5', '4G', 350, -34.567256, -58.472734, 'Operativo'));
                lstAntennas.add(createAntenna('4PCGH6', '3G', 400, -34.564085, -58.474072, 'No Operativo'));
                lstAntennas.add(createAntenna('4PCGH7', '3G', 500, -34.567054, -58.470156, 'No Operativo'));
            }

            outMap.put('Antennas', lstAntennas);
        } catch(Exception ex){
            outmap.put('error', 'Error al obtener datos de antenas: ' + ex.getMessage() + ex.getLineNumber());
        }
    }

    private Map<String, Object> createAntenna(String name, String technology, Integer coverage, Decimal lat, Decimal lng, String state){

        return createAntenna(name, technology, coverage, lat, lng, state, '');
    }

    private Map<String, Object> createAntenna(String name, String technology, Integer coverage, Decimal lat, Decimal lng, String state, String incCode){
        Map<String, Object> antenna = new Map<String, Object>();

        try{
            Map<String, Object> coordinates = new Map<String, Object>();
            coordinates.put('lat', lat);
            coordinates.put('lng', lng);

            antenna.put('name', name);
            antenna.put('technology', technology);
            antenna.put('coverage', coverage);
            antenna.put('status', state);
            antenna.put('massiveIncident', incCode);

            antenna.put('coordinates', coordinates);
        } catch(Exception ex){
            throw new FuncException('Error al crear antena: ' + ex.getMessage());
        }

        return antenna;
    }

    private void MockValidateCardRefill(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String lotNumber = (String) options.get('lotNumber');
            //String lotNumber = (String) input.get('LoteNumber');

            Map<String,Object> response = new Map<String,Object>();
            String result, amount, status;
            String [] arrayListStatus = new List<String>();
            arrayListStatus.add('Activo');
            arrayListStatus.add('Bloqueado');
            arrayListStatus.add('Quemado');
            arrayListStatus.add('Inactiva');


            if(lotNumber == '1111111111111111')
            {
                result = 'false';
                status = arrayListStatus[1];
                amount = '';
            }

            else if(lotNumber == '2222222222222222')
            {
                result = 'false';
                status = arrayListStatus[2];
                amount = '';

            }
            else if(lotNumber == '3333333333333333')
            {
                result = 'false';
                status = arrayListStatus[3];
                amount = '';
            }
            else 
            {
                result = 'true';
                status = arrayListStatus[0];
                amount = String.valueOf(randomWithLimit(999999));
            }

            response.put('result', result);
            response.put('status', status);
            response.put('amount', amount);

            Outmap.put('Response',response);

        } catch(Exception ex){
            OutMap.put('error', 'Error: ' + ex.getMessage());
        }
    }

    static Integer randomWithLimit(Integer upperLimit)
    {
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
}