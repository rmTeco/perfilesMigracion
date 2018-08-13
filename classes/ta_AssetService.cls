global with sharing class ta_AssetService  implements vlocity_cmt.VlocityOpenInterface {
    global ta_AssetService () {
    } 

    Double unidadesMGDisponibles = 0;

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try 
        {
            if (methodName.Equals('GetPlanAssetsByAccountId')) 
            {
                GetPlanAssetsByAccountId(inputMap, outMap, options);
            }
            if (methodName.Equals('GetTrafficEquipmentByLineNumber')) 
            {
                GetTrafficEquipmentByLineNumber(inputMap, outMap, options);
            }

            if (methodName.Equals('GetDeviceAssetsByAccountId')) 
            {
                GetDeviceAssetsByAccountId(inputMap, outMap, options);
            }

        }
        catch(Exception ex) {
            outMap.put('error', ex.getStackTraceString());
            result = false;
        }
        return result;
    }

    private void GetPlanAssetsByAccountId(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try {
            List<Object> PlanAssets = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'PlanAssets');
            
            for (Object PlanAsset : PlanAssets) 
            {
                Map<String, Object> PlanAssetMap = (Map<String, Object>)PlanAsset;
                
                System.debug('PlanAssetMap: ' + PlanAssetMap);
                CompletePlanAssetInfo(PlanAssetMap);
                System.debug('Final JSON: '+PlanAssetMap); 
            }           
        }
        catch(Exception ex) {
            outMap.put('codError', '101');
            outMap.put('descError', ex.getMessage());
        }
    }

    @TestVisible 
    private void CompletePlanAssetInfo(Map<String,Object> PlanAsset) {
        try {
            Map<String, Object> assetBalance = new Map<String, Object>();
            String statusAsset;
            System.debug('Linea: '+String.valueOf(PlanAsset.get('LineNumber')));
            System.debug('AssetId: '+String.valueOf(PlanAsset.get('AssetId')));

            if(String.valueOf(PlanAsset.get('LineNumber')) != null)
            {
                assetBalance = GetAssetBalance(PlanAsset);
                statusAsset  = String.valueOf(PlanAsset.get('Status'));

                if(assetBalance != null) 
                {
                    System.debug('assetBalance: ' + assetBalance);
                    List<Map<String, Object>> freeUnits = GetFreeUnits(assetBalance, String.valueOf(PlanAsset.get('LineNumber')),String.valueOf(PlanAsset.get('AssetId')),statusAsset);

                    if(freeUnits != null)
                    {
                        Map<String, Object> totalesBalance = (Map<String, Object>)assetBalance.get('totalesBalance');
                        if(unidadesMGDisponibles != 0)
                            totalesBalance.put('mbAvailable', unidadesMGDisponibles);
                        else
                            totalesBalance.put('mbAvailable', 'Información no disponible');

                        System.debug('freeUnits: ' + freeUnits);
                        PlanAsset.put('Balance', assetBalance);
                    }
                    else
                    {
                        Map<String, Object> totalUnidadesLibres = new Map<String, Object>();
                        Map<String, Object> unidadLibre = new Map<String, Object>();
                        unidadLibre.put('unidadLibre', notBalanceFound(String.valueOf(PlanAsset.get('LineNumber')), statusAsset, String.valueOf(PlanAsset.get('AssetId'))));
                        totalUnidadesLibres.put('totalUnidadesLibres',unidadLibre);
                        PlanAsset.put('Balance', totalUnidadesLibres);
                    }
                }
                else
                {
                    Map<String, Object> totalUnidadesLibres = new Map<String, Object>();
                    Map<String, Object> unidadLibre = new Map<String, Object>();
                    unidadLibre.put('unidadLibre', notBalanceFound(String.valueOf(PlanAsset.get('LineNumber')), statusAsset,String.valueOf(PlanAsset.get('AssetId'))));
                    totalUnidadesLibres.put('totalUnidadesLibres',unidadLibre);
                    PlanAsset.put('Balance', totalUnidadesLibres);
                }
            }
            else //Si no existe el numero de linea no vamos a poder ejecutar la S439, enviamos nodo vacio.
            {
                Map<String, Object> totalUnidadesLibres = new Map<String, Object>();
                Map<String, Object> unidadLibre = new Map<String, Object>();
                unidadLibre.put('unidadLibre', notBalanceFound(String.valueOf(PlanAsset.get('LineNumber')), statusAsset, String.valueOf(PlanAsset.get('AssetId'))));
                totalUnidadesLibres.put('totalUnidadesLibres',unidadLibre);
                PlanAsset.put('Balance', totalUnidadesLibres);
            }
        }
        catch(Exception ex) {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
    }

    @TestVisible 
    private List<Map<String, Object>> notBalanceFound(String lineNumber, String statusAsset, String assetId) {
        try
        {
            Map<String, Object> noBalanceFoundVoice = new Map<String, Object>();
            Map<String, Object> noBalanceFoundSMS = new Map<String, Object>();
            Map<String, Object> noBalanceFoundInternet = new Map<String, Object>();
            List<Map<String, Object>> ul = new List<Map<String, Object>>();

            noBalanceFoundVoice.put('freeUnitCode', 'Voz');
            noBalanceFoundVoice.put('remainingSecondaryUnits', 'Sin datos');
            noBalanceFoundVoice.put('remainingPrimaryUnits','Sin datos');
            noBalanceFoundVoice.put('fechaVigenciaHastaProdAdq','Sin datos');
            noBalanceFoundVoice.put('cantUnidadesRemanentes','Sin datos');
            noBalanceFoundVoice.put('codUnidadDeMedida','SEGUNDOS');
            noBalanceFoundVoice.put('codUsoUnidadesLibres','Voice');
            noBalanceFoundVoice.put('lineNumber',lineNumber);
            noBalanceFoundVoice.put('status',statusAsset);
            noBalanceFoundVoice.put('AssetId',assetId);
            ul.add(noBalanceFoundVoice);
            noBalanceFoundSMS.put('freeUnitCode', '');
            noBalanceFoundSMS.put('remainingSecondaryUnits', 'Sin datos');
            noBalanceFoundSMS.put('remainingPrimaryUnits','Sin datos'); 
            noBalanceFoundSMS.put('fechaVigenciaHastaProdAdq','Sin datos');
            noBalanceFoundSMS.put('cantUnidadesRemanentes','Sin datos');
            noBalanceFoundSMS.put('codUnidadDeMedida','ITEMS');
            noBalanceFoundSMS.put('codUsoUnidadesLibres','SMS');
            noBalanceFoundSMS.put('lineNumber',lineNumber);
            noBalanceFoundSMS.put('status',statusAsset);
            noBalanceFoundSMS.put('AssetId',assetId);
            ul.add(noBalanceFoundSMS);
            noBalanceFoundInternet.put('freeUnitCode', 'Internet');
            noBalanceFoundInternet.put('remainingSecondaryUnits', 'Sin datos');
            noBalanceFoundInternet.put('remainingPrimaryUnits','Sin datos');
            noBalanceFoundInternet.put('fechaVigenciaHastaProdAdq','Sin datos');
            noBalanceFoundInternet.put('cantUnidadesRemanentes','Sin datos');
            noBalanceFoundInternet.put('codUnidadDeMedida','KB');
            noBalanceFoundInternet.put('codUsoUnidadesLibres','Data');
            noBalanceFoundInternet.put('lineNumber', lineNumber);
            noBalanceFoundInternet.put('status',statusAsset);
            noBalanceFoundInternet.put('AssetId',assetId);
            ul.add(noBalanceFoundInternet);

            return ul;
        }
        catch(Exception ex)
        {
            System.debug('Error en notBalanceFound: '+ ex.getMessage());
            throw ex;
        }
    }

    @TestVisible 
    private Map<String, Object> GetAssetBalance(Map<String,Object> PlanAsset) {
        try {
            String integProcName = 'IFS_S439';

            Map<String, Object> input = GetJSONRequest(PlanAsset);
            System.debug('input: ' + input);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            if(!Test.isRunningTest()){
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod(integProcName, input, output, options);
                
                Map<String, Object> response = (Map<String, Object>)output.get('IPResult');
                
                if(!(response.get('detalle') == null))
                {   
                    System.debug('Error de IF439');
                    return null;
                }
                else
                {
                    return response;
                }
            }
            else
            {
                String jsonString='{"totalUnidadesLibres": {"unidadLibre": [{"fechaVigenciaHastaProdAdq": "2017-10-31 10:10:10","cantUnidadesRemanentes": 6458,"codUnidadDeMedida": "SEGUNDOS","codUsoUnidadesLibres": "Voice"},{"fechaVigenciaHastaProdAdq": "2017-11-31 10:10:10","cantUnidadesRemanentes": 200,"codUnidadDeMedida": "ITEMS","codUsoUnidadesLibres": "SMS"},{"fechaVigenciaHastaProdAdq": "2017-12-31 10:10:10","cantUnidadesRemanentes": 58358,"codUnidadDeMedida": "KB","codUsoUnidadesLibres": "Data"}]},"totalesBalance": {"fechaExpiracionBalance": "string", "proximaFechaExpiracionBalance": "string","saldoSuscripcionRegalado": 300,"saldoSuscripcionComprado": 0,"saldoBalance": 200},"ofertaPrincipal": {"descripcionProducto": " ","nombreProducto": "Plan Nacional Prepago","codProducto": 0},"marcaSuspensionActiva": "FuncionSobreStatusDetail","estadoSuscripcion": "Activa","identificadorRecurso": "1138305304"}';
                Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
                
                return responseNode;
            }
        }
        catch(Exception ex) {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
    }

    @TestVisible 
    private Map<String, Object> GetJSONRequest(Map<String,Object> PlanAsset) {
        try 
        {
            Map<String, Object> input = new Map<String, Object>();
            String lineNumber = (String)PlanAsset.get('LineNumber');
            System.debug('lineNumber: '+lineNumber);
            Map<String, Object> params = new Map<String, Object>();
            params.put('identificadorRecurso', lineNumber); //1177701111
            input.put('params', params);

            return input;
        }
        catch(Exception ex) {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
    }

    @TestVisible 
    private List<Map<String, Object>> GetFreeUnits(Map<String, Object> assetBalance, String lineNumber, String assetId, String statusAsset) 
    {
        try {
            List<Map<String, Object>> newFreeUnitsList = new List<Map<String, Object>>();
            Map<String, Object> totalFreeUnits = (Map<String, Object>)assetBalance.get('totalUnidadesLibres');

            if(totalFreeUnits == null)
                return newFreeUnitsList; //Devolvemos nodo vacio.
            
            System.debug('totalFreeUnits: ' + totalFreeUnits);
            List<Object> freeUnits = (List<Object>)totalFreeUnits.get('unidadLibre');

            if(freeUnits == null) {
                return newFreeUnitsList; //Devolvemos nodo vacio.      
            } else {
                if (freeUnits.size() == 0) {
                    //PFTA-11471, si no existe unidadLibre, queremos aun asi enviar los nodos vacios para poder mostrar el flyout correctamente.
                    //Map<String, Object> unidadLibre = new Map<String, Object>();
                    //unidadLibre.put('unidadLibre', notBalanceFound(lineNumber, statusAsset, assetId));
                    totalFreeUnits.put('unidadLibre',notBalanceFound(lineNumber, statusAsset, assetId));
                    newFreeUnitsList.add(totalFreeUnits);
                    System.debug('unidadLibre null: '+JSON.serialize(newFreeUnitsList));
                    return newFreeUnitsList; //Devolvemos nodo vacio.      
                }
            }
            

            System.debug('freeUnits2: ' + freeUnits);

            for (Object freeUnitObj : freeUnits) {
                Double remainingPrimaryUnits;
                Double remainingSecondaryUnits;
                String newFreeUnitCode;
                Map<String, Object> newFreeUnit = new Map<String, Object>();
                Map<String, Object> freeUnit = (Map<String, Object>)freeUnitObj;

                String freeUnitCode = (String)freeUnit.get('codUsoUnidadesLibres');
                String measureUnitCode = (String)freeUnit.get('codUnidadDeMedida');
                String remainingUnits = String.ValueOf(freeUnit.get('cantUnidadesRemanentes'));

                System.debug('measureUnitCode: ' + measureUnitCode);
                System.debug('remainingUnits: ' + remainingUnits);

                if (freeUnitCode.equals('Voice')) {
                    newFreeUnitCode = 'Voz';
                } else if (freeUnitCode.equals('Data')) {
                    newFreeUnitCode = 'Internet';
                }

                if (measureUnitCode.equals('SEGUNDOS')) {
                    Double remainingMinutes = Math.floor(Double.ValueOf(remainingUnits) / 60);
                    Long remainingSeconds = Math.mod(Long.ValueOf(remainingUnits), 60);

                    remainingPrimaryUnits = remainingMinutes;
                    remainingSecondaryUnits = remainingSeconds;
                } else if (measureUnitCode.equals('KB')) {
                    Double remainingMB = Math.floor(Double.ValueOf(remainingUnits) / 1024);
                    Long remainingKB = Math.mod(Long.ValueOf(remainingUnits), 1024);

                    remainingPrimaryUnits = remainingMB;
                    remainingSecondaryUnits = remainingKB;
                }

                System.debug('remainingPrimaryUnits: ' + remainingPrimaryUnits);
                System.debug('remainingSecondaryUnits: ' + remainingSecondaryUnits);
                freeUnit.put('remainingPrimaryUnits', remainingPrimaryUnits);
                unidadesMGDisponibles = remainingPrimaryUnits;
                freeUnit.put('remainingSecondaryUnits', remainingSecondaryUnits);
                freeUnit.put('freeUnitCode', newFreeUnitCode);
                freeUnit.put('lineNumber', lineNumber); //Agregamos el nodo para poder leerlo en el Flyout
                freeUnit.put('AssetId', assetId); //PFTA-11225. Necesitamos el AssetId para poder mandarlo como parametro en el flyout

                System.debug('newFreeUnit: '+JSON.serialize(newFreeUnit));
                newFreeUnitsList.add(newFreeUnit);
            }

            return newFreeUnitsList;
        }
        catch(Exception ex) {
            return null;
        }
   }

    @TestVisible 
    private void GetTrafficEquipmentByLineNumber(Map<String,Object> inputMap, Map<String,Object> result, Map<String,Object> options) 
    {
        try 
        {
            String valorConsulta = (String)inputMap.get('LineNumber');
            System.debug('Numero de linea: '+ valorConsulta);
            Datetime GMTDate = Datetime.now();
            String strConvertedDate = GMTDate.format('yyyy/MM/dd HH:mm:ss:ms');
            String idSolicitudWS = strConvertedDate.remove('/').remove(':').deleteWhitespace();
            String userSolicitud = 'u000123'; //No hay definicion sobre este campo siempre llamamos con el mismo User ficticio.
            String fechaActual = idSolicitudWS;
            Map<String, Object> outMap = new Map<String, Object>();

            if(!Test.isRunningTest())
            {
                String jsonString = '{"body":{"idSolicitudWS":"'+idSolicitudWS+'","versionWS":"1","nombreAppOrigen":"FAN","userSolicitud":"'+userSolicitud+'","date":"'+fechaActual+'","tipoValorConsulta":"1","valorConsulta":"'+valorConsulta+'","location":"1","smsEncolado":"1","autenticacion":"1","autentication3g":"1","camel":"1","categoriasHSS":"1"}}';
                System.debug('Request String: '+ jsonString);
                Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                System.debug('Request: '+input);
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S132', input, outMap, options);
                System.debug('Response: ' + JSON.serialize(outMap));
            }
            else
            {
                String jsonString = '{"IPResult":{"errorCode":"INVOKE-200","error":"OK","voiceMailCategoria":"NAEA 74","voiceMail":"CORRECTO (VM MUNRO ZTE)","tecnologia":"4G LTE - Smartphone - OS= Android","tecMsc":"Huawei","state":"CONNECTED","smsEncolado":"","serviciosActivos":"","restriccion":"","regionALM":"NACIONAL","portabilidad":"Abonado de Telecom Personal","mtMobileSubscriberStat":"","modelo":"HUAWEI P9 lite","marca":"HUAWEI Technologies Co Ltd","locacionGPRS":"MME2MUN - TP Argentina","locacionDelMovil":"mun01dcMSOFTX - TP Argentina","imeiDelTerminal":"860920039068349","hssSubscriberData":"","hssSubscriberCategorias":"","hlrSubscriberData":"","hlr":"CLIBDUSP18","estadoTerminal":"White listed","estadoSMSEncolado":"","estado":"","camel":"","authd":"","autentificacion3G":"","autentificacion":""}}';
                outMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            }

            Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');

            if(response.get('detalle') == null)
            {
                String modelo = (String) response.get('modelo');
                System.debug('Modelo: '+modelo);
                String imei = (String) response.get('imeiDelTerminal');
                System.debug('IMEI: '+imei);
                String marca = (String) response.get('marca');
                System.debug('Modelo: '+marca);

                result.put('Device',modelo);
                result.put('IMEI',imei);
                result.put('Marca',marca);

            }
            else
            {
                System.debug('Error in S132');
                result.put('Device','Información no disponible');
                result.put('IMEI','Información no disponible');
                result.put('Marca','Información no disponible');
            }
        }
        catch(Exception ex)
        {
            System.debug('Error in S132 - '+ex.getMessage());
            result.put('Device','Información no disponible');
            result.put('IMEI','Información no disponible');
            result.put('Marca','Información no disponible');
        }
    }

    @TestVisible 
    private void GetDeviceAssetsByAccountId(Map<String,Object> inputMap, Map<String,Object> result, Map<String,Object> options) 
    {
        try 
        {
            System.debug(options);
            List<Object> DeviceAssets = VlocityOpenInterfaceHelper.getListObjectsFromMap(options, 'DeviceAssets');
            System.debug(DeviceAssets);

            for (Object DeviceAsset : DeviceAssets) 
            {
                Map<String, Object> DeviceAssetMap = (Map<String, Object>)DeviceAsset;
                getJSONAttributeTransform(DeviceAssetMap);   
            }           
        }
        catch(Exception ex) 
        {
            result.put('codError', '101');
            result.put('descError', ex.getMessage() + ex.getStackTraceString());
        }
    }
    
    @TestVisible 
    public void getJSONAttributeTransform (Map<String,Object> DeviceAssetMap)
    {
        try
        {  
            Map<String,Object> output = new Map<String, Object>();
            String jsonAttribute;

            jsonAttribute = String.valueOf(DeviceAssetMap.get('JSONAttribute'));
            System.debug('jsonAttribute: '+jsonAttribute);
            if(jsonAttribute != null)
            {
                Map<String, Object> attributesKeys = (Map<String, Object>)JSON.deserializeUntyped(jsonAttribute);
                System.debug('attributesKeys: '+attributesKeys);
                for (Object attributeKey : attributesKeys.values())
                {
                    List<Object> attributes = (List<Object>)attributeKey;
                    for(Object attribute : attributes)
                    {
                        Map<String, object> mapAttribute = (Map<String, object>)attribute;
                        String modelo = getAttributeSelectedValue(mapAttribute, 'Modelo');
                        String marca = getAttributeSelectedValue(mapAttribute, 'Marca');
                        String gama = getAttributeSelectedValue(mapAttribute, 'Gama Equipo');
                        String garantia = getAttributeSelectedValue(mapAttribute, 'Periodo de Garantia');
                        String so = getAttributeSelectedValue(mapAttribute, 'Sistema Operativo');

                        if(modelo != null)
                            DeviceAssetMap.put('Modelo', modelo);
                        if(marca != null)
                            DeviceAssetMap.put('Marca', marca);
                        if(gama != null)
                            DeviceAssetMap.put('Gama', gama);
                        if(garantia != null)
                            DeviceAssetMap.put('Garantia', garantia);
                        if(so != null)
                            DeviceAssetMap.put('SO', so);
                        
                        DeviceAssetMap.remove('JSONAttribute');
                    }
                }            
            }
            else
            {
                DeviceAssetMap.put('Modelo', 'No disponible');
                DeviceAssetMap.put('Marca', 'No disponible');
                DeviceAssetMap.put('Gama', 'No disponible');
                DeviceAssetMap.put('Garantia', 'No disponible');
                DeviceAssetMap.remove('JSONAttribute');
            }
        }
        catch(Exception ex)
        {
            System.debug('Error en getJSONAttributeTransform: '+ ex.getMessage());
            //throw ex; Quitamos el Throw para que siga con los siguientes Assets.
        }
    }

    @TestVisible 
    public String getAttributeSelectedValue(Map<String, Object> mapAttribute, String keyFilter)
    {
        try
        {
            String selectedValue;

            if(mapAttribute.get('attributedisplayname__c') == keyFilter)
            {
                Map<String, Object>valueInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                String dataType = String.valueOf(valueInfo.get('dataType'));
                if(dataType == 'Picklist')
                {
                    List<Object>defaultValue = (List<Object>)valueInfo.get('default');
                    for(Object valueData : defaultValue)
                    {
                        Map<String, Object> mapValue = (Map<String, Object>)valueData;  
                        selectedValue = String.valueOf(mapValue.get('displayText'));
                    }
                }
                if(dataType == 'Text')
                {
                    selectedValue = String.valueOf(valueInfo.get('default'));
                }
            }

            return selectedValue;
        }
        catch(Exception ex)
        {
            return null;
        }
    }
}