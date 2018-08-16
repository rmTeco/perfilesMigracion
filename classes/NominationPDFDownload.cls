global with sharing class NominationPDFDownload implements vlocity_cmt.VlocityOpenInterface{

    global NominationPDFDownload() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('invokeMethod');
        System.debug('DEBUG:inputMap '+inputMap);
        Boolean result = true;
        try
        {
            if (methodName.equals('getPdf')){
                getPdf(inputMap, outMap);
            }else{ 
                result = false;
            }  
            System.debug('outMap:' + outMap);
        } 
        catch(Exception e)
        {
            System.debug('NominationPDFDownload:invokeMethod -> exception: '+e);
            throw e;
            //result = false;
        }
        return result;
    }

    public static void getPdf(Map<String,Object> inputMap, Map<String,Object> outMap){
        System.debug('getPdf');
        Map<String,Object> contac = (Map<String,Object>) inputMap.get('Contact');
        String documentType = (String)contac.get('DocumentType');
        System.debug('DEBUG:documentType '+ documentType);
        if(documentType.equalsIgnoreCase('PAS')){
            getPdfExtrangero(inputMap, outMap);
        }else{
            getPdfArgentino(inputMap, outMap);
        }       
    }

     public static void getPdfArgentino(Map<String,Object> inputMap, Map<String,Object> outMap){
        System.debug('getPdfArgentino');
        PageReference pag = Page.taSalesNominacionArgentino;
        Map<String,Object> account = (Map<String,Object>) inputMap.get('Account');
        String accountId= (String) account.get('Id') ;
        pag.getParameters().put('accountId', accountId);
        //Blob reportPdf = pag.getContentAsPDF();
        Blob reportPdf ;
        if (Test.IsRunningTest())
       {
            reportPdf=Blob.valueOf('UNIT.TEST');
       }
       else
       {
            reportPdf=pag.getContentAsPDF();
       }
        Attachment att = new Attachment();
        att.ParentId = accountId;
        att.Name = 'PdfArgentino';
        att.ContentType = 'application/pdf';
        att.Body = reportPdf;
        insert att;
        download(att, outMap);
    }

     public static void getPdfExtrangero(Map<String,Object> inputMap, Map<String,Object> outMap){
        System.debug('getPdfExtrangero');
        PageReference pag = Page.taSalesNominacionExtranjero;
        Map<String,Object> account = (Map<String,Object>) inputMap.get('Account');
        String accountId= (String) account.get('Id') ;
        pag.getParameters().put('accountId', accountId);
       // Blob reportPdf = pag.getContentAsPDF();
        Blob reportPdf ;
        if (Test.IsRunningTest())
        {
            reportPdf=Blob.valueOf('UNIT.TEST');
        }
        else
        {
            reportPdf=pag.getContentAsPDF();
        }
        Attachment att = new Attachment();
        att.ParentId = accountId; //Id del objeto donde se agrega el doc.
        att.Name = 'PdfExtrangero';
        att.ContentType = 'application/pdf';
        att.Body = reportPdf;
        insert att;
        download(att, outMap);
    }

    public static void download(Attachment att, Map<String,Object> outMap){
        System.debug('download');
        String downloadUr;
        if(att != null){
            downloadUr =  '/servlet/servlet.FileDownload?file='+string.valueOf(att.id);
            System.debug('url PDF: '+downloadUr);
        }
        outMap.put('downloadUrl', downloadUr);
    }
    
}