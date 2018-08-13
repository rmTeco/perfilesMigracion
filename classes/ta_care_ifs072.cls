global with sharing class ta_care_ifs072 {
    
    global ta_care_ifs072() {}
    
    public Boolean getRollbackResultSuccess (Map<String,Object> options){
        Boolean result = false;
        Map<String, Object> paymentResponseMap = (Map<String, Object>)options.get('revertirPagosRespuesta');
        Map<String, Object> paymentResponseMap2 = (Map<String, Object>)paymentResponseMap.get('revertirPagosRespuesta');
        if(paymentResponseMap2.containsKey('listaInformacionPagos')){
            List<Object> paymentList = (List<Object>)paymentResponseMap2.get('listaInformacionPagos');
            for(Object obj: paymentList){
                Map<String, Object> paymentInfo = (Map<String, Object>)obj;
                Map<String, Object> paymentResult = (Map<String, Object>)paymentInfo.get('informacionPago');
                Map<String, Object> rollBackResult = (Map<String, Object>)paymentResult.get('resultadoReversion');
                if(rollBackResult.containsKey('revExitosa')){
                    result = true;
                } else{
                    result = false;
                }
            }
        }else{
            result = false;
        }
        return result;
    }
}