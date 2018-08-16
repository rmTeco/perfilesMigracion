global with sharing class DummyDataBase implements vlocity_cmt.VlocityOpenInterface
{
    global DummyDataBase() {}
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('GetClientsGrid'))
            {
                GetClientsGrid(outMap);
            }
            
            if (methodName.equals('GetClientInfo'))
            {
                GetClientInfo(outMap);
            }

            if (methodName.equals('getDocumentType')){
                GetDocumentType(options, outMap);
            }

            return result;
        } 
        catch(Exception e)
        {
            System.debug('DummyDataBase:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    void GetClientsGrid(Map<String, Object> outMap)
   {
         List<Map<String, Object>>  returnList = new List<Map<String,Object>>();

         List<Map<String, Object>>  clientesActivos = new List<Map<String,Object>>();
      
               Map<String, Object> tempMap = new Map<String, Object>();
               tempMap.put('Name', 'Juan Perez');
               tempMap.put('Apellido', 'Perez');
               tempMap.put('Documento', '34456678');
               tempMap.put('Linea', '9999999999999');
               tempMap.put('Mail', 'sandra.ramos@gmail.com');
               tempMap.put('Cuenta', '00000000001');                                            
               tempMap.put('Permiso', 'default');        
                tempMap.put('Nominado', 'Si');    
               clientesActivos.add(tempMap);

               tempMap = new Map<String, Object>();
               tempMap.put('Name', 'Pedro Aznar');
               tempMap.put('Apellido', 'Aznar');
               tempMap.put('Documento', '34456345');
               tempMap.put('Linea', '9999888999999');
               tempMap.put('Mail', 'sandra.ramos@gmail.com');
               tempMap.put('Cuenta', '00000000001');                                            
               tempMap.put('Permiso', 'default');        
                tempMap.put('Nominado', 'Si');    
               clientesActivos.add(tempMap);

        List<Map<String, Object>>  clientesInActivos = new List<Map<String,Object>>();
               
               tempMap = new Map<String, Object>();
               tempMap.put('Name', 'Juana Molina');
               tempMap.put('Apellido', 'Molina');
               tempMap.put('Documento', '32345123');
               tempMap.put('Linea', '888888888888');
               tempMap.put('Mail', 'asdf.asdf@gmail.com');
               tempMap.put('Cuenta', '00000000002');                                            
               tempMap.put('Permiso', 'default');        
                tempMap.put('Nominado', 'No');    
               clientesInActivos.add(tempMap);

           tempMap = new Map<String, Object>();
           tempMap.put('clientesActivos', clientesActivos);
           tempMap.put('clientesInActivos', clientesInActivos);
           returnList.add(tempMap);
           outMap.put('options', returnList);
           System.debug('These are my Cases' + returnList);
    }  

    public void GetDocumentType(Map<String, Object> options, Map<String, Object> outMap)
    {
        Map<String, Object> contact = (Map<String, Object>) options.get('Contact');

        System.debug('contact: ' + contact);

        List<Object> accounts = (List<Object>) contact.get('Accounts');

        System.debug('accounts: ' + accounts);

        Integer countAccounts = accounts.size();

        System.debug('countAccounts: ' + countAccounts);

        Integer countCUIT2X = 0;
        Integer countCUIT3X = 0;
        Integer countDNI = 0;

        for(Object account : accounts)
        {
            Map<String, Object> acc = (Map<String, Object>) account;

            String docType = (String) acc.get('DocumentType');

            if(docType == 'CUIT')
            {
                String docNumber = (String) acc.get('DocumentNumber');
                String startNum = docNumber.substring(0,1);

                if( startNum == '2')
                {
                    countCUIT2X++;
                }
                else if(startNum == '3')
                {
                    countCUIT3X++;
                }
            }
            if(docType == 'DNI')
            {
                countDNI++;
            }
        }

        String documentType = 'x';

        if(countCUIT2X == countAccounts)
            documentType = 'CUIT2X';
        else if(countCUIT3X == countAccounts)
            documentType = 'CUIT3X';
        else if(countDNI == countAccounts)
            documentType = 'DNI';
        else if(countDNI > 0 && countCUIT2X > 0 && countCUIT3X == 0)
            documentType = 'All';

        outMap.put('options', documentType);
    }

void GetClientInfo(Map<String, Object> outMap)
   {
         List<Map<String, Object>>  returnList = new List<Map<String,Object>>();
      
               Map<String, Object> tempMap = new Map<String, Object>();
               tempMap.put('Nombre', 'Sandra');
               tempMap.put('Apellido', 'Ramos');
               tempMap.put('TipoDocumento', 'DNI');
               tempMap.put('Documento', '9399939');
               tempMap.put('Cuil', '9939992');
               tempMap.put('FechaNacimiento','01/05/2017');
               tempMap.put('Genero', 'Femenino');
               tempMap.put('Email', 'sandra.ramos@gmail.com');
               tempMap.put('Movil', '9999999999999');                                            
               tempMap.put('TelAlternativo', '19999999999');                                            
               returnList.add(tempMap);

           outMap.put('options', returnList);
           System.debug('These are my Cases' + returnList);
    }  

}