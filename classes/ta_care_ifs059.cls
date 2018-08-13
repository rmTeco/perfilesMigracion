/* 
 * This class is tested by "ta_care_refunds_test" 
 * Code coverage : 90%
*/

global with sharing class ta_care_ifs059 {
    
    global ta_care_ifs059() {}
    
    public List<Object> getPaymentHistoryForPaymentMethod (Map<String,Object> options){
        
       List<Object> result = new List<Object>();
       Map<String, Object> cardPayments = new Map<String, Object>();
       List<Object> paymentsList = new List<Object>();
       String paymentCode;
       String objPaymentCode;
       
       try{
           Map <String, Object> infoPagosMap =(Map <String, Object>)options.get('listaInfoPagos');
           List<Object> infoPagoList = VlocityOpenInterfaceHelper.getListObjectsFromMap(infoPagosMap, 'infoPago');
           system.debug('infoPagoList: ' + infoPagoList);
           paymentCode = (String)options.get('codMedioPago');
           
           for (Object obj : infoPagoList ) {
               Map<String, Object> paymentMap = (Map<String, Object>)obj;
               objPaymentCode = (String) paymentMap.get('codMedioPago');
               if(paymentCode == objPaymentCode)
               {
                   paymentsList.add(paymentMap);
                   
               }
           }
           //result.add(paymentsList);
           return paymentsList;
       }catch(Exception e){
           System.debug('ta_care_ifs059:getPaymentHistoryForPaymentMethod -> exception: '+e);
           return result;
       }
        
    }
    

}