@isTest
public class KAL_PagoTest {

    @isTest 
    public static void consigoLasPromocionesFinancieras(){
        
        test.startTest();
        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);

        Product2 producto = new Product2();
        producto.name = 'hola';
        insert producto;

        Pricebook2 libroPrecio = new Pricebook2();
        libroPrecio.name = 'lista precio';
        insert libroprecio;
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pb.Id, 
                                    Product2Id = producto.Id, UnitPrice = 10000, IsActive = true, 
                                    UseStandardPrice = false);
        insert standardPrice;

        PricebookEntry entradaLibroPrecio = new PricebookEntry();
        entradaLibroPrecio.unitPrice = 123;
        entradaLibroPrecio.Pricebook2Id = libroPrecio.id;
        entradaLibroPrecio.Product2Id = producto.id;
        entradaLibroPrecio.IsActive = true;
        insert entradaLibroPrecio;

        ID rcoriginStore = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();

        vlocity_cmt__BusinessSite__c originStore = new vlocity_cmt__BusinessSite__c();
        originStore.Channel_Type_3__c = 'E-Commerce';
        originStore.Channel_Type_2__c = 'E-Commerce';
        originStore.Channel_Type__c = 'E-Commerce';
        originStore.Channel__c = 'Digital';
        originStore.recordTypeId = rcoriginStore;
        originStore.vlocity_cmt__OrganizationId__c = cuenta.id;
        insert originStore;

        
        Order ordenQueGenero = KAL_DatosTest.crearUnaOrdenDraftParaElUsuario(cuenta.id, usuario.id, libroPrecio.id, originStore.id);
        /*
        Order ordenQueGenero = new Order();
        ordenQueGenero.Pricebook2Id = libroPrecio.id;
        ordenQueGenero.status = 'Draft';
        ordenQueGenero.OriginStoreLocation__c = originStore.id;
        ordenQueGenero.vlocity_cmt__originatingchannel__c = 'E-Commerce';
        ordenQueGenero.AccountId = cuenta.id;
        ordenQueGenero.EffectiveDate = date.today();
        insert ordenQueGenero;
        */
        
        OrderItem oitem = new OrderItem();
        oitem.Product2id = producto.id;
        oitem.Orderid = ordenQueGenero.id;
        oitem.PricebookEntryId = entradaLibroPrecio.id; 
        oitem.Quantity = 1;
        oitem.unitPrice = 123;
        insert oitem;

        ID rc = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();

        system.debug('id record type credit card -- '+rc);

        FinancialPromotion__c promocion = new FinancialPromotion__c();
        promocion.BankEntities__c = '407';//AMERICAN EXPRESS
        promocion.RecordTypeid = rc;
        promocion.CreditCards__c = '405';//CABAL
        promocion.Instalment__c = '12';
        promocion.From__c = date.today().addDays(-1);
        promocion.to__c = date.today().addDays(+1);
        promocion.ChannelPromotion__c = 'Digital';
        promocion.ProductPromotion__c = producto.id;
        promocion.PromotionStatus__c = 'Vigente';
        insert promocion;

        test.stopTest();

        system.runAs(usuario){
            String jsonObtenido = KAL_PagoController.conseguirPromocionesFinancieras();

            system.debug(jsonObtenido);

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonObtenido);

            List<Object> Options = (List<Object>)m.get('options');        

            system.assertEquals(options.size(),1);

            Map<String, Object> opciones1 = (Map<String,Object>) options[0];

            system.assertEquals((String)opciones1.get('BankEntities__c'),'AMERICAN EXPRESS');
            system.assertEquals((String)opciones1.get('CreditCards__c'),'CABAL');
        }
    }

    @isTest 
    public static void consigoLasPromocionesFinancierasGenericas(){
        
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

        ID rc = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();

        system.debug('id record type credit card -- '+rc);

        FinancialPromotion__c promocion2 = new FinancialPromotion__c();
        promocion2.BankEntities__c = '407';//AMERICAN EXPRESS
        promocion2.RecordTypeid = rc;
        promocion2.CreditCards__c = '522';//CABAL
        promocion2.Instalment__c = '12';
        promocion2.From__c = date.today().addDays(-1);
        promocion2.to__c = date.today().addDays(+1);
        promocion2.ChannelPromotion__c = 'MVNO';
        promocion2.PromotionStatus__c = 'Vigente';
        insert promocion2;

        FinancialPromotion__c promocion = new FinancialPromotion__c();
        promocion.BankEntities__c = '407';//AMERICAN EXPRESS
        promocion.RecordTypeid = rc;
        promocion.CreditCards__c = '405';//CABAL
        promocion.Instalment__c = '12';
        promocion.From__c = date.today().addDays(-1);
        promocion.to__c = date.today().addDays(+1);
        promocion.ChannelPromotion__c = null;
        //promocion.PaymentMethodPromotion__c = '2001';
        promocion.PromotionStatus__c = 'Vigente';
        insert promocion;

        system.runAs(usuario){
            String jsonObtenido = KAL_PagoController.conseguirPromocionesFinancieras();

            system.debug(jsonObtenido);

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonObtenido);

            List<Object> Options = (List<Object>)m.get('options');        

            system.assertEquals(options.size(),1);

            Map<String, Object> opciones1 = (Map<String,Object>) options[0];

            system.assertEquals((String)opciones1.get('BankEntities__c'),'AMERICAN EXPRESS');
            system.assertEquals((String)opciones1.get('CreditCards__c'),'CABAL');
        }
    }

    @isTest 
    public static void consigoLasPromocionesFinancierasYGenericasAlMismoTiempo(){
        
        test.startTest();
        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);

        Product2 producto = new Product2();
        producto.name = 'hola';
        insert producto;

        Pricebook2 libroPrecio = new Pricebook2();
        libroPrecio.name = 'lista precio';
        insert libroprecio;
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pb.Id, 
                                    Product2Id = producto.Id, UnitPrice = 10000, IsActive = true, 
                                    UseStandardPrice = false);
        insert standardPrice;

        PricebookEntry entradaLibroPrecio = new PricebookEntry();
        entradaLibroPrecio.unitPrice = 123;
        entradaLibroPrecio.Pricebook2Id = libroPrecio.id;
        entradaLibroPrecio.Product2Id = producto.id;
        entradaLibroPrecio.IsActive = true;
        insert entradaLibroPrecio;

        ID rcoriginStore = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();

        vlocity_cmt__BusinessSite__c originStore = new vlocity_cmt__BusinessSite__c();
        originStore.Channel_Type_3__c = 'E-Commerce';
        originStore.Channel_Type_2__c = 'E-Commerce';
        originStore.Channel_Type__c = 'E-Commerce';
        originStore.Channel__c = 'Digital';
        originStore.recordTypeId = rcoriginStore;
        originStore.vlocity_cmt__OrganizationId__c = cuenta.id;
        insert originStore;

        Order ordenQueGenero = new Order();
        ordenQueGenero.Pricebook2Id = libroPrecio.id;
        ordenQueGenero.status = 'Draft';
        ordenQueGenero.OriginStoreLocation__c = originStore.id;
        ordenQueGenero.vlocity_cmt__originatingchannel__c = 'E-Commerce';
        ordenQueGenero.AccountId = cuenta.id;
        ordenQueGenero.EffectiveDate = date.today();
        insert ordenQueGenero;

        OrderItem oitem = new OrderItem();
        oitem.Product2id = producto.id;
        oitem.Orderid = ordenQueGenero.id;
        oitem.PricebookEntryId = entradaLibroPrecio.id; 
        oitem.Quantity = 1;
        oitem.unitPrice = 123;
        insert oitem;

        ID rc = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();

        system.debug('id record type credit card -- '+rc);

        FinancialPromotion__c promocion = new FinancialPromotion__c();
        promocion.BankEntities__c = '407';//AMERICAN EXPRESS
        promocion.RecordTypeid = rc;
        promocion.CreditCards__c = '405';//CABAL
        promocion.Instalment__c = '12';
        promocion.From__c = date.today().addDays(-1);
        promocion.to__c = date.today().addDays(+1);
        promocion.ChannelPromotion__c = 'Digital';
        promocion.ProductPromotion__c = producto.id;
        promocion.PromotionStatus__c = 'Vigente';
        insert promocion;

        FinancialPromotion__c promocionGenerica = new FinancialPromotion__c();
        promocionGenerica.BankEntities__c = '522';
        promocionGenerica.RecordTypeid = rc;
        promocionGenerica.CreditCards__c = '405';//CABAL
        promocionGenerica.Instalment__c = '12';
        promocionGenerica.From__c = date.today().addDays(-1);
        promocionGenerica.to__c = date.today().addDays(+1);
        promocionGenerica.ChannelPromotion__c = null;
        promocionGenerica.PromotionStatus__c = 'Vigente';
        insert promocionGenerica;

        test.stopTest();

        system.runAs(usuario){
            String jsonObtenido = KAL_PagoController.conseguirPromocionesFinancieras();

            system.debug(jsonObtenido);

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonObtenido);

            List<Object> Options = (List<Object>)m.get('options');        

            system.assertEquals(options.size(),2);
        }
    }

    @isTest 
    public static void siLaPromocionFinancieraEsLaMismaQueLaGenericaSoloMeQuedoConUna(){
        
        test.startTest();
        Account cuenta = new Account();
        cuenta.name = 'unaCuenta';
        insert cuenta; 

        User usuario = KAL_DatosTest.crearUsuarioDeComunidad(cuenta.id);

        Product2 producto = new Product2();
        producto.name = 'hola';
        insert producto;

        Pricebook2 libroPrecio = new Pricebook2();
        libroPrecio.name = 'lista precio';
        insert libroprecio;
        
        PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
        update pb;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pb.Id, 
                                    Product2Id = producto.Id, UnitPrice = 10000, IsActive = true, 
                                    UseStandardPrice = false);
        insert standardPrice;

        PricebookEntry entradaLibroPrecio = new PricebookEntry();
        entradaLibroPrecio.unitPrice = 123;
        entradaLibroPrecio.Pricebook2Id = libroPrecio.id;
        entradaLibroPrecio.Product2Id = producto.id;
        entradaLibroPrecio.IsActive = true;
        insert entradaLibroPrecio;

        ID rcoriginStore = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Call Center').getRecordTypeId();

        vlocity_cmt__BusinessSite__c originStore = new vlocity_cmt__BusinessSite__c();
        originStore.Channel_Type_3__c = 'E-Commerce';
        originStore.Channel_Type_2__c = 'E-Commerce';
        originStore.Channel_Type__c = 'E-Commerce';
        originStore.Channel__c = 'Digital';
        originStore.recordTypeId = rcoriginStore;
        originStore.vlocity_cmt__OrganizationId__c = cuenta.id;
        insert originStore;

        Order ordenQueGenero = new Order();
        ordenQueGenero.Pricebook2Id = libroPrecio.id;
        ordenQueGenero.status = 'Draft';
        ordenQueGenero.OriginStoreLocation__c = originStore.id;
        ordenQueGenero.vlocity_cmt__originatingchannel__c = 'E-Commerce';
        ordenQueGenero.AccountId = cuenta.id;
        ordenQueGenero.EffectiveDate = date.today();
        insert ordenQueGenero;

        OrderItem oitem = new OrderItem();
        oitem.Product2id = producto.id;
        oitem.Orderid = ordenQueGenero.id;
        oitem.PricebookEntryId = entradaLibroPrecio.id; 
        oitem.Quantity = 1;
        oitem.unitPrice = 123;
        insert oitem;

        ID rc = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();

        system.debug('id record type credit card -- '+rc);

        FinancialPromotion__c promocion = new FinancialPromotion__c();
        promocion.BankEntities__c = '407';//AMERICAN EXPRESS
        promocion.RecordTypeid = rc;
        promocion.CreditCards__c = '405';//CABAL
        promocion.Instalment__c = '12';
        promocion.Interest__c  = 20;
        promocion.From__c = date.today().addDays(-1);
        promocion.to__c = date.today().addDays(+1);
        promocion.ChannelPromotion__c = 'Digital';
        promocion.ProductPromotion__c = producto.id;
        promocion.PromotionStatus__c = 'Vigente';
        insert promocion;

        FinancialPromotion__c promocionGenerica = new FinancialPromotion__c();
        promocionGenerica.BankEntities__c = '407';
        promocionGenerica.RecordTypeid = rc;
        promocionGenerica.CreditCards__c = '405';//CABAL
        promocionGenerica.Instalment__c = '12';
        promocionGenerica.Interest__c  = 20;
        promocionGenerica.From__c = date.today().addDays(-1);
        promocionGenerica.to__c = date.today().addDays(+1);
        promocionGenerica.ChannelPromotion__c = null;
        promocionGenerica.PromotionStatus__c = 'Vigente';
        insert promocionGenerica;

        test.stopTest();

        system.runAs(usuario){
            String jsonObtenido = KAL_PagoController.conseguirPromocionesFinancieras();

            system.debug(jsonObtenido);

            Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonObtenido);

            List<Object> Options = (List<Object>)m.get('options');        

            system.assertEquals(options.size(),1);

            Map<String, Object> opciones1 = (Map<String,Object>) options[0];

            system.assertEquals((String)opciones1.get('BankEntities__c'),'AMERICAN EXPRESS');
            system.assertEquals((String)opciones1.get('CreditCards__c'),'CABAL');
        }
    }
}