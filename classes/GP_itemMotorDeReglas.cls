public with sharing class GP_itemMotorDeReglas {

    public Double puntos {get;set;}
    public String idRegla {get;set;}
    public String titularID {get;set;}
    public String suscriptorID {get;set;}
    public String tipoDeEvento {get;set;}
    public Integer numeroDeOrden {get;set;}
    public List<GP_AtributoValorDeUnEvento> variablesDelEvento {get;set;}
    public Date vencimiento {get;set;}

    public GP_itemMotorDeReglas(String unTitularId, String unSuscriptorId, String unTipoDeEvento, List<GP_AtributoValorDeUnEvento> unasVariables, Integer unNumeroDeOrden){
        constructor(unTitularId, unSuscriptorId, 0, unTipoDeEvento, unasVariables, unNumeroDeOrden);
    }

    public GP_itemMotorDeReglas(String unTitularId, String unSuscriptorId, Double unosPuntos, String unTipoDeEvento, List<GP_AtributoValorDeUnEvento> unasVariables, Integer unNumeroDeOrden){
        constructor(unTitularId, unSuscriptorId, unosPuntos, unTipoDeEvento, unasVariables, unNumeroDeOrden);
    }

    public void constructor(String unTitularId, String unSuscriptorId, Double unosPuntos, String unTipoDeEvento, List<GP_AtributoValorDeUnEvento> unasVariables, Integer unNumeroDeOrden) {
        if(String.isBlank(unTipoDeEvento) || unasVariables == null || String.isBlank(unTitularID)){
            throw new GP_APIException('Los datos tipoDeEvento, idTitular y lista de variables son obligatorios');
        }

        titularID = unTitularId;
        suscriptorID = unSuscriptorId;
        puntos = unosPuntos;
        tipoDeEvento = unTipoDeEvento;
        variablesDelEvento = unasVariables;
        numeroDeOrden = unNumeroDeOrden;
    }

    public void cargarPuntos (Double unosPuntos){
        puntos = unosPuntos;
    }
}