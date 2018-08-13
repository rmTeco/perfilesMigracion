public class anularPagoButtonController {
    
    public Task tarea{get;set;}
    public Boolean flagx{get;set;}
    public Id idOrden{get;set;}
    
    public anularPagoButtonController(ApexPages.StandardController stdController){
           
            flagx = false;
            tarea = (Task) stdController.getRecord();
            Task unaTarea = [select id, what.type, whatId from Task where id = : tarea.id];
            
           if(unaTarea.what.Type == 'Order'){
                
                Order orden = [select id, TrackingStatus__c from Order where id = : unaTarea.whatId];
                
                //idOrden = '8016C0000000Z8l';
                //id de la orden que pasó octavio 8016C0000000Z9t;
                idOrden = orden.id;
                
                if (orden.TrackingStatus__c == 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro'|| orden.TrackingStatus__c == 'Pendiente de Anulación de Pago'){
                    flagx = true;
                }
                
                
            }
    }
    
    //public PageReference anulacionOS(){
      //  PageReference pageRef = new PageReference('https://ta-dev--desa01--vlocity-cmt.cs63.visual.force.com/apex/vlocity_cmt__OmniScriptUniversalPage?id={0}&layout=lightning#/OmniScriptType/Sales/OmniScriptSubType/OrderAnnulment/OmniScriptLang/English/ContextId/{0}/PrefillDataRaptorBundle//true');
        //pageRef.setRedirect(true);
        //return pageRef;
    //}
    
}