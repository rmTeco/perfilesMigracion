Global with sharing class GP_MotorDeReglas {

    //Motor de reglas
    public static List<GP_itemMotorDeReglas> pasarPorLasReglas(List<GP_itemMotorDeReglas> items){

        Set<String> tiposDeEvento = new Set<String>();
        for(GP_itemMotorDeReglas item: items){
            tiposDeEvento.add(item.tipoDeEvento);
        }

        //Traigo todas las reglas activas para ese tipo de evento
        List<GP_Regla__c> reglasActivas = [select id, Valor_resultado_fijo__c, Tipo_de_evento__c, Fecha_vencimiento__c, SeComparaContraElValorFijo__c,
                                           Vencimiento_fecha_fija__c, Dias_vencimiento__c, Operador_calculo__c, Variable_calculo__c, Valor_calculo__c,
                                           (select id, Operador__c, valor_string__c, Valor_entero__c, Valor_Booleano__c, Valor_contra_el_que_se_compara__c, Variable_a_comparar__c
                                           from Condicionales_logicos__r) 
                                           from GP_Regla__c where Tipo_de_evento__c in: tiposDeEvento and activa__c = true];

        system.debug(reglasActivas);
        
        Map<String, List<GP_Regla__c>> reglasActivasPorEvento = new Map<String, List<GP_Regla__c>>();
        for(GP_Regla__c regla: reglasActivas){

            List<GP_Regla__c> listaAGuardar = reglasActivasPorEvento.get(regla.Tipo_de_evento__c.toUpperCase());
            
            if(listaAGuardar == null){
                listaAGuardar = new List<GP_Regla__c>();
                listaAGuardar.add(regla);
                reglasActivasPorEvento.put(regla.Tipo_de_evento__c.toUpperCase(), listaAGuardar);
            }else{
                listaAGuardar.add(regla);
            }
        }

        for(GP_itemMotorDeReglas item: items){
            if( !item.tipoDeEvento.equalsIgnoreCase('Canje') ) {
                WppPuntos wppResultado = calcularPuntosASumar(item.tipoDeEvento, item.variablesDelEvento, reglasActivasPorEvento.get(item.tipoDeEvento.toUpperCase()));  
                system.debug(wppResultado);
                item.puntos = wppResultado.puntos;
                item.idRegla = wppResultado.idRegla;
                item.vencimiento = wppResultado.vencimiento;
            }
        }

        return items;
    }

    private static WppPuntos calcularPuntosASumar(String tipoDeEvento, List<GP_AtributoValorDeUnEvento> variablesDelEvento, List<GP_Regla__c> reglasActivas){

        if(reglasActivas == null){
            reglasActivas = new List<GP_Regla__c>();
            system.debug('no hay reglas para el evento: '+tipoDeEvento);
        }
        
        //Conseguir todas las variables de ese tipo de evento.
        Map<String, GP_AtributoValorDeUnEvento> mapaNombreAtributo = new Map<String, GP_AtributoValorDeUnEvento>(); 
        for(GP_AtributoValorDeUnEvento atr: variablesDelEvento){
            mapaNombreAtributo.put(atr.variable, atr);
        }

        //Evaluo todas las reglas y me quedo con la que cumpla y que mas puntos me de.
        Double PuntosADar = 0;
        String reglaId = '';
        Date fechaVencimiento = Date.today();
        for(GP_Regla__c regla: reglasActivas){
            
            Boolean seCumplenLasCondiciones = true;
            //Por cada regla evaluo que sus condiciones se cumplan, 
            //deben de cumplirse todas las condiciones para considerar que se cumplio una regla.
            system.debug(regla.Condicionales_logicos__r);
            for(GP_Condicional_logico__c condicion: regla.Condicionales_logicos__r){
                
                //consigo el valor de la variable a comparar.
                if(condicion.Variable_a_comparar__c != null || 
                condicion.Valor_contra_el_que_se_compara__c != null || condicion.Operador__c != null ){ 
                    
                    GP_AtributoValorDeUnEvento atributo =  mapaNombreAtributo.get(condicion.Variable_a_comparar__c.toLowerCase());
                    if(atributo == null){
                        throw new GP_APIException('Falta el atributo '+condicion.Variable_a_comparar__c.toLowerCase());
                    }

                    //veo si se cumple la condicion.
                    system.debug(condicion);
                    system.debug(atributo);
                    system.debug(comparar(condicion, atributo));
                    if(!comparar(condicion, atributo)){
                        //Si una de las condiciones ya no cumple, salimos del for seteando que no se cumplen las condiciones.
                        seCumplenLasCondiciones = false;
                        break;
                    }

                }

            }

            //Para cada regla que cumpla, veo si es la que mas puntos da.
            if(seCumplenLasCondiciones){
                if(regla.SeComparaContraElValorFijo__c){
                    
                    if(regla.Valor_resultado_fijo__c > PuntosADar){
                        puntosADar = regla.Valor_resultado_fijo__c;
                        reglaId = regla.id;
                        
                        //Si la fecha es fija o variable.
                        if(regla.Vencimiento_fecha_fija__c){
                            fechaVencimiento = regla.Fecha_vencimiento__c;
                        }else{
                            fechaVencimiento = Date.today().addDays(Integer.valueOf(regla.Dias_vencimiento__c));
                        }
                    }
                //Si el resultado es variable
                }else{
                    
                    if( mapaNombreAtributo.get(regla.Variable_calculo__c.toLowerCase()) == null ){
                        throw new GP_APIException('Error: No existe la variable con nombre '+regla.Variable_calculo__c);
                    }
                    
                    Double puntosVariables = obtenerPuntosDeResultadoVariable( mapaNombreAtributo.get(regla.Variable_calculo__c.toLowerCase()) , 
                                                                            regla.Operador_calculo__c, Integer.valueOf(regla.Valor_calculo__c));

                    if(puntosVariables > puntosADar){
                        puntosADar = puntosVariables;
                        reglaId = regla.id;

                        if(regla.Vencimiento_fecha_fija__c){
                            fechaVencimiento = regla.Fecha_vencimiento__c;
                        }else{
                            fechaVencimiento = Date.today().addDays(Integer.valueOf(regla.Dias_vencimiento__c));
                        }
                    }
                }
            }
        }
        
        return new wppPuntos(puntosADar, reglaId, fechaVencimiento);
    }

    private Static Boolean comparar(GP_Condicional_logico__c condicion, GP_AtributoValorDeUnEvento atributo){
        
        Boolean resultado = false;
        if(atributo.tipo == 'STRING'){
            if(condicion.valor_string__c == null){
                resultado = compararSegunOperador(condicion.Valor_contra_el_que_se_compara__c, condicion.Operador__c, atributo.valorString);
            }else{
                resultado = compararSegunOperador(condicion.valor_string__c, condicion.Operador__c, atributo.valorString);
            }
        }
        
        if(atributo.tipo == 'BOOLEAN'){
            resultado = compararSegunOperador(condicion.Valor_Booleano__c, condicion.Operador__c, atributo.valorBooleano);
        }
        
        if(atributo.tipo == 'INTEGER'){
            system.debug('entre a integer');
            
            system.debug(condicion.Valor_entero__c);
            system.debug(condicion.Operador__c);
            system.debug(atributo.valorNumerico);
            
            resultado = compararSegunOperador(condicion.Valor_entero__c, condicion.Operador__c, atributo.valorNumerico);
        }

        return resultado;
    }
    
    private static Boolean compararSegunOperador(Decimal valorAComparar, String operador, Integer valor){
        
        if(operador == '='){
            return (valorAComparar == valor);
        }

        if(operador == '!='){
            return (valorAComparar != valor);
        }
        
        if(operador == '>'){
            return (valor > valorAComparar);
        }

        if(operador == '<'){
            return (valor < valorAComparar);
        }
        
        if(operador == '>='){
            return (valor > valorAComparar || valorAComparar == valor );
        }
        
        if(operador == '<='){
            return (valor < valorAComparar || valorAComparar == valor );
        }

        return false;
    }
    
    private static Boolean compararSegunOperador(Boolean valorAComparar, String operador, Boolean valor){
        if(operador == '='){
            return (valorAComparar == valor);
        }

        if(operador == '!='){
            return (valorAComparar != valor);
        }

        return false;
    }
    
    private static Boolean compararSegunOperador(String valorAComparar, String operador, String valor){

        if(operador == '='){
            return (valorAComparar == valor);
        }

        if(operador == '!='){
            return (valorAComparar != valor);
        }

        return false;
    }

    public class wppPuntos{
        Double puntos {get;set;}
        String idRegla {get;set;}
        Date vencimiento {get;set;}

        public wppPuntos(Double unosPuntos, String unaRegla, Date unVencimiento){
            puntos = unosPuntos;
            idRegla = unaRegla;
            vencimiento = unVencimiento;
        }
    }

    private static Double obtenerPuntosDeResultadoVariable(GP_AtributoValorDeUnEvento atributoValor, String operador, Integer valor){
        
        system.debug(atributoValor);
        if(atributoValor.tipo != 'Integer'){
            throw new GP_APIException('Error atributo '+atributoValor.variable+': El atributo debe ser de tipo numerico');
        }

        if(operador == '*'){
            return atributoValor.valorNumerico * valor;
        }
        if(operador == '-'){
            return atributoValor.valorNumerico - valor;
        }
        if(operador == '+'){
            return atributoValor.valorNumerico + valor;
        }
        if(operador == '/'){
            return atributoValor.valorNumerico / valor;            
        }
        if(operador == '%'){
            return ((atributoValor.valorNumerico*valor)/100);            
        }

        return 0;
    }
}