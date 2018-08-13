global with sharing class ChangesValidation implements vlocity_cmt.VlocityOpenInterface
{
    global ChangesValidation() {}
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {

        Boolean result = true;
        try
        {
        
            if (methodName.equals('GetAccountHistory'))
            {
                 
                GetAccountHistory(input, outMap, options);
            }
            if (methodName.equals('CompareChangesDNI'))
            {
                 
                CompareChangesDNI(input, outMap, options);
            }
            if (methodName.equals('CountDataChanges'))
            {
                 
                CountDataChanges(input, outMap, options);
            }
            if (methodName.equals('CreateOrUpdateCase'))
            {
                 
                CreateOrUpdateCase(input, outMap, options);
            }
            if (methodName.equals('PhoneValidation'))
            {
                 
                PhoneValidation(input, outMap, options);
            }
            
            result = false; 
          
        } 
        catch(Exception e)
        {
            System.debug('ChangesValidation:invokeMethod -> exception: '+e);
            result = false;
        }
        return result; 
    }

    boolean GetAccountHistory(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
   {
        System.debug('Comienzo del GetAccountHistory');
        String contactIdInput = (String) inputMap.get('ContactId');


        List<Contact> contactDate = [SELECT ActivationDate__c FROM Contact WHERE Id = :contactIdInput LIMIT 1];
        Date activatedContactDate = null;
        if (contactDate != null) {
            System.debug('contactDate: ' + contactDate);
            activatedContactDate = (Date) contactDate[0].ActivationDate__c;
            System.debug('activatedContactDate: ' + activatedContactDate);
        }

        List<ContactHistory> invoiceList =  new List<ContactHistory>();
        invoiceList = [SELECT CreatedDate,NewValue FROM ContactHistory WHERE ContactId = :contactIdInput AND CreatedDate > :activatedContactDate AND Field = 'DocumentNumber__c'];
        System.debug('query: ' + invoiceList);
        System.debug('query size: ' + invoiceList.size());
        Boolean changeAllowed = false;
        Boolean flagMonth = false;
        Date actualDate = date.today();
        Date actualDateLessMonth = actualDate.addMonths(-1);
        System.debug('actualDate: ' + actualDate);
        System.debug('actualDateLessMonth: ' + actualDateLessMonth);

        for(integer i = 0; i < invoiceList.size(); i++)
        {
            System.debug('for ' + i);
            Datetime createdDateQuery = (Datetime) invoiceList[i].CreatedDate;
            System.debug('createdDateQuery: ' + createdDateQuery);
            //flag para saber si ya hubo un cambio este mes
            if(createdDateQuery > actualDateLessMonth)
            {
                flagMonth = true;
            }
        }
        System.debug('flagMonth: ' + flagMonth);
       
         if(flagMonth != true) //(flagMonth != true) SE MODIFICA PARA PROBAR
        {
            System.debug('In primero if');
            If(invoiceList.size() >= 1 )
            {   
                System.debug('In segundo if');
                if(invoiceList.size() == 1 )
                {
                    //Se realizó una sola modificación previa
                    changeAllowed = true;
                    System.debug('changeAllowed1: ' + changeAllowed);
                    
                }

            }else{
                //No hubo ningun cambio de dni previo
                changeAllowed = true;
                System.debug('changeAllowed4: ' + changeAllowed);
            }
        }//else Ya se hizo una modificación este mes

        if (flagMonth) {
            outMap.put('errorMessage', 'Se realizó un cambio de DNI en el último mes. No se permite una nueva modificación.');
        }
        else if (!changeAllowed) {
            outMap.put('errorMessage', 'Se realizaron más de dos cambios de DNI desde la fecha de activación. No se permite una nueva modificación.');
        }
        else {
             outMap.put('errorMessage', '');
        }

        outMap.put('validationDNI', changeAllowed);//changeAllowed);
        System.debug('changeAllowed final: ' + changeAllowed);
        return changeAllowed;

    }  

    boolean CompareChangesDNI(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        String contactIdInput = (String) inputMap.get('ContactId');
        List<Contact> dniContact = [SELECT DocumentNumber__c FROM Contact WHERE Id = :contactIdInput  LIMIT 1];

        Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');

        String oldDNI = dniContact[0].DocumentNumber__c;
        String newDNI = (String) clientInformation.get('DocumentNumber');

        Integer limitDifs = 2;
        boolean equal = true;
        Integer countDif = 0;

        if(oldDNI == newDNI){
            equal = true;
        }
        else
        {
            String longestDni;
            String shortestDni;
            
            if(oldDNI.length() >= newDNI.length()){
                longestDni = oldDNI;
                shortestDni = newDNI;
            } else{
                longestDni = newDNI;
                shortestDni = oldDNI;
            }
            
            for(Integer x = 0; x < longestDni.length(); x++){
                if((longestDNI.length() - shortestDNI.length()) > limitDifs){
                    equal = false;
                    break;
                } else if(shortestDNI.length() > x){
                    if(longestDNI.substring(x,x+1) != shortestDNI.substring(x,x+1))
                    {
                        countDif++;
                        
                        if(countDif > limitDifs){
                            equal = false;
                            break;
                        }
                    }
                }
                else
                {
                    countDif++;
                    
                    if(countDif > limitDifs){
                        equal = false;
                        break;
                    }
                }
            }
            
            System.debug('Diferencias: ' + countDif);
            System.debug('Son iguales? ' + equal);
        }
        
        outMap.put('validationDigits', equal);

        return equal;
    }

    integer CountDataChanges(Map<String, Object> inputMap,
        Map<String, Object> outMap, Map<String, Object> options)
    {
        System.debug('Comienzo del metodo CountDataChanges');
        String contactIdInput = (String) inputMap.get('ContactId');
        System.debug('contactIdInput: ' + contactIdInput);
        List<Contact> contactToModify = [SELECT Email,Birthdate,DocumentNumber__c,Gender__c FROM Contact WHERE Id  = :contactIdInput];


        /*Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        Map<String, Object> basicInformation = (Map<String, Object>) clientInformation.get('BasicInformation');
        String newDNI = (String)basicInformation.get('DocumentNumber');
        System.debug('newDNI: ' + newDNI);
        String newGender = (String)basicInformation.get('Gender');
        System.debug('newGender: ' + newGender);
        String newBirthdateString = (String)basicInformation.get('Birthdate');
        System.debug('newBirthda<teString: ' + newBirthdateString);
        Date newBirthdate = Date.parse(newBirthdateString);
        System.debug('newBirthdate: ' + newBirthdate);
        integer countDataChanges = 0;*/

        Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        //Map<String, Object> basicInformation = (Map<String, Object>) clientInformation.get('BasicInformation');
        String newDNI = (String)clientInformation.get('DocumentNumber');
        System.debug('newDNI: ' + newDNI);
        String newGender = (String)clientInformation.get('Gender');
        System.debug('newGender: ' + newGender);
        //String newBirthdateString = (String)clientInformation.get('Birthdate');
        //System.debug('newBirthda<teString: ' + newBirthdateString);
        //Date newBirthdate = Date.parse(newBirthdateString); 
        Date newBirthdate = Date.ValueOf(clientInformation.get('BirthdateString'));
        System.debug('newBirthdate: ' + newBirthdate);
        integer countDataChanges = 0;
        String newEmail = (String)clientInformation.get('Email');

        for(Contact c : contactToModify)
        {
            System.debug('IN FOR');
            if(c.Birthdate != newBirthdate)
            {
                countDataChanges++;
                System.debug('c.Birthdate: ' + c.Birthdate);
            }
            if(c.DocumentNumber__c != newDNI)
            {
                countDataChanges++;
                System.debug('c.DocumentNumber__c: ' + c.DocumentNumber__c);
                
            }
            if(c.Gender__c != newGender)
            {
                countDataChanges++;
                System.debug('c.Gender__c: ' + c.Gender__c);
                
            }
        }
        outMap.put('validationDataChanges', countDataChanges);
        
        System.debug('countDataChanges: ' + countDataChanges);
        return countDataChanges;
        //query que trae los datos actuales del cliente
        //for que compara los datos a modificar contra los actuales del cliente
        //dentro del for un count de los datos cambiados
        //Se devuelve la cantidad de datos modificados
    }

    public void CreateOrUpdateCase(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        String caseStatus;
        Case caseObject;
        String caseId = (String) inputMap.get('CaseId');
        Boolean digitChanges = (Boolean) inputMap.get('DigitChanges');
        Integer countChanges = (Integer) inputMap.get('CountChanges');
        String accountId = (String) inputMap.get('ContextId');
        String contactIdInput = (String) inputMap.get('ContactId');

        Boolean isNewCase = false;
        
        /*if (digitChanges && countChanges < 3) {

            caseStatus = 'Closed';
        }
        else {
            isNewCase = true;
            caseStatus = 'New';
        }
        --------- previous
        Boolean isNewCase = true;
        caseStatus = 'New';*/
        if (!digitChanges || countChanges > 2) {

            caseStatus = 'Closed';
        }
        else {
            isNewCase = true;
            caseStatus = 'New';
        }
        System.debug('digitChanges: ' + digitChanges);
        System.debug('countChanges: ' + countChanges);
        System.debug('caseStatus: ' + caseStatus);
        System.debug('accountId: ' + accountId);
        System.debug('caseId: ' + caseId);

        if (caseId == null) {
            caseObject = new Case();
            caseObject.Subject = 'Actualización de Datos';
            caseObject.AccountId = accountId;

            if(!isNewCase)
                caseObject.Status = caseStatus;

            insert caseObject;

            caseObject = [SELECT Id,
                                 CaseNumber
                            FROM Case
                           WHERE Id = :caseObject.Id];
            
            AddTasksToCase(caseObject, digitChanges, countChanges);
        }
        else {
            caseObject = [SELECT Id,
                                 CaseNumber
                            FROM Case
                           WHERE Id = :caseId];
            
            if(!isNewCase)
                caseObject.Status = caseStatus;

            AddTasksToCase(caseObject, digitChanges, countChanges);

            update caseObject;
        }

        outMap.put('CaseId', caseObject.Id);
        outMap.put('CaseNumber', caseObject.CaseNumber);
    }

    private void AddTasksToCase(Case caseObject, Boolean digitChanges, Integer countChanges) {
        List<Task> taskList = new List<Task>();

        if (!digitChanges) {
            Task taskObject = new Task();

            taskObject.Subject = 'Error - Supera cantidad de digitos modificados para el Número de documento';
            taskObject.Status = 'Completed';
            taskObject.WhatId = caseObject.Id;

            taskList.Add(taskObject);
        }

        if (countChanges > 2) { //(countChanges > 3)
            Task taskObject = new Task();

            taskObject.Subject = 'Error - Supera cantidad de campos habilitados para modificación';
            taskObject.Status = 'Completed';
            taskObject.WhatId = caseObject.Id;

            taskList.Add(taskObject);
        }

        if (taskList.size() > 0)
            insert taskList;
    }

    public void PhoneValidation (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        //System.debug('Comienzo del metodo PhoneValidation');
        Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        String mobilePhone = (String)clientInformation.get('MobilePhone');
        //System.debug('mobilePhone: ' + mobilePhone);
        /*String phone = (String)clientInformation.get('Phone');
        System.debug('Phone: ' + phone);*/
        String otherPhone = (String)clientInformation.get('OtherPhone');
        //System.debug('otherPhone: ' + otherPhone);

        If(!String.isEmpty(mobilePhone))
        {
            mobilePhone = getValidatedPhone(mobilePhone);
            System.debug('mobilePhone != Empty: ' + mobilePhone);
        }
        /*If(!String.isEmpty(phone))
        {
            phone = getValidatedPhone(phone);
            System.debug('phone != Empty: ' + phone);
        }*/
        If(!String.isEmpty(otherPhone))
        {
            otherPhone = getValidatedPhone(otherPhone);
            System.debug('otherPhone != Empty: ' + otherPhone);
        }
        /*System.debug('mobilePhone final' + mobilePhone);
        System.debug('phone final' + phone);
        System.debug('otherPhone final ' + otherPhone);*/
        outMap.put('ValidmobilePhone', mobilePhone);
        //outMap.put('Validphone', phone);
        outMap.put('ValidotherPhone', otherPhone);
    }

    private String getValidatedPhone(String phoneNumber)
    {
        
        String validPhoneNumber = 'Error';

        Integer digitCount = phoneNumber.length();

        if(phoneNumber.substring(0, 4) == '+549')
        {
            phoneNumber = phoneNumber.substring(4, digitCount);
            digitCount = phoneNumber.length();
        }
        if (phoneNumber.substring(0, 3) == '+54') {
            phoneNumber = phoneNumber.substring(3, digitCount);
            digitCount = phoneNumber.length();
        }
        if (phoneNumber.substring(0, 3) == '549') {
            phoneNumber = phoneNumber.substring(3, digitCount);
            digitCount = phoneNumber.length();
        }
        if (phoneNumber.substring(0, 2) == '54') {
            phoneNumber = phoneNumber.substring(2, digitCount);
            digitCount = phoneNumber.length();
        }
        if (phoneNumber.substring(0, 1) == '0') {
            phoneNumber = phoneNumber.substring(1, digitCount);
            digitCount = phoneNumber.length();
        }

        if (digitCount == 10) {
            validPhoneNumber = phoneNumber;
        }
        else if (digitCount > 10)
        {
            if (phoneNumber.substring(digitCount - 10, digitCount - 8) == '15') {
                validPhoneNumber = phoneNumber.substring(0, digitCount - 10) + phoneNumber.substring(digitCount - 8, digitCount);
            }
            else if (phoneNumber.substring(digitCount - 9, digitCount - 7) == '15') {
                validPhoneNumber = phoneNumber.substring(0, digitCount - 9) + phoneNumber.substring(digitCount - 7, digitCount);
            }
            else if (phoneNumber.substring(digitCount - 8, digitCount - 6) == '15') {
                validPhoneNumber = phoneNumber.substring(0, digitCount - 8) + phoneNumber.substring(digitCount - 6, digitCount);
            }
        }

        if(validPhoneNumber.length() > 10)
        {
            validPhoneNumber = 'Error';
        }

        return validPhoneNumber;
    }
}