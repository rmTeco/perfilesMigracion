@isTest
public class TaCpqAppHandlerInputMapFactoryTest {
    
    public static String createPrefeasibilityJson() {
        Map<String, Object> prefeMap = new Map<String, Object>();
        List<Object> tecnologiasAccesoList = new List<Object>();
        Map<String, Object> technologyMap = new Map<String, Object>();
        List<Object> servicesList = new List<Object>();
        Map<String, Object> serviceTypeInternetMap = new Map<String, Object>();
        Map<String, Object> serviceTypeVozMap = new Map<String, Object>();
        List<Object> technicalStandardsList = new List<Object>();
        Map<String, Object> techStandardMap = new Map<String, Object>();
        techStandardMap.put('disponibilidad', 'SI');
        techStandardMap.put('medicionDeBajada', '12345');
        technicalStandardsList.add(techStandardMap);
        serviceTypeInternetMap.put('standardsTecnico', technicalStandardsList);
        serviceTypeInternetMap.put('servicio', 'Internet');
        serviceTypeVozMap.put('standardsTecnico', technicalStandardsList);
        serviceTypeVozMap.put('servicio', 'Voz');
        servicesList.add(serviceTypeInternetMap);
        servicesList.add(serviceTypeVozMap);
        technologyMap.put('servicios', servicesList);
        tecnologiasAccesoList.add(technologyMap);
        prefeMap.put('tecnologiasAcceso', tecnologiasAccesoList);
        return JSON.serialize(prefeMap);
    }

    public static Map<String, Object> generateInputMap() {
        Map<String, Object> inputMap = new Map<String, Object>();

        inputMap.put('pagesize', 10);
        inputMap.put('fields', 'IsActive,Id,Name,UnitPrice,ProductCode,vlocity_cmt__RecurringPrice__c,product2.description,product2.Tipo_de_Bien_de_Uso__c,Product2.Marca__c,Product2.vlocity_cmt__HelpText__c,Product2.NMU__c,Product2.vlocity_cmt__Type__c,Product2.Family');

        Map<String, Object> billingOrderMap = new Map<String, Object>();
        Decimal pickUpStore = 21;

        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c = acc.Id);
        storeLocation.PointOfSaleId__c = pickUpStore;
        storeLocation.AssociatedWarehouseId__c = 'DFMULT001';
        insert storeLocation;

        billingOrderMap.put('PickUpStore', String.valueOf(pickUpStore));
        inputMap.put('BillingOrder', billingOrderMap);
        return inputMap;
    }
}