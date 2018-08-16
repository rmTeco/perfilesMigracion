public with sharing class KAL_carritoController {
    @AuraEnabled
    public static void agregarUnProducto(String PriceBookId) {
        try{
            if(!String.isBlank(PriceBookId)) {
                List<String> idsPBE = new List<String>();
                idsPBE.add(PriceBookId);
                agregarProductos(idsPBE);
            } else {
                throw new kal_exception('El parametro PriceBookId es obligatorio y no admite valor nulo.');
            }
        }catch(Exception ex) {
            System.debug(ex.getStackTraceString() + ' :- ' + ex.getMessage());
            throw new kal_exception(ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
    @AuraEnabled
    public static void agregarProductos(List<String> idsPBE) {
        try{
            if(idsPBE == null || idsPBE.size() == 0) {
                throw new kal_exception('La lista de ids de Pricebook no puede ser nula.');
            }
            Map<String,Object> mapProd = new Map<String,Object>();
            Set<String> setPBEIds = new Set<String>();
            Set<String> idsProducts = new Set<String>();
            String error = '';
            String uId = UserInfo.getUserId();

            Map<String, KAL_ItemCarrito__c> mapItems = new Map<String, KAL_ItemCarrito__c>();
            List<KAL_ItemCarrito__c> itemsExistentes = [
                Select Id, Price_book_entry_id__c, Cantidad__c
                From KAL_ItemCarrito__c
                Where ownerId = :uId
            ];
            Map<String,Integer> cantidadAnterior = new Map<String,Integer>();
            if(itemsExistentes.size() > 0) {
                for(KAL_ItemCarrito__c item : itemsExistentes) {
                    if(!mapItems.containsKey(item.Price_book_entry_id__c)) {
                        mapItems.put(
                            item.Price_book_entry_id__c,
                            item
                        );
                    }
                }
            }
            
            List<PricebookEntry> PBEs = [
                Select Id,IsActive,Pricebook2Id,Product2Id,UnitPrice 
                From PricebookEntry 
                Where Id In :idsPBE 
                And Pricebook2.Name = 'TA Price Book' 
                And isActive = true
            ];

            if(PBEs.size() > 0) {
                for(PricebookEntry PBE : PBEs) {
                    if(!setPBEIds.contains(PBE.Id)) {
                        setPBEIds.add(PBE.Id);
                    }
                }
                List<KAL_ItemCarrito__c> itemCarrito = new List<KAL_ItemCarrito__c>();
                // Creo items y los agrego a la lista a insertar

                for(String IdPBE : idsPBE) {
                    if(!setPBEIds.contains(IdPBE)) {
                        error += '** No se encontró PriceBook Entry de Id: "' + IdPBE + '" ';
                        break;
                    }
                    KAL_ItemCarrito__c item = new KAL_ItemCarrito__c();
                    Integer cantidad = 1;

                    if(!mapItems.containsKey(IdPBE)) {
                        mapItems.put(IdPBE, item);
                        item.Price_Book_Entry_Id__c = IdPBE;
                    } else {
                        item = mapItems.get(IdPBE);
                        cantidad = item.Cantidad__c.intValue();
                        cantidad++;
                    }

                    item.Cantidad__c = cantidad;
                }
                itemCarrito = mapItems.values();

                // Agrego el producto a la orden
                List<String> listaIds = new List<String>();
                listaIds.addAll(setPBEIds);
                Order orden = KAL_utils.obtenerOrdenActualDelUsuario(uId);
                if(orden.Id == null) {
                    throw new kal_exception('Orden no encontrada');
                }
                KAL_utils.agregarProductosAOrden(orden.Id, listaIds);
                
                upsert itemCarrito;
                if(error != '') {
                    throw new kal_exception(error);
                }
            } else {
                throw new kal_exception('No se encontró el producto en las listas de catálogo.');
            }
        }catch(Exception ex) {
            System.debug(ex.getStackTraceString() +  ' --- ' + ex.getLineNumber() + ' :- ' + ex.getMessage());
            throw new kal_exception(ex.getStackTraceString() +  ' --- ' + ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
    @AuraEnabled
    public static Map<String, Object> conseguirCarrito() {
        try{
            Map<String,Object> mapProd = new Map<String,sObject>();
            Map<String,Object> mapPBEs = new Map<String,sObject>();
            Set<String> idsProducts = new Set<String>();
            Set<String> idsPBEs = new Set<String>();
            Double subtotal = 0;

            // Consigo el usuario logueado a la comunidad
            String uId = UserInfo.getUserId();

            // Consigo los items en el carrito del usuario
            List<KAL_ItemCarrito__c> itemsCarrito = [
                Select Id,OwnerId,Cantidad__c,Price_Book_Entry_Id__c
                From KAL_ItemCarrito__c
                Where OwnerId = :uId
                Order By CreatedDate ASC
            ];
            for(KAL_ItemCarrito__c item : itemsCarrito) {
                if(!idsPBEs.contains(item.Price_Book_Entry_Id__c)) {
                    idsPBEs.add(item.Price_Book_Entry_Id__c);
                }
            }

            // Consigo el precio de c/prod mediante el Pricebook Entry
            List<PricebookEntry> PBEs = [
                Select Id,IsActive,Pricebook2Id,Product2Id,UnitPrice 
                From PricebookEntry 
                Where Id In :idsPBEs 
                And Pricebook2.Name = 'TA Price Book' 
                And isActive = true
            ];
            for(PricebookEntry pbe : PBEs) {
                if(!mapPBEs.containsKey(pbe.ID)) {
                    mapPBEs.put(pbe.Id, pbe);
                }
                if(!idsProducts.contains(pbe.Product2Id)) {
                    idsProducts.add(pbe.Product2Id);
                }
            }
            
            List<Product2> productos = [Select Id, Name From Product2 Where Id In :idsProducts];
            for(Product2 prod : productos) {
                if(!mapProd.containsKey(prod.Id)) {
                    mapProd.put(prod.Id, prod);
                }
            }

            Map<String, Object> ordenActual = crearOrdenParaCarrito(uId); //IdOrden
            String IdOrden = (String) ordenActual.get('IdOrden');

            Map<String, OrderItem> mapOrderItems = KAL_utils.conseguirPrecios(IdOrden);

            // Recorro los items y genero la lista
            Map<String,Object> mapItem;
            Map<String,Object> mapIdItem = new Map<String,Object>();

            Integer cantidad = 0;
            for(KAL_ItemCarrito__c item : itemsCarrito) {
                mapItem = new Map<String,Object>();
                PricebookEntry PBE = (PricebookEntry) mapPBEs.get(item.Price_Book_Entry_Id__c);
                Product2 prod = (Product2) mapProd.get(PBE.Product2Id);
                OrderItem itemDeOrden = new OrderItem();
                if(mapOrderItems.containsKey(PBE.Id)) {
                    itemDeOrden = mapOrderItems.get(PBE.Id);
                }

                cantidad = item.Cantidad__c.intValue();
                
                mapItem.put('Name', prod.Name);
                mapItem.put('IdProd', prod.Id);
                mapItem.put('IdPBE', PBE.Id);
                mapItem.put('IdItem', item.Id);
                mapItem.put('Cant', cantidad);
                mapItem.put('Price', itemDeOrden.vlocity_cmt__EffectiveOneTimeTotal__c);
                mapItem.put('TotalPrice', cantidad * itemDeOrden.vlocity_cmt__EffectiveOneTimeTotal__c);
                mapItem.put('flagDeshacer', false);

                subtotal += (Double) mapItem.get('TotalPrice');

                mapIdItem.put(prod.Id, mapItem);
            }

            Map<String, Object> mapRetorno = new Map<String, Object>();
            mapRetorno.put('Productos', mapIdItem.values());
            mapRetorno.put('Subtotal', subtotal);

            return mapRetorno;
        }catch(Exception ex) {
            System.debug(ex.getStackTraceString() + ' :- ' + ex.getMessage());
            throw new kal_exception(ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
    @AuraEnabled
    public static void eliminarDeCarrito(String IdItem) {
        try{
            String uId = UserInfo.getUserId();
            List<KAL_ItemCarrito__c> itemC = [Select Id, Price_book_entry_id__c From KAL_ItemCarrito__c Where OwnerId =: uId And Price_book_entry_id__c =: IdItem Limit 1];
            if(itemC.size() > 0) {
                String pbdId = itemC[0].Price_book_entry_id__c;
                delete itemC;

                Order orden = KAL_utils.obtenerOrdenActualDelUsuario(uId);
                if(orden != null) {
                    Map<String, OrderItem> itemsEnOrden = KAL_Utils.conseguirPrecios(orden.Id);
                    if(itemsEnOrden.values().size() > 0) {
                        if(itemsEnOrden.containsKey(pbdId)) {
                            OrderItem itemOrdenEliminar = itemsEnOrden.get(pbdId);
                            delete itemOrdenEliminar;
                        }
                    }
                }
            }
        }catch(Exception ex) {
            System.debug(ex.getStackTraceString() + ' :- ' + ex.getMessage());
            throw new kal_exception(ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
    @AuraEnabled
    public static Map<String,Object> crearOrdenParaCarrito(String userId) {
        try {
            if(String.isBlank(userId)) {
                userId = UserInfo.getUserId();
            }
            String orderId = '';
            Map<String,Object> precios = new Map<String,Object>();
            Map<String,Object> response = new Map<String,Object>();
            
            Order orden = new order();
            orden = KAL_utils.obtenerOrdenActualDelUsuario(userId);
            // Si no existe la creo.
            if(orden == new order()) {
                orderId = KAL_utils.crearOrden(userId);
                //agregarProductoEnvioStandard(orderId);
                orden = KAL_utils.obtenerOrdenActualDelUsuario(userId);
            }
            // Si sigue sin existir entonces hubo un error insertando una nueva.
            if(orden == null) {
                throw new kal_exception('No se pudo crear la orden y no existe una previa.');
            }
            if(String.isBlank(orderId)) {
                orderId = orden.Id;
            }
            response.put('IdOrden', orderId);
            response.put('AccountId', orden.AccountId);
            if(orden.OneTimeTotal_w_Tax__c != null) {
                response.put('OneTimeTotal_w_Tax__c', orden.OneTimeTotal_w_Tax__c);
            }
            response.put('OrderNumber', orden.OrderNumber);
            precios = KAL_utils.conseguirPrecios(orderId);
            if(precios != null){
                response.put('Precios', precios);
            }
            return response;
        } catch(Exception ex) {
            System.debug(ex.getStackTraceString() + ' :- ' + ex.getMessage());
            throw new kal_exception(ex.getLineNumber() + ' :- ' + ex.getMessage());
        }
    }
    //Inicio Kal-93
    @AuraEnabled
    public static void restarCantidad(String IdItem){
    	
        String uId = UserInfo.getUserId();
   
        List<KAL_ItemCarrito__c> itemC = [
            SELECT Id, Cantidad__c
            FROM KAL_ItemCarrito__c
            WHERE OwnerId =: uId AND Id =: IdItem LIMIT 1
        ];
        
        for(KAL_ItemCarrito__c myItemCar : itemC)
        {
        	Decimal cantidad = 0;
            cantidad = myItemCar.Cantidad__c;
        	cantidad -= 1;
        	myItemCar.Cantidad__c = cantidad;
        }
        
        update itemC;
    }  
    @AuraEnabled
    public static void sumarCantidad(String IdItem){

        String uId = UserInfo.getUserId();
        
        List<KAL_ItemCarrito__c> itemC = [
            SELECT Id, Cantidad__c
            FROM KAL_ItemCarrito__c
            WHERE OwnerId =: uId AND Id =: IdItem LIMIT 1
        ];
        
        for(KAL_ItemCarrito__c myItemCar : itemC)
        {
        	Decimal cantidad = 0;
            cantidad = myItemCar.Cantidad__c;
        	cantidad += 1;
        	myItemCar.Cantidad__c = cantidad;
        }
        
        update itemC;
    }
    //Fin Kal-93
    
}