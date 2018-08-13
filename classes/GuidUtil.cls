/**
* Provides logic support to UUID Generator
*
*/
global class GuidUtil {
    
    /*
     * Generate Random UUID
     *
     */
    global static String NewGuid() {
        String returnValue;
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        returnValue = h.SubString(0,4);
        returnValue += '-';
        returnValue += h.SubString(4,8);
        returnValue += '-';
        returnValue += h.SubString(8,12);
        returnValue += '-';
        returnValue += h.SubString(12,16);
        returnValue += '-';
        returnValue += h.SubString(16,19);
        return returnValue;
    }

}