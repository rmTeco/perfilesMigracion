@isTest
public class gp_datosSociosTriggerTest {

    @isTest 
    public static void consigoLasPromocionesFinancieras(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        insert cuenta;
        
        Asset ass = New Asset();
        ass.msisdn__c = '1164943334';
        ass.name = 'asd';
        ass.accountId = cuenta.id;
        insert ass;
        
        List<GP_Dato_Socio_FAN__c> datos = new List<GP_Dato_Socio_FAN__c>();

        GP_Dato_Socio_FAN__c a = new GP_Dato_Socio_FAN__c ();
        a.puntos__c = 5000;
        a.account_id__c = cuenta.id;
        a.fecha_de_vencimiento__c = date.today().addDays(30);
        a.operacion__c = 'Insert';
        a.MSISDN__C = '1164943334';
        
        GP_Dato_Socio_FAN__c a2 = new GP_Dato_Socio_FAN__c ();
        a2.puntos__c = 1000;
        a2.account_id__c = cuenta.id;
        a2.fecha_de_vencimiento__c = date.today().addDays(60);
        a2.operacion__c = 'Insert';
        a2.MSISDN__C = '1164943334';
        
        datos.add(a);
        datos.add(a2);
        
        insert datos;
        
        
        
        system.assertEquals(1, [SELECT id from GP_Socio__c].size());
        system.assertEquals(6000, [SELECT id, Saldo_total__c from GP_Socio__c][0].Saldo_total__c);
        
    }
    
    @isTest 
    public static void BorroLosQueInserte(){
        
        Account cuenta = new Account();
        cuenta.name = 'ter';
        insert cuenta;
        
        Asset ass = New Asset();
        ass.msisdn__c = '1164943334';
        ass.name = 'asd';
        ass.accountId = cuenta.id;
        insert ass;
        
        List<GP_Dato_Socio_FAN__c> datos = new List<GP_Dato_Socio_FAN__c>();

        GP_Dato_Socio_FAN__c a = new GP_Dato_Socio_FAN__c ();
        a.puntos__c = 5000;
        a.account_id__c = cuenta.id;
        a.fecha_de_vencimiento__c = date.today().addDays(30);
        a.operacion__c = 'Insert';
        a.MSISDN__C = '1164943334';
        
        GP_Dato_Socio_FAN__c a2 = new GP_Dato_Socio_FAN__c ();
        a2.puntos__c = 1000;
        a2.account_id__c = cuenta.id;
        a2.fecha_de_vencimiento__c = date.today().addDays(60);
        a2.operacion__c = 'Insert';
        a2.MSISDN__C = '1164943334';
        
        datos.add(a);
        datos.add(a2);
        
        insert datos;

        system.assertEquals(1, [SELECT id from GP_Socio__c].size());
        system.assertEquals(6000, [SELECT id, Saldo_total__c from GP_Socio__c][0].Saldo_total__c);
        
        List<GP_Dato_Socio_FAN__c> datosABorrar = new List<GP_Dato_Socio_FAN__c>();
        
        GP_Dato_Socio_FAN__c borrara = new GP_Dato_Socio_FAN__c();
        borrara.puntos__c = 5000;
        borrara.account_id__c = cuenta.id;
        borrara.fecha_de_vencimiento__c = date.today().addDays(30);
        borrara.operacion__c = 'Delete';
        borrara.MSISDN__C = '1164943334';

        datosABorrar.add(borrara);
        
        insert datosABorrar;

    }
        
}