public class KAL_compraExitosaController {
 @AuraEnabled
    public static Order getOrdenActualDelUSuario(){
        String userId = UserInfo.getUserId();
        Order userOrden = KAL_utils.obtenerOrdenActualDelUsuario(userId);
        return userOrden; 
    } 

    @AuraEnabled
    public static Map<String, Object> getProductsCart(){
        Map<String, Object> carrito = KAL_carritoController.conseguirCarrito();
        return carrito;
    }
}