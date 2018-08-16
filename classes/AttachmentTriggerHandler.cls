/**
 * Created by Alex Lazarev
 * Date: 14/12/17
 *
 * Version: 1.0
 */

public with sharing class AttachmentTriggerHandler {

    public static void checkAttachmentLimits(List<Attachment> triggerNew){
        Boolean debug = false;

        try {
            AttachmentLimitsSettings__c attchSettings = AttachmentLimitsSettings__c.getInstance('Default');
            System.debug('Attachment Settings: ' + attchSettings.AttachmentSizeLimit__c);

            // Before we do anything, we check that there were settings grabbed for Default instance
            // this kind of validation prevent null pointers
            if (attchSettings != null) {
                if(debug) System.debug('Attachment Limit Settings grabbed');
                for (Attachment attach : triggerNew) {
                    //System.debug('Attachment: ' + attach);

                    // Converting the limit from Kb to Bytes
                    Decimal attachmentSizeLimit = attchSettings.AttachmentSizeLimit__c * 1000;

                    if(debug) System.debug('Current Size Limit: ' + attachmentSizeLimit);
                    if(debug) System.debug('Attachment Size: ' + attach.BodyLength);
                    if ((Decimal) attach.BodyLength > attachmentSizeLimit) {
                        if(debug) System.debug('Attachment Limit fired');
                        AttachmentTriggerHandler.dispatchAttachmentNotification(attchSettings, attach);
                    }
                }
            }
        } catch(Exception ex){
            System.debug('Exception checkAttachmentLimits: ' + ex.getMessage());
        }

    }


    public static void attachToClosedCaseValidation(List<Attachment> triggerNew) {
        for (Attachment attachmentObject : triggerNew) {

            String caseKeyPrefixId = Case.SObjectType.getDescribe().getKeyPrefix();
            System.debug('ATTACHMENTS123'+attachmentObject.ParentId);
            System.debug('ATTACHMENTS123'+attachmentObject);
            if (String.valueOf(attachmentObject.ParentId).substring(0, 3) == caseKeyPrefixId) {
                Case caseObject = [SELECT Id, Status, LastModifiedById FROM Case WHERE Id = :attachmentObject.ParentId];

                if (caseObject.Status == 'Closed') {
                    String userId = UserInfo.getUserId();
                    String userProfileId = UserInfo.getProfileId();
                    Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

                    if (userProfile.Name != 'System Administrator') {
                        attachmentObject.addError('Solo el administrador puede adjuntar archivos a casos cerrados.');
                    }
                }
            }
        }
    }

    public static Decimal getAttachmentsObjSizeInMb(){
        Decimal attachSize;

        AggregateResult[] attachSumList = [SELECT SUM(BodyLength) FROM Attachment];
        for (AggregateResult ar : attachSumList) {
            attachSize = (Decimal) ar.get('expr0'); // Cannot apply divide to an Object
            attachSize = attachSize.divide(1000000,2);
            System.debug('Attachments Total Size Mbytes: ' + attachSize);

        }

        return attachSize;
    }

    public static void dispatchAttachmentNotification(AttachmentLimitsSettings__c attachmentLimitsSettings, Attachment attachment){
        try{
            Boolean debug = false;
            if(debug) System.debug('Attachment Notification running debug');
            // Limit above which there will be a warning message added to the email
            String[] toAddresses;

            // Reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            Messaging.reserveSingleEmailCapacity(10);
            if(debug) System.debug('Messaging reserved');

            // Getting the distribution list and splitting it.
            if(debug){
                toAddresses = new String[]{'alex.lazarev@cloudgaia.com'};
            } else {
                String distributionList = attachmentLimitsSettings.AttachmentNotifDistributionList__c;
                toAddresses = distributionList.split(';');
            }

            String user = [SELECT Id, Name FROM User WHERE Id = :attachment.CreatedById].Name;
            Decimal attachmentSize = (Decimal)attachment.BodyLength;
            Decimal attachmentSizeKb = attachmentSize.divide(1000,2);
            Decimal attachmentSizeMb = attachmentSize.divide(1000000,2);
            Decimal attachmentsObjSize = AttachmentTriggerHandler.getAttachmentsObjSizeInMb();

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = toAddresses;
            message.setSenderDisplayName('Salesforce Attachments Notifications');

            message.subject = 'Salesforce  - Attachment Limit Exceeded';
            //message.optOutPolicy = 'FILTER';
            //message.plainTextBody = 'The attachment limit was exceeded';
            message.setHtmlBody('<p>Attached file: <b>' + attachment.Name +' </b>('+ attachment.Id +')</p>' +
                    '<p>Size: <b>'+attachmentSizeKb+' Kb</b> ('+attachmentSizeMb+' Mb)<p>' +
                    '<p>Created by '+user+'.</p>'+
                    'To review the attachment file <a href='+System.URL.getSalesforceBaseUrl().toExternalForm()+'/'+attachment.Id+'>click here.</a>' +
                    '<p>&nbsp;</p>' +
                    '<p>ORG Current Attachments total size: ' + attachmentsObjSize + 'Mb - ('+attachmentsObjSize*100/400+'%)</p>' +
                    '<p>ORG Current Attachment Limit: '+attachmentLimitsSettings.AttachmentSizeLimit__c+'Kb</p>');

            if(debug) System.debug('Message for email Attachment Notification: ' + message);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});

            if (results[0].success) {
                System.debug('Salesforce Notification - Attachment Limit Exceeded email was sent successfully.');
            } else {
                System.debug('Salesforce Notification - Attachment Limit Exceeded email failed to send: ' +
                        results[0].errors[0].message);
            }

            if(debug) System.debug('getOrgDatastorageStatus execute');
            AttachmentTriggerHandler.getOrgDatastorageStatus();
        } catch(Exception ex){
            System.debug('Exception dispatchAttachmentNotification: ' + ex.getMessage());
        }
    }

    @future (callout=true)
    public static void getOrgDatastorageStatus(){

        Boolean debug = false;
        if(debug) System.debug('getOrgDatastorageStatus running debug');
        // Limit above which there will be a warning message added to the email
        Integer warningLimit = 75;
        String[] toAddresses;
        AttachmentLimitsSettings__c attachmentLimitsSettings = AttachmentLimitsSettings__c.getInstance('Default');
        String requestUrl = '/setup/org/orgstorageusage.jsp?id=' + UserInfo.getOrganizationId() + '&setupid=CompanyResourceDisk';
        String htmlCode;
        try {
            //Get the Storage Page, prepare to scrape
            PageReference pg = new PageReference(requestUrl);
            htmlCode = pg.getContent().toString();
        } catch (Exception ex) {
            System.debug('Exception dispatchAttachmentNotification: ' + ex.getMessage());
        }

        //Find the pattern
        Pattern patternToSearch = Pattern.compile('\\d+%</td></tr>');
        Matcher matcherPattern = patternToSearch.matcher(htmlCode);

        String  dataStorageString, fileStorageString, dataStorageUsedPercentage, fileStorageUsedPercentage;

        //Find the first Occurrence which is Data Storage
        if ( matcherPattern.find() ) {

            dataStorageString = htmlCode.substring(matcherPattern.start(), matcherPattern.end());
            if(debug) System.debug('**************************** dataStorageString: ' + dataStorageString);

            //Find the Subpattern
            Pattern subpatternToSearch = Pattern.compile('\\d+'); //Indica valores de la tabla de porcentages
            Matcher matcherPatternPercentage = subpatternToSearch.matcher(dataStorageString);

            if ( matcherPatternPercentage.find() ) {

                dataStorageUsedPercentage = dataStorageString.substring(matcherPatternPercentage.start(), matcherPatternPercentage.end());
                if(debug) System.debug('**************************** dataStorageUsedPercentage: ' + dataStorageUsedPercentage);

            }else{
                dataStorageString =  null;
            }
        }

        //Find the first Occurrence; which is File Storage
        if ( matcherPattern.find() ) {

            fileStorageString = htmlCode.substring(matcherPattern.start(), matcherPattern.end());
            if(debug) System.debug('**************************** fileStorageString: ' + fileStorageString);


            Pattern subpatternToSearch = Pattern.compile('\\d+'); //Indica valores de la tabla de percentages
            Matcher matcherPatternPercentage = subpatternToSearch.matcher(fileStorageString);

            if ( matcherPatternPercentage.find() ) {
                fileStorageUsedPercentage = fileStorageString.substring(matcherPatternPercentage.start(), matcherPatternPercentage.end());
            }else{
                fileStorageString = null;
            }
        }

        if ((warningLimit <= integer.valueof(dataStorageUsedPercentage)) || (warningLimit <= integer.valueof(fileStorageUsedPercentage)) || debug) {
            try {
                // Reserve email capacity for the current Apex transaction to ensure
                // that we won't exceed our daily email limits when sending email after
                // the current transaction is committed.
                Messaging.reserveSingleEmailCapacity(10);
                if (debug) System.debug('Messaging reserved');

                // Getting the distribution list and splitting it.
                if (debug) {
                    toAddresses = new String[]{
                            'alex.lazarev@cloudgaia.com'
                    };
                } else {
                    String distributionList = attachmentLimitsSettings.AttachmentNotifDistributionList__c;
                    toAddresses = distributionList.split(';');
                }

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = toAddresses;
                message.setSenderDisplayName('Salesforce Storage Notifications');

                message.subject = 'Salesforce Storage Warning - DataStorage: ' + dataStorageUsedPercentage + '% - FileStorage: ' + fileStorageUsedPercentage+'%';
                //message.optOutPolicy = 'FILTER';
                //message.plainTextBody = 'The attachment limit was exceeded';
                message.setHtmlBody('<p>DataStorage current status: <b>' + dataStorageUsedPercentage + '%</b><br/>' +
                        'FileStorage current status: <b>' + fileStorageUsedPercentage + '%</b></p>' +
                        '<p>&nbsp;</p>' +
                        'To review the storage current status <a href=' + System.URL.getSalesforceBaseUrl().toExternalForm() + '' + requestUrl + '>click here</a>.');

                if (debug) System.debug('Message for email Storage Notifications: ' + message);
                Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
                        message
                });

                if (results[0].success) {
                    System.debug('Salesforce Notification - Attachment Limit Exceeded email was sent successfully.');
                } else {
                    System.debug('Salesforce Notification - Attachment Limit Exceeded email failed to send: ' +
                            results[0].errors[0].message);
                }
            } catch (Exception ex) {
                System.debug('Exception dispatchAttachmentNotification: ' + ex.getMessage());
            }
        }
    }
}