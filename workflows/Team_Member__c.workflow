<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ActiveValidation</fullName>
        <description>Update the ActiveValidation__c field to do the validation to ensure that a user has a single active membership by user. 
The ActiveValidation__c field is marked as an unique.</description>
        <field>ActiveValidation__c</field>
        <formula>IF( Is_Active__c, User_member__c &amp; &apos;TRUE&apos;, Id )</formula>
        <name>ActiveValidation__c</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Validation Membership Active</fullName>
        <actions>
            <name>ActiveValidation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule used to update the ActiveValidation__c field in the work team member and ensure that there is a single active membership in a team for a user.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
