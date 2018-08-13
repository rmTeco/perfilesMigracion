<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Last_Updated_Account_Email_Field</fullName>
        <field>Last_Modified_Email_Date__c</field>
        <formula>TODAY()</formula>
        <name>Last Updated Account Email Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AccountIntegration_Id</fullName>
        <field>AccountIntegrationId__c</field>
        <formula>AccountIntegrationFormula__c</formula>
        <name>Update AccountIntegrationId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Last Updated Account Email Field</fullName>
        <actions>
            <name>Last_Updated_Account_Email_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.vlocity_cmt__BillingEmailAddress__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateAccountIntegrationIdWithFormula</fullName>
        <actions>
            <name>Update_AccountIntegration_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.AccountIntegrationFormula__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AccountIntegrationFormula__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
