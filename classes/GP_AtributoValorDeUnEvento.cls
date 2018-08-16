public with sharing class GP_AtributoValorDeUnEvento {

    public String variable{get;set;}
    public String tipo{get;set;}
    public Integer valorNumerico {get;set;}
    public Boolean valorBooleano {get;set;}
    public String valorString {get;set;}

    public GP_AtributoValorDeUnEvento(String unaVariable, String tipoDeVariable, Integer unValorNumerico){
        tipo = tipoDeVariable.toLowerCase();
        if(tipo != 'INTEGER'){
            throw new GP_APIException('Solo puede ingresar valores de tipo INTEGER en este constructor.');
        }

        validarVariable(unaVariable);
        validarValor(unValorNumerico);

        valorNumerico = unValorNumerico; 
        variable = unaVariable.toLowerCase();
    }

    public GP_AtributoValorDeUnEvento(String unaVariable, String tipoDeVariable, Boolean unValorBooleano){
        tipo = tipoDeVariable.toLowerCase();
        if(tipo != 'BOOLEAN'){
            throw new GP_APIException('Solo puede ingresar valores de tipo BOOLEAN en este constructor.');
        }

        valorBooleano = unValorBooleano;  
        variable = unaVariable.toLowerCase();
    }

    public GP_AtributoValorDeUnEvento(String unaVariable, String tipoDeVariable, String unValorString){
        tipo = tipoDeVariable.toLowerCase();
        if(tipo != 'STRING'){
            throw new GP_APIException('Solo puede ingresar valores de tipo STRING en este constructor.');
        }

        valorString = unValorString;
        variable = unaVariable.toLowerCase();
    }

    public void validarVariable(String var){
        if(String.isBlank(var)){
            throw new GP_APIException('El nombre de la variable es un valor obligatorio');
        }
    }

    public void validarValor(String var){
        if(String.isBlank(var)){
            throw new GP_APIException('El valor de la variable es obligatorio');
        }
    }

    public void validarValor(Boolean var){
        if(var == null){
            throw new GP_APIException('El valor de la variable es obligatorio');
        }
    }

    public void validarValor(Integer var){
        if(var == null){
            throw new GP_APIException('El valor de la variable es obligatorio');
        }
    }
                
}