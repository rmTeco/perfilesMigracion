@RestResource(urlMapping='/v1/integrationprocedure/asociarTarjeta/*')
global with sharing class IFS_S465_asociarTarjeta {

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Object> result1 = new Map<String, Object>();
        Boolean isPrimary;
        Integer securityCode;
        res.addHeader('Content-Type', 'application/json');
        try {

            res.statuscode = 200;
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);


            // Validaciones de requeridos
            if (string.isBlank(jsonBody.asociarTarjeta.idCliente)) {
                throw new CalloutException('Error: El campo idCliente es requerido');
            }
/*            if (string.isBlank(jsonBody.asociarTarjeta.cardHolderName)) {
                throw new CalloutException('Error: El campo cardHolderName es requerido');
            }*/
            if (string.isBlank(jsonBody.asociarTarjeta.cardNumber)) {
                throw new CalloutException('Error: El campo cardNumber es requerido');
            }
            if (string.isBlank(jsonBody.asociarTarjeta.expirationYear)) {
                throw new CalloutException('Error: El campo expirationYear es requerido');
            }
            if (string.isBlank(jsonBody.asociarTarjeta.last4Numbers)) {
                throw new CalloutException('Error: El campo last4Numbers es requerido');
            }
            if (string.isBlank(jsonBody.asociarTarjeta.expirationMonth)) {
                throw new CalloutException('Error: El campo expirationMonth es requerido');
            }

            if (jsonBody.asociarTarjeta.isPrimary == null) {
                isPrimary = false;
            }
            else
            {
                isPrimary = jsonBody.asociarTarjeta.isPrimary;
            }

            if (jsonBody.asociarTarjeta.securityCode != null) {
                securityCode = Integer.valueof(jsonBody.asociarTarjeta.securityCode.trim()); 
            }

            if (!validaExpirationMonth(jsonBody.asociarTarjeta.expirationMonth)){
                throw new CalloutException('Error: El campo expirationMonth es invalido');
            }
            
            if (!validaExpirationYear(jsonBody.asociarTarjeta.expirationYear)){
                throw new CalloutException('Error: El campo expirationYear es invalido');
            }
            
            if (!validalast4Numbers(jsonBody.asociarTarjeta.last4Numbers)){
                throw new CalloutException('Error: El campo last4Numbers es invalido');
            }

            if (!validaCardType(jsonBody.asociarTarjeta.cardType)){
                throw new CalloutException('Error: El valor de cardType no está en la lista');
            }

            if (!asociaTarjeta(jsonBody.asociarTarjeta.idCliente, jsonBody.asociarTarjeta.cardHolderName, jsonBody.asociarTarjeta.cardType, jsonBody.asociarTarjeta.expirationMonth, jsonBody.asociarTarjeta.expirationYear,jsonBody.asociarTarjeta.last4Numbers, securityCode, isPrimary,jsonBody.asociarTarjeta.cardNumber)){
                throw new CalloutException('Error: No pudo asociar la tarjeta');
            }
            




            result.put('resultado','OK');
            res.responseBody = Blob.valueOf(JSON.serialize(result));

        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
        }
    }
    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    private static Boolean validaExpirationMonth(String pExpirationMonth){
        Integer numEntero = Integer.valueof(pExpirationMonth.trim());
        Boolean stat = ((numEntero >= 1 && numEntero <= 12) ? true : false);
        return stat;
    }
    private static Boolean validaExpirationYear(String pExpirationYear){
        Boolean stat = ((pExpirationYear >= '17' && pExpirationYear <= '30')?true:false);
        System.debug('Entre a getRespuestaNoOk() ' + stat );
        return stat;
    }
    private static Boolean validalast4Numbers(String plast4Numbers){
        Boolean stat = ((plast4Numbers >= '0000' && plast4Numbers <= '9999')?true:false);
        return stat;
    }
    private static Boolean validaCardType(String pcardType){
        Boolean stat = false;
        String cardType = pcardType;

        Schema.DescribeFieldResult fieldResult =  vlocity_cmt__PaymentMethod__c.vlocity_cmt__CardType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            if(f.getValue() == cardType){
                stat= true;
                break;
            }
        }       

        return stat;
    }



    private static Boolean asociaTarjeta(String pidCliente, String pcardHolderName, String pcardType, String pexpirationMonth, String pexpirationYear, String plast4Numbers, Integer psecurityCode, Boolean pisPrimary, String pCardNumber){
        Boolean stat;
        String idCliente = pidCliente; 
        String cardHolderName = pcardHolderName;
        String cardType = pcardType;
        String expirationMonth = pexpirationMonth;
        String expirationYear = pexpirationYear;
        String last4Numbers = plast4Numbers;
        Integer securityCode = psecurityCode;
        Boolean isPrimary = pisPrimary;
        String cardNumber = pCardNumber;

        Account[] cuenta = [SELECT Id FROM account WHERE AccountIntegrationId__c = :idCliente];

        if (cuenta.size() > 0){

            List<vlocity_cmt__PaymentMethod__c> paymentMtd = [SELECT vlocity_cmt__AccountId__c, vlocity_cmt__IsActive__c, vlocity_cmt__CardHolderName__c, vlocity_cmt__CardType__c, vlocity_cmt__ExpirationMonth__c, vlocity_cmt__ExpirationYear__c, vlocity_cmt__Last4Numbers__c FROM vlocity_cmt__PaymentMethod__c 
            WHERE vlocity_cmt__AccountId__c = :cuenta[0].Id AND vlocity_cmt__MethodType__c = 'Credit Card' AND vlocity_cmt__CardHolderName__c = :cardHolderName AND vlocity_cmt__CardType__c = :cardType AND vlocity_cmt__ExpirationMonth__c = :expirationMonth AND vlocity_cmt__ExpirationYear__c = :expirationYear AND vlocity_cmt__Last4Numbers__c = :last4Numbers AND  vlocity_cmt__IsActive__c = true LIMIT 1];

            if(paymentMtd.size() > 0){
                throw new CalloutException('Error: La tarjeta ya está asociada');
                System.debug('Entre a asociar Tarjeta --> encontre registro :' + paymentMtd.size());
            }
            else
            {
                stat = insertarTarjeta(cuenta[0].Id, cardHolderName, cardType, expirationMonth, expirationYear, last4Numbers, securityCode, isPrimary, cardNumber);
            }
        }else{
                throw new CalloutException('Error: La cuenta ' + idCliente + ' no existe');            
        }
        return stat;
    }

    private static Boolean insertarTarjeta(String pidCliente, String pcardHolderName, String pcardType, String pexpirationMonth, String pexpirationYear, String plast4Numbers, Integer psecurityCode, Boolean pisPrimary, string pCardNumber){
        Boolean stat = false;
        String idCliente = pidCliente; 
        String cardHolderName = pcardHolderName;
        String cardType = pcardType;
        String expirationMonth = pexpirationMonth;
        String expirationYear = pexpirationYear;
        String last4Numbers = plast4Numbers;
        Integer securityCode = psecurityCode;
        Boolean isPrimary = pisPrimary;
        String cardNumber = pCardNumber;
      
        try{
            vlocity_cmt__PaymentMethod__c paymentMtd = new vlocity_cmt__PaymentMethod__c();
            
            paymentMtd.vlocity_cmt__AccountId__c = idCliente; 
            paymentMtd.vlocity_cmt__CardHolderName__c = cardHolderName;
            paymentMtd.vlocity_cmt__CardNumber__c = cardNumber;
            paymentMtd.vlocity_cmt__CardType__c = cardType;
            paymentMtd.vlocity_cmt__ExpirationMonth__c = expirationMonth;
            paymentMtd.vlocity_cmt__ExpirationYear__c = expirationYear;
            paymentMtd.vlocity_cmt__Last4Numbers__c = last4Numbers;
            paymentMtd.vlocity_cmt__IsActive__c = true;
            paymentMtd.Security__c = securityCode;
            paymentMtd.vlocity_cmt__IsPrimary__c = isPrimary;
            paymentMtd.vlocity_cmt__MethodType__c = 'Credit Card';
            //paymentMtd.alias__c = '';
            paymentMtd.vlocity_cmt__BankAccountNumber__c = '';
            paymentMtd.vlocity_cmt__BankAccountType__c = 'TC';
            paymentMtd.BankEntityName__c = '';
            paymentMtd.Cbu__c='';
            paymentMtd.vlocity_cmt__RoutingTransitNumber__c='';

            System.debug('Entre a insert tarjeta :' + paymentMtd.vlocity_cmt__CardType__c);
            System.debug('Entre a insert tarjeta :' + paymentMtd.vlocity_cmt__IsPrimary__c);
            System.debug('Entre a insert tarjeta :' + paymentMtd.vlocity_cmt__MethodType__c);


            insert paymentMtd; 
            stat = true;
        }
        catch(Exception e){
            throw new CalloutException(e.getMessage());
        }
        return stat;
    }


    public class FromJSON {
        public FromJSON_1 asociarTarjeta; 
    }
    public class FromJSON_1 {
        public String idCliente; 
        public String cardHolderName;
        public String cardNumber;
        public String cardType;
        public String expirationMonth;
        public String expirationYear;
        public String last4Numbers;
        public Boolean isPrimary;
        public String securityCode;
    }
}