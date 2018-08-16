public class GP_Reglas_ListController{
    public List<GP_Regla__c> listaReglas{get;set;}
    private ApexPages.StandardController controller;
    public Id IdRegla{get;set;}

    public GP_Reglas_ListController(ApexPages.StandardController stdController){
        getReglas();
    }

    public void borrarRegla() {
        GP_Regla__c regla = [SELECT Id FROM GP_Regla__c WHERE Id = :IdRegla];
        delete regla;
        getReglas();
    }

    public void getReglas() {
        listaReglas = new List<GP_Regla__c>();
        listaReglas = [ SELECT  Id, Descripcion_regla__c, Activa__c, Metodo_a_ejecutar__c, Name,
                                Tipo_de_evento__c,Valor_resultado_fijo__c,Valor_resultado_variable__c,
                                SeComparaContraElValorFijo__c, Evento_general__c, Evento_general__r.Name 
                        FROM GP_Regla__c];
    }

}