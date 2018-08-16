public with sharing class KAL_PagoController {

    @AuraEnabled
    //d
    public static String conseguirPromocionesFinancieras(){
        //Order orden = [select id, vlocity_cmt__EffectiveOrderTotal__c from order where id = '8016C0000000oCA' ];
        Order orden = Kal_utils.obtenerOrdenActualDelUsuario(UserInfo.getUserId());
        system.debug(orden.id);
        system.debug(orden.vlocity_cmt__EffectiveOrderTotal__c);
        
        Map<String, Object> respuesta = ObtenerPromocionesFinancieras(UserInfo.getUserId(),orden.id);
        
        return '{"Monto":"'+orden.vlocity_cmt__EffectiveOrderTotal__c+'","options": '+(String) respuesta.get('options')+'}';
    }  

    public static Map<String, Object> ObtenerPromocionesFinancieras(String userId, String idOrder) {
        
        Map<String, Object> outMap = new Map<String, Object>();

        //vlocity_cmt__BusinessSite__c tm = ta_sales_UserUtils.getStoreLocation(userId);

        List<OrderItem> itemsList = [SELECT Id, Product2Id
                                       FROM OrderItem
                                      WHERE OrderId = :idOrder];

  
        //String recordTypeName = (String) input.get('recordTypeName');

        Order order = [SELECT Id, Vlocity_cmt__OriginatingChannel__c, OriginStoreLocation__r.Channel__c
                         FROM Order
                        WHERE Id = :idOrder LIMIT 1];

        List<String> productList = new List<String>();
        //String location = tm.Location__c;

        for(OrderItem item : itemsList){ 
            productList.add(item.Product2Id);
        }

        Date todaydate = Date.Today();
        //Solo me traigo los de tipo tarjeta de credito
        ID rc = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();
        //Comentado parametro en el and -- AND LocationPromotion__c = :location, and RecordType.Name = :recordTypeName
        List<FinancialPromotion__c> financialPromotions = [SELECT toLabel(BankEntities__c), toLabel(CreditCards__c), NombrePromocion__c, Instalment__c, Interest__c, Percentage__c
                                                             FROM FinancialPromotion__c
                                                            WHERE From__c <= :todaydate
                                                              AND To__c >= :todaydate
                                                              AND ChannelPromotion__c = : 'Digital'
                                                              AND ProductPromotion__c = null
                                                              AND recordtypeid =: rc
                                                              AND PromotionStatus__c = 'Vigente'];
//AND ProductPromotion__c IN :productList

        List<FinancialPromotion__c> genericPromotions = new List<FinancialPromotion__c>();
        genericPromotions = [SELECT toLabel(BankEntities__c), toLabel(CreditCards__c), NombrePromocion__c, Instalment__c, Interest__c, Percentage__c
                               FROM FinancialPromotion__c
                              WHERE From__c <= :todaydate
                                AND To__c >= :todaydate
                                AND ChannelPromotion__c = null
                                AND ProductPromotion__c = null
                                AND LocationPromotion__c = null
                                AND recordtypeid =: rc
                                AND PromotionStatus__c = 'Vigente'];

        if(financialPromotions.isEmpty()){
            financialPromotions.addAll(genericPromotions);
        }
        else{
            for(FinancialPromotion__c gp : genericPromotions){

                Boolean aggregate = true;
                for(FinancialPromotion__c fp : financialPromotions){
                    if(gp.BankEntities__c == fp.BankEntities__c &&
                       gp.CreditCards__c  == fp.CreditCards__c  &&
                       gp.Instalment__c   == fp.Instalment__c &&
                       gp.Percentage__c == fp.Percentage__c){
                        aggregate = false;
                        break;
                    }
                }
                if(aggregate){
                    financialPromotions.add(gp);
                }
            }
        }
        String serializedList = JSON.serialize(financialPromotions);
        outMap.put('options', serializedList);
        return outMap;
    }
    
    @AuraEnabled
    public static String getTerminosycondiciones(){
        List<TerminosyCondiciones__c> laUrlList = [Select termsproduct__c, activo__c From TerminosyCondiciones__c Where activo__c = true order by lastmodifieddate desc limit 1];
        TerminosyCondiciones__c laUrlinstancia = laUrlList[0];
        String laUrl = laUrlinstancia.termsproduct__c;
        return laUrl;
    } 
}