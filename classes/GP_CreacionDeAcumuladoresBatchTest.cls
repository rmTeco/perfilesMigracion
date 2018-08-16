@isTest
public class GP_CreacionDeAcumuladoresBatchTest {
    
    
    @isTest static void doyDeAltaUnParAcumuladorGpAssetConPuntos(){
        Account cuenta = new Account();
        cuenta.name = 'hola';
        insert cuenta;
        
        Asset nuevoAsset = new Asset();
        nuevoAsset.msisdn__c = '123';
        nuevoAsset.name = 'nombreAsset';
        nuevoAsset.AccountId = cuenta.id;
        insert nuevoAsset;
        
        GP_Dato_Socio_FAN__c datosSocio = new GP_Dato_Socio_FAN__c();
        datosSocio.Account_Id__c = cuenta.id;
        datosSocio.Fecha_de_vencimiento__c = Date.today().addDays(20); 
        datosSocio.MSISDN__c = '123';
        datosSocio.Puntos__c = 1233;
        
        insert datosSocio;
        
        test.startTest();

        Database.executeBatch(new GP_CreacionDeAcumuladoresBatch()); 
            
        Test.stopTest();

        system.assertEquals(1, [select id from gp_socio__c].size());
        system.assertEquals(1, [select id from gp_lista_de_asset__c].size());
        system.assertEquals(false, [select id, hayError__c from GP_Dato_Socio_FAN__c][0].hayError__c);
        system.assert([select id, procesado__C from GP_Dato_Socio_FAN__c][0].procesado__c);
        system.assertEquals(cuenta.id, [select id, cuenta__C from gp_socio__c][0].cuenta__c);
        system.assertEquals(cuenta.id, [select id, socio__r.cuenta__C from gp_lista_de_asset__c][0].socio__r.cuenta__c);
        system.assertEquals(1233, [select id, saldo_total__c from gp_socio__c][0].saldo_total__c);
    }
    
    @isTest static void doyDeAltaUnParAcumuladorGpAssetConPuntosDuplicadoElAcumulador(){
            Account cuenta = new Account();
            cuenta.name = 'hola';
            insert cuenta;
            
            Asset nuevoAsset = new Asset();
            nuevoAsset.msisdn__c = '123';
            nuevoAsset.name = 'nombreAsset';
            nuevoAsset.AccountId = cuenta.id;
            insert nuevoAsset;
            
            Asset nuevoAsset2 = new Asset();
            nuevoAsset2.msisdn__c = '1234';
            nuevoAsset2.name = 'nombreAsset';
            nuevoAsset2.AccountId = cuenta.id;
            insert nuevoAsset2;
            
            GP_Dato_Socio_FAN__c datosSocio = new GP_Dato_Socio_FAN__c();
            datosSocio.Account_Id__c = cuenta.id;
            datosSocio.Fecha_de_vencimiento__c = Date.today().addDays(20); 
            datosSocio.MSISDN__c = '123';
            datosSocio.Puntos__c = 1233;
            
            insert datosSocio;
            
            GP_Dato_Socio_FAN__c datosSocio2 = new GP_Dato_Socio_FAN__c();
            datosSocio2.Account_Id__c = cuenta.id;
            datosSocio2.Fecha_de_vencimiento__c = Date.today().addDays(20); 
            datosSocio2.MSISDN__c = '1234';
            datosSocio2.Puntos__c = 10;
            
            insert datosSocio2;
            
            test.startTest();
    
            Database.executeBatch(new GP_CreacionDeAcumuladoresBatch()); 
                
            Test.stopTest();
    
            system.assertEquals(1, [select id from gp_socio__c].size());
            system.assertEquals(2, [select id from gp_lista_de_asset__c].size());
            system.assertEquals(false, [select id, hayError__c from GP_Dato_Socio_FAN__c][0].hayError__c);
            system.assert([select id, procesado__C from GP_Dato_Socio_FAN__c][0].procesado__c);
            system.assertEquals(cuenta.id, [select id, cuenta__C from gp_socio__c][0].cuenta__c);
            system.assertEquals(cuenta.id, [select id, socio__r.cuenta__C from gp_lista_de_asset__c][0].socio__r.cuenta__c);
            system.assertEquals(1243, [select id, saldo_total__c from gp_socio__c][0].saldo_total__c);
    }
    
    @isTest static void doyDeAltaUnParAcumuladorGpAssetConPuntosConUnSocioYaCreadoPreviamente(){
        Account cuenta = new Account();
        cuenta.name = 'hola';
        insert cuenta;
        
        Asset nuevoAsset = new Asset();
        nuevoAsset.msisdn__c = '123';
        nuevoAsset.name = 'nombreAsset';
        nuevoAsset.AccountId = cuenta.id;
        insert nuevoAsset;
        
        gp_socio__c socioYaExistente = new gp_socio__c();
        socioYaExistente.cuenta__c = cuenta.id;
        socioYaExistente.Activo__c = true;
        socioYaExistente.saldo_total__c = 0;
        insert socioYaExistente;
        
        GP_Dato_Socio_FAN__c datosSocio = new GP_Dato_Socio_FAN__c();
        datosSocio.Account_Id__c = cuenta.id;
        datosSocio.Fecha_de_vencimiento__c = Date.today().addDays(20); 
        datosSocio.MSISDN__c = '123';
        datosSocio.Puntos__c = 1233;
        
        insert datosSocio;
        
        test.startTest();

        Database.executeBatch(new GP_CreacionDeAcumuladoresBatch()); 
            
        Test.stopTest();

        system.assertEquals(1, [select id from gp_socio__c].size());
        system.assertEquals(1, [select id from gp_lista_de_asset__c].size());
        system.assertEquals(false, [select id, hayError__c from GP_Dato_Socio_FAN__c][0].hayError__c);
        system.assert([select id, procesado__C from GP_Dato_Socio_FAN__c][0].procesado__c);
        system.assertEquals(cuenta.id, [select id, cuenta__C from gp_socio__c][0].cuenta__c);
        system.assertEquals(cuenta.id, [select id, socio__r.cuenta__C from gp_lista_de_asset__c][0].socio__r.cuenta__c);
        system.assertEquals(1233, [select id, saldo_total__c from gp_socio__c][0].saldo_total__c);
    }
    
    @isTest static void hayUnErrorInsertandoElSocioYNoSeInsertaNada(){
        Account cuenta = new Account();
        cuenta.name = 'hola';
        insert cuenta;
        
        Asset nuevoAsset = new Asset();
        nuevoAsset.msisdn__c = '123';
        nuevoAsset.name = 'nombreAsset';
        nuevoAsset.AccountId = cuenta.id;
        insert nuevoAsset;

        GP_Dato_Socio_FAN__c datosSocio = new GP_Dato_Socio_FAN__c();
        datosSocio.Account_Id__c = '0016C000009IHAh';
        datosSocio.Fecha_de_vencimiento__c = Date.today().addDays(20); 
        datosSocio.MSISDN__c = '123';
        datosSocio.Puntos__c = 1233;
        
        insert datosSocio;
        
        test.startTest();

        Database.executeBatch(new GP_CreacionDeAcumuladoresBatch()); 
            
        Test.stopTest();

        system.assertEquals(true, [select id, hayError__c from GP_Dato_Socio_FAN__c][0].hayError__c);
        system.assertEquals(0, [select id from gp_socio__c].size());
        system.assertEquals(0, [select id from gp_lista_de_asset__c].size());
        system.assert([select id, procesado__C from GP_Dato_Socio_FAN__c][0].procesado__c);
    }
    
}