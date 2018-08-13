public class IFS_S271_prefeseabilty {

    public static Map<String, Object> prefeseabilty(String family, String op, Map<String,Object> dom, Map<String,Object> coor, Map<String,Object> services){
        //familia  operacion  domicilio  coordenadas  servicios
        prefeseabiltyJSON jsonParse = new prefeseabiltyJSON();
        coordenadasJSON coordinates = new coordenadasJSON();
        coordinates.latitud=(String)coor.get('latitud');
        coordinates.longitud=(String)coor.get('longitud');
        jsonParse.familia=family;
        jsonParse.operacion=op;
        jsonParse.coordenadas=coordinates;
        domicilioJSON domicilioJ = new domicilioJSON();
        domicilioJ.localizacion= (String)dom.get('localizacion');
        domicilioJ.altura= (String)dom.get('altura');
        domicilioJ.lote= (String)dom.get('lote');
        domicilioJ.torre= (String)dom.get('torre');
        domicilioJ.piso= (String)dom.get('piso');
        domicilioJ.departamento= (String)dom.get('departamento');
        domicilioJ.edificio= (String)dom.get('edificio');
        domicilioJ.Manzana= (String)dom.get('Manzana');
        domicilioJ.Zona= (String)dom.get('Zona');
        domicilioJ.sector= (String)dom.get('sector');
        domicilioJ.entreCalle1= (String)dom.get('entreCalle1');
        domicilioJ.entreCalle2= (String)dom.get('entreCalle2');
        domicilioJ.calleAtras= (String)dom.get('calleAtras');
        domicilioJ.tipoDomicilio= (String)dom.get('tipoDomicilio');
		jsonParse.domicilio=domicilioJ;
        for(String clave : services.keySet()){
            servicioTypeJSON servicio= new servicioTypeJSON();
            Map<String,Object> aux = new Map<String,Object>();
            aux = (Map<String,Object>) services.get(clave);
            servicio.idServicio= (String)aux.get('idServicio');
            servicio.ebos= (String)aux.get('ebos');
            servicio.tipo= (String)aux.get('tipo');
            servicio.tecnologia= (String)aux.get('tecnologia');
            jsonParse.servicios.add(servicio);
        }

        String body = JSON.serialize(jsonParse);
        
        system.debug(body);
        
        HttpResponse respuesta = makePostCallout(body);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(respuesta.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(respuesta.getStatusCode())));        
        return responseNode; 
        
    }
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s271' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        system.debug(request.getBody());
        HttpResponse response = http.send(request);
        system.debug(response);

        return response;
        
    }
    
	public class prefeseabiltyJSON{
        public String familia {get;set;}
        public String operacion {get;set;}
        public domicilioJSON domicilio {get;set;}
        public coordenadasJSON coordenadas {get;set;}
        public List<servicioTypeJSON> servicios {get;set;}
        
        public prefeseabiltyJSON(){
            servicios = new List<servicioTypeJSON>();
        }
    }
    public class coordenadasJSON{
        public String latitud {get;set;}
        public String longitud {get;set;}
    }
    
    public class domicilioJSON{
        public String localizacion {get;set;}
        public String altura {get;set;}
        public String lote {get;set;}
        public String torre {get;set;}
        public String piso {get;set;}
        public String departamento {get;set;}
        public String edificio {get;set;}
        public String Manzana {get;set;}
        public String Zona {get;set;}
        public String sector {get;set;}
        public String entreCalle1 {get;set;}
        public String entreCalle2 {get;set;}
        public String calleAtras {get;set;}
        public String tipoDomicilio {get;set;}
    }
    public class servicioTypeJSON{
        public String idServicio {get;set;}
        public String ebos {get;set;}
        public String tipo {get;set;}
        public String tecnologia {get;set;}
    }

}