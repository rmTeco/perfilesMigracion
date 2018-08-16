@isTest
public with sharing class Kal_ConfirmationDataTest {
    
    public static List<String> pbeIds;
    public static Pricebook2 pricebook;

    public static void insertarDatos() {
        pbeIds = new List<String>();
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        Product2 prod = new Product2(
            Name = 'Samsung j7',
            IsActive = true
        );
        insert prod;
        Product2 prod2 = new Product2(
            Name = 'Samsung s7',
            IsActive = true
        );
        insert prod2;

        // Creo Standard Price
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry stdPBE = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            isActive = true,
            UnitPrice = 13000
        );
        PricebookEntry stdPBE2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod2.Id,
            isActive = true,
            UnitPrice = 20000
        );
        List<PricebookEntry> stdPBEList = new List<PricebookEntry>();
        stdPBEList.add(stdPBE);
        stdPBEList.add(stdPBE2);
        insert stdPBEList;
        
        pricebook = new Pricebook2(
            IsActive = true,
            Name = 'TA Price Book'
        );
        insert pricebook;
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebook.Id,
            Product2Id = prod.Id,
            UseStandardPrice = false,
            isActive = true,
            UnitPrice = 13500
        );
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = pricebook.Id,
            Product2Id = prod2.Id,
            isActive = true,
            UseStandardPrice = false,
            UnitPrice = 20500
        );
        pbeList.add(pbe);
        pbeList.add(pbe2);
        insert pbeList;

        for(PricebookEntry pb : pbeList) {
            pbeIds.add(pb.Id);
        }
        if(pbeList.size() > 0) {
            pbeIds.add(pbeList[1].Id);
        }
    }

    @isTest
    public static void testAgregarUnProducto() {
        insertarDatos();
        String idInsert = pbeIds[0];

        Test.StartTest();
        KAL_carritoController.agregarUnProducto(idInsert);
        Test.StopTest();

        System.AssertEquals(1, [Select Count() From KAL_ItemCarrito__c]);
    }
    
    @isTest
    public static void testErrorSinProducto() {
        try {
            Test.StartTest();
            KAL_carritoController.agregarUnProducto('1');
            Test.StopTest();
        } catch(Exception ex) {
            system.assertEquals('No se encontró el producto en las listas de catálogo.', ex.getMessage());
        }
    }
    
    @isTest
    public static void testErrorSinPriceBook() {
        try {
            insertarDatos();
            Test.StartTest();
            pbeIds.add('unIdIncorrecto');
            KAL_carritoController.agregarProductos(pbeIds);
            Test.StopTest();
        } catch(Exception ex) {
            system.assertEquals('** No se encontró PriceBook Entry de Id: "unIdIncorrecto" ', ex.getMessage());
        }
    }

}