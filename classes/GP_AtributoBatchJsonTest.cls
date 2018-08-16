@isTest
public class GP_AtributoBatchJsonTest {
    
    static testMethod void crearAtributoBatch(){
        GP_AtributoBatchJson atr = new GP_AtributoBatchJson();
        atr.listaDeAtributos = new list<GP_AtributoBatchJson.gp_atributos>();
        
        GP_AtributoBatchJson.gp_atributos nuevo = new GP_AtributoBatchJson.gp_atributos();
        nuevo.NombreDelAtributo = 'a';
        nuevo.TipoDeAtributo = 'b';
        nuevo.Valor = 'c';
    }
}