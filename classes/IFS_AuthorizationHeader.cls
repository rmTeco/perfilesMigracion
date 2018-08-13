global class IFS_AuthorizationHeader {
    
    global static String giveHeader(){
        String username='webvas';
        String password='webvas';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        return authorizationHeader;
    }

}