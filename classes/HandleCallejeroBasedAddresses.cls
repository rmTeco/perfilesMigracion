global with sharing class HandleCallejeroBasedAddresses implements vlocity_cmt.VlocityOpenInterface
{
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if (methodName.equals('UpsertToAddress2')){
                UpsertToAddress2(inputMap, outMap, options);
            }
            
            if (methodName.equals('DeleteAddressfromAddress2')){
                DeleteAddressfromAddress2(inputMap, outMap, options);
            }
            
            if (methodName.equals('UIAddressHelper_street')){
                UIAddressHelper_street(inputMap, outMap, options);
            }
            if (methodName.equals('UIAddressHelper_zone')){
                UIAddressHelper_zone(inputMap, outMap, options);
            }
            if (methodName.equals('ValidateAddress')){
                ValidateAddress(inputMap, outMap, options);
            }
            
            
            result = false;
        }catch(Exception e){
            System.debug('HandleCallejeroBasedAddresses:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    /* Method used to insert/update address2 record*/
    global void UpsertToAddress2(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        
        // Variable will hold the State Code entered in the UI
        String State = (String) options.get('State'); 
        // Variable will hold the Location record ID entered in the UI   
        String LocationTypeAhead = (String) options.get('LocationTypeAhead'); 
        // Variable will hold the street record ID entered in the UI     
        String StreetTypeAhead = (String) options.get('StreetTypeAhead'); 
        // Variable will hold the Zone record ID entered in the UI      
        String ZoneTypeAhead = (String) options.get('ZoneTypeAhead'); 
        // Variable will hold the Account ID        
        String AccountId = (String) options.get('AccountId');
        // Variable will hold the Contact ID
        String ContactId = (String) options.get('ContactId');  
        // Variable will hold the Type of Address .. Billing/Legal/Service Address
        String TypeOfAddress = (String) options.get('TypeOfAddress');
        // Variable will hold the Location Name if the Location entered by CSR does not match the records in the System, then the CSR will enter the location Name Manually
        String LocationName = (String) options.get('LocationName'); 
        // Variable will hold the Street Name if the Street entered by CSR does not match the records in the System, then the CSR will enter the Street Name Manually  
        String StreetName = (String) options.get('StreetName');  
        // Variable will hold the Zone Name if the zone entered by CSR does not match the records in the System, then the CSR will enter the Zone Name Manually   
        String ZoneName = (String) options.get('ZoneName');   
        
        
        List<Address2__c> addressesToInsert = new List<Address2__c>(); 
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        
        
        // If the Addresses of the account are inserted/modified then it enters this loop
        If(AccountId != Null){
            
            accounts = [select id, billing_address__c /* ,Service_Address__c, Legal_Address__c*/ from account where id=:AccountId];
            
            Address2__c address = new Address2__c();
            address.Province__c = State;
            
            if(string.IsNotBlank(LocationName))
                address.Location_Name__C = LocationName;
            if(string.IsNotBlank(StreetName))
                address.Street_Name__C = StreetName;
            if(string.IsNotBlank(ZoneName))
                address.Zone_Name__C = ZoneName;
            if(string.IsNotBlank(LocationTypeAhead))
                address.Location_ID__c = LocationTypeAhead;
            if(string.IsNotBlank(StreetTypeAhead))
                address.Street_ID__c = StreetTypeAhead;
            if(string.IsNotBlank(ZoneTypeAhead ))
                address.Zone_ID__c = ZoneTypeAhead;
            if(string.IsNotBlank(address.Location_Name__C) || string.IsNotBlank(address.Zone_Name__C) || string.IsNotBlank(address.Street_Name__C)){ 
                address.Validado__c = false;
            } else {
                address.Validado__c = true;
            }
            
            address.Account_Owner__C = AccountId;
            addressesToInsert.add(address);
            
            
        }
        
        // If the Addresses of the Contact are inserted/modified then it enters this loop
        If(string.IsNotBlank(ContactId)){
            
            contacts = [select id, mailing_Address__c  from contact where id=:ContactId];
            
            Address2__c address = new Address2__c();
            address.Province__c = State;
            
            if(string.IsNotBlank(LocationName))
                address.Location_Name__C = LocationName;
            if(string.IsNotBlank(StreetName))
                address.Street_Name__C = StreetName;
            if(string.IsNotBlank(ZoneName))
                address.Zone_Name__C = ZoneName;
            
            if(string.IsNotBlank(LocationTypeAhead))
                address.Location_ID__c = LocationTypeAhead;
            if(string.IsNotBlank(StreetTypeAhead))
                address.Street_ID__c = StreetTypeAhead;
            if(string.IsNotBlank(ZoneTypeAhead))
                address.Zone_ID__c = ZoneTypeAhead;
            
            if(string.IsNotBlank(address.Location_Name__C) || string.IsNotBlank(address.Zone_Name__C) || string.IsNotBlank(address.Street_Name__C)){ 
                address.Validado__c = false;
            } else {
                address.Validado__c = true;
            }
            address.Contact_Owner__C = ContactId;
            addressesToInsert.add(address);
            
        }
        
        upsert addressesToInsert;
        
        if(accounts.size()>0){
            
            if(TypeOfAddress == 'Billing Address'){
                accounts[0].billing_address__c = addressesToInsert[0].id;  
        /*    } else if(TypeOfAddress == 'Legal Address'){
                accounts[0].Legal_address__c = addressesToInsert[0].id;  */
        /*    } else if(TypeOfAddress == 'Service Address'){
                accounts[0].Service_address__c = addressesToInsert[0].id;  */
            }
            update accounts;
        }
        if(contacts.size()>0){
            
            if(TypeOfAddress == 'Mailing Address'){
                contacts[0].Mailing_Address__c =  addressesToInsert[0].id;   
            }
            update contacts;
            
        }
        
        // Returning back the Address2ID 
        outMap.put('Address2Id',addressesToInsert[0].id);
    }
    
    
    /* Method used to delete address2 record using the address2 record Id */
    global void DeleteAddressfromAddress2(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        String Address2Id = (String) options.get('Address2Id');   
        List<Address2__c> addresses = new List<Address2__c>();
        addresses = [select id from Address2__c where id=:Address2Id];
        if(addresses.size()>0){
            delete addresses[0];
        } 
        
    }
    
    /* Method used to fetch all the street records based on the Location Selected by the user and of record type street */ 
    global void UIAddressHelper_Street(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        String ProvinceCode = (String) options.get('ProvinceCode');   
        String LocationId = (String) options.get('LocationId');
        String StreetName = (String) options.get('StreetName');
        
        String str ='%'+StreetName +'%';
        
        list<RecordType> recordtypes = new list<RecordType>();   
        recordtypes = [select id,Developername from Recordtype where developername='Street'];
        
        list<street__c> streets = new list<street__c>();
        
        
        streets = [select id,name from street__C where Name Like: str and Location__c =: LocationId and Recordtypeid =: recordtypes[0].id ORDER BY Name];
        
        outMap.put('streets', streets);
        
    }
    
    /* Method used to fetch all the Zone records based on the location selected by the user */ 
    global void UIAddressHelper_zone(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        String ProvinceCode = (String) options.get('ProvinceCode');   
        String LocationId = (String) options.get('LocationId');
        String zonename = (String) options.get('zonename');
        String str ='%'+zonename +'%';
        
        list<zones__c> zones = new list<zones__c>();
        
        zones = [select id,name from Zones__c where name like:str and Location__c =: LocationId ORDER BY Name];
        
        
        outMap.put('zones', zones);
        
        
    }
    
    /* Functionality to validate an address to see if it exists or not in Callejero Objects. */
    public void ValidateAddress(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        
        
        String LocationId;
        String LocationName ;
        String StreetName;
        String StreetId ;
        String RangeId;
        String ZoneId;
        String ZoneName ;
        Decimal AddressNumber;
        String ZipCode ;
        String Province;
        
        system.debug('CP options'+options);
        
        if (((Options.get('AddressNumber')) != 'null'))
            AddressNumber= (Decimal) Options.get('AddressNumber');
        
        if(options.get('ZipCode')!= 'null')
            ZipCode = (String) options.get('ZipCode');
        
        if(options.get('Province')!= 'null')
            Province = (string)options.get('Province');
        
        if(options.get('LocationId')!= 'null')
            LocationId = (string)options.get('LocationId');
        
        if(options.get('LocationName')!= 'null')
            LocationName = (string)options.get('LocationName');
        
        if(options.get('StreetId')!= 'null')
            StreetId = (string)options.get('StreetId');
        
        if(options.get('StreetName')!= 'null')
            StreetName = (string)options.get('StreetName');
        
        if(options.get('RangeId')!= 'null')    
            RangeId =(Id)options.get('RangeId'); 
        
        
        
        if(options.get('ZoneId')!='null') 
            ZoneId = (string)options.get('ZoneId'); 
        
        if(options.get('ZoneName')!='null') 
            ZoneName =(string)options.get('ZoneName'); 
        
        Map<string,Map<string,object>> AddressDetails = new Map<string,Map<string,object>>();
        
        Map<string,object>  LocationMap = new Map<string,object>{'IsValid'=>'null', 'CallejeroLocationID'=> 'null','LocationId'=>'null','LocationName'=>'null'};
            Map<string,object>  StreetMap = new Map<string,object>{'IsValid'=>'null', 'CallejeroStreetID'=> 'null','StreetId'=>'null','StreetName'=>'null'};
                Map<string,object>  zoneMap = new Map<string,object>{'IsValid'=>'null', 'CallejeroZoneID'=> 'null','ZoneId'=>'null','ZoneName'=>'null'};
                    Map<string,object>  RangeMap = new Map<string,object>{'IsValid'=>'null', 'CallejeroRangeID'=> 'null','RangeId'=>'null','RangeName'=>'null'};
                        List<Location__c> Loc = new List<Location__c>() ;
        List<Street__c> Street = new List<Street__c>();
        List<Zones__c> Zone = new List<Zones__c>();
        
        system.debug('CP LocationId'+LocationId);
        
        // If there is LocationId and LocationName and if there name matches return valid as true else false
        if(string.isNotBlank(LocationId) && (string.isNotBlank(LocationName))){
            system.debug('In LocId!=null');
            
            Loc = [select LocationCode__c,name from Location__c where id=:LocationId];
            LocationMap.put('LocationName',LocationName);
            LocationMap.put('LocationId',LocationId);
            
            if(Loc.size()>0){
                LocationMap.put('CallejeroLocationID',Loc[0].LocationCode__c);
                system.debug('LocationName'+LocationName+'Loc[0].Name'+Loc[0].Name);
                if((Loc[0].Name).containsIgnoreCase(LocationName))
                    LocationMap.put('IsValid','true');
                else
                    LocationMap.put('IsValid','false');
            }
            
        }
        // If LocationId is blank and contains LocationName then entered location is valid only if provided  LocationName and province  matches with location records in SFdatabase
        else if(string.isBlank(LocationId) && (string.isNotBlank(LocationName))){ 
            system.debug('In LocId=null');
            LocationMap.put('LocationName',LocationName);
            LocationMap.put('IsValid','false');
            
            Loc = [select id,Name,StateCode__c,LocationCode__c from Location__c where StateCode__c =:Province and name like : '%'+LocationName+'%' limit 1]; // will always return one record like : '%*%'+LocationName+'%*%'
            system.debug('CP Location'+Loc);
            if(Loc.size()>0 && Province!=null )
                
                if((Loc[0].StateCode__c).equalsIgnoreCase(Province)){
                    LocationMap.put('LocationId',Loc[0].id);
                    LocationMap.put('CallejeroLocationID',Loc[0].LocationCode__c); 
                    LocationMap.put('IsValid','true'); 
                    
                }
            
        }
        
        if( LocationMap.get('IsValid')=='true') {
             // If there is StreetId and StreetName and if there name matches return valid as true else false
            if(string.isNotBlank(StreetId) && string.isNotBlank(StreetName) ){
                StreetMap.put('StreetName',StreetName);
                StreetMap.put('StreetId',StreetId);
                Street = [select Name,StreetCode__c from street__c where Id=: StreetId];             
                if(Street.size()>0 ){
                    StreetMap.put('CallejeroStreetID',Street[0].StreetCode__c);
                    if((Street[0].Name).containsIgnoreCase(StreetName) )
                        
                        StreetMap.put('IsValid','true');
                    else
                        StreetMap.put('IsValid','false');
                }
                
            }
            // If StreetId is blank and contains StreetName then entered Street is valid only if provided  StreetName and CallejeroLocationID  matches with Street records in SFdatabase and a valid LocationId is provided
            else if(string.isBlank(StreetId)&& string.isNotBlank(StreetName) ){
                system.debug('In StreetId=null');
                StreetMap.put('StreetName',StreetName);
                StreetMap.put('IsValid','false');
                if(LocationMap.get('CallejeroLocationID')!=null)
                    Street = [select id,StreetCode__c, Location__r.LocationCode__c from street__c where Location__r.LocationCode__c =: (string)LocationMap.get('CallejeroLocationID') and Name like :'%'+StreetName+'%'];
                
                if( street.size()>0){
                    
                    StreetMap.put('StreetId',Street[0].id);
                    StreetMap.put('CallejeroStreetID',Street[0].StreetCode__c); 
                    StreetMap.put('IsValid','true'); 
                }
                
            }
            if(StreetMap.get('IsValid')=='true'){
                Street__c Street_range;
                if (RangeId != null)
                    
                {
                    Street_range = [select id,Name, Range_From__c, Range_To__C, Postal_Code__C,StreetCode__c from street__c WHERE id =: RangeId];  
                    
                }
                
                
                If (Street_range != null )
                {
                    RangeMap.put('CallejeroRangeID' , Street_range.StreetCode__c);
                    RangeMap.put('RangeId' , RangeId);
                    RangeMap.put('RangeName' , Street_range.Name);
                    RangeMap.put('ZipCode' , Street_range.Postal_Code__c);
                    RangeMap.Put('IsValid' , 'false');
                    /* Here check RangeFrom, RangeTo, AddressNumber is null or not. To satisify this condition, the three values should not be null.*/
                    If(Street_range.Range_From__c  != null && Street_range.Range_To__c != null && AddressNumber != null )
                    {
                        
                        /* this is a condition to check Address number is in between RangeFrom and RangeTo. */
                        
                        if ( Street_range.Range_From__c  < = AddressNumber && Street_range.Range_To__c >= AddressNumber )
                        {
                            
                            /* Condition : check Zipcode is null or Zipcode is equal to Postal code */
                            
                            if (String.isBlank(ZipCode) || (String.isNotBlank(ZipCode) && String.isNotBlank(Street_range.Postal_Code__c) && ZipCode == Street_range.Postal_Code__c))
                            {
                                RangeMap.Put('IsValid' , 'true');
                            }
                            
                        }
                    }
                } 
                
                
                // Zone Validation only when Location ,street and Range validation is successfull
                if(RangeMap.get('IsValid')=='true'){
                    if(string.isNotBlank(ZoneId) && string.isNotBlank(ZoneName)){
                        ZoneMap.put('ZoneName',ZoneName);
                        ZoneMap.put('ZoneId',ZoneId);
                        
                        Zone = [select id,Name,ZoneID__c, Location__r.LocationCode__c from Zones__c where id=:ZoneId ]; 
                        
                        
                        if(Zone.size()>0){
                            ZoneMap.put('CallejeroZoneID',Zone[0].ZoneID__c);
                            if((Zone[0].Name).containsIgnoreCase(ZoneName) )
                                ZoneMap.put('IsValid','true');
                            else
                                ZoneMap.put('IsValid','false');
                        }
                    }
                    else if(string.isBlank(ZoneId) && string.isNotBlank(ZoneName) ){
                        system.debug('In ZoneId=null');
                        ZoneMap.put('ZoneName',ZoneName);
                        ZoneMap.put('IsValid','false');
                        if(LocationMap.get('CallejeroLocationID')!=null )
                            Zone = [select id,Name,ZoneID__c, Location__r.LocationCode__c from Zones__c where Location__r.LocationCode__c =:(string)LocationMap.get('CallejeroLocationID') and Name like : '%'+ZoneName+'%'limit 1];
                        
                        if( Zone.size()>0)
                        {
                            ZoneMap.put('ZoneId',Zone[0].id);
                            ZoneMap.put('CallejeroZoneID',Zone[0].ZoneID__c); 
                            ZoneMap.put('IsValid','true'); 
                        }
                        
                    }
                }
            }
        }
        AddressDetails.put('Range',rangeMap); 
        AddressDetails.put('Street',StreetMap);
        AddressDetails.put('Zone',ZoneMap);
        AddressDetails.put('Location',LocationMap);
        
        //Returning the valid/invalid,callejeroId,Name,recordId of Location,street,range and zone
        outMap.put('AddressInformation',AddressDetails);
    }
    
    
    
    
    
}