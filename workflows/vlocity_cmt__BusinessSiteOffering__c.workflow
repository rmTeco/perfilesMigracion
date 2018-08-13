<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NameDerivationST</fullName>
        <description>Field update used to concatenate the &quot;Derivación&quot; word with the order of the derivation in the store offering with record type equals to Derivation technical center</description>
        <field>Name</field>
        <formula>&quot;Derivación - &quot;  &amp; TEXT(Order__c)</formula>
        <name>NameDerivationST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>StoreOfferingNameST</fullName>
        <actions>
            <name>NameDerivationST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>vlocity_cmt__BusinessSiteOffering__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Derivation technical center</value>
        </criteriaItems>
        <description>Workflow rule used to update the name of the the store offer with the concatenation of the &quot;Derivation&quot; word with the order.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
