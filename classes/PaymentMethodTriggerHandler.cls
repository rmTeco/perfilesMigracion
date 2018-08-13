/**
 * Created by Alex on 14/9/2017.
 */
public class PaymentMethodTriggerHandler {

	public static void processPaymentMethodUpdates(List<vlocity_cmt__PaymentMethod__c> triggerNew) {

		// Process logic for each paymentMethod
		for(vlocity_cmt__PaymentMethod__c payment : triggerNew){
			if(payment.vlocity_cmt__MethodType__c=='Credit Card' || payment.vlocity_cmt__MethodType__c=='Bank Account' &&
			payment.alias__c == null){
				// Parsing the ccNumber to grab the last 4 digits
				String methodNumber = null;
				if(payment.vlocity_cmt__MethodType__c=='Credit Card'){ methodNumber = payment.vlocity_cmt__CardNumber__c; }
				if(payment.vlocity_cmt__MethodType__c=='Bank Account' && payment.Cbu__c != null){ methodNumber = payment.Cbu__c; }
				String last4digits = PaymentMethodTriggerHandler.extractLast4(methodNumber);
				// Changing the trigger.new data of the last4Numbers field
				payment.vlocity_cmt__Last4Numbers__c = last4digits;
			}

			if(payment.vlocity_cmt__MethodType__c=='Credit Card') {
				// Grabbing the CardType by Bins matching
				String cardTypeName = PaymentMethodTriggerHandler.extractCardTypebyMatchingWithBines(
						payment.vlocity_cmt__CardNumber__c);
				// Changing the trigger.new data of cardType field
				payment.vlocity_cmt__CardType__c = cardTypeName;
			}

		}

	}

	public static String extractLast4(String ccNumber){

		// Grabbing total length
		Integer length = ccNumber.length();
		// returning the last 4 digits
		return ccNumber.substring(length-4,length);
	}

	public static String extractCardTypebyMatchingWithBines(String ccNumber) {
		// Getting al the bines from the custom setting
		List<CreditCardsBins__c> ccBins = CreditCardsBins__c.getall().values();
		// setting isvalidbin to false
		Boolean isBin = false;
		String cardType;

		for (CreditCardsBins__c ccb : ccBins){
			// Only checking against the ccnumbers that are the same length as the bin
			String ccNumberAccordingtoBinLength = ccNumber.substring(0,ccb.CredicardTypeId__c.length());
			// Check if the bin is part of the cc
			isBin = ccNumberAccordingtoBinLength.contains(ccb.CredicardTypeId__c);
			if(isBin){
				// if true assign the string the cardtypename
				cardType = ccb.Name;
				break;
			}
		}
		return cardType;
	}

}