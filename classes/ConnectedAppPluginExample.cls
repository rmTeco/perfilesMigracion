global class ConnectedAppPluginExample extends Auth.ConnectedAppPlugin{
    global override Map<String,String> customAttributes(Id userId, Map<String,String> formulaDefinedAttributes) 
    {  
        
        //Acá iría la consulta a las líneas de la cuenta basado en el userId que viene como parámetro
        //
        //
         
        //Ejemplo devolviendo 1 atributo
        formulaDefinedAttributes.put('AtributoCliente','Valor Atributo Cliente');
        
        //Ejemplo devolviendo 4 Líneas
        String custlineas = '[';
           
       for (Integer i = 0; i < 4; i++) 
        {
            formulaDefinedAttributes.put('LineasCliente' + String.valueOf(i), '11 9901 045' + String.valueOf(i));
        }
        custlineas += ']';
        
        //Set Resultado
        return formulaDefinedAttributes;
    } 
}