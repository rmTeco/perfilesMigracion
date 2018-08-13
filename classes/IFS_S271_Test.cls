@isTest 
public class IFS_S271_Test {
    @isTest static  void testGetCallout() {
        IFS_S271_prefeseabiltyMock mock= new IFS_S271_prefeseabiltyMock();
        mock.status=200;        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Map<String,Object> mapTest = new map<String,Object>();
        Map<String,Object> mapTest2 = new map<String,Object>();
        List<Integer> lista = new List<Integer>();
        Map<String,Object> mapAux = new map<String,Object>();
        
        mapTest2.put('idServicio','algo');
        mapTest2.put('ebos','algo');
        mapTest2.put('tipo','algo');
        mapTest2.put('tecnologia','algo');
        
        mapAux.put('servicio', mapTest2);
        
        
        Map<String,Object> MapResponse = IFS_S271_prefeseabilty.prefeseabilty('gus','tav',mapTest,mapTest2,mapAux);
        
        Map<String,Object> MapReview = new map<String,Object>();
        Map<String,Object> mapaTecnologias = new map<String,Object>();
        Map<String,Object> mapaServicios = new map<String,Object>();
        Map<String,Object> mapaTecnologia = new map<String,Object>();
        Map<String,Object> mapaCdo = new map<String,Object>();
        Map<String,Object> mapaTerminal = new map<String,Object>();
        Map<String,Object> mapaServicios2 = new map<String,Object>();
        Map<String,Object> mapaServicio2 = new map<String,Object>();
        Map<String,Object> mapaCentrales = new map<String,Object>();
        Map<String,Object> mapaStandars = new map<String,Object>();
        Map<String,Object> mapaStandard = new map<String,Object>();
        Map<String,Object> mapaServicio = new map<String,Object>();
        Map<String,Object> mapaTerminal2 = new map<String,Object>();
        
        mapaCdo.put('categoria','test');
        mapaCdo.put('estado','test');
        mapaCdo.put('modalidad','test');
        
        mapaTerminal.put('codigoTerminal','test');
        mapaTerminal.put('paresDisponibles',8);
        mapaTerminal.put('paresDefectuosos',8);
        mapaTerminal.put('categoriaTerminal','test');
        mapaTerminal.put('Topologia','test');
        
        mapaStandard.put('standardTecnico','test');
        mapaStandard.put('medicionDeBajada',8);
        
        mapaStandars.put('standardTecnico',mapaStandard);
        
        mapaServicio2.put('servicio','test');
        mapaServicio2.put('standardsTecnico',mapaStandars);
        mapaServicio2.put('disponibilidad','test'); 
        mapaServicio2.put('codigoMensaje','test');
        mapaServicio2.put('descMensaje','test');
        
        mapaServicios2.put('servicio',mapaServicio2);
        
        mapaCentrales.put('centralAtendida','test');
        mapaCentrales.put('centralGSMF','test');
        mapaCentrales.put('centralGirafe','test');
        mapaCentrales.put('centralVoz','test');
        mapaCentrales.put('centralInternet','test');
        
        mapaTecnologia.put('tecnologia','test');
        mapaTecnologia.put('ebos','test');
        mapaTecnologia.put('armario','test');
        mapaTecnologia.put('autoconmutador','test');
        mapaTecnologia.put('cdo',mapaCdo);
        mapaTecnologia.put('terminal',mapaTerminal);
        mapaTecnologia.put('servicios',mapaServicios2);
        mapaTecnologia.put('centrales',mapaCentrales);
        
        mapaTerminal2.put('codigoTerminal','test');
        mapaTerminal2.put('Categoria','test');
        mapaTerminal2.put('Topologia','test');
        mapaTerminal2.put('medicionDeBajada','test');
        
        mapaServicio.put('ebos','test');
        mapaServicio.put('idServicio','test');
        mapaServicio.put('Tipo','test');
        mapaServicio.put('Tecnologia','test');
        mapaServicio.put('centralAtendida','test');
        mapaServicio.put('Autoconmutador','test');
        mapaServicio.put('Armario','test');
        mapaServicio.put('Terminal',mapaTerminal2);

        mapaTecnologias.put('TecnologiaAcceso',mapaTecnologia);
        mapaServicios.put('servicio',mapaServicio);
        
        MapReview.put('tecnologiasAcceso',mapaTecnologias);
        MapReview.put('Servicios',mapaServicios);
        MapReview.put('httpStatusCode','200');
        
        system.debug(MapReview);
        system.debug(MapResponse);
        
        //system.assertEquals(MapReview.size(), MapResponse.size());
        //system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }  
    }
}