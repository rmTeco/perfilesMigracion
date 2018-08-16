<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>KB_Article_ExternalId</fullName>
        <field>KB_ExternalID__c</field>
        <formula>&apos;KB_&apos;
+ 
&apos;_&apos;
+
SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(
TEXT(NOW()), &quot;-&quot;, &quot;&quot;), &quot;:&quot;, &quot;&quot;), &quot; &quot;, &quot;&quot;)</formula>
        <name>KB_Article_ExternalId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>KB_BorrarVotosAP</fullName>
        <description>Se setea en True el campo de borrar votos, para ejecutar el process builder que realiza el delete ante un cambio de versión.</description>
        <field>KB_BorrarVotos__c</field>
        <literalValue>1</literalValue>
        <name>KB_BorrarVotosAP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>KB_ArticlePublish</fullName>
        <action>Publish</action>
        <description>Publico el artículo sin cambiar la versión.</description>
        <label>Publish Article</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>KB_ArticlePublishNew</fullName>
        <action>PublishAsNew</action>
        <description>Publico el artículo con una nueva versión</description>
        <label>Publish Article as New</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>KB_Articulo_ExternalId</fullName>
        <actions>
            <name>KB_Article_ExternalId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>KB_Article__kav.KB_ExternalID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Regla que genera el campo &quot;External ID&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
