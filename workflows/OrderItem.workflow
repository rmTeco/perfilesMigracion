<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>vlocity_cmt__AssetRefIdForOLIUpdate</fullName>
        <field>vlocity_cmt__AssetReferenceId__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>AssetRefIdForOLIUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>vlocity_cmt__AssetRefIdForQLIUpdate</fullName>
        <field>vlocity_cmt__AssetReferenceId__c</field>
        <formula>Id</formula>
        <name>AssetRefIdForQLIUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>vlocity_cmt__AssetRefIdForOLI</fullName>
        <actions>
            <name>vlocity_cmt__AssetRefIdForOLIUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>vlocity_cmt__AssetRefIdForQLIUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>$Setup.vlocity_cmt__RunTriggerAndWorkFlow__c.vlocity_cmt__AllowWorkflow__c &amp;&amp; ( LOWER(vlocity_cmt__ProvisioningStatus__c) == &apos;new&apos; || LOWER(vlocity_cmt__ProvisioningStatus__c) == &apos;pendinginsert&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
