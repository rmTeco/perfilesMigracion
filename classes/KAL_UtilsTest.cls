@isTest
public class KAL_UtilsTest {

    @isTest
    public static void puedoObtenerOrdenActualDelUsuario(){
        
        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);

        Order ordenQueGenero = new Order();
        ordenQueGenero.status = 'Draft';
        ordenQueGenero.vlocity_cmt__originatingchannel__c = 'E-Commerce';
        ordenQueGenero.AccountId = cuenta.id;
        ordenQueGenero.EffectiveDate = date.today();
        insert ordenQueGenero;

        Order orden = KAL_Utils.obtenerOrdenActualDelUsuario(usuario.id);

        System.assertEquals(ordenQueGenero.id, orden.id); 

    }
}