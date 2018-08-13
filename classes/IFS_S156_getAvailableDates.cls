public class IFS_S156_getAvailableDates {
    
    public static Map<String, Object> getAvailableDates(String catCentral, String catCliente, String catTerminal, String codLocalidad, String codProvincia, Date fechaFinReserva, Date fechaInicioReserva, Date fechaMensaje, String gr, String idServ, String macroTar, String ebo, String nat, String lvl0, String lvl1, String lvl2, String orig, String servRed, String tec, String topol, String reservedUser, Map<String,Object> facilidadRed, Map<String,Object> tareas){
        getAvailableDatesJSON jsonParse = new getAvailableDatesJSON();
        if(catCentral!=null){
            jsonParse.CategoriaCentral=catCentral;}
        jsonParse.CategoriaCliente=catCliente;
        if(catTerminal!=null){
            jsonParse.CategoriaTerminal=catTerminal;}
        jsonParse.CodigoLocalidad=codLocalidad;
        jsonParse.CodigoProvincia=codProvincia;
        jsonParse.FechaHoraFinReserva=String.valueOf(fechaFinReserva);
        jsonParse.FechaHoraInicioReserva=String.valueOf(fechaInicioReserva);
        if(fechaMensaje!=null){
            jsonParse.FechaHoraMensaje=String.valueOf(fechaMensaje);}
        jsonParse.Grupo=gr;
        jsonParse.IdServInstDesinst=idServ;
        jsonParse.MacroTarea=macroTar;
        if(ebo!=null){
            jsonParse.Ebos=ebo;}
        if(nat!=null){
            jsonParse.Naturaleza=nat;}
        if(lvl0!=null){
            jsonParse.Nivel0Red=lvl0;}
        if(lvl1!=null){
            jsonParse.Nivel1Red=lvl1;}
        if(lvl2!=null){
            jsonParse.Nivel2Red=lvl2;}
        jsonParse.Origen=orig;
        jsonParse.ServicioRed=servRed;
        jsonParse.Tecnologia=tec;
        jsonParse.UsuarioReservado=reservedUser;
        if(topol!=null){
            jsonParse.Topologia=topol;}
        if(tareas!=null){
            for(String clave : tareas.keySet()){
                Map<String,Object> aux = new Map<String,Object>();
                aux=(Map<String,Object>)tareas.get(clave);
                macroTareaBasePreviaJSON tarea = new macroTareaBasePreviaJSON();
                tarea.CodigoMacroTareaBasePrevia=(String)aux.get('CodigoMacroTareaBasePrevia');
                jsonParse.MacroTareasBasePrevias.add(tarea);
            }}
        
        ///////////////////////////Facilidades Red desde aca//////////////
        if(facilidadRed!=null){
        facilidadesRedJSON facilidad = new facilidadesRedJSON();
        if(facilidadRed.get('CategoriaCentral')!=null){
            facilidad.CategoriaCentral=(String)facilidadRed.get('CategoriaCentral');}
        if(facilidadRed.get('CategoriaTerminal')!=null){
            facilidad.CategoriaTerminal=(String)facilidadRed.get('CategoriaTerminal');}
        if(facilidadRed.get('Latitud')!=null){
            facilidad.Latitud=(String)facilidadRed.get('Latitud');}
        if(facilidadRed.get('Longitud')!=null){
            facilidad.Longitud=(String)facilidadRed.get('Longitud');}
        
        Map<String,Object> equiposAux = new Map<String,Object>();
        if(facilidadRed.get('Equipos')!=null){
        equiposAux=(Map<String,Object>)facilidadRed.get('Equipos');
        for(String key : equiposAux.keySet()){
            Map<String,Object> aux = new Map<String,Object>();
            Map<String,Object> auxDatos = new Map<String,Object>();
            Map<String,Object> auxDomicilio = new Map<String,Object>();
            aux=(Map<String,Object>)equiposAux.get(key);
            equiposJSON team = new equiposJSON();
            ////////////////////////////Datos Equipo aqui////////////////////
            if(equiposAux.get('DatosEquipo')!=null){
                auxDatos=(Map<String,Object>)equiposAux.get('DatosEquipo');
                datosEquipoJSON datos = new datosEquipoJSON();
                if(auxDatos.get('CantidadVacantesElementoRed')!=null){
                    datos.CantidadVacantesElementoRed=(Integer)auxDatos.get('CantidadVacantesElementoRed');}
                if(auxDatos.get('CategoriaEquipoElementoRed')!=null){
                    datos.CategoriaEquipoElementoRed=(String)auxDatos.get('CategoriaEquipoElementoRed');}
                if(auxDatos.get('CentralElementoRed')!=null){
                    datos.CentralElementoRed=(String)auxDatos.get('CentralElementoRed');}
                if(auxDatos.get('ComentarioElementoRed')!=null){
                    datos.ComentarioElementoRed=(String)auxDatos.get('ComentarioElementoRed');}
                if(auxDatos.get('EquipoAbajoElementoRed')!=null){
                    datos.EquipoAbajoElementoRed=(String)auxDatos.get('EquipoAbajoElementoRed');}
                if(auxDatos.get('ZonaElementoRed')!=null){
                    datos.ZonaElementoRed=(String)auxDatos.get('ZonaElementoRed');}
                team.DatosEquipo=datos;}
            ////////////////////////////////Domicilio aca/////////////////
            if(equiposAux.get('Domicilio')!=null){
                auxDomicilio=(Map<String,Object>)equiposAux.get('Domicilio');
                domicilioJSON dom = new domicilioJSON();
                if(auxDomicilio.get('AlturaElementoRed')!=null){
                    dom.AlturaElementoRed=(String)auxDatos.get('AlturaElementoRed');}
                if(auxDomicilio.get('ManzanaElementoRed')!=null){
                    dom.ManzanaElementoRed=(String)auxDatos.get('ManzanaElementoRed');}
                if(auxDomicilio.get('NombreCalleElementoRed')!=null){
                    dom.NombreCalleElementoRed=(String)auxDatos.get('NombreCalleElementoRed');}
                if(auxDomicilio.get('NombreEdificioElementoRed')!=null){
                    dom.NombreEdificioElementoRed=(String)auxDatos.get('NombreEdificioElementoRed');}
                team.Domicilio=dom;}
            if(aux.get('Id')!=null){
                team.Id=(Integer)aux.get('Id');}
            if(aux.get('Nivel')!=null){
                team.Nivel=(Integer)aux.get('Nivel');}
            if(aux.get('Tipo')!=null){
                team.Tipo=(String)aux.get('Tipo');}
            team.Atendido=(String)aux.get('Atendido');
            facilidad.Equipos.add(team);
        }}
        //facilidad.Equipos=(String)facilidadRed.get('CategoriaCentral');
        if(facilidadRed.get('Naturaleza')!=null){
            facilidad.Naturaleza=(String)facilidadRed.get('Naturaleza');}
        if(facilidadRed.get('Nivel0Red')!=null){
            facilidad.Nivel0Red=(String)facilidadRed.get('Nivel0Red');}
        if(facilidadRed.get('Nivel1Red')!=null){
            facilidad.Nivel1Red=(String)facilidadRed.get('Nivel1Red');}
        if(facilidadRed.get('Nivel2Red')!=null){
            facilidad.Nivel2Red=(String)facilidadRed.get('Nivel2Red');}
        if(facilidadRed.get('ParqueDesconfiabilizado')!=null){
            facilidad.ParqueDesconfiabilizado=(String)facilidadRed.get('ParqueDesconfiabilizado');}
        //facilidad.Vinculos=(String)facilidadRed.get('ParqueDesconfiabilizado');
        
        //Aca se abre el mapa de Vinculos que tienen Vinculo individual con sus respectivos sub-campos
            if(facilidadRed.get('Vinculos')!=null){
                Map<String,Object> auxVin = new Map<String,Object>();
                auxVin=(Map<String,Object>)facilidadRed.get('Vinculos');
                for(String key : auxVin.keySet()){
                    vinculosJSON vinculosActual = new vinculosJSON();
                    arribaJSON arribaJ = new arribaJSON();
                    abajoJSON abajoJ = new abajoJSON();
                    vinculoJSON vinculoJ = new vinculoJSON();
                    Map<String,Object> vinculosInd = new Map<String,Object>();
                    Map<String,Object> abajoMap = new Map<String,Object>();
                    Map<String,Object> arribaMap = new Map<String,Object>();
                    Map<String,Object> vinculoInterior = new Map<String,Object>();
                    vinculosInd=(map<String,Object>)auxVin.get(key);
                    if(vinculosInd.get('PrecalificacionElementoRed')!=null){
                        vinculosActual.PrecalificacionElementoRed=(String)vinculosInd.get('PrecalificacionElementoRed');}
                    if(vinculosInd.get('DestinoElementoRed')!=null){
                        vinculosActual.DestinoElementoRed=(String)vinculosInd.get('DestinoElementoRed');}
                    if(vinculosInd.get('Vinculo')!=null){
                        vinculoInterior=(Map<String,Object>)vinculosInd.get('Vinculo');
                        //////////////////////////////abro "Abajo" ////////////////////////
                           if(vinculoInterior.get('Abajo')!=null){
                               abajoMap = (map<String,Object>) vinculoInterior.get('Abajo');
                               if(abajoMap.get('CableAbElementoRed')!=null){
                                   abajoJ.CableAbElementoRed=(String)abajoMap.get('CableAbElementoRed');
                               }
                               if(abajoMap.get('CentralAbElementoRed')!=null){
                                   abajoJ.CentralAbElementoRed=(String)abajoMap.get('CentralAbElementoRed');
                               }
                               if(abajoMap.get('EquipoAbElementoRed')!=null){
                                   abajoJ.EquipoAbElementoRed=(String)abajoMap.get('EquipoAbElementoRed');
                               }
                               if(abajoMap.get('ParAbElementoRed')!=null){
                                   abajoJ.ParAbElementoRed=(String)abajoMap.get('ParAbElementoRed');
                               }
                               if(abajoMap.get('ZonaAbElementoRed')!=null){
                                   abajoJ.ZonaAbElementoRed=(String)abajoMap.get('ZonaAbElementoRed');
                               }
                               vinculoJ.Abajo=abajoJ;
                           }
                                 //////////////////////////////abro "Arriba" ////////////////////////
                           if(vinculoInterior.get('Arriba')!=null){
                               arribaMap = (map<String,Object>) vinculoInterior.get('Arriba');
                               if(arribaMap.get('CentralArrElementoRed')!=null){
                                   arribaJ.CentralArrElementoRed=(String)arribaMap.get('CentralArrElementoRed');
                               }
                               if(arribaMap.get('CableArrElementoRed')!=null){
                                   arribaJ.CableArrElementoRed=(String)arribaMap.get('CableArrElementoRed');
                               }
                               if(arribaMap.get('EquipoArrElementoRed')!=null){
                                   arribaJ.EquipoArrElementoRed=(String)arribaMap.get('EquipoArrElementoRed');
                               }
                               if(arribaMap.get('ParArrElementoRed')!=null){
                                   arribaJ.ParArrElementoRed=(String)arribaMap.get('ParArrElementoRed');
                               }
                               if(arribaMap.get('ParSecundarioArrElementoRed')!=null){
                                   arribaJ.ParSecundarioArrElementoRed=(String)arribaMap.get('ParSecundarioArrElementoRed');
                               }
                               if(arribaMap.get('ZonaArrElementoRed')!=null){
                                   arribaJ.ZonaArrElementoRed=(String)arribaMap.get('ZonaArrElementoRed');
                               }                               
                               vinculoJ.Arriba=arribaJ;
                           }
                        
                        vinculosActual.Vinculo=vinculoJ;
                    }
                    facilidad.Vinculos.add(vinculosActual);

                }
            }
            
        jsonParse.FacilidadesRed=facilidad;
        
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
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s156' limit 1];
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
    
    public class getAvailableDatesJSON{
        public String CategoriaCentral {get;set;}
        public String CategoriaCliente {get;set;}
        public String CategoriaTerminal {get;set;}
        public String CodigoProvincia {get;set;}
        public String CodigoLocalidad {get;set;}
        public String FechaHoraFinReserva {get;set;}
        public String FechaHoraInicioReserva {get;set;}
        public String FechaHoraMensaje {get;set;}
        public String Grupo {get;set;}
        public String IdServInstDesinst {get;set;}
        public String MacroTarea {get;set;}
        public String Ebos {get;set;}
        public String Naturaleza {get;set;}
        public String Nivel0Red {get;set;}
        public String Nivel1Red {get;set;}
        public String Nivel2Red {get;set;}
        public String Origen {get;set;}
        public String ServicioRed {get;set;}
        public String Tecnologia {get;set;}
        public String Topologia {get;set;}
        public String UsuarioReservado {get;set;}
        public facilidadesRedJSON FacilidadesRed {get;set;}
        public List<macroTareaBasePreviaJSON> MacroTareasBasePrevias {get;set;}
        
        public getAvailableDatesJSON(){
            MacroTareasBasePrevias = new List<macroTareaBasePreviaJSON>();
        }
    }
    
    public class facilidadesRedJSON{
        public String CategoriaCentral {get;set;}
        public String CategoriaTerminal {get;set;}
        public String Latitud {get;set;}
        public String Longitud {get;set;}
        public List<equiposJSON> Equipos {get;set;}
        public String Naturaleza {get;set;}
        public String Nivel0Red {get;set;}
        public String Nivel1Red {get;set;}
        public String Nivel2Red {get;set;}
        public String ParqueDesconfiabilizado {get;set;}
        public List<vinculosJSON> Vinculos {get;set;}
        
        public facilidadesRedJSON(){
            Vinculos = new List<vinculosJSON>();
            Equipos = new List<equiposJSON>();
        }
    }
    
    public class equiposJSON {
        public datosEquipoJSON DatosEquipo {get;set;}
        public domicilioJSON Domicilio {get;set;}
        public Integer Id {get;set;}
        public Integer Nivel {get;set;}
        public String Tipo {get;set;}
        public String Atendido {get;set;}
    }
    
    public class datosEquipoJSON {
        public Integer CantidadVacantesElementoRed {get;set;}
        public String CategoriaEquipoElementoRed {get;set;}
        public String CentralElementoRed {get;set;}
        public String ComentarioElementoRed {get;set;}
        public String EquipoAbajoElementoRed {get;set;}
        public String ZonaElementoRed {get;set;}
    }
    
    public class domicilioJSON {
        public String AlturaElementoRed {get;set;}
        public String ManzanaElementoRed {get;set;}
        public String NombreCalleElementoRed {get;set;}
        public String NombreEdificioElementoRed {get;set;}
    }
    
    public class vinculosJSON {
        public vinculoJSON Vinculo {get;set;}
        public String PrecalificacionElementoRed {get;set;}
        public String DestinoElementoRed {get;set;}        
    }
    
    public class vinculoJSON {
        public abajoJSON Abajo {get;set;}
        public arribaJSON Arriba {get;set;}     
    }
    
    public class abajoJSON {
        public String CableAbElementoRed {get;set;}
        public String CentralAbElementoRed {get;set;}
        public String EquipoAbElementoRed {get;set;}
        public String ParAbElementoRed {get;set;}
        public String ZonaAbElementoRed {get;set;}
    }
    
    public class arribaJSON {
        public String CentralArrElementoRed {get;set;}
        public String CableArrElementoRed {get;set;}
        public String EquipoArrElementoRed {get;set;}
        public String ParArrElementoRed {get;set;}
        public String ParSecundarioArrElementoRed {get;set;}
        public String ZonaArrElementoRed {get;set;}
    }
    
    
    public class macroTareaBasePreviaJSON{
        public String CodigoMacroTareaBasePrevia {get;set;}
        
    }
    
    
}