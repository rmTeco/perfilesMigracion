<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EnviarMailDetallesPickup</fullName>
        <description>Enviar Mail Detalles Pickup</description>
        <protected>false</protected>
        <recipients>
            <field>Email1__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DetallesDePickup</template>
    </alerts>
    <alerts>
        <fullName>EnviarMailNominacionExitosa</fullName>
        <description>Enviar Mail Nominacion Exitosa</description>
        <protected>false</protected>
        <recipients>
            <field>Email1__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/NominacionExitosa</template>
    </alerts>
    <alerts>
        <fullName>EnviarMailPermanencia</fullName>
        <description>Enviar mail plazo permanencia</description>
        <protected>false</protected>
        <recipients>
            <field>Email1__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PlazoPorVencer</template>
    </alerts>
    <alerts>
        <fullName>EnviarMailPlazoRetiro</fullName>
        <description>Enviar Mail Plazo Retiro</description>
        <protected>false</protected>
        <recipients>
            <field>Email1__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PlazoPickupPorVencer</template>
    </alerts>
    <fieldUpdates>
        <fullName>MarkEmailForDeletion</fullName>
        <field>MarkForDeletion__c</field>
        <literalValue>1</literalValue>
        <name>Mark Email For Deletion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send DueDate Expiration Email</fullName>
        <actions>
            <name>EnviarMailPermanencia</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MarkEmailForDeletion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Crossobject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email to send</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.MarkForDeletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.Picklist1__c</field>
            <operation>equals</operation>
            <value>Vencimiento de plazo de permanencia</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Pickup Details Email</fullName>
        <actions>
            <name>EnviarMailDetallesPickup</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Crossobject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email to send</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.MarkForDeletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.Picklist1__c</field>
            <operation>equals</operation>
            <value>Detalles de Pickup</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Pickup Expiration Email</fullName>
        <actions>
            <name>EnviarMailPlazoRetiro</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MarkEmailForDeletion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Crossobject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email to send</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.MarkForDeletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.Picklist1__c</field>
            <operation>equals</operation>
            <value>Vencimiento de plazo de permanencia,Vencimiento de Pickup</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Successful Nomination Expiration Email</fullName>
        <actions>
            <name>EnviarMailNominacionExitosa</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>MarkEmailForDeletion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Crossobject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Email to send</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.MarkForDeletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Crossobject__c.Picklist1__c</field>
            <operation>equals</operation>
            <value>Nominacion exitosa</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
