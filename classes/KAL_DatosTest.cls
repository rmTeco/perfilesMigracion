@IsTest
public class KAL_DatosTest {

    public static user crearUsuarioDeComunidad(String idCuenta){
        
        Contact contacto = new Contact();
        contacto.lastname = 'contacto';
        contacto.accountid = idCuenta; 
        insert contacto;

        User usuario = new User();
       
        usuario.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community User'].Id;
        usuario.LastName = 'last';
        usuario.Email = 'puser000@amamama.com';
        usuario.Username = 'puser000@amamama.com' + System.currentTimeMillis();
        usuario.CompanyName = 'TEST';
        usuario.Title = 'title';
        usuario.Alias = 'alias';
        usuario.TimeZoneSidKey = 'America/Los_Angeles';
        usuario.EmailEncodingKey = 'UTF-8';
        usuario.LanguageLocaleKey = 'en_US';
        usuario.LocaleSidKey = 'en_US';
        usuario.contactid = contacto.id;
        usuario.isactive = true;
        insert usuario;

        insertar_workplace_user(usuario.Id);

        return usuario;
    }

    // NS: KAL_carritoController.crearOrdenParaCarrito() crea una orden con el usuario logueado.
    public static order crearUnaOrdenDraftParaElUsuario(String AccountId, String userId, String Pricebook2Id, String OriginStoreLocationId){
        
        Order ordenQueGenero = new Order();
        ordenQueGenero.status = 'Draft';
        ordenQueGenero.vlocity_cmt__originatingchannel__c = 'E-Commerce';
        ordenQueGenero.AccountId = AccountId;
        ordenQueGenero.EffectiveDate = date.today();
        ordenQueGenero.ownerId = userId;
        ordenQueGenero.Delivery_Method__c = 'Delivery';
        
        if(Pricebook2Id != null){
            ordenQueGenero.Pricebook2Id = Pricebook2Id;
        }
        if(OriginStoreLocationId != null){
            ordenQueGenero.OriginStoreLocation__c = OriginStoreLocationId;
        }
        
        insert ordenQueGenero;

        return ordenQueGenero;
    }

    /*  Inserta dos productos y sus respectivos PBEs.
        Estructura del json que devuelve:
        result = {
            'Productos': 'lista de productos',
            'PBEs': 'lista de PBEs',
            'IdsPBEs': 'lista de Ids de PBE'
        }
    */ 
    public static Map<String, Object> insertarProductosYPBEs() {

        List<Product2> listaDeProductos = new List<Product2>();
        List<PricebookEntry> listaDePBEs = new List<PricebookEntry>();
        List<String> pbeIds = new List<String>();
        Map<String, Object> result = new Map<String, Object>();

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
        Product2 prod3 = new Product2(
            Name = 'Blu vivo 8',
            IsActive = true
        );
        insert prod3;

        listaDeProductos.add(prod);
        listaDeProductos.add(prod2);
        listaDeProductos.add(prod3);
        result.put('Productos', listaDeProductos);

        // Creo Standard Price
        Id stdPricebookId = Test.getStandardPricebookId();
        PricebookEntry stdPBE = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id = prod.Id,
            isActive = true,
            UnitPrice = 13000
        );
        PricebookEntry stdPBE2 = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id = prod2.Id,
            isActive = true,
            UnitPrice = 20000
        );
        PricebookEntry stdPBE3 = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id = prod3.Id,
            isActive = true,
            UnitPrice = 11000
        );
        List<PricebookEntry> stdPBEList = new List<PricebookEntry>();
        stdPBEList.add(stdPBE);
        stdPBEList.add(stdPBE2);
        stdPBEList.add(stdPBE3);
        insert stdPBEList;
        
        String pricebookId = insertar_vlocity_PriceBook();
        // Creo price list
        String idPriceList = insertar_vlocity_PriceList(pricebookId);

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UseStandardPrice = false,
            isActive = true,
            UnitPrice = 13500
        );
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod2.Id,
            isActive = true,
            UseStandardPrice = false,
            UnitPrice = 20500
        );
        PricebookEntry pbe3 = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod3.Id,
            isActive = true,
            UseStandardPrice = false,
            UnitPrice = 11000
        );
        pbeList.add(pbe);
        insert pbe;
        pbeList.add(pbe2);
        insert pbe2;
        pbeList.add(pbe3);
        insert pbe3;

        listaDePBEs.addAll(stdPBEList);
        listaDePBEs.addAll(pbeList);
        result.put('PBEs', listaDePBEs);

        for(PricebookEntry pb : pbeList) {
            pbeIds.add(pb.Id);
        }
        if(pbeList.size() > 0) {
            pbeIds.add(pbeList[1].Id);
        }
        result.put('IdsPBEs', pbeIds);

        return result;
    }

    public static String insertar_vlocity_PriceList(String IdPB) {

        Id IdPriceBook = Id.valueOf(IdPB);
        String taPriceListId;

        List<vlocity_cmt__PriceList__c> listPriceLists = [
            Select Id
            From vlocity_cmt__PriceList__c
            Where vlocity_cmt__Code__c = 'PRL_TELCOM'
        ];

        if(listPriceLists.size() == 0) {
            vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(
                Name = 'Telecom Price List', 
                vlocity_cmt__Code__c = 'PRL_TELCOM',
                vlocity_cmt__Description__c = 'Create for Testing', 
                vlocity_cmt__Pricebook2Id__c = IdPriceBook,
                vlocity_cmt__IsActive__c = true
            );
            insert taPriceList;
            taPriceListId = taPriceList.Id;
        } else {
            taPriceListId = listPriceLists[0].Id;
        }

        return taPriceListId;
    }

    public static void insertar_workplace_user(String userId) {
        Decimal cuit = Decimal.valueOf('20386732303');
        Account storeAccount = new Account(
            Name = 'store Account',
            CuitNumber__c = cuit
        );
        storeAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert storeAccount;

        vlocity_cmt__BusinessSite__c workPlace = new vlocity_cmt__BusinessSite__c(
            Name = 'workPlace-Test',
            BillingMode__c = 'Electronico',
            Channel__c = 'Digital',
            Channel_Type__c = 'E-Commerce',
            Channel_Type_2__c = 'E-Commerce',
            Channel_Type_3__c = 'E-Commerce',
            vlocity_cmt__OrganizationId__c = storeAccount.Id
        );
        insert workPlace;

        WorkTeam__c workTeam = new WorkTeam__c(
            Name = 'nombreEquipo',
            Work_Place__c = workPlace.Id,
            Team_Name__c = 'nombreEquipo',
            Is_Active__c = true
        );
        insert workTeam;
        
        Team_Member__c teamMember = new Team_Member__c(
            User_Member__c = userId,
            UserRoleAPIName__c = 'rolFalso123',
            Work_Team__c = workTeam.Id,
            Is_Active__c = true
        );
        insert teamMember;

        /*
        SELECT Work_Team__r.Work_Place__c,
            Work_Team__r.Work_Place__r.Name,
            Work_Team__r.Work_Place__r.BillingMode__c,
            Work_Team__r.Work_Place__r.Channel__c,
            Work_Team__r.Work_Place__r.Channel_Type__c,
            Work_Team__r.Work_Place__r.Channel_Type_2__c,
            Work_Team__r.Work_Place__r.Channel_Type_3__c, 
            Work_Team__r.Work_Place__r.PointOfSaleId__c,
            Work_Team__r.Work_Place__r.Location__c
        FROM Team_Member__c 
        WHERE User_Member__c = :userId 
        AND Is_Active__c = true
        LIMIT 1
        */
    }
    public static String insertar_vlocity_PriceBook() {
        String taPriceBookId;

        List<Pricebook2> listPriceBooks = [
            Select Id
            From Pricebook2
            Where Name = 'TA Price Book'
        ];

        if(listPriceBooks.size() == 0) {
            Pricebook2 PriceBook = new Pricebook2(
                IsActive = true,
                vlocity_cmt__IsDefault__c = true,
                vlocity_cmt__IsOpportunityDefault__c = false,
                vlocity_cmt__IsOrderDefault__c = true,
                vlocity_cmt__isQuoteDefault__c = true,
                Name = 'TA Price Book'
            );
            insert PriceBook;
            taPriceBookId = PriceBook.Id;
        } else {
            taPriceBookId = listPriceBooks[0].Id;
        }

        return taPriceBookId;
    }
}