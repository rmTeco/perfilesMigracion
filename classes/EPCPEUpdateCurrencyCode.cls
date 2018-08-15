/*
* VLOCITY, INC. CONFIDENTIAL
* __________________
*
*  2014-2017 Vlocity, Inc.
*  All Rights Reserved.
*
* NOTICE:  All information contained herein is, and remains
* the property of Vlocity, Inc. and its suppliers,
* if any. The intellectual and technical concepts contained
* herein are proprietary to Vlocity, Inc. and its suppliers and may be
* covered by U.S. and Foreign Patents, patents in process, and are
* protected by trade secret or copyright law. Dissemination of this
* information and reproduction, modification or reverse-engineering
* of this material, is prohibited unless prior written permission
* is obtained from Vlocity, Inc.
*
* EPCPEUpdateCurrencyCode
*
* Author
* Manish
*
* v1
*
* This is for to update currency code in pricing elements.
*/
public class EPCPEUpdateCurrencyCode implements Database.Batchable<sObject>
{

    private String query;
    /*
     * for Managed code, use this
     */
    private String nsPrefix = 'vlocity_cmt__';
    /*
     * for unmanaged code, use this
     */
    //private String nsPrefix = ApplicationUtilities.getNameSpacePrefix();

    public EPCPEUpdateCurrencyCode()
    {
        query = 'SELECT Id, '+ nsPrefix +'PriceListId__c, '+ nsPrefix +'CurrencyCode__c, '+ nsPrefix+'PriceListId__r.'+ nsPrefix +'CurrencyCode__c'+
        ' FROM '+ nsPrefix +'PricingElement__c where '+ nsPrefix +'PriceListId__c != null AND '+ nsPrefix +'CurrencyCode__c = null';
    }

    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('start: batch started');
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> pricingElementList)
    {
        System.debug('Size of list' + pricingElementList.size());
        List<SObject> updatedList = new List<SObject>();
        for(SObject pricingElement: pricingElementList)
        {
            SObject priceList = (SObject) pricingElement.getSObject(nsPrefix + 'PriceListId__r');
            String currencyCode = (String) priceList.get(nsPrefix + 'CurrencyCode__c');
            if(String.isBlank(currencyCode))
            {
                continue;
            }
            //check if more than one selected.
            if(currencyCode.contains(';'))
            {
                String[] codes = currencyCode.split(';');
                currencyCode = codes[0];
            }
            pricingElement.put(nsPrefix + 'CurrencyCode__c', currencyCode);
            updatedList.add(pricingElement);
        }
        System.debug(updatedList);
        update updatedList;
    }

    public void finish(Database.BatchableContext BC)
    {
        System.debug('finished');
    }
}