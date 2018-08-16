global with sharing class community_generateRequestS210 implements vlocity_cmt.VlocityOpenInterface {
    
    
     public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getRequest_S210')){
                System.debug('options_--' + options);
                getRequest_S210(input, outMap, options);
            }
        }
        catch(Exception e)
        {
            System.debug('community_generateRequestS210:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
   void getRequest_S210(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        
        String desde = (String) options.get('desde');
        String hasta = (String) options.get('hasta');
                
        String year = desde.substring(0,4);
        String mes = desde.substring(5,8);
        String dia = desde.substring(8,11);
        
        String Hhs = hasta.substring(11,14);
        String Mms = hasta.substring(14,16);
        
        String fechaDesde = dia + '-' + mes + ' ' + year + ' ' + Hhs + ':' + Mms;
        
        String yearUntil = hasta.substring(0,4);
        String meses = hasta.substring(5,8);
        String dias = hasta.substring(8,11);
        
        String Hh = hasta.substring(11,14);
        String Mm = hasta.substring(14,16);
        
        String fechaHasta = dias  + '-' + meses + ' ' + yearUntil ;
        String hora = Hh + ' ' + Mm;
        
        outMap.put('fechaDesde',fechaDesde);
        outMap.put('fechaHasta',fechaHasta);
        outMap.put('hora ',hora );
        
    }
    
}