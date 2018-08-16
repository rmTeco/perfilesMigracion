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
* EPCConvertGPEToSPE
*
* Author
* Manish
*
* v1
*
* This is for to convert all global pricing elements to standalone pricing elements.
*/
public class EPCConvertGPEToSPE implements Database.Batchable<SObject>, Database.Stateful
{
    private List<SObject> skippedPEList;
    private List<SObject> convertedPEList;
    private List<SObject> foundGlobalPEList;
    private Map<Id, Set<Id>> peIdToPLIdList;
    private String query;
    /*
     * for Managed code, use this
     */
    private String nsPrefix = 'vlocity_cmt__';
    /*
     * for unmanaged code, use this
     */
    //private String nsPrefix = ApplicationUtilities.getNameSpacePrefix();

    public EPCConvertGPEToSPE()
    {
        query = 'SELECT Id, '+ nsPrefix +'PriceListId__c, '+ nsPrefix +'CurrencyCode__c '+
        ' FROM '+ nsPrefix +'PricingElement__c where '+ nsPrefix +'PriceListId__c = null';
        skippedPEList = new List<SObject>();
        convertedPEList = new List<SObject>();
        peIdToPLIdList = new Map<Id, Set<Id>>();
        foundGlobalPEList = new List<SObject>();
    }

    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> pricingElementList)
    {
        foundGlobalPEList.addAll(pricingElementList);

        List<Id> peIdList = new List<Id>();
        Map<Id, Boolean> idToIfConversion = new Map<Id, Boolean>();
        Map<Id, Id> idToPricelistId = new Map<Id, Id>();
        for(SObject pe: pricingElementList)
        {
            peIdList.add((Id) pe.get('Id'));
        }
        checkIfConversionPossible(peIdList, idToIfConversion, idToPricelistId);
        convertGPEToSPE(pricingElementList, idToIfConversion, idToPricelistId);
    }

    private void checkIfConversionPossible(List<Id> peIdList, Map<Id, Boolean> idToIfConversion, Map<Id, Id> idToPricelistId)
    {
        String pleQuery = 'SELECT Id, '+ nsPrefix + 'PriceListId__c, '+ nsPrefix + 'PricingElementId__c FROM '+ nsPrefix + 'PriceListEntry__c WHERE '
                            + nsPrefix + 'PricingElementId__c in :peIdList';
        List<SObject> pleList = Database.query(pleQuery);
        for(SObject ple: pleList)
        {
            Id plId = (Id) ple.get(nsPrefix + 'PriceListId__c');
            Id peId = (Id) ple.get(nsPrefix + 'PricingElementId__c');
            Set<Id> plIdList = peIdToPLIdList.get(peId);
            if(plIdList == null)
            {
                plIdList = new Set<Id>();
                peIdToPLIdList.put(peId, plIdList);
            }
            plIdList.add(plId);
        }
        for(Id peId: peIdToPLIdList.keySet())
        {
            Set<Id> plIdList = peIdToPLIdList.get(peId);
            if(plIdList.size() == 1)
            {
                idToIfConversion.put(peId, true);
                List<Id> dList = new List<Id>(plIdList);
                idToPricelistId.put(peId, dList[0]);
            }
            else
            {
                idToIfConversion.put(peId, false);
            }
        }
    }

    private void convertGPEToSPE(List<sObject> pricingElementList, Map<Id, Boolean> idToIfConversion, Map<Id, Id> idToPricelistId)
    {
        List<SObject> updatedList = new List<SObject>();
        for(SObject pe: pricingElementList)
        {
            Id peId = (Id) pe.get('Id');
            if(idToIfConversion.get(peId)== null || !idToIfConversion.get(peId))
            {
                skippedPEList.add(pe);
                continue;
            }
            pe.put(nsPrefix + 'PriceListId__c', idToPricelistId.get(peId));
            updatedList.add(pe);
            convertedPEList.add(pe);
        }
        update updatedList;
    }

    public void finish(Database.BatchableContext BC)
    {
        System.debug('Batch job finished');
        System.debug('Found global pricing elements: size '+ foundGlobalPEList.size());
        for(SObject pe: foundGlobalPEList)
        {
            System.debug('Id '+ (Id) pe.get('Id'));
        }
        System.debug('Converted pricing elements: size '+ convertedPEList.size());
        for(SObject pe: convertedPEList)
        {
            System.debug('Id '+ (Id) pe.get('Id') + ' PriceListId: '+ (Id) pe.get(nsPrefix + 'PriceListId__c'));
        }

        System.debug('Not possilbe to converted pricing elements from script: size '+ skippedPEList.size());
        for(SObject pe: skippedPEList)
        {
            Id peId = (Id) pe.get('Id');
            System.debug('Id '+ peId + ' PriceListIds: '+ peIdToPLIdList.get(peId));
        }
    }

}