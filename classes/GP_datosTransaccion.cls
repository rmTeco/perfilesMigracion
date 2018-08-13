public with sharing class GP_datosTransaccion {

    public String reglaId {get;set;}
    public String titularID {get;set;}
    public String suscriptorID {get;set;}
    public Double puntos {get;set;}
    public String operacion {get;set;}
    public String tipoEvento {get;set;}
    public Integer numeroDeOrden {get;set;}
    public Date vencimiento {get;set;}

    public GP_datosTransaccion(String unaReglaId, String unTitularID, String unSuscriptorID, Double datoPuntos, String unaOperacion, String unTipoEvento, Integer unNumeroDeOrden, Date unVencimiento){
        constructor(unaReglaId, unTitularID, unSuscriptorID, datoPuntos, unaOperacion, unTipoEvento, unNumeroDeOrden, unVencimiento);
    }

    public GP_datosTransaccion(String unaReglaId, String unTitularID, String unSuscriptorID, Double datoPuntos,  String unTipoEvento, Integer unNumeroDeOrden, Date unVencimiento){

        if(unTipoEvento == 'Consumo' || unTipoEvento == 'Canje'){
            constructor(unaReglaId,unTitularID, unSuscriptorID,datoPuntos,'Resta',unTipoEvento,unNumeroDeOrden,unVencimiento); 
        }else{
            if(datoPuntos>=0){
                constructor(unaReglaId,unTitularID, unSuscriptorID,datoPuntos,'Suma',unTipoEvento,unNumeroDeOrden,unVencimiento);
            }else{
                constructor(unaReglaId,unTitularID, unSuscriptorID,datoPuntos*-1,'Resta',unTipoEvento,unNumeroDeOrden,unVencimiento); 
            }
        }

    }

    public void constructor(String unaReglaId, String unTitularID, String unSuscriptorID, Double datoPuntos, String unaOperacion, String unTipoEvento, Integer unNumeroDeOrden, Date unVencimiento){
        
        /*if ( String.isBlank(unaReglaId) ) {
            throw new GP_Saldos_TransaccionesException('El Id de regla es obligatorio y no acepta valor nulo');
        }*/
        
        if ( String.isBlank(unTitularID) ) {
            throw new GP_Saldos_TransaccionesException('El Id de titular es obligatorio y no acepta valor nulo');
        }
        if (datoPuntos < 0) {
            throw new GP_Saldos_TransaccionesException('Los puntos a sumar o restar deben ser mayores o iguales a cero.');
        }
        if (unaOperacion != 'Suma' && unaOperacion != 'Resta') {
            throw new GP_Saldos_TransaccionesException('Las posibles operaciones son la Suma o la Resta de puntos.');
        }

        reglaId = unaReglaId;
        titularID = unTitularID;
        suscriptorID = unSuscriptorID;
        puntos = datoPuntos;
        operacion = unaOperacion;
        tipoEvento = unTipoEvento;
        numeroDeOrden = unNumeroDeOrden;
        vencimiento = unVencimiento;
    }
}