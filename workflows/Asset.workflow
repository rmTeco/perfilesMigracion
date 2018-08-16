<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Provision_Status_to_Active</fullName>
        <description>Provision status to active when resumed</description>
        <field>vlocity_cmt__ProvisioningStatus__c</field>
        <formula>&apos;Active&apos;</formula>
        <name>Provision Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_Activation_Date_a_Ahora</fullName>
        <field>Activation_Datetime__c</field>
        <formula>NOW()</formula>
        <name>xOM - Actualizar Activation Date a Ahora</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_Activation_Date_a_Hoy</fullName>
        <field>vlocity_cmt__ActivationDate__c</field>
        <formula>TODAY()</formula>
        <name>xOM - Actualizar Activation Date a Hoy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_RehabDateTime_Resume</fullName>
        <field>Rehab_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM - Actualizar RehabDateTime Resume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_Status_Resume</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>xOM - Actualizar Status Resume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_SubStatus_Resume</fullName>
        <description>Update SubStatus on Resume</description>
        <field>Sub_Status__c</field>
        <name>xOM - Actualizar SubStatus Resume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Actualizar_SuspendDateTime_Resume</fullName>
        <field>Suspend_Date_Time__c</field>
        <name>xOM - Actualizar SuspendDateTime Resume</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_ProvisioningStatus_ResumedToActive</fullName>
        <field>vlocity_cmt__ProvisioningStatus__c</field>
        <formula>&apos;Active&apos;</formula>
        <name>xOM ProvisioningStatus ResumedToActive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_Extravio</fullName>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend Extravio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_Fraude</fullName>
        <description>Update status on a Suspend by Fraude</description>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend Fraude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_Hurto</fullName>
        <description>Update Suspend on Hurto</description>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend Hurto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_PortOut</fullName>
        <description>Update Status on a suspend by PortOut</description>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend PortOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_Robo</fullName>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend Robo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_Suspend_Siniestro</fullName>
        <description>Update Status on a Suspend by Siniestro</description>
        <field>Status</field>
        <literalValue>Suspended</literalValue>
        <name>xOM Status Suspend Siniestro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Status_SuspendedToActive</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>xOM Status SuspendedToActive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_Extravio</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Extravio</literalValue>
        <name>xOM SubStatus Suspend Extravio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_Fraude</fullName>
        <description>Update SubStatus in a Suspension by Fraude</description>
        <field>Sub_Status__c</field>
        <literalValue>Administrativo</literalValue>
        <name>xOM SubStatus Suspend Fraude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_Hurto</fullName>
        <description>Update fields when suspend by hurto</description>
        <field>Sub_Status__c</field>
        <literalValue>Hurto</literalValue>
        <name>xOM SubStatus Suspend Hurto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_PortOut</fullName>
        <description>Update SubStatus on a Suspend by a PortOut</description>
        <field>Sub_Status__c</field>
        <literalValue>PortOut</literalValue>
        <name>xOM SubStatus Suspend PortOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_Robo</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Robo</literalValue>
        <name>xOM SubStatus Suspend Robo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SubStatus_Suspend_Siniestro</fullName>
        <description>Update SubStatus in a Suspend by Siniestro</description>
        <field>Sub_Status__c</field>
        <literalValue>Siniestro</literalValue>
        <name>xOM SubStatus Suspend Siniestro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspendDate_Suspend_Extravio</fullName>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspendDate Suspend Extravio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspendDate_Suspend_Hurto</fullName>
        <description>Update SuspenDate on Suspend by Hurto.</description>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspendDate Suspend Hurto</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspendDate_Suspend_PortOut</fullName>
        <description>Update SuspendDate on a Suspension by PortOut</description>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspendDate Suspend PortOut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspendDate_Suspend_Robo</fullName>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspendDate Suspend Robo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspendDate_Suspend_Siniestro</fullName>
        <description>Update SuspendDate on a Suspension by Siniestro</description>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspendDate Suspend Siniestro</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_SuspensionDate_Suspend_Fraude</fullName>
        <description>Update Suspension Date on a Suspension by Fraude</description>
        <field>Suspend_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>xOM SuspensionDate Suspend Fraude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Update_status_to_Active</fullName>
        <field>Status</field>
        <literalValue>Active</literalValue>
        <name>xOM - Update status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Update_status_to_Inactive</fullName>
        <field>Status</field>
        <literalValue>Inactive</literalValue>
        <name>xOM - Update status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>xOM_Update_status_to_Preactive</fullName>
        <field>Status</field>
        <literalValue>Preactive</literalValue>
        <name>xOM - Update status to Preactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>xOM - Actualizar Activation Date en Nominación</fullName>
        <actions>
            <name>xOM_Actualizar_Activation_Date_a_Ahora</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_Actualizar_Activation_Date_a_Hoy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ActivationDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Actualizar SubStatus y rehabDate on Resume</fullName>
        <actions>
            <name>xOM_Actualizar_RehabDateTime_Resume</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_Actualizar_Status_Resume</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_Actualizar_SubStatus_Resume</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_Actualizar_SuspendDateTime_Resume</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>contains</operation>
            <value>Resume</value>
        </criteriaItems>
        <description>Actualizar SubStatus y DateTime de rehabilitación en un Resume</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update Status%2C SubStatus and SuspendDate on Suspend Siniestro</fullName>
        <actions>
            <name>xOM_Status_Suspend_Siniestro</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_Siniestro</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspendDate_Suspend_Siniestro</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-Siniestro</value>
        </criteriaItems>
        <description>Update Status, SubStatus and SuspendDate on a Suspend by Siniestro</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update Status%2C SubStatus on Fraude</fullName>
        <actions>
            <name>xOM_Status_Suspend_Fraude</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_Fraude</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspensionDate_Suspend_Fraude</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>contains</operation>
            <value>Suspend-Fraude</value>
        </criteriaItems>
        <description>Update Status, SubStatus on Suspension by Fraude</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update Status%2CSubStatus%2CSuspendDateTime on a Suspend by PortOut</fullName>
        <actions>
            <name>xOM_Status_Suspend_PortOut</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_PortOut</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspendDate_Suspend_PortOut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-PortOut</value>
        </criteriaItems>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-Portabilidad</value>
        </criteriaItems>
        <description>Status,SubStatus,SuspendDateTime on a Suspend by PortOut</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update on Suspend Extravio</fullName>
        <actions>
            <name>xOM_Status_Suspend_Extravio</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_Extravio</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspendDate_Suspend_Extravio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-Extravio</value>
        </criteriaItems>
        <description>Update Fields for Suspend by Extravio</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update on Suspend Hurto</fullName>
        <actions>
            <name>xOM_Status_Suspend_Hurto</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_Hurto</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspendDate_Suspend_Hurto</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-Hurto</value>
        </criteriaItems>
        <description>Update Status, SubStatus and SuspendDate on a Suspend by Hurto</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update on Suspend Robo</fullName>
        <actions>
            <name>xOM_Status_Suspend_Robo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SubStatus_Suspend_Robo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_SuspendDate_Suspend_Robo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Sub_Status__c</field>
            <operation>equals</operation>
            <value>Suspend-Robo</value>
        </criteriaItems>
        <description>Update Status, SubStatus and SuspendDate on a Suspend by Robo</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update status from Suspended to Active</fullName>
        <actions>
            <name>xOM_ProvisioningStatus_ResumedToActive</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>xOM_Status_SuspendedToActive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.Status</field>
            <operation>equals</operation>
            <value>Suspended</value>
        </criteriaItems>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Resumed</value>
        </criteriaItems>
        <description>This rule change the Asset status from &quot;Suspended&quot; to &quot;Active&quot; on Resume flow.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update status to Active</fullName>
        <actions>
            <name>xOM_Update_status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Change to status Active when provisioning status = Active</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update status to Active from resumed</fullName>
        <actions>
            <name>Provision_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Resumed</value>
        </criteriaItems>
        <description>Change to status Active when provisioning status = Resumed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update status to Inactive</fullName>
        <actions>
            <name>xOM_Update_status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>Change to status to Inactive when provisioning status = Inactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>xOM - Update status to Preactive</fullName>
        <actions>
            <name>xOM_Update_status_to_Preactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset.vlocity_cmt__ProvisioningStatus__c</field>
            <operation>equals</operation>
            <value>Preactive</value>
        </criteriaItems>
        <description>Change to status to Preactive when provisioning status = Preactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
