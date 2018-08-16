global with sharing class ta_sales_locationSearch implements vlocity_cmt.VlocityOpenInterface {
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        if(methodName.equals('PopulateLocations')) {
            PopulateLocations(input, outMap, options);
        }

         if(methodName.equals('PopulateLocationsTypeAHeadbyOptions')) {
            PopulateLocationsTypeAHeadbyOptions(input, outMap, options);
        }
        if(methodName.equals('PopulateLocationsTypeAHead')) {
            PopulateLocationsTypeAHead(input, outMap, options);
        }

        if(methodName.equals('PopulateStreetsTypeAHead')) {
            PopulateStreetsTypeAHead(input, outMap, options);
        }

        if(methodName.equals('validateAdressRange')) {
            validateAdressRange(input, outMap, options);
        }

        if(methodName.equals('PopulateStateLocationsPickupAvailable')) {
            PopulateStateLocationsPickupAvailable(input, outMap, options);
        }
        if(methodName.equals('PopulateCityLocationsPickupAvailable')) {
            PopulateCityLocationsPickupAvailable(input, outMap, options);
        }

        if(methodName.equals('PopulateLocationsNewTypeAHead')) {
            PopulateLocationsNewTypeAHead(input, outMap, options);
        }
                //-------------------------------------------------------------------------
                if(methodName.equals('PopulateLocationsTypeAHeadbyOptions1'))
                {
                    PopulateLocationsTypeAHeadbyOptions1(input, outMap, options);
                }
                if(methodName.equals('PopulateStreetsTypeAHead1'))
                {
                    PopulateStreetsTypeAHead1(input, outMap, options);
                }
                if(methodName.equals('validateAdressRange1'))
                {
                    validateAdressRange1(input, outMap, options);
                }
                if(methodName.equals('GenerarCodigoPostal1'))
                {
                    GenerarCodigoPostal1(input, outMap, options);
                }
                if(methodName.equals('GenerarCodigoPostalBilling1'))
                {
                    GenerarCodigoPostalBilling1(input, outMap, options);
                }
                //-----------------------------------------------------------
        return true;
    }

    public void PopulateLocations (Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();
            for (Location__c rel : [SELECT Id, Name, LocationCode__c, StateCode__c FROM Location__c ORDER BY Name]) {
                if (!dependency.containsKey(rel.StateCode__c)) {
                    dependency.put(rel.StateCode__c, new List<Map<String, String>>());
                }

                Map<String, String> tempMap = new Map<String, String>();

                tempMap.put('name', rel.Id);
                tempMap.put('value', rel.Name);

                dependency.get(rel.StateCode__c).add(tempMap);
            }
        System.debug('paso 2.1 ');
            outMap.put('dependency', dependency);
        }
        catch(Exception e) {
            System.debug('PopulateLocations Exception Msg: ' + e.getMessage());
            System.debug('PopulateLocations Exception Cause: ' + e.getCause());
            System.debug('PopulateLocations Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public void PopulateLocationsTypeAHead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            Map<String, Object> accountData = (Map<String, Object>) input.get('AccountData');

            String state = (String) accountData.get('State');

            List<Location__c> locations = [SELECT Id,
                                                  Name,
                                                  Postal_Code__c,
                                                  LocationCode__c
                                             FROM Location__c
                                            WHERE StateCode__c = :state
                                            ORDER BY Name];

            outMap.put('locations', locations);
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
 public void PopulateLocationsTypeAHeadbyOptions(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {


            String state = (String) options.get('State');

            List<Location__c> locations = [SELECT Id,
                                                  Name,
                                                  Postal_Code__c,
                                                  LocationCode__c
                                             FROM Location__c
                                            WHERE StateCode__c = :state
                                            ORDER BY Name];

            outMap.put('locations', locations);
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    public void PopulateStreetsTypeAHead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String locationId = (String) options.get('LocationId');

            if (!String.IsBlank(locationId)) {
                List<Street__c> streets = [SELECT Id,
                                                  Name,
                                                  StreetCode__c,
                                                  Postal_Code__c
                                             FROM Street__c
                                            WHERE Parent_Street__c = null
                                              AND Location__C = :locationId
                                            ORDER BY Name];

                outMap.put('streets', streets);
            }
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }

    }

    public void validateAdressRange(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            Double addressnumber = Double.valueof( options.get('addressnumber'));
            String streetId = (string) Options.get('streetId');
            boolean isvalidated = false;
            Street__C street1;
            try{
             street1 = [SELECT id, name,Range_From__c , Range_To__c, (Select id, name,Range_From__c , Range_To__c FROM Streets__r WHERE Range_From__c <=: addressnumber and Range_To__c >=:addressnumber ) FROM Street__c WHERE id =: streetId];
            }catch (Exception e) {}
            boolean isunnamedstreet = (boolean) options.get('validateexceptions');
            if(isunnamedstreet == true){isvalidated= true;}
            if (street1 != null)
            {
                if ( (street1.Range_From__c <= addressnumber &&  addressnumber <= street1.Range_To__c) || (street1.Streets__r.Size() >0))
                {
                    isvalidated = true;
                }

            }
            if (isvalidated == true) {
            outMap.put('status', 'Ok');
            }
            else
            {
            outMap.put('error', 'Address Number must be with in the range.');
            }

        }catch (Exception e){ outMap.put('error', e.getMessage());}
    }

    public void PopulateStateLocationsPickupAvailable(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Populate State Locations');
        Map<String, String> statePicklistValues = new Map<String, String>();
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();

        //Gets the value of the Points of Sale available for Store Pickup
        List<vlocity_cmt__BusinessSite__c> businessSitesList = [SELECT vlocity_cmt__State__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true];
        Set<String> stateAvailable = new Set<String>();
        for (vlocity_cmt__BusinessSite__c businessSite : businessSitesList) {
            if (businessSite.vlocity_cmt__State__c != null && businessSite.vlocity_cmt__State__c != '') {
                stateAvailable.add(businessSite.vlocity_cmt__State__c);
            }
        }

        //Gets the value of the states
        List<Schema.PicklistEntry> statePicklistEntries = Account.BillingStateCode.getDescribe().getPicklistValues();
        statePicklistEntries = sortPicklistEntryListByLabel(statePicklistEntries);

        for (Schema.PicklistEntry picklistEntry : statePicklistEntries) {
            if (stateAvailable.contains(picklistEntry.getValue())) {
                if (!statePicklistValues.containsKey(picklistEntry.getValue())) {
                    statePicklistValues.put(picklistEntry.getValue(), picklistEntry.getLabel());
                }
                Map<String, String> tempMap = new Map<String, String>();

                tempMap.put('name', picklistEntry.getValue());
                tempMap.put('value', statePicklistValues.get(picklistEntry.getValue()));

                returnedPicklistValues.add(tempMap);
            }
        }
        outMap.put('options', returnedPicklistValues);
    }

    public void PopulateCityLocationsPickupAvailable(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Populate Locations');
        Map<String, List<Map<String, String>>> returnedPicklistValues = new Map<String, List<Map<String, String>>>();

        //Gets the value of the Points of Sale available for Store Pickup
        List<vlocity_cmt__BusinessSite__c> businessSitesList = [SELECT vlocity_cmt__City__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true];
        Set<String> cityAvailable = new Set<String>();
        for (vlocity_cmt__BusinessSite__c businessSite : businessSitesList) {
            if (businessSite.vlocity_cmt__City__c != null && businessSite.vlocity_cmt__City__c != '') {
                cityAvailable.add(businessSite.vlocity_cmt__City__c);
            }
        }

        //Gets the value of the states
        List<Location__c> cityPicklistValues = [SELECT Name, LocationCode__c, StateCode__c FROM Location__c ORDER BY Name];
        for (Location__c location : cityPicklistValues) {

            if (cityAvailable.contains(location.LocationCode__c)) {
                if (!returnedPicklistValues.containsKey(location.StateCode__c)) {
                    returnedPicklistValues.put(location.StateCode__c, new List<Map<String, String>>());
                }
                Map<String, String> tempMap = new Map<String, String>();

                tempMap.put('name', location.LocationCode__c);
                tempMap.put('value', location.Name);

                returnedPicklistValues.get(location.StateCode__c).add(tempMap);
            }
        }
        outMap.put('dependency', returnedPicklistValues);
    }

    private List<Schema.PicklistEntry> sortPicklistEntryListByLabel(List<Schema.PicklistEntry> stringListEntries) {
        System.debug('Sort List');
        List<String> auxListToSort = new List<String>();
        List<Schema.PicklistEntry> sortedListToReturn = new List<PicklistEntry>();
        for (Schema.PicklistEntry picklistEntry : stringListEntries) {
            auxListToSort.add(picklistEntry.getLabel());
        }
        auxListToSort.sort();
        for (String label : auxListToSort) {
            for (Schema.PicklistEntry picklistEntry : stringListEntries) {
                if (picklistEntry.getLabel().equals(label)) {
                    sortedListToReturn.add(picklistEntry);
                }
            }
        }
        return sortedListToReturn;
    }

    public void PopulateLocationsNewTypeAHead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String state = (String) options.get('state');

            List<Location__c> locations = [SELECT Name, LocationCode__c
                                    FROM Location__c WHERE StateCode__c = :state
                                    ORDER BY Name];

            outMap.put('locations', locations);
        }catch (Exception e){}
    }
    //Metodo Utilizado para cargar la lista de Localidad
    public void PopulateLocationsTypeAHeadbyOptions1(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            String state = (String) options.get('State');
            String Province = (String) options.get('Provincia');
            List<Location__c> locations = new List<Location__c>();
            If(state != null)
            {
            locations = [SELECT Id,
                                Name,
                                Postal_Code__c,
                                LocationCode__c
                            FROM Location__c
                            WHERE StateCode__c = :state
                            ORDER BY Name
                        ];
            }
            else
            {
            locations = [SELECT Id,
                                Name,
                                Postal_Code__c,
                                LocationCode__c
                            FROM Location__c
                            WHERE StateCode__c = :Province
                            ORDER BY Name
                        ];
            }
            outMap.put('locations', locations);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        }
        //Metodo Utilizado para cargar el campo de Calle
        public void PopulateStreetsTypeAHead1(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
        {
        try
        {
            String locationId = (String) options.get('LocationId');
            if (!String.IsBlank(locationId))
            {
                List<Street__c> streets = [SELECT Id,
                                                    Name,
                                                    StreetCode__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C = :locationId
                                                ORDER BY Name
                                            ];
                outMap.put('streets', streets);
            }
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    //metodo encargado de generar el codigo podtsl dedes un remote action del OS
    public static final String strZona1 = 'Urbana';
    public static final String strZona2 = 'Casilla de Correo';
    public static final String strZona3 = 'Isla';
    public static final String strZona4 = 'Rural';
    public void GenerarCodigoPostal1(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        String strlocationId = (String) options.get('LocalidadId');
        String strAlturaIngresada = String.valueof(options.get('AlturaNum'));
        String strPruebainput = (String) input.get('userCurrencyCode');
        String strTipoZona = String.valueOf(options.get('TipoZona'));
        System.debug('strTipoZona Codigo ===> '+strTipoZona);
        IF(strlocationId != '' && strTipoZona != '')
        {
            IF(strTipoZona == strZona1)
            {
                String strCalleId = (String) options.get('CalleId');
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                                AND Id =: strCalleId
                                            ];
                system.debug('lstStreet '+strZona1+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('ShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('ShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona2)
            {
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                            ];
                system.debug('lstStreet '+strZona2+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('ShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('ShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona3)
            {
                String strRioId = String.valueOf(options.get('RioId'));
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                                AND Id =: strRioId
                                            ];
                system.debug('lstStreet '+strZona3+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('ShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('ShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona4)
            {
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                            ];
                system.debug('lstStreet '+strZona4+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('ShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('ShippingCodigoPostal', '');
                    }
                }
            }
        }
    }
    public void GenerarCodigoPostalBilling1(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        System.debug('entro billing codigo ===> ');
        String strlocationId = (String) options.get('LocalidadBillingId');
        String strAlturaIngresada = String.valueof(options.get('AlturaNumBilling'));
        String strPruebainput = (String) input.get('userCurrencyCode');
        String strTipoZona = String.valueOf(options.get('TipoZonaBilling'));
        System.debug('strTipoZona Billing Codigo ===> '+strTipoZona);
        IF(strlocationId != '' && strTipoZona != '')
        {
            IF(strTipoZona == strZona1)
            {
                String strCalleId = (String) options.get('CalleBillingId');
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                                AND Id =: strCalleId
                                            ];
                system.debug('lstStreet '+strZona1+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('BillingShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('BillingShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona2)
            {
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                            ];
                system.debug('lstStreet '+strZona2+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('BillingShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('BillingShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona3)
            {
                String strRioId = String.valueOf(options.get('RioBillingId'));
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                                AND Id =: strRioId
                                            ];
                system.debug('lstStreet '+strZona3+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('BillingShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('BillingShippingCodigoPostal', '');
                    }
                }
            }
            IF(strTipoZona == strZona4)
            {
                list<Street__c> lstStreet = [ SELECT Id,
                                                    Name,
                                                    Location__c,
                                                    Postal_Code__c,
                                                    Range_From__c,
                                                    Range_To__c,
                                                    Location__r.Name,
                                                    Location__r.StateCode__c,
                                                    Location__r.StateName__c
                                                FROM Street__c
                                                WHERE Parent_Street__c = null
                                                AND Location__C =: strlocationId
                                            ];
                system.debug('lstStreet '+strZona4+'===> '+lstStreet);
                for(Street__c objStreet : lstStreet)
                {
                    String strCodigoPostal;
                    String intAltura1;
                    String intAltura2;
                    intAltura1 = String.valueOf(objStreet.Range_From__c);
                    intAltura2 = String.valueOf(objStreet.Range_To__c);
                    if(intAltura1 <= strAlturaIngresada && intAltura2 >= strAlturaIngresada)
                    {
                        strCodigoPostal = String.valueOf(objStreet.Postal_Code__c);
                        outMap.put('BillingShippingCodigoPostal', strCodigoPostal);
                    }
                    else
                    {
                        outMap.put('BillingShippingCodigoPostal', '');
                    }
                }
            }
        }
    }
    //Metodo encargado de realizar la creacion de los asset2 y actuaizar las cuentas y contactos
    public void validateAdressRange1(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
    {
        Map<String, object> mapReturn = new map<String, object>();
        Map<String, object> mapReturnBilling = new map<String, object>();
        String strProvinciaId = (String) options.get('ProvinciaId');
        String strCalleId = (String) options.get('CalleId');
        String strlocationId = (String) options.get('LocalidadId');
        String strAlturaIngresada = (String) options.get('AlturaNum');
        String strCodigoPostal = (String) options.get('CodigoPostal');
        String strTipoZona = String.valueOf(options.get('TipoZona'));
        String strIdAccount = (String)Options.get('accountId');
        String strIdContact = (String)Options.get('contactId');
        System.debug('strTipoZona ===> '+strTipoZona);
        System.debug('strProvinciaId ===> '+strProvinciaId);
        Map<String,Object> mapAccoundata = (Map<String,Object>) Options.get('AccountData');
        System.debug('mapAccoundata ===> '+mapAccoundata);
        if(strCalleId != '' && strlocationId != '' && strCodigoPostal != '')
        {
            Street__c objStreet = [ SELECT Id,
                                            Name,
                                            Location__c,
                                            Postal_Code__c,
                                            Range_From__c,
                                            Range_To__c,
                                            Location__r.Name,
                                            Location__r.StateCode__c,
                                            Location__r.StateName__c
                                        FROM Street__c
                                        WHERE Parent_Street__c = null
                                        AND Location__C =: strlocationId
                                        AND Id =: strCalleId
                                    ]; 
            IF(strTipoZona == strZona1 && input.get('CopyLegalAddress') == true)
            {
                mapReturn = DatosUrbanos(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            else IF(strTipoZona == strZona1 && input.get('CopyLegalAddress') == false)
            {
                mapReturn = DatosUrbanos(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
                mapReturnBilling = DatosUrbanosBilling(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            IF(strTipoZona == strZona2 && input.get('CopyLegalAddress') == true)
            {
                mapReturn = DatosCasilla(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            else IF(strTipoZona == strZona2 && input.get('CopyLegalAddress') == false)
            {
                mapReturn = DatosCasilla(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
                mapReturnBilling = DatosCasillaBilling(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            IF(strTipoZona == strZona3 && input.get('CopyLegalAddress') == true)
            {
                mapReturn = DatosIsla(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            else IF(strTipoZona == strZona3 && input.get('CopyLegalAddress') == false)
            {
                mapReturn = DatosIsla(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
                mapReturnBilling = DatosIslaBilling(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            IF(strTipoZona == strZona4 && input.get('CopyLegalAddress') == true)
            {
                mapReturn = DatosRural(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            else IF(strTipoZona == strZona4 && input.get('CopyLegalAddress') == false)
            {
                mapReturn = DatosRural(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
                mapReturnBilling = DatosRuralBilling(strTipoZona, mapAccoundata, objStreet, strIdAccount, strIdContact, strCodigoPostal, strlocationId);
            }
            IF(mapReturn != null && mapReturnBilling != null && !mapReturn.isEmpty() && !mapReturnBilling.isEmpty())
            {
                outMap.put('Address2Id',mapReturn.get('Address2Id'));
                outMap.put('Address2IdBilling',mapReturnBilling.get('Address2IdBilling'));
            }
            else
            {
                outMap.put('Address2Id',mapReturn.get('Address2Id'));
            }
        }
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Urbano
    public static final String strTipoDomicilioCasa = 'CASA';
    public static final String strTipoDomicilioEdificio = 'EDIFIIO';
    public static final String strTipoDomicilioLocal = 'LOCAL';
    public Map<String,String> DatosUrbanos (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto , String strCodigoPostal, String strlocationId)
    {
        System.debug('strCuenta ===> '+strCuenta);
        system.debug('objCalle ===> '+objCalle);
        Map<String,String> mapData1 = new Map<String,String>();
        String strValEdifi;
        String strCalle1;
        String strCalle2;
        String strPuerta;
        String strBarrio;
        String strTypeLocal;
        String strNumLocal;
        String strPiso;
        String strDeparta;
        String strTypeEdificio;
        String strNumEdificio;
        if(mapData.get('ShippingCalle1-Block') != null && mapData.get('ShippingCalle2-Block')!= null)
        {
            strCalle1 = (String)mapData.get('ShippingCalle1');
            strCalle2 = (String)mapData.get('ShippingCalle2');
        }
        String strTypeDomicilio = String.valueOf(mapData.get('ShippingTipoDeDomicilio'));
        Schema.DescribeFieldResult fieldResult = Address2__c.Tipo_de_Domicilio__c.getDescribe();
        List<Schema.PicklistEntry> lstValuesSch = fieldResult.getPicklistValues();
        List<String> lstDomicilio = new List<String>();
        for(Schema.PicklistEntry v : lstValuesSch)
        {
            //Casa-
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioCasa == strTypeDomicilio)
            {
                strPuerta = (String)mapData.get('ShippingPuerta');
                strBarrio = (String)mapData.get('ShippingBarrio');
                break;
            }
            //-
            //Local--
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioLocal == strTypeDomicilio)
            {
                strTypeLocal = (String)mapData.get('ShippingTipodeLocal');
                strNumLocal = (String)mapData.get('ShippingNumerodeLocal');
                break;
            }
            //--
            //Edificio---
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioEdificio == strTypeDomicilio)
            {
                strPiso = (String)mapData.get('ShippingPiso');
                strDeparta = (String)mapData.get('ShippingDepartmento');
                strTypeEdificio = (String)mapData.get('ShippingTipodeEdificio');
                strNumEdificio = (String)mapData.get('ShippingNumerodeEdificio');
                break;
            }
            //---
        }
        String strAlturaIngresada = (String) mapData.get('ShippingAltitude');
        String strComentario = (String)mapData.get('ShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Tipo_de_Domicilio__c = strTypeDomicilio;
        objAddress2.Entre_calle_interna_2__c = strCalle2;
        objAddress2.Entre_calle_interna_1__c = strCalle1;
        objAddress2.Puerta__c = strPuerta;
        objAddress2.Barrio__c = strBarrio;
        objAddress2.Tipo_de_Local__c = strTypeLocal;
        objAddress2.Numero_del_Local__c = strNumLocal;
        objAddress2.Tipo_de_Edificio__c = strTypeEdificio;
        objAddress2.Piso__c = strPiso;
        objAddress2.Departamento__c = strDeparta;
        objAddress2.Numero_de_Edificio__c = strNumEdificio;
        objAddress2.Comment__c = strComentario;     
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objAddress2.Validado__c = True;
        }
        System.debug('objAddress2 ===> '+objAddress2);
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                        Billing_Address__c,
                                        Shipping_Address__c
                                    From Account
                                    where ID =: strCuenta
                                ];
            lstAccount.Shipping_Address__c = objAddress2.Id;
            update lstAccount;
        }
        //-------------------------------------------------
        // se envia el Id de addres2
        System.debug('Addres2 Id ===> '+objAddress2.Id);
        mapData1.put('Address2Id',objAddress2.Id);
        system.debug('mapData Urbano ===> '+mapData1);
        Return mapData1;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Casilla de Correo
    public Map<String,String> DatosCasilla (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData2 = new Map<String,String>();
        String strSucursal = (String)mapData.get('ShippingSucursal');
        mapData.put('strSucursal',strSucursal);
        String strNumCasilla = (String)mapData.get('ShippingNúmeroDeCasillaDeCorreo');
        mapData.put('strNumCasilla',strNumCasilla);
        String strAlturaIngresada = (String) mapData.get('ShippingAltitude');
        String strComentario = (String)mapData.get('ShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Comment__c = strComentario;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.sucursalNro__c = strSucursal;
        objAddress2.casillaPostal__c = strNumCasilla;
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objaddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Shipping_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Addres2 Id ===> '+objAddress2.Id);
        mapData2.put('Address2Id',objAddress2.Id);
        system.debug('mapData Casilla ===> '+mapData2);
        Return mapData2;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Isla
    public Map<String,String> DatosIsla (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData3 = new Map<String,String>();
        String strRio;
        if(mapData.get('ShippingRio-Block') != null)
        {
            Map<String,Object> mapRio = (Map<String,Object>)mapData.get('ShippingRio-Block');
            strRio = (String)mapRio.get('ShippingRio');
        }
        String strMuelle = (String)mapData.get('ShippingMuelle');
        String strSeccion = (String)mapData.get('ShippingSeccion');
        String strAlturaIngresada = (String) mapData.get('ShippingAltitude');
        String strComentario = (String)mapData.get('ShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Comment__c = strComentario;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Calle_rio_de_atras__c = strRio;
        objAddress2.Muelle__c = strMuelle;
        objAddress2.Seccion__c = strSeccion;
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objaddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Shipping_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Addres2 Id ===> '+objAddress2.Id);
        mapData3.put('Address2Id',objAddress2.Id);
        system.debug('mapData Isla ===> '+mapData3);
        Return mapData3;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Rural
    public Map<String,String> DatosRural (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData4 = new Map<String,String>();
        if(mapData.get('ShippingRuta-Block') != null)
        {
            Map<String,Object> mapRuta = (Map<String,Object>)mapData.get('ShippingRuta-Block');
            String strRuta = (String)mapRuta.get('ShippingRuta');
            mapData.put('strRuta',strRuta);
        }
        String strEstablecimiento = (String)mapData.get('ShippingNombredelEstablecimiento');
        String strAlturaIngresada = (String) mapData.get('ShippingAltitude');
        String strComentario = (String)mapData.get('ShippingComments');
        mapData.put('strComentario',strComentario);
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Nombre_del_Establecimiento__c = strEstablecimiento;
        // la ruta no hay donde guardarla en addres2
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objAddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Shipping_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Addres2 Id ===> '+objAddress2.Id);
        mapData4.put('Address2Id',objAddress2.Id);
        system.debug('mapData Rural ===> '+mapData4);
        Return mapData4;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona para billing: Urbano
    public Map<String,String> DatosUrbanosBilling (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto , String strCodigoPostal, String strlocationId)
    {
        System.debug('strCuenta ===> '+strCuenta);
        system.debug('objCalle ===> '+objCalle);
        Map<String,String> mapData1 = new Map<String,String>();
        String strValEdifi;
        String strCalle1;
        String strCalle2;
        String strPuerta;
        String strBarrio;
        String strTypeLocal;
        String strNumLocal;
        String strPiso;
        String strDeparta;
        String strTypeEdificio;
        String strNumEdificio;
        if(mapData.get('BillingShippingCalle1-Block') != null && mapData.get('BillingShippingCalle2-Block')!= null)
        {
            strCalle1 = (String)mapData.get('BillingShippingCalle1');
            strCalle2 = (String)mapData.get('BillingShippingCalle2');
        }
        String strTypeDomicilio = String.valueOf(mapData.get('BillingShippingTipoDeDomicilio'));
        Schema.DescribeFieldResult fieldResult = Address2__c.Tipo_de_Domicilio__c.getDescribe();
        List<Schema.PicklistEntry> lstValuesSch = fieldResult.getPicklistValues();
        List<String> lstDomicilio = new List<String>();
        for(Schema.PicklistEntry v : lstValuesSch)
        {
            //Casa-
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioCasa == strTypeDomicilio)
            {
                strPuerta = (String)mapData.get('BillingShippingPuerta');
                strBarrio = (String)mapData.get('BillingShippingBarrio');
                break;
            }
            //-
            //Local--
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioLocal == strTypeDomicilio)
            {
                strTypeLocal = (String)mapData.get('BillingShippingTipodeLocal');
                strNumLocal = (String)mapData.get('BillingShippingNumerodeLocal');
                break;
            }
            //--
            //Edificio---
            if(v.getLabel() == strTypeDomicilio && strTipoDomicilioEdificio == strTypeDomicilio)
            {
                strPiso = (String)mapData.get('BillingShippingPiso');
                strDeparta = (String)mapData.get('BillingShippingDepartmento');
                strTypeEdificio = (String)mapData.get('BillingShippingTipodeEdificio');
                strNumEdificio = (String)mapData.get('BillingShippingNumerodeEdificio');
                break;
            }
            //---
        }
        String strAlturaIngresada = (String) mapData.get('BillingShippingAltitude');
        String strComentario = (String)mapData.get('BillingShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Tipo_de_Domicilio__c = strTypeDomicilio;
        objAddress2.Entre_calle_interna_2__c = strCalle2;
        objAddress2.Entre_calle_interna_1__c = strCalle1;
        objAddress2.Puerta__c = strPuerta;
        objAddress2.Barrio__c = strBarrio;
        objAddress2.Tipo_de_Local__c = strTypeLocal;
        objAddress2.Numero_del_Local__c = strNumLocal;
        objAddress2.Tipo_de_Edificio__c = strTypeEdificio;
        objAddress2.Piso__c = strPiso;
        objAddress2.Departamento__c = strDeparta;
        objAddress2.Numero_de_Edificio__c = strNumEdificio;
        objAddress2.Comment__c = strComentario;
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objAddress2.Validado__c = True;
        }
        System.debug('objAddress2 ===> '+objAddress2);
        //-------------------------------------------------
        // se envia el Id de addres2
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Billing_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Address2IdBilling Id ===> '+objAddress2.Id);
        mapData1.put('Address2IdBilling',objAddress2.Id);
        system.debug('mapData Urbano ===> '+mapData1);
        Return mapData1;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Casilla de Correo
    public Map<String,String> DatosCasillaBilling (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData2 = new Map<String,String>();
        String strSucursal = (String)mapData.get('BillingShippingSucursal');
        mapData.put('strSucursal',strSucursal);
        String strNumCasilla = (String)mapData.get('BillingShippingNúmeroDeCasillaDeCorreo');
        mapData.put('strNumCasilla',strNumCasilla);
        String strAlturaIngresada = (String) mapData.get('BillingShippingAltitude');
        String strComentario = (String)mapData.get('BillingShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Comment__c = strComentario;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.sucursalNro__c = strSucursal;
        objAddress2.casillaPostal__c = strNumCasilla;
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objaddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Billing_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Address2IdBilling Id ===> '+objAddress2.Id);
        mapData2.put('Address2IdBilling',objAddress2.Id);
        system.debug('mapData Casilla ===> '+mapData2);
        Return mapData2;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Isla
    public Map<String,String> DatosIslaBilling (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData3 = new Map<String,String>();
        String strRio;
        if(mapData.get('BillingShippingRio-Block') != null)
        {
            Map<String,Object> mapRio = (Map<String,Object>)mapData.get('BillingShippingRio-Block');
            strRio = (String)mapRio.get('BillingShippingRio');
        }
        String strMuelle = (String)mapData.get('BillingShippingMuelle');
        String strSeccion = (String)mapData.get('BillingShippingSeccion');
        String strAlturaIngresada = (String) mapData.get('BillingShippingAltitude');
        String strComentario = (String)mapData.get('BillingShippingComments');
        mapData.put('strComentario',strComentario);
        List<Address2__c> lstAddress2 = new List<Address2__c>();
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Comment__c = strComentario;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Calle_rio_de_atras__c = strRio;
        objAddress2.Muelle__c = strMuelle;
        objAddress2.Seccion__c = strSeccion;
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objaddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Billing_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Address2IdBilling Id ===> '+objAddress2.Id);
        mapData3.put('Address2IdBilling',objAddress2.Id);
        system.debug('mapData Isla ===> '+mapData3);
        Return mapData3;
    }
    //Metodo utilizado para realizar el envio de informacion correspondiente a la dependencia de campos Tipo de zona : Rural
    public Map<String,String> DatosRuralBilling (String strTipoZona, Map<String,Object> mapData, Street__c objCalle, String strCuenta, String strContacto, String strCodigoPostal, String strlocationId)
    {
        Map<String,String> mapData4 = new Map<String,String>();
        if(mapData.get('BillingShippingRuta-Block') != null)
        {
            Map<String,Object> mapRuta = (Map<String,Object>)mapData.get('BillingShippingRuta-Block');
            String strRuta = (String)mapRuta.get('BillingShippingRuta');
            mapData.put('strRuta',strRuta);
        }
        String strEstablecimiento = (String)mapData.get('BillingShippingNombredelEstablecimiento');
        String strAlturaIngresada = (String) mapData.get('BillingShippingAltitude');
        String strComentario = (String)mapData.get('BillingShippingComments');
        mapData.put('strComentario',strComentario);
        Address2__c objAddress2 = new Address2__c();
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            objAddress2.Account_Owner__c = strCuenta;
        }
        objAddress2.Address_Number__c = Decimal.valueOf(strAlturaIngresada);
        objAddress2.Contact_Owner__c = strContacto;
        objAddress2.Location_ID__c = strlocationId;
        objAddress2.Location_Name__c = objCalle.Location__r.Name;
        //objAddress2.Province_ID__c = strProvinciaId;
        objAddress2.Province__c = objCalle.Location__r.StateCode__c;
        objAddress2.Street_ID__c = objCalle.Id;
        objAddress2.Street_Name__c = objCalle.Name;
        objAddress2.Tipo_de_Zona__c = strTipoZona;
        //------------------------ Codigo Postal ----------------------------------
        objAddress2.Nombre_del_Establecimiento__c = strEstablecimiento;
        // la ruta no hay donde guardarla en addres2
        if(strCodigoPostal != objCalle.Postal_Code__c)
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
        }
        else
        {
            objAddress2.ZIP_Code__c = strCodigoPostal;
            objAddress2.Validado__c = True;
        }
        //-------------------------------------------------
        Insert objAddress2;
        if(strCuenta != null && strCuenta != '' && String.isNotEmpty(strcuenta))
        {
            Account lstAccount = [ Select Id,
                                                Billing_Address__c,
                                                Shipping_Address__c
                                            From Account
                                            where ID =: strCuenta
                                        ];
            lstAccount.Billing_Address__c = objAddress2.Id;
            update lstAccount;
        }
        System.debug('Address2IdBilling Id ===> '+objAddress2.Id);
        mapData4.put('Address2IdBilling',objAddress2.Id);
        system.debug('mapData Rural ===> '+mapData4);
        Return mapData4;
    }
}