public with sharing class GP_socioAAdherir {

    public String idCuenta {get;set;}
    public String idCuentaTitular {get;set;}
    public List<String> assets {get;set;}
    public String tipoDeSocio {get;set;}
    public String idGp {get;set;}


    public gp_socioAAdherir(String unIdCuenta, String cuentaTitular, List<String> unosAssets){
        if(unIdCuenta == null || cuentaTitular == null){
            throw new GP_APIException('Los datos idCuenta y cuentaTitular son obligatorios.');
        }

        idCuenta = unIdCuenta;
        idCuentaTitular = cuentaTitular;  
        assets = unosAssets;
        
        if(cuentaTitular == '0' || String.isBlank(cuentaTitular)){
            tipoDeSocio = 'Titular';
            cuentaTitular = '0';
        }else{
            tipoDeSocio = 'Adherente';
        }
        
        idGp = unIdCuenta+cuentaTitular;   
    }
}