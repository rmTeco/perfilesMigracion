@isTest
public with sharing class KAL_carritoControllerTEST {

    // asd
    public static List<String> pbeIds;
    public static Pricebook2 pricebook;
    @isTest
    public static void testCrearOrden() {
        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;

        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);

        System.runAs(usuarioComunidad) {
            // Hacer test aca adentro
            Pricebook2 pricebook = new Pricebook2(
                IsActive = true,
                vlocity_cmt__IsDefault__c = true,
                vlocity_cmt__IsOpportunityDefault__c = false,
                vlocity_cmt__IsOrderDefault__c = true,
                vlocity_cmt__isQuoteDefault__c = true,
                Name = 'TA Price Book'
            );
            insert pricebook;

            // Creo price list
            String idPriceList = KAL_DatosTest.insertar_vlocity_PriceList(pricebook.Id);

            Test.StartTest();
            Map<String, Object> orden = KAL_carritoController.crearOrdenParaCarrito('');
            Test.StopTest();

            Order ordenCreada = [Select Id, OrderNumber, AccountId From Order Limit 1];

            System.assertEquals(ordenCreada.Id, orden.get('IdOrden'));
        }
    }
    @isTest
    public static void testAgregarUnProducto() {

        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;
        
        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        String priceListId = KAL_DatosTest.insertar_vlocity_PriceList(pricebookId);

        Map<String, Object> datos = KAL_DatosTest.insertarProductosYPBEs();

        List<String> PBEsInsertados = (List<String>) datos.get('IdsPBEs');
        String idInsert = PBEsInsertados[0];
        String idPBEBLU = PBEsInsertados[2];
        //System.debug('Datos creados: ' + datos);

        System.runAs(usuarioComunidad) {
            Kal_itemCarrito__c item = new Kal_ItemCarrito__c(
                Price_Book_Entry_Id__c = idPBEBLU,
                Cantidad__c = 1
            );
            insert item;
            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(a.Id, usuarioComunidad.Id, pricebookId, null);
            
            Test.StartTest();
            KAL_carritoController.agregarUnProducto(idInsert);
            Test.StopTest();
        }

        System.AssertEquals(2, [Select Count() From KAL_ItemCarrito__c]);
    }
    @isTest
    public static void testEliminarUnProducto() {
        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;

        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        String priceListId = KAL_DatosTest.insertar_vlocity_PriceList(pricebookId);

        System.runAs(usuarioComunidad) {
            Map<String, Object> datos = KAL_DatosTest.insertarProductosYPBEs();
            pbeIds = new List<String>();
            pbeIds = (List<String>) datos.get('IdsPBEs');

            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(a.Id, usuarioComunidad.Id, pricebookId, null);
            KAL_carritoController.agregarProductos(pbeIds);
            Map<String,Object> result = KAL_carritoController.conseguirCarrito();
            List<Object> productos = (List<Object>) result.get('Productos');
            Map<String,Object> item1 = (Map<String,Object>) productos[0];
            String idItem1 = (String) item1.get('IdItem');

            Test.StartTest();
            KAL_carritoController.eliminarDeCarrito(idItem1);
            Test.StopTest();
        }

        System.AssertEquals(pbeIds.size() - 1 , [Select Count() From KAL_ItemCarrito__c]);
    }
    @isTest
    public static void testConseguirCarrito() {
        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;

        Map<String, Object> result;
        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        String priceListId = KAL_DatosTest.insertar_vlocity_PriceList(pricebookId);

        Map<String, Object> datos = KAL_DatosTest.insertarProductosYPBEs();
        pbeIds = new List<String>();
        pbeIds = (List<String>) datos.get('IdsPBEs');

        System.runAs(usuarioComunidad) {
            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(a.Id, usuarioComunidad.Id, pricebookId, null);
            KAL_carritoController.agregarProductos(pbeIds);

            Test.StartTest();
            result = KAL_carritoController.conseguirCarrito();
            Test.StopTest();
        }
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
    @isTest
    public static void testSumarCantidad() {
        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;
        
        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        String priceListId = KAL_DatosTest.insertar_vlocity_PriceList(pricebookId);

        Map<String, Object> datos = KAL_DatosTest.insertarProductosYPBEs();

        List<String> PBEsInsertados = (List<String>) datos.get('IdsPBEs');
        String idInsert = PBEsInsertados[0];
        String idPBEBLU = PBEsInsertados[2];
        //System.debug('Datos creados: ' + datos);

        Kal_itemCarrito__c item;

        System.runAs(usuarioComunidad) {
            item = new Kal_ItemCarrito__c(
                Price_Book_Entry_Id__c = idPBEBLU,
                Cantidad__c = 1
            );
            insert item;
            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(a.Id, usuarioComunidad.Id, pricebookId, null);

            Test.StartTest();
                KAL_carritoController.sumarCantidad(item.Id);
            Test.StopTest();
        }
        String idAInsertar = item.Id;
        System.assertEquals(2, [Select Id,Cantidad__c From Kal_itemCarrito__c Where Id = :idAInsertar].Cantidad__c);
    }
    @isTest
    public static void testRestarCantidad() {
        Account a = new Account(
            Name = 'prueba Orden'
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;
        
        user usuarioComunidad = KAL_DatosTest.crearUsuarioDeComunidad(a.Id);
        String pricebookId = KAL_DatosTest.insertar_vlocity_PriceBook();
        String priceListId = KAL_DatosTest.insertar_vlocity_PriceList(pricebookId);

        Map<String, Object> datos = KAL_DatosTest.insertarProductosYPBEs();

        List<String> PBEsInsertados = (List<String>) datos.get('IdsPBEs');
        String idInsert = PBEsInsertados[0];
        String idPBEBLU = PBEsInsertados[2];
        //System.debug('Datos creados: ' + datos);

        Kal_itemCarrito__c item;

        System.runAs(usuarioComunidad) {
            item = new Kal_ItemCarrito__c(
                Price_Book_Entry_Id__c = idPBEBLU,
                Cantidad__c = 2
            );
            insert item;
            Order orden = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(a.Id, usuarioComunidad.Id, pricebookId, null);

            Test.StartTest();
                KAL_carritoController.restarCantidad(item.Id);
            Test.StopTest();
        }
        String idAInsertar = item.Id;
        System.assertEquals(1, [Select Id,Cantidad__c From Kal_itemCarrito__c Where Id = :idAInsertar].Cantidad__c);
    }
    @isTest
    public static void testErrorNoPasoParametroIdPriceBook() {
        try {
            Test.StartTest();
            KAL_carritoController.agregarUnProducto('');
            Test.StopTest();
        } catch(Exception ex) {
            system.assertEquals('El parametro PriceBookId es obligatorio y no admite valor nulo.', ex.getMessage());
        }
    }
    @isTest
    public static void testErrorPasoListaVaciaMetodoAgregarProductos() {
        try {
            Test.StartTest();
            KAL_carritoController.agregarProductos(new List<String>());
            Test.StopTest();
        } catch(Exception ex) {
            system.assertEquals('La lista de ids de Pricebook no puede ser nula.', ex.getMessage());
        }
    }

}