public class showPdfTest {
    
    public showPdfTest(){}
        public Attachment att {
        get {
            if (att == null) {
                att = [SELECT Body, ContentType, Name FROM Attachment WHERE ID = '00P6C000000uTBdUAM'];
            }
            return att;
        }
        private set;
    }
    public String pdf {
        get {
            Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String,Object> options = new Map<String, Object>();
            IFS_S073_getBill S073 = new IFS_S073_getBill();
            //Map<String, Object> output = S073.getBill(inputMap,outMap,options);
            S073.invokeMethod('getBill',inputMap,outMap,options);
            system.debug('outMap = '+outMap);
            Map<String, Object> IPResult = (Map<String, Object>)outMap.get('IPResult');
            system.debug('IPResult = '+IPResult);
            Map<String, Object> renderTransformResult = (Map<String, Object>)IPResult.get('renderTransformResult');
            system.debug('renderTransformResult = '+renderTransformResult);
            String pagedatabytes = (String)renderTransformResult.get('pagedatabytes');
            system.debug('pagedatabytes = '+pagedatabytes);
            return pagedatabytes;
            //return EncodingUtil.Base64Encode(pagedatabytes2);
        }
    }
    
   public String pdf2 {
        get {
            /*Map<String, Object> inputMap = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            Map<String,Object> options = new Map<String, Object>();
            IFS_S073_getBill S073 = new IFS_S073_getBill();
            //Map<String, Object> output = S073.getBill(inputMap,outMap,options);
            S073.invokeMethod('getBill',inputMap,outMap,options);
            system.debug('outMap = '+outMap);
            Map<String, Object> IPResult = (Map<String, Object>)outMap.get('IPResult');
            system.debug('IPResult = '+IPResult);
            Map<String, Object> renderTransformResult = (Map<String, Object>)IPResult.get('renderTransformResult');
            system.debug('renderTransformResult = '+renderTransformResult);
            String pagedatabytes = (String)renderTransformResult.get('pagedatabytes');
            system.debug('pagedatabytes = '+pagedatabytes);*/
            
            
            //Blob afterblob = EncodingUtil.base64Decode(pagedatabytes);
            //Blob newBlob = new Blob([afterblob], {type: "application/pdf"});
            
            
            return EncodingUtil.Base64Encode(att.body);
        }
    }
}