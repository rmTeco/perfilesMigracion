public class KAL_resumen_productos_controller {
	
	//Select Id, Name From Product2 Where Id ='01t6C000000a3H4'
    //Select IsActive,Pricebook2Id,Product2Id,UnitPrice From PricebookEntry Where Product2Id = :prod.Id And Pricebook2.Name = 'TA Price Book' And isActive = true Limit 1
    //Ids de productos que voy a harcodear: 01t6C000000a3GV 01t6C000000a3H4
	@AuraEnabled
    public String dir {get{return 'no';}set{dir = 'hola';}}
    
    @AuraEnabled
    public static List<Map<String,String>> getProducts() {
        List<String> losId = new List<String>();
        losId.add('01t6C000000a3GV');
        losId.add('01t6C000000a3H4');
        List<Product2> losProductos = [Select Id, Name From Product2 Where Id In :losId];
        List<Map<String,String>> listaFinal = new List<Map<String,String>>();
        Map<String,String> infoProd = new Map<String,String>();
        for(Product2 prod : losProductos){
            infoProd.clear();
            Decimal precioUnitario = [
                        Select IsActive,Pricebook2Id,Product2Id,UnitPrice 
                        From PricebookEntry 
                        Where Product2Id = :prod.Id 
                        And Pricebook2.Name = 'TA Price Book' 
                        And isActive = true 
                        Limit 1
                    ].UnitPrice;
            String precio = String.valueOf(precioUnitario);
            infoProd.put('Id', prod.Id);
            infoProd.put('Name', prod.Name);
            infoProd.put('Precio', precio);
            listaFinal.add(infoProd);
        }
        return listaFinal;
    }
    
    @AuraEnabled
    public static Map<String,String> getOneProduct() {
        List<String> losId = new List<String>();
        losId.add('01t6C000000a3H4');
        Product2 prod = [Select Id, Name From Product2 Where Id = '01t6C000000a3H4'];
        Map<String,String> infoProd = new Map<String,String>();
        Decimal precioUnitario = [
                        Select IsActive,Pricebook2Id,Product2Id,UnitPrice 
                        From PricebookEntry 
                        Where Product2Id = '01t6C000000a3H4' 
                        And Pricebook2.Name = 'TA Price Book' 
                        And isActive = true 
                        Limit 1
                    ].UnitPrice;
        String precio = String.valueOf(precioUnitario);
        infoProd.put('Id', prod.Id);
        infoProd.put('Name', prod.Name);
        infoProd.put('Precio', precio);
        
        return infoProd;
    }
    
    @AuraEnabled
    public static List<Map<String,String>> getProductsPrueba() {
        
        Product2 prod = [Select Id, Name From Product2 Where Id = '01t6C000000a3H4'];
    
        List<Map<String,String>> listaFinal = new List<Map<String,String>>();
        Map<String,String> infoProd = new Map<String,String>();
        Decimal precioUnitario = [
                    Select IsActive,Pricebook2Id,Product2Id,UnitPrice 
                    From PricebookEntry 
                    Where Product2Id = :prod.Id 
                    And Pricebook2.Name = 'TA Price Book' 
                    And isActive = true 
                    Limit 1
                ].UnitPrice;
        String precio = String.valueOf(precioUnitario);
        infoProd.put('Id', prod.Id);
        infoProd.put('Name', prod.Name);
        infoProd.put('Precio', precio);
        listaFinal.add(infoProd);
    
        return listaFinal;
    }
    
    @AuraEnabled
    public static Integer getSubtotal() {
        
        Map<String,String> prod = getOneProduct();
        String precio = prod.get('Precio');
        Integer res = Integer.valueof(precio);
        return res;
        
    }
    
    @AuraEnabled
    public static Map<String,String> getUserComunidad() {
        //Me conviene devolver un map
        Map<String,String> datosUsuarioComu = new Map<String,String>();
        
        String uId = UserInfo.getUserId();
        User usuarioComu = [Select Id, Name, AccountId From User Where Id =: uId];
        String accId = usuarioComu.AccountId; //0016C000009IHAhQAO
        //Select Id, Name, AccountId From User Where Id = '0056C000000tuzB'
        //Select Id, Name, BillingStreet, BillingState, BillingCity, BillingPostalCode From Account Where Id = '0016C000009IHAhQAO'
        Account cuentaUsuario = [Select BillingStreet, BillingState, BillingCity, BillingPostalCode From Account Where Id =: accId];
        String laStreet = cuentaUsuario.BillingStreet;
        List<String> streetList = laStreet.split(' ');
        Integer tam = streetList.size();
        Integer i = 0;
        String lleca = '';
        while(i < tam-1){
            //acá teniendo en cuenta que la lista como mínimo va a tener tamaño 2
            //ya que va a tener una calle de una palabra y un número como mínimo
            lleca = lleca + ' ' + streetList[i];
            i++;
        }
        String numero = streetList[tam-1];
        datosUsuarioComu.put('Calle', lleca);
        datosUsuarioComu.put('Numero',numero);
        datosUsuarioComu.put('Provincia',cuentaUsuario.BillingCity);
        datosUsuarioComu.put('Localidad',cuentaUsuario.BillingState);
        datosUsuarioComu.put('CodigoPostal', cuentaUsuario.BillingPostalCode);
        //dir = 'datosUsuarioComu.values()[0]';
        return datosUsuarioComu;
        
      
    }
     
}