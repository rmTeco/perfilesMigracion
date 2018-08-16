/*
    Created by Federico Biaus 10/07/2018
    No test clase needed
*/

global with sharing class TestClassForResponsiveGridWithPaging implements vlocity_cmt.VlocityOpenInterface {

    global TestClassForResponsiveGridWithPaging (){}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try{
            if (methodName.Equals('ResponsiveGridWithPaging')) {
                ResponsiveGridWithPaging(inputMap, outMap, options);
            }

            if (methodName.Equals('ResponsiveGridWithPagingTestData')) {
                ResponsiveGridWithPaging(inputMap, outMap, options);
            }

        }catch(Exception ex)
        {
            outMap.put('error', ex.getStackTraceString());
            result = false;
        }

        return result;
    }

    global static void ResponsiveGridWithPaging(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        try
        {
            //DateTime fechaIncio = DateTime.now() - 20;
            //String codSuscriptor =  '9900000352810001';
            String sDate, eDate, descError;

            if((String.valueOf(inputMap.get('startDateFilter')) == null) && (String.valueOf(inputMap.get('endDateFilter')) == null))
            {
                DateTime fechaIncio = DateTime.now() - 5;
                DateTime fechaFin = DateTime.now() + 1; //+1 por la hora 00:00:00.
                sDate = String.valueOf(fechaIncio);
                eDate = String.valueOf(fechaFin);
                descError = 'No hay registros en los ultimos 5 dias.';
            }
            else
            {
                sDate = String.valueOf(inputMap.get('startDateFilter'));
                eDate = String.valueOf(inputMap.get('endDateFilter'));
                descError = 'No se encontraron registros para el cirterio de busqueda ingresado.';
            }

            String codSuscriptor = String.valueOf(inputMap.get('codSuscriptor'));
            String cantidadMaxConsulta = String.valueOf(inputMap.get('cantidadMaxConsulta'));
            String referenciaItemPaginado = String.valueOf(inputMap.get('referenciaItemPaginado'));
            String cantidadItemsConsulta = String.valueOf(inputMap.get('cantidadItemsConsulta'));

            Map<String, Object> result2 = new Map<String, Object>();
            Map<String, Object> outputMap = new Map<String, Object>();

            String jsonString = '{"body":{"cantidadItemsConsulta":'+cantidadItemsConsulta+',"cantidadMaxConsulta":'+cantidadMaxConsulta+',"cuenta":{"codigoAcceso":{"codSuscripcion":"'+codSuscriptor+'"}},"fechaDesde":"'+sDate+'","fechaHasta":"'+eDate+'","infoDetalle":{},"referenciaItemPaginado":'+referenciaItemPaginado+'}}';

            System.debug('Request jsonString: '+jsonString);
            Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S138', input, outputMap, options);
            System.debug('Response S138: '+outputMap);

            Map<String, Object> result = (Map<String, Object>)outputMap.get('IPResult');
            Map<String, Object> mapAjustes;

            List<Object> ajustments = (List<Object>)result.get('listaDetalleAjuste');
            List<Object> ajustments2 = new List<Object>();

            if(result.get('detalle') != null)
            {
                mapAjustes = new Map<String, Object>();
                result2.put('codError', '201');
                result2.put('descError', 'Ocurrio un error en el legado.');

                mapAjustes = new Map<String, Object>();
                mapAjustes.put('motivoAjuste','');
                mapAjustes.put('codCanal','');
                mapAjustes.put('fechaAjuste','');
                mapAjustes.put('codCuentaTasacion','');
                mapAjustes.put('codigoAjuste','');
                mapAjustes.put('codMoneda','');
                mapAjustes.put('montoAjuste','');
                mapAjustes.put('tipoAjuste','');
                mapAjustes.put('fechaExpiracionBalance','');
                mapAjustes.put('codTipoBalance','');
                ajustments2.add(mapAjustes); //Si no agrego dos veces el nodo se rompe todo, la villa. (bug vlocity)
                ajustments2.add(mapAjustes);
            }
            else
            {
                if(ajustments == null)
                {
                    result2.put('codError', '201');
                    result2.put('descError', descError);

                    mapAjustes = new Map<String, Object>();
                    mapAjustes.put('motivoAjuste','');
                    mapAjustes.put('codCanal','');
                    mapAjustes.put('fechaAjuste','');
                    mapAjustes.put('codCuentaTasacion','');
                    mapAjustes.put('codigoAjuste','');
                    mapAjustes.put('codMoneda','');
                    mapAjustes.put('montoAjuste','');
                    mapAjustes.put('tipoAjuste','');
                    mapAjustes.put('fechaExpiracionBalance','');
                    mapAjustes.put('codTipoBalance','');
                    ajustments2.add(mapAjustes); //Si no agrego dos veces el nodo se rompe todo, la villa. (bug vlocity)
                    ajustments2.add(mapAjustes); 
                }
                else {
                    result2.put('codError', '0');
                    result2.put('descError', '');
                    for (Object a : ajustments) {
                        mapAjustes = new Map<String, Object>();
                        Map<string, object> aMap = (Map<string, object>) a;

                        mapAjustes.put('motivoAjuste', String.valueOf(aMap.get('codMotivoAjuste')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codMotivoAjuste')));
                        mapAjustes.put('codCanal', String.valueOf(aMap.get('codCanal')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codCanal')));
                        mapAjustes.put('fechaAjuste', String.valueOf(aMap.get('fechaAjuste')) == '' ? 'Sin datos' : String.valueOf(aMap.get('fechaAjuste')));
                        mapAjustes.put('codCuentaTasacion', String.valueOf(aMap.get('codCuentaTasacion')) == '' ? 'Sin datos' : String.valueOf(aMap.get('codCuentaTasacion')));

                        List<Object> listaAjusteBalanceInfo = (List<Object>) aMap.get('listaAjusteBalanceInfo');
                        List<Object> listaInfoAjusteUnidadesLibres = (List<Object>) aMap.get('listaInfoAjusteUnidadesLibres');

                        if (listaAjusteBalanceInfo != null) {
                            mapAjustes.put('codigoAjuste', 'Balance');

                            for (Object b : listaAjusteBalanceInfo) {
                                Map<string, object> bMap = (Map<string, object>) b;
                                String tipoAjuste = String.valueOf(bMap.get('tipoAjuste')) == null ? 'Sin datos' : String.valueOf(bMap.get('tipoAjuste'));
                                //Actualmente se muestra lo que esta en MAIN BILLING ACCOUNT
                                if (String.valueOf(bMap.get('codTipoBalance')) == 'C_MAIN_ACCOUNT') {
                                    mapAjustes.put('codMoneda', String.valueOf(bMap.get('codMoneda')) == null ? 'Sin datos' : String.valueOf(bMap.get('codMoneda')));

                                    Double montoDouble = 0;
                                    String montoString = String.valueOf(bMap.get('montoAjuste')) == null ? 'Sin datos' : String.valueOf(bMap.get('montoAjuste'));
                                    if (montoString != 'Sin datos') {
                                        montoDouble = (Double.valueOf(montoString.remove('.')) / 10000);
                                        if (tipoAjuste == 'CREDITO')
                                            montoString = '-$ ' + String.valueOf(montoDouble); //Verificar
                                        else if (tipoAjuste == 'DEBITO')
                                            montoString = '$ ' + String.valueOf(montoDouble);
                                    }
                                    mapAjustes.put('montoAjuste', montoString);
                                    mapAjustes.put('tipoAjuste', tipoAjuste);
                                    mapAjustes.put('fechaExpiracionBalance', String.valueOf(bMap.get('fechaExpiracionBalance')) == null ? 'Sin datos' : String.valueOf(bMap.get('fechaExpiracionBalance')));
                                    mapAjustes.put('codTipoBalance', String.valueOf(bMap.get('codTipoBalance')));
                                }
                            }
                        } else {
                            if (listaInfoAjusteUnidadesLibres != null) {
                                mapAjustes.put('codigoAjuste', 'Libre');

                                for (Object c : listaInfoAjusteUnidadesLibres) {
                                    Map<string, object> cMap = (Map<string, object>) c;
                                    mapAjustes.put('codUnidadDeMedida', String.valueOf(cMap.get('codUnidadDeMedida')) == null ? 'Sin datos' : String.valueOf(cMap.get('codUnidadDeMedida')));

                                    String unidad;
                                    String unidadMedida = String.valueOf(cMap.get('codUnidadDeMedida')) == null ? 'Sin datos' : String.valueOf(cMap.get('codUnidadDeMedida'));
                                    if (unidadMedida != 'Sin datos') {
                                        switch on unidadMedida {
                                            when 'SEGUNDOS' {
                                                unidad = ' Min';
                                            }
                                            when 'ITEMS' {
                                                unidad = ' SMS';
                                            }
                                            when 'KB' {
                                                unidad = ' MB';
                                            }
                                            when else {
                                                unidad = ' ?';
                                            }
                                        }
                                    }
                                    Double montoDouble = 0;
                                    String montoString = String.valueOf(cMap.get('montoAjuste')) == null ? 'Sin datos' : String.valueOf(cMap.get('montoAjuste'));
                                    if (montoString != 'Sin datos') {
                                        montoDouble = (Double.valueOf(montoString.remove('.')) / 10000);
                                        if (unidad == 'MB')
                                            montoString = String.valueOf(montoDouble / 1024) + unidad;

                                        else if (unidad == 'Min')
                                            montoString = String.valueOf(montoDouble / 60) + unidad;

                                        else if (unidad == 'Min')
                                            montoString = String.valueOf(montoDouble / 60) + unidad; else
                                                montoString = String.valueOf(montoDouble) + unidad;
                                    }
                                    mapAjustes.put('montoAjuste', montoString);
                                    mapAjustes.put('tipoAjuste', String.valueOf(cMap.get('tipoAjuste')) == null ? 'Sin datos' : String.valueOf(cMap.get('tipoAjuste')));
                                    mapAjustes.put('fechaExpiracionBalance', String.valueOf(cMap.get('fechaAjusteVigenciaHasta')) == null ? 'Sin datos' : String.valueOf(cMap.get('fechaAjusteVigenciaHasta')));
                                    mapAjustes.put('codTipoBalance', String.valueOf(cMap.get('codUsoUnidadesLibres')));
                                }
                            }
                        }
                        ajustments2.add(mapAjustes);
                    }
                }
            }


            result2.put('listaDetalleAjuste', ajustments2);
            result2.put('cantidadMaxConsulta', result.get('cantidadMaxConsulta'));
            result2.put('referenciaItemPaginado', result.get('referenciaItemPaginado'));
            result2.put('cantidadItemsConsulta', result.get('cantidadItemsConsulta'));
            outMap.put('IPResult', result2);
            System.debug('outMap: '+outMap);
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
    }

    global static void ResponsiveGridWithPagingTestData(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {

        String jsonString = '{"IPResult":{"listaDetalleAjuste":[{"motivoAjuste":"Ajuste por Fidelizacion","fechaAjuste":"2014/05/27 15:30:30","codCuentaTasacion":"a13600434101","codSuscripcion":"20140527145411","identificadorRecurso":"13600434101","codCanal":"4","codAjuste":"1849199","codMotivoAjuste":"5"},{"motivoAjuste":"Rec. por actualizacion de datos del cliente","fechaAjuste":"2014/07/27 15:30:30","codCuentaTasacion":"b13600434101","codSuscripcion":"20150527145411","identificadorRecurso":"13600434101","codCanal":"5","codAjuste":"1849200","codMotivoAjuste":"4"},{"motivoAjuste":"Ajuste por Fidelizacion","fechaAjuste":"2015/01/27 15:30:30","codCuentaTasacion":"c13600434101","codSuscripcion":"20330527145411","identificadorRecurso":"13600434101","codCanal":"4","codAjuste":"1849211","listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"2014/08/13 15:30:30","fechaAjusteVigenciaDesde":"2014/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":150,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1000"},{"fechaAjusteVigenciaHasta":"2015/08/13 15:30:30","fechaAjusteVigenciaDesde":"2015/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":275,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1001"},{"fechaAjusteVigenciaHasta":"2016/08/13 15:30:30","fechaAjusteVigenciaDesde":"2016/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":56,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1002"}],"codMotivoAjuste":"5"}],"cantidadItemsConsulta":3,"referenciaItemPaginado":0,"cantidadMaxConsulta":5},"errorCode":"INVOKE-200","error":"OK"}';
        outMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

    }

}