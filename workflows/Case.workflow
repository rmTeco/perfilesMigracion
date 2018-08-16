<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email</fullName>
        <description>Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>federico.h.biaus@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>geraldina.fiore@personal.com.ar</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CLUB_PERSONAL_ALTA</template>
    </alerts>
    <alerts>
        <fullName>Notificaci_n_SLA_vencido</fullName>
        <description>Notificación SLA vencido</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Care_SLA_vencido</template>
    </alerts>
    <alerts>
        <fullName>TestEmailAlert</fullName>
        <ccEmails>lino.acosta@accenture.com</ccEmails>
        <description>TestEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <recipient>federico.h.biaus@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CLUB_PERSONAL_ALTA</template>
    </alerts>
    <alerts>
        <fullName>TestEmailAlert2</fullName>
        <ccEmails>federico.h.biaus@accenture.com</ccEmails>
        <description>TestEmailAlert2</description>
        <protected>false</protected>
        <recipients>
            <recipient>lino.acosta@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CLUB_PERSONAL_ALTA</template>
    </alerts>
    <alerts>
        <fullName>testmail</fullName>
        <description>testmail</description>
        <protected>false</protected>
        <recipients>
            <recipient>alex.lazarev@cloudgaia.com.fan</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>federico.h.biaus@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CLUB_PERSONAL_ALTA</template>
    </alerts>
    <fieldUpdates>
        <fullName>Asignar_caso_a_backoffice</fullName>
        <description>Asigna el caso al bakoffice</description>
        <field>OwnerId</field>
        <lookupValue>BackOfficeTest</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Asignar caso a backoffice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Asignar_caso_a_backoffice1</fullName>
        <description>Asignar caso a backoffice</description>
        <field>OwnerId</field>
        <lookupValue>BackOfficeTest</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Asignar caso a backoffice</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseCloseOnViolation</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case on non SMS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeStatusChangeStatusToDerivada</fullName>
        <description>Change Status to Derivada.</description>
        <field>Status</field>
        <literalValue>Derivada</literalValue>
        <name>ChangeStatusToDerivada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status</fullName>
        <description>Cambia el estado del caso a &quot;En autorización&quot;</description>
        <field>Status</field>
        <literalValue>En autorización</literalValue>
        <name>Change_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_EnAutorizacion</fullName>
        <description>Cambia el estado del caso a En Autorizacion. Significa que el Revisor la aprobo, y tiene que continuar el autorizante</description>
        <field>Status</field>
        <literalValue>En autorización</literalValue>
        <name>Change_Status_EnAutorizacion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_EnEsperaDeEjecucion</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>Change_Status_EnEsperaDeEjecucion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_EnEsperaEjecucion</fullName>
        <description>Una vez aprobada por el autorizante pasa a En Espera de Ejecucion</description>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>Change_Status_EnEsperaDeEjecucion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_Rechazada</fullName>
        <description>Cambia el estado del caso a &quot;No se pudo realizar&quot;</description>
        <field>Status</field>
        <literalValue>No se pudo realizar</literalValue>
        <name>Change_Status_Rechazada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CloseCase</fullName>
        <field>Status</field>
        <literalValue>Resuelta exitosa</literalValue>
        <name>CloseCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_on_Violation</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close on Violation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Comment_Milestone</fullName>
        <description>asd</description>
        <field>Resolution_Comment__c</field>
        <formula>&quot;Milestone run&quot;</formula>
        <name>Comment Milestone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsEscalated</fullName>
        <field>IsEscalated</field>
        <literalValue>1</literalValue>
        <name>IsEscalated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseStatus</fullName>
        <field>Status</field>
        <literalValue>Derivada</literalValue>
        <name>UpdateCaseStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateNotify</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>UpdateNotify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatusField</fullName>
        <field>Status</field>
        <literalValue>Derivada</literalValue>
        <name>UpdateStatusField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatusToDerivada</fullName>
        <description>Update Case status to Derivada</description>
        <field>Status</field>
        <literalValue>Derivada</literalValue>
        <name>UpdateStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Resolution_Comment_on_non_SMS</fullName>
        <description>Se cierra gestión no completada ya que no se recibió mensaje de confirmación</description>
        <field>Resolution_Comment__c</field>
        <formula>&quot;Se cierra gestión no completada ya que no se recibió mensaje de confirmación&quot;</formula>
        <name>Update Resolution Comment on non SMS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>changeStatus</fullName>
        <description>Change Status to Derivada</description>
        <field>Status</field>
        <literalValue>Derivada</literalValue>
        <name>changeStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setStatusEnEspera</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>setStatusEnEspera</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>setStatusExpirado</fullName>
        <field>Status</field>
        <literalValue>Expirada</literalValue>
        <name>setStatusExpirado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test</fullName>
        <field>Subject</field>
        <formula>&apos;Prueba Workflow&apos;</formula>
        <name>test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>testUpdate</fullName>
        <description>Status</description>
        <field>Status</field>
        <literalValue>Pendiente de retiro</literalValue>
        <name>testUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatus</fullName>
        <description>Cambiar el Status del caso a &quot;En espera de ejecución&quot; para disparar el process builder y escalar el caso al superior dentro de la gerarquía.</description>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusDerivar</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatusDerivar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusExpirada</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatusExpirada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusTemporal</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatusTemporal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusToDerivar</fullName>
        <description>Actualizar Status a &quot;En espera de ejecución&quot; para escalar el caso mediante el process builder.</description>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatusToDerivar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateStatusToDerivation</fullName>
        <field>Status</field>
        <literalValue>En espera de ejecución</literalValue>
        <name>updateStatusToDerivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>RAV_SendAdjustmentToHW</fullName>
        <apiVersion>42.0</apiVersion>
        <description>Ejecuta la integración de ajustes de HW</description>
        <endpointUrl>http://prueba</endpointUrl>
        <fields>AccountId</fields>
        <fields>Id</fields>
        <fields>vlocity_cmt__Amount__c</fields>
        <fields>vlocity_cmt__ServiceId__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>geraldina.fiore@personal.com.ar</integrationUser>
        <name>RAV-SendAdjustmentToHW</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>SelfManagementCloseCase</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Technical Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Asteriscos TP,Otros Asteriscos,Nros. emergencia,0800,WEB,APP,WAP,USSD,Mi Personal (SIM)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CloseCase</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ta_techCare_automaticRejectionOfBudget</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RelatedTechQuoteStatus__c</field>
            <operation>equals</operation>
            <value>Pendiente de aprobación</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>En espera del cliente</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>Gestión de Servicio Técnico</value>
        </criteriaItems>
        <description>Automatic rejection of budget after 10 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ChangeStatusChangeStatusToDerivada</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Notificacion_Prueba</fullName>
        <assignedTo>oswaldo.morales@certaconsulting.net.fan</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Prueba</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.SlaStartDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Notificacion Prueba</subject>
    </tasks>
    <tasks>
        <fullName>PendienteAprobacionBackoffice</fullName>
        <assignedToType>owner</assignedToType>
        <description>Tarea para aprobar un ajuste</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Modified_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>PendienteAprobacionBackoffice</subject>
    </tasks>
    <tasks>
        <fullName>TestForApprovalProcess</fullName>
        <assignedTo>lino.acosta@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>45</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.Start_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>TestForApprovalProcess</subject>
    </tasks>
</Workflow>
