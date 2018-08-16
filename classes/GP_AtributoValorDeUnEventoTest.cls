@isTest
public class GP_AtributoValorDeUnEventoTest {
    
    static testMethod void crearUnAtributoValor(){
        GP_AtributoValorDeUnEvento nuevoAtributo;
        
        nuevoAtributo = new GP_AtributoValorDeUnEvento('a','String', 'string');
        nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Boolean', true);
        nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Integer', 20);
        
        try{
            Boolean un;
            Integer dos;
            
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','String', '');
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Boolean', un);
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Integer', dos);
            
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','String', 20);
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Boolean', 20);
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Integer', true);
            
        }catch(GP_APIException e){
            
        }
        
        try{
            Boolean uno = null;
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Integer', 20);
            nuevoAtributo.validarValor(uno);
        }catch(GP_APIException e){
            
        }
        
        try{
            Integer uno = null;
            nuevoAtributo = new GP_AtributoValorDeUnEvento('a','Integer', 20);
            nuevoAtributo.validarValor(uno);
        }catch(GP_APIException e){
            
        }
        
    }
}