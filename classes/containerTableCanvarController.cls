global with sharing class containerTableCanvarController{

    public String valor { get; set; }
    
    @RemoteAction
    global static Map<String, Object> filterDataByFamily(string family){
        
        Map<String, Object> outMap= new Map<String, Object>();
        Map<String, String> node = new Map<String, String>();
        try{

           if(family== 'Internet'){
            //internetScope.add('{"Family":"Internet","StartDate":"01/01/2017 23:12:15","EndDate":"28/01/2027 23:12:15","Usage":"101","Cost":"10.01$","InvoceType":"No Facturado","IO":"Saliente"}');
            node.put('Family', 'Internet');
            node.put('StartDate', '01/01/2017');
            node.put('EndDate', '28/01/2027');
            node.put('Usage', '101');
            node.put('Cost', '10.01$');
            node.put('InvoceType', 'No Facturado');
            node.put('IO', 'Saliente');
            }
          
            outMap.put('Result', node);
            
            
   
        }catch(DmlException e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
        return outMap;
    }

}
/*
global with sharing class ConsumptionDetailsHandler implements vlocity_cmt.VlocityOpenInterface{

   global ConsumptionDetailsHandler(){}

   global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
   {
    Boolean result = true;
      try {

         if (methodName.equals('filterDataByFamily')) {

            filterDataByFamily(methodName, input, outMap, options);
         }
         return result;

      }
      catch(Exception e) {
         System.debug('ConsumptionDetailsHandler: invokeMethod -> exception: '+e);
         return false;
      }
      
   }

   @RemoteAction
   global static void filterDataByFamily(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
   {    
      String familyScope= (String) input.get('family');
      // Este string esta para que no pinche, sacar y cambiar por inputmap y recorrerlo, setear si es Internet en el outmap el scope
      
      Map<String, String> node = new Map<String, String>();
      Map<String, Object> jsonNode = new Map<String, Object>();
      
      if(familyScope == 'Internet'){
            //internetScope.add('{"Family":"Internet","StartDate":"01/01/2017 23:12:15","EndDate":"28/01/2027 23:12:15","Usage":"101","Cost":"10.01$","InvoceType":"No Facturado","IO":"Saliente"}');
            node.put('Family', 'Internet');
            node.put('StartDate', '01/01/2017');
            node.put('EndDate', '28/01/2027');
            node.put('Usage', '101');
            node.put('Cost', '10.01$');
            node.put('InvoceType', 'No Facturado');
            node.put('IO', 'Saliente');
      }
      
     outMap.put('Result', node);
   }
}*/