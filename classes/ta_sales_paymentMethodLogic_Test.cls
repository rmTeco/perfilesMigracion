@IsTest
public class ta_sales_paymentMethodLogic_Test {

	@IsTest
	static void PopulateEntidadesTest(){
		String methodName = 'PopulateEntidades';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createExternalBankEntities();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> ret = (List<Map<String, String>>) outMap.get('options');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void PopulateTarjetasTest(){
		String methodName = 'PopulateTarjetas';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createFinancialPromotions();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> ret = (Map<String, Object>) outMap.get('dependency');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void PopulateCuotasTest(){
		String methodName = 'PopulateCuotas';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createFinancialPromotions();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> ret = (Map<String, Object>) outMap.get('dependency');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void GetCardsByBankTest(){
        TestDataFactory.createFinancialPromotions();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> ret = testedClass.GetCardsByBank('6');
        Test.stopTest();

        List<Map<String, Object>> retList = (List<Map<String, Object>>) ret.get('options');

        System.assertEquals(1, retList.size());
	}

	@IsTest
	static void GetInstallmentsByCardTest(){
        TestDataFactory.createFinancialPromotions();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> ret = testedClass.GetInstallmentsByCard('6', '404');
        Test.stopTest();

        List<Map<String, Object>> retList = (List<Map<String, Object>>) ret.get('options');

        System.assertEquals(1, retList.size());
	}

	@IsTest
	static void PopulatePlanDeCuotasTest(){
        String methodName = 'PopulatePlanDeCuotas';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createFinancialPromotions();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> ret = (Map<String, Object>) outMap.get('dependency');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void PopulateEntidadesFromObjectTest(){
        String methodName = 'PopulateEntidadesFromObject';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        List<FinancialPromotion__c> financialPromotions = TestDataFactory.createFinancialPromotionsForCreditCard();
        String serializedList = JSON.serialize(financialPromotions);
        input.put('promotionOptions',serializedList);
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Set<Map<String, String>> ret = (Set<Map<String, String>>) outMap.get('options');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void PopulateTarjetasFromObjectTest(){
        String methodName = 'PopulateTarjetasFromObject';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        List<FinancialPromotion__c> financialPromotions = TestDataFactory.createFinancialPromotionsForCreditCard();
        String serializedList = JSON.serialize(financialPromotions);
        input.put('promotionOptions',serializedList);
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Set<Map<String, String>> ret = (Set<Map<String, String>>) outMap.get('options');

        System.assertEquals(2, ret.size());
	}

	@IsTest
	static void PopulateDPFInstallmentsFromObjectTest(){
        String methodName = 'PopulateDPFInstallmentsFromObject';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createFinancialPromotionsDPF();

        Test.startTest();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String,String>> ret = (List<Map<String,String>>) outMap.get('options');

        System.assertEquals(2, ret.size());
	}
	
	@IsTest
	static void GetPromotionsByBankCardTest(){

        Test.startTest();
        List<FinancialPromotion__c> financialPromotions = TestDataFactory.createFinancialPromotionsForCreditCard();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> options = new Map<String, Object>();

        String serializedList = JSON.serialize(financialPromotions);
        options.put('promotionOptions',serializedList);
        Map<String, Object> ret = testedClass.GetPromotionsByBankCard('331', '468', options);
        Test.stopTest();

        Set<Map<String, String>> retList = (Set<Map<String, String>>) ret.get('options');

        System.assertEquals(1, retList.size());
	}

	@IsTest
	static void GetInstallmentsByPromotionsTest(){

        Test.startTest();
        List<FinancialPromotion__c> financialPromotions = TestDataFactory.createFinancialPromotionsForCreditCard();
        ta_sales_paymentMethodLogic testedClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> options = new Map<String, Object>();
        String serializedList = JSON.serialize(financialPromotions);
        options.put('promotionOptions',serializedList);
        Map<String, Object> ret = testedClass.GetInstallmentsByPromotions('331', '468', 'Promo1', options);
        Test.stopTest();

        Set<Map<String, String>> retList = (Set<Map<String, String>>) ret.get('options');

        System.assertEquals(1, retList.size());
	}
}