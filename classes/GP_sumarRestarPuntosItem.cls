public with sharing class GP_sumarRestarPuntosItem {

    public String titularID {get;set;}
    public String tipoDeEvento {get;set;}
    public Double puntos{get;set;}
    public Integer numeroDeOrden {get;set;} 
    public String suscriptorID {get;set;}
    public List<GP_AtributoValorDeUnEvento> variablesDelEvento {get;set;}

    public GP_sumarRestarPuntosItem (String unTitularID, String unSuscriptorID, String unTipoDeEvento, Integer unNumeroDeOrden, List<GP_AtributoValorDeUnEvento> variables){
        if(String.isBlank(unTitularID) || String.isBlank(unTipoDeEvento) || unNumeroDeOrden == null || variables == null){
            throw new GP_APIException('Los campos unTitularID, tipoDeEvento y numeroDeOrden son obligatorios y deben poseer un valor.');
        }
        puntos = 0;
        if(unTipoDeEvento == 'Canje') {
            Boolean existeVarPuntos = false;
            for(GP_AtributoValorDeUnEvento var : variables) {
                if(var.variable == 'puntos') {
                    existeVarPuntos = true;
                    puntos = var.valorNumerico;
                }
            }
            if(!existeVarPuntos) {
                throw new GP_APIException('Para los eventos de \'Canje\' es obligatoria la variable \'Puntos\' con un valor numérico.');
            }
        }

        titularID = unTitularID;
        suscriptorID = unSuscriptorID;
        tipoDeEvento = unTipoDeEvento;
        numeroDeOrden = unNumeroDeOrden;
        variablesDelEvento = variables;
    }

}