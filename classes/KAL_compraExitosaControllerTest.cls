@isTest
public class KAL_compraExitosaControllerTest {

    //public static List<Object> pbeIds;

    @isTest
    public static void getOrdenActualDelUSuarioTest(){
        
        Account cuenta = new Account();
        cuenta.name = 'CompraExitosa';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);
        Order ordenDePrueba = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(cuenta.id,usuario.id,null,null);  /* */

        System.runAs(usuario){
            Test.startTest();
                Order orden = KAL_compraExitosaController.getOrdenActualDelUSuario();
                System.assertEquals(ordenDePrueba.id, orden.id); 
            Test.stopTest();
        }
    }

    @isTest
    public static void getProductsCartTest(){
        
        Account cuenta = new Account();
        cuenta.name = 'CompraExitosa';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        
        System.runAs(usuario){

            Map<String, Object> productos2 = KAL_DatosTest.insertarProductosYPBEs();
        
            List<String> pbeIds= (List<String>) productos2.get('IdsPBEs');

            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(cuenta.Id, usuario.Id, pricebookId, null);
            KAL_carritoController.agregarProductos(pbeIds);

            Test.startTest();
                Map<String, Object> result = KAL_compraExitosaController.getProductsCart();
            Test.stopTest();

            List<Object> productos = (List<Object>) result.get('Productos');
            Map<String,Object> item1 = (Map<String,Object>) productos[0];
            Map<String,Object> item2 = (Map<String,Object>) productos[1];

            System.assertEquals(1, (Integer) item1.get('Cant'));
            System.assertEquals(2, (Integer) item2.get('Cant'));

            System.assertEquals(13500, (Double) item1.get('Price'));
            System.assertEquals(20500, (Double) item2.get('Price'));

            System.assertEquals(13500, (Double) item1.get('TotalPrice'));
            System.assertEquals(41000, (Double) item2.get('TotalPrice'));
        
       
           
        }       

        
        
        
        
        
        
    }

}