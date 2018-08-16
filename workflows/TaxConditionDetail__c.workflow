<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Condicion_Impositiva_check_alarm_1</fullName>
        <field>Alarm_Level__c</field>
        <formula>&quot;1&quot;</formula>
        <name>Condicion Impositiva check alarm 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ondicion_Impositiva_check_alarm_2</fullName>
        <field>Alarm_Level__c</field>
        <formula>&quot;2&quot;</formula>
        <name>ondicion Impositiva check alarm 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Care - Condiciones Impositivas - Crea Alarma 1</fullName>
        <active>false</active>
        <description>Care - Condiciones Impositivas - Crea Alarma 1</description>
        <formula>AND(  Alarm_Level__c =&quot;&quot;,Tax_Condition_Status__c &lt;&gt; &apos;Inactivo&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Condici_n_impositiva_Alarma_1</name>
                <type>Task</type>
            </actions>
            <offsetFromField>TaxConditionDetail__c.DateTo__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Care - Condiciones Impositivas - Crea Alarma 2</fullName>
        <active>true</active>
        <description>Care - Condiciones Impositivas - Crea Alarma 2</description>
        <formula>AND( Alarm_Level__c = &quot;1&quot;,Tax_Condition_Status__c &lt;&gt; &apos;Inactivo&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ondicion_Impositiva_check_alarm_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>TaxConditionDetail__c.DateTo__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Condici_n_impositiva_Alarma_1</fullName>
        <assignedTo>gmota@ta.com.vlocity</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>TaxConditionDetail__c.DateTo__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Condición impositiva Alarma 1</subject>
    </tasks>
</Workflow>
