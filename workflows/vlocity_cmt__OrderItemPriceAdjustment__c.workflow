<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>vlocity_cmt__AssetPricingAdjRefIdForOLIPAUpdate</fullName>
        <field>vlocity_cmt__AssetPricingAdjustmentReferenceId__c</field>
        <formula>Id</formula>
        <name>AssetPricingAdjRefIdForOLIPAUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>vlocity_cmt__AssetPricingAdjustmentRefIdForOLIPA</fullName>
        <actions>
            <name>vlocity_cmt__AssetPricingAdjRefIdForOLIPAUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(LOWER(vlocity_cmt__ProvisioningStatus__c) == &apos;new&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
