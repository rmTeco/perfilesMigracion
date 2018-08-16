public class Kal_ConfirmationData {
    
    @AuraEnabled
    public static Map<String, Object> getProductsCart(){
      Map<String, Object> carrito = KAL_carritoController.conseguirCarrito();
      List<Object> producto = (List<Object>) carrito.get('Productos');
      return carrito;
    }    
}