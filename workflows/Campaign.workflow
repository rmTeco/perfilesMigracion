<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Mkt_Aviso_fin_de_campana</fullName>
        <description>Mkt - Aviso fin de campaña</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Mkt_Alert_campaign_end</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_when_a_campaign_is_created_or_edited</fullName>
        <description>Send Email when a campaign is created or edited</description>
        <protected>false</protected>
        <recipients>
            <recipient>Campaign_Notifications_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/send_Email_when_a_campaign_is_created_or_edited</template>
    </alerts>
    <alerts>
        <fullName>send_Email_when_a_campaign_status_is_aborted</fullName>
        <description>send Email when a campaign status is aborted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/send_Email_when_a_campaign_status_is_aborted</template>
    </alerts>
    <rules>
        <fullName>Mkt - Alert campaign end</fullName>
        <active>true</active>
        <description>Send email alert when campaign is going to end</description>
        <formula>NOT(ISNULL(EndDate))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Mkt_Aviso_fin_de_campana</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
