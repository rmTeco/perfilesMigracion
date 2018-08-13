global with sharing class IFS_S470_NominateProcess implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('nominateProcessIntegration')){
                nominateProcessIntegration(inputMap, outMap, options);
            }
            
            result = false;  
        } 
        catch(Exception e)
        {
            System.debug('taSalesSimulationInvoiceHandler:invokeMethod -> exception: '+e+e.getStackTraceString());
            throw e; 
            //result = false;
        }
        return result;
    }
    
    global static void nominateProcessIntegration(map<String,Object> input, map<String,Object> output, map<String,Object> options){
        map<String,Object> contact = new map<String,Object>();
        map<String,Object> accountData = new map<String,Object>();
        map<String,Object> assetInfo = new map<String,Object>();
        map<String,Object> data = new map<String,Object>();
        map<String,Object> aux = new map<String,Object>();
        nominateProcessJSON nominate = new nominateProcessJSON();
        paramsJSON params = new paramsJSON();
        bodyJSON body = new bodyJSON();
        cuilJSON cuil = new cuilJSON();
        //direccionJSON direccion = new direccionJSON();
        contact=(map<String,Object>)input.get('Contact');
        accountData=(map<String,Object>)input.get('AccountData');
        assetInfo=(map<String,Object>)input.get('AssetInfo');
        system.debug('El Input: ' + JSON.serialize(input));
        system.debug('El Options: ' + JSON.serialize(options));
        //params.nroLinea=(String)assetInfo.get('LineNumber');
        params.nroLinea=(String)assetInfo.get('MSISDN');
        body.fechaNominacionLinea=Datetime.now() + '';
        //body.nroLinea=(String)assetInfo.get('LineNumber');
        body.nroLinea=(String)assetInfo.get('MSISDN');
        body.tipoDocumento=(String)contact.get('DocumentType');
        body.numeroDocumento=(String)contact.get('DocumentNumber');
        body.nombre=(String)contact.get('FirstName');
        body.apellido=(String)contact.get('LastName');
        String auxGender=(String)contact.get('Gender');
        if(auxGender=='Masculino'){
            auxGender='M';
        }else{
            if(auxGender=='Femenino'){
                auxGender='F';
            }else{
                auxGender='U';
            }
        }
        body.genero=auxGender;
        String idContacto;
        if(contact.containsKey('Id') && !(String.isEmpty((String)contact.get('Id')))){
            idContacto = (String)contact.get('Id');
        }
        else{
            idContacto = (String)accountData.get('PrimaryContactId');
        }
        // List<Contact> auxContactoLista = new List<Contact>();
        Contact auxContacto = [SELECT id,Birthdate FROM Contact WHERE id =: idContacto limit 1];
        // Contact auxContacto = new Contact();
        // auxContacto=auxContactoLista[0];

        // Parsing Birthdate value to 'YYYY-MM-DD'
        String stringDate = String.valueOf(auxContacto.Birthdate.year()) + '-' + String.valueOf(auxContacto.Birthdate.month()).leftPad(2, '0') + '-' + String.valueOf(auxContacto.Birthdate.day()).leftPad(2, '0');
        
        body.fechaNacimiento = stringDate;
        //cuil.numeroDocumento=(String)contact.get('DocumentNumber');
        cuil.numeroDocumento=body.numeroDocumento;
        system.debug(cuil);
        system.debug('Llega a la línea 68');
        body.cuil=cuil;
        /* -------------------DECIDED BY POs THAT THIS INTEGRATION WOULDN'T SEND ADDRESS INFO-----------------------
        //direccion.marcaExistenciaPadron;
        auxStreet=(map<String,Object>)accountData.get('LegalStreetTypeAhead-Block');
        String auxString=(String)auxStreet.get('NewStreetName');
        if(auxString==null){
        direccion.calle=(String)auxStreet.get('LegalStreetTypeAhead');
        }else{
        direccion.calle=(String)auxStreet.get('NewStreetName');
        }
        direccion.altura=(String)accountData.get('StreetNumber');
        direccion.piso=(String)accountData.get('FloorNumber');
        direccion.departamento=(String)accountData.get('Department');
        //direccion.descripcionLocalidad;
        direccion.codigoPostal=(String)accountData.get('LegalAddressPostalCodeFormula');
        //direccion.descripcionProvincia;
        //direccion.codPais;
        direccion.tipoDireccion='L';
        //direccion.marcaDireccionVerificada;
        body.direccion=direccion;*/
        if(input.containsKey('data')){
            data=(map<String,Object>)input.get('data');
            if(data.containsKey('listaPreguntas')){
                body.ticket=(String)data.get('ticket');}
            if(data.containsKey('listaPreguntas')){
                list<Object> auxRespuesta = new list<Object>();
                auxRespuesta=(list<Object>)data.get('listaPreguntas');
                for(Object id:auxRespuesta){
                    Map<string,object> respuesta =(Map<string,object>)id; 
                    preguntaJSON preg = new preguntaJSON();
                    preg.codConsulta=(String)respuesta.get('codConsulta');
                    preg.consulta=(String)respuesta.get('consulta');
                    preg.codRespuesta=(String)respuesta.get('codRespuestaFinal');
                    list<Object> listaRTA= new list<Object>();
                    listaRTA=(list<Object>)respuesta.get('listaRespuestas');
                    for(Object idInterno : listaRTA){    
                        Map<string,object> auxiliarInterno =(Map<string,object>)idInterno;  
                        if((String)auxiliarInterno.get('codRespuesta')==preg.codRespuesta){
                            String respuestaCorrecta = (String)auxiliarInterno.get('respuesta');
                            preg.respuesta=respuestaCorrecta;
                        }
                    }
                    system.debug('Llega a la línea 111, hay pregunta');
                    body.listadoPreguntasYRtas.add(preg);                
                }            
            }}else{
                body.ticket='0';
                preguntaJSON preg = new preguntaJSON();
                preg.codConsulta='0';
                preg.consulta='Validacion de identidad por canales Presenciales';
                preg.codRespuesta='0';
                preg.respuesta='No Aplica';
                body.listadoPreguntasYRtas.add(preg);      
                system.debug('Llega a la línea 121, no hay pregunta');
            }
        String bodySend = JSON.serialize(body);
        String paramSend = JSON.serialize(params);
        Map<String, Object> paramsNode = (Map<String, Object>) JSON.deserializeUntyped(paramSend);
        Map<String, Object> bodyNode = (Map<String, Object>) JSON.deserializeUntyped(bodySend);
        Map<String, Object> inMap = new Map<String, Object>();
        inMap.put('params',paramsNode);
        inMap.put('body',bodyNode);
        system.debug('Llega todo el proceso antes de enviar el llamado');
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        system.debug('Este es el inMap');
        system.debug(JSON.serialize(inMap));
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        if(test.isRunningTest()){
            IFS_S470_NominateProcess_Test metodoTest = new IFS_S470_NominateProcess_Test();
            outMap= metodoTest.generarRespuesta();
        }else{   
            integProcService.invokeMethod('IFS_S470', inMap, outMap, options2);}
        system.debug('outMap');
        system.debug(outMap);
        Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
        
        output.put('IPResult', response);
    }
    
    public class nominateProcessJSON {
        public paramsJSON params {get;set;}
        public bodyJSON body {get;set;}
    }
    
    public class paramsJSON{
        public String nroLinea {get;set;}
    }
    
    public class bodyJSON{
        public String fechaNominacionLinea {get;set;}
        public String nroLinea {get;set;}
        public String tipoDocumento {get;set;}
        public String numeroDocumento {get;set;}
        public String nombre {get;set;}
        public String apellido {get;set;}
        public String genero {get;set;}
        public String fechaNacimiento {get;set;}
        public cuilJSON cuil {get;set;}
        //public direccionJSON direccion {get;set;}
        public String ticket {get;set;}
        public List<preguntaJSON> listadoPreguntasYRtas {get;set;}
        
        public bodyJSON(){
            listadoPreguntasYRtas = new List<preguntaJSON>();
        }
    }
    
    public class cuilJSON{
        public String numeroDocumento {get;set;}
    }
    
    /*
public class direccionJSON{
public String marcaExistenciaPadron {get;set;}
public String calle {get;set;}
public String altura {get;set;}
public String piso {get;set;}
public String departamento {get;set;}
public String descripcionLocalidad {get;set;}
public String codigoPostal {get;set;}
public String descripcionProvincia {get;set;}
public String codPais {get;set;}
public String tipoDireccion {get;set;}
public String marcaDireccionVerificada {get;set;}                
}
*/
    
    public class preguntaJSON{
        public String codConsulta{get;set;}
        public String consulta{get;set;}
        public String codRespuesta{get;set;}
        public String respuesta{get;set;}
    }
    
}