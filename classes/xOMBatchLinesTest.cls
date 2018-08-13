@isTest(seeAllData=false)
global class xOMBatchLinesTest {

    static xOMBatchLines.BatchLinesRequestObject batchLinesReqObj = null;
    static Map<String, Object> batchLineReqUnTyped = null;

    @isTest static void testBatchLinesRequestObject () {
        System.debug('Method --> testBatchLinesRequestObject');
        Test.startTest();
        createBatchLinesRequestObject();
        xOMBatchLines.ResultObj ro = xOMBatchLines.generateBatchJobsFromJSON(batchLinesReqObj);
        System.assertEquals(Integer.valueOf('200'), ro.resultCode); 
        Test.stopTest();
    }
    
    @isTest static void testBatchLinesUntyped () {
        System.debug('Method --> testBatchLinesUntyped');
        Test.startTest();
        createBatchLinesUntypedObject();
        xOMBatchLines.ResultObj ro = xOMBatchLines.generateBatchJobsFromJSONUntyped(batchLineReqUnTyped);
        System.assertEquals(Integer.valueOf('200'), ro.resultCode); 
        Test.stopTest();
    }

    @isTest static void testBatchLinesReqObjectBad () {
        System.debug('Method --> testBatchLinesReqObjectBad');
        Test.startTest();
        xOMBatchLines.ResultObj ro = xOMBatchLines.generateBatchJobsFromJSON(null);
        System.assertEquals(Integer.valueOf('400'), ro.resultCode); 
        Test.stopTest();
    }

    @isTest static void testBatchLinesUnTypedBad () {
        System.debug('Method --> testBatchLinesUnTypedBad');
        Test.startTest();
        xOMBatchLines.ResultObj ro = xOMBatchLines.generateBatchJobsFromJSONUntyped(null);
        System.assertEquals(Integer.valueOf('400'), ro.resultCode); 
        Test.stopTest();
    }


    static void createBatchLinesRequestObject () {
        batchLinesReqObj = new xOMBatchLines.BatchLinesRequestObject();
        batchLinesReqObj.lines = new List<Object>();
        batchLinesReqObj.typeOfJob = 'Nominatividad';
        batchLinesReqObj.lines.add(JSON.serialize('{"activateNominatedService":{"nroLinea": "3413102678","tipoDocumento": "DNI","numeroDocumento":"2444233","nombre":"Pinola","apellido":"Pinola","genero":"M","fechaNacimiento":"1987-04-04","calle":"Av. pehuelche 3444" }}'));
    }

    static void createBatchLinesUntypedObject () {
        batchLineReqUnTyped = new Map<String, Object>();
        List<Object> lines = new List<Object>();
        batchLineReqUnTyped.put('typeOfJob','Nominatividad');
        batchLineReqUnTyped.put('lines',lines);
        lines.add (JSON.serialize('{"activateNominatedService":{"nroLinea": "3413102678","tipoDocumento": "DNI","numeroDocumento":"2444233","nombre":"Pinola","apellido":"Pinola","genero":"M","fechaNacimiento":"1987-04-04","calle":"Av. pehuelche 3444" }}'));
    }
}