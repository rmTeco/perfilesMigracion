@isTest public class taNewContactTestDataFactory {
    public static List<Object> createNewContactSelectableData() {
        Map<String,String> DNI = new Map<String, String>();
        DNI.put('name', 'DNI');
        //DNI.put('value', 'Documento Nacional de Identidad');
        DNI.put('value', 'DNI');
        Map<String,String> LEN = new Map<String, String>();
        LEN.put('name', 'LEN');
        LEN.put('value', 'Libreta de Enrolamiento');
        Map<String,String> LCV = new Map<String, String>();
        LCV.put('name', 'LCV');
        LCV.put('value', 'Libreta Civica');
        Map<String,String> PAS = new Map<String, String>();
        PAS.put('name', 'PAS');
        PAS.put('value', 'Pasaporte');
        Map<String,String> CUIT = new Map<String, String>();
        CUIT.put('name', 'CUIT');
        CUIT.put('value', 'CUIT');
        
        
        
        
        List<Object> newContactSelectableDataList = new List<Object>();
        newContactSelectableDataList.add(DNI);
        newContactSelectableDataList.add(LEN);
        newContactSelectableDataList.add(LCV);
        newContactSelectableDataList.add(PAS);
        newContactSelectableDataList.add(CUIT);
        
        return newContactSelectableDataList;
    }
}