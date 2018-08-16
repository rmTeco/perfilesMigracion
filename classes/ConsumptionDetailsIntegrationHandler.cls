/**
 * Created by Alex Lazarev
 * Date: 05/12/17
 *
 * Version: 1.0
 */

global with sharing class ConsumptionDetailsIntegrationHandler implements vlocity_cmt.VlocityOpenInterface {

    global ConsumptionDetailsIntegrationHandler(){}

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {

            if (methodName.equals('filterDataByFamily')) {

                filterDataByFamily(input, outMap, options);
            }
            return result;

        }
        catch(Exception e) {
            System.debug('ConsumptionDetailsIntegrationHandler: invokeMethod -> exception: '+e);
            return false;
        }

    }

    static Datetime getDate(String dateT) {
        Integer year;
        Integer month;
        Integer day;

        if (dateT.indexOf('/') == -1) {
            year = Integer.valueof(dateT.substring(0,4));
            month = Integer.valueof(dateT.substring(4,6));
            day = Integer.valueof(dateT.substring(6,8));
        } else {
            String[] arrDate  = dateT.split('/');

            day    = Integer.valueof(arrDate[0]);
            month  = Integer.valueof(arrDate[1]);
            year   = Integer.valueof(arrDate[2]);  
        }

        return Datetime.newInstance(year,month,day,0,0,0);      
    }  

    /*static Integer getMonth(String month){
    
        try
        {
            if (month == 'Enero')  {
                    return 1;
            } else if (month == 'Febrero')  {
                    return 2;
            } else if (month == 'Marzo')  {
                    return 3;
            } else if (month == 'Abril')  {
                    return 4;
            } else if (month == 'Mayo')  {
                    return 5;
            } else if (month == 'Junio')  {
                    return 6;
            } else if (month == 'Julio')  {
                    return 7;
            } else if (month == 'Agosto')  {
                    return 8;
            } else if (month == 'Septiembre')  {
                    return 9;
            } else if (month == 'Octubre')  {
                    return 10;
            } else if (month == 'Noviembre')  {
                    return 11;
            } else {
                    return 12;
            }  
        }
        catch(Exception ex)
        {
            //DebugInfo.AddDebugInfoEntry('ConsumptionDetailsIntegrationHandler', 'filterDataByFamily', 'Error al obtener mes: '+ex.getMessage());
            throw ex;
        }
    }      */

    @RemoteAction
    global static void filterDataByFamily(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) 
    {      
        try
        {
            System.debug('ConsumptionDetailsIntegrationHandler - filterDataByFamily');
            System.debug('inputMap: ' + inputMap);

            String startDateScope   = String.valueOf(inputMap.get('startDateFilter'));
            String endDateScope     = String.valueOf(inputMap.get('endDateFilter'));
            //String optionFactura    = (String) inputMap.get('facturaFilter');
            String filterOption     = (String) inputMap.get('filterOption');
            Datetime sDate;
            Datetime eDate;

            //DebugInfo.AddDebugInfoEntry('ConsumptionDetailsIntegrationHandler', 'filterDataByFamily', startDateScope+ ' ' + endDateScope);
            System.debug('startDateScope ==='+ startDateScope);
            System.debug('endDateScope ==='+ endDateScope);
            //System.debug('optionFactura ==='+ optionFactura);
            System.debug('filterOption ==='+ filterOption);
            
            try
            {
                if (filterOption == 'Una factura')
                {
                    /*if(optionFactura != null)
                    {
                        System.debug('Factura');
                        Integer month     = getMonth(optionFactura);
                        Integer year      = Date.today().year();
                        Integer day       = Date.daysInMonth(year, month);
                        sDate             = Datetime.newInstance(year,month,1,0,0,0);
                        eDate             = Datetime.newInstance(year,month,day,0,0,0);
                    }
                    else
                        return; */
                }
                else 
                {
                    if (filterOption == 'Los últimos 15 días')
                    {
                        System.debug('15 dias');
                        sDate = (Date.today()).addDays(-15); 
                        System.debug('step1');
                        eDate = Date.today(); 
                    }
                    else
                    {
                        System.debug('default');
                        sDate = getDate(startDateScope); 
                        eDate = getDate(endDateScope); 
                    }
                }
            }
            catch(Exception ex)
            {
                //DebugInfo.AddDebugInfoEntry('ConsumptionDetailsIntegrationHandler', 'filterDataByFamily', ex.getMessage());
                throw ex;
            }
            
            System.debug('Fecha1: '+sDate);
            System.debug('Fecha2: '+eDate);

            JSONGenerator inputJSON = JSON.createGenerator(true); // true for pretty formatting
            /* This is the JSON we are building here
            {
                "body": {
                    "codigoAcceso": {
                        "identificadorRecurso": "13800001139",
                        "codSuscripcion": ""
                    },
                    "cantidadItemsConsulta": 3,
                    "referenciaItemPaginado": 0,
                    "cantidadMaxConsulta": 2,
                    "fechaDesde": "20170205",
                    "fechaHasta": "20171106"
                }
            }

            */

            //Map<String, Object> inMap = new Map<String, Object>();
            String identificadorRecursoScope = (String) inputMap.get('CustomerIntegrationId');
            //String identificadorRecursoScope = '13800001139';

            // Vlocity Integration Procedure Obj 
            if(!Test.isRunningTest())
            {
                String jsonString = '{"body":{"codigoAcceso":{"identificadorRecurso":"'+identificadorRecursoScope+'","codSuscripcion":null},"cantidadItemsConsulta":2,"referenciaItemPaginado":0,"cantidadMaxConsulta":3,"fechaDesde":"'+String.valueOfGmt(sDate)+'","fechaHasta":"'+String.valueOfGmt(eDate)+'"}}';
                Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
                
                System.debug('Request: '+input);
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S139', input, outputMap, options);
                System.debug('Response: ' + JSON.serialize(outputMap));

                Map<String, Object> response = (Map<String, Object>)outputMap.get('IPResult');
                System.debug('Response IFS_S139: '+ response);
            }
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }   
    }
    
    public class PromocionTasadaLista{
        String codProducto;
        String codTipoBalance;
        String fechaVigenciaHastaProdAdq;
        String nombreProducto;
        String saldoBalance;
        
    }
    
    public class DetalleDeUnidadesLibresTasadasLista{
       ElementoDetalleDeUnidadesLibresTasada elementoDetalleDeUnidadesLibresTasada;
        
    }

    public class ElementoDetalleDeUnidadesLibresTasada{
        String cantUnidadesLibresTas;
        String codProducto;
        String codUnidadDeMedida;
        String codUsoUnidadesLibres;
        String fechaVigenciaHastaProdAdq;
        String nombreProducto;  
        
    }    
    
    public class NodoTemp{
        String descripcion;
        String descripcionTipoEvento;
        //DetalleDeUnidadesLibresTasadasLista detalleDeUnidadesLibresTasadasLista;
        String fechaHoraFinTrafico;
        String fechaTasacionTrafico;
        String importeTasado;
        String nombreProducto;
        String numeroOrigen;
        //PromocionTasadaLista promocionTasadaLista;
        String saldoBalance;
            
    }
    
    public class DetalleDeMovimientosLista{
       String cantidadItemsConsulta;
       String cantidadMaxConsulta;
       //List<NodoTemp> elementoDetalleDeMovimientos;
       String referenciaItemPaginado;
    }
   
    
    
    global class CodigoAccesoWrapper {
        String identificadorRecurso;
        String codSuscripcion;

        global CodigoAccesoWrapper(String i, String c) {
            identificadorRecurso = i;
            codSuscripcion = c;
        }
    }

}