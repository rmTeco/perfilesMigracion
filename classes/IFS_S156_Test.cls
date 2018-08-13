@isTest 
private class IFS_S156_Test {
    @isTest static  void testGetCallout() {
        IFS_S156_getAvailableDatesMock mock= new IFS_S156_getAvailableDatesMock();
        mock.status=201;        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Map<String,Object> mapaMacro2 = new map<String,Object>();
        mapaMacro2.put('CodigoMacroTareaBasePrevia','cod001');
        
        Map<String,Object> mapaMacro = new map<String,Object>();
        mapaMacro.put('MacroTareaBasePrevia',mapaMacro2);
        
        Map<String,Object> mapaComplex = new map<String,Object>();
        mapaComplex.put('MacroTareasBasePrevias',mapaMacro);
        
        Date date1=Date.today();
        Date date2=Date.today();
        Date date3=Date.today();
        
        
        
        
        
        Map<String,Object> mapaDatosEquipo = new Map<String,Object>();
        mapaDatosEquipo.put('CantidadVacantesElementoRed',2);
        mapaDatosEquipo.put('CategoriaEquipoElementoRed','dos');
        mapaDatosEquipo.put('CentralElementoRed','cen2');
        mapaDatosEquipo.put('ComentarioElementoRed','com');
        mapaDatosEquipo.put('EquipoAbajoElementoRed','com');
        mapaDatosEquipo.put('ZonaElementoRed','com');
        
        Map<String,Object> mapaDomicilio = new Map<String,Object>();
        mapaDomicilio.put('AlturaElementoRed','alt');
        mapaDomicilio.put('ManzanaElementoRed','alt');
        mapaDomicilio.put('NombreCalleElementoRed','alt');
        mapaDomicilio.put('NombreEdificioElementoRed','alt');
        
        Map<String,Object> mapaEquipo = new Map<String,Object>();
        mapaEquipo.put('Id',001);
        mapaEquipo.put('Nivel',2);
        mapaEquipo.put('Tipo','t1');
        mapaEquipo.put('Atendido','zez');
        
        Map<String,Object> mapaEquipos = new Map<String,Object>();
        mapaEquipos.put('DatosEquipo',mapaDatosEquipo);
        mapaEquipos.put('Domicilio', mapaDomicilio);
        mapaEquipos.put('Equipo',mapaEquipo);
        
        Map<String,Object> mapaAbajo = new Map<String,Object>();
        mapaAbajo.put('CableAbElementoRed', 'cab');
        mapaAbajo.put('CentralAbElementoRed', 'cab');
        mapaAbajo.put('EquipoAbElementoRed', 'cab');
        mapaAbajo.put('ParAbElementoRed', 'cab');
        mapaAbajo.put('ZonaAbElementoRed', 'cab');
        
        Map<String,Object> mapaArriba = new Map<String,Object>();
        mapaArriba.put('CentralArrElementoRed', 'arr');
        mapaArriba.put('CableArrElementoRed', 'arr');
        mapaArriba.put('EquipoArrElementoRed', 'arr');
        mapaArriba.put('ParArrElementoRed', 'arr');
        mapaArriba.put('ParSecundarioArrElementoRed', 'arr');
        mapaArriba.put('ZonaArrElementoRed', 'arr');
        
        Map<String,Object> mapaVinculo = new Map<String,Object>();
        mapaVinculo.put('Abajo',mapaAbajo);
        mapaVinculo.put('Arriba',mapaArriba);
        
        Map<String,Object> mapaVinculoDos = new Map<String,Object>();
        mapaVinculoDos.put('PrecalificacionElementoRed','pre');
        mapaVinculoDos.put('DestinoElementoRed','des');
        mapaVinculoDos.put('Vinculo',mapaVinculo);
        
        Map<String,Object> mapaVinculos = new Map<String,Object>();
        mapaVinculos.put('algo',mapaVinculoDos);
        
        Map<String,Object> mapa1 = new Map<String,Object>();
        mapa1.put('CategoriaCentral','cat1');
        mapa1.put('CategoriaTerminal','cat1');
        mapa1.put('Latitud','cat1');
        mapa1.put('Longitud','cat1');
        mapa1.put('Naturaleza','cat1');
        mapa1.put('Nivel0Red','cat1');
        mapa1.put('Nivel1Red','cat1');
        mapa1.put('Nivel2Red','cat1');
        mapa1.put('ParqueDesconfiabilizado','cat1');
        mapa1.put('Equipos',mapaEquipos);
        mapa1.put('Vinculos',mapaVinculos);

        Map<String,Object> mapAux = new Map<String,Object>();
        mapAux.put('FacilidadesRed', mapa1);
        
        Map<String,Object> MapResponse = IFS_S156_getAvailableDates.getAvailableDates('mapTest','mapTest','mapTest','mapTest','mapTest',date1, date2, date3,'mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest','mapTest',mapa1,mapaComplex);   
        
        Map<String,Object> MapReview = new map<String,Object>();
        
        Map<String,Object> MapVentana = new map<String,Object>();
        MapVentana.put('FechaHoraFinReserva','201707011159');
        MapVentana.put('FechaHoraInicioReserva','201707011059');
        MapVentana.put('NumeroReserva', '222');
        
        MapReview.put('EstadoOperacion','e001');
        MapReview.put('FechaHoraMensaje','201707011259');
        
        List<Map<String,Object>> lista = new List<Map<String,Object>>();
        lista.add(MapVentana);
        mapReview.put('VentanaReserva', lista);
        mapReview.put('httpStatusCode','201');

        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        for(String Cons : MapReview.keySet()){
          system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }
        
         MapReview.equals(MapResponse);  
    }
}