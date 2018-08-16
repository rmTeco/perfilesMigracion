@RestResource(urlMapping='/xom/batch')
global with sharing class xOMBatchJobRESTService {

	@HttpPost
    global static void createBatchJobRecords() {
        //RestRequest request = RestContext.request;
        //RestResponse response = RestContext.response;
        RestContext.response.addHeader('Context-Type', 'application/json');

        try {
        	String batchLinesJSON = RestContext.request.requestBody.toString();

	        //xOMBatchLines.BatchLinesRequestObject reproLinesRequest = (xOMBatchLines.BatchLinesRequestObject) JSON.deserialize(batchLinesJSON, xOMBatchLines.BatchLinesRequestObject.class);
	        //xOMBatchLines.ResultObj resultObject = xOMBatchLines.generateBatchJobsFromJSON(reproLinesRequest);
	        xOMBatchLines.ResultObj resultObject = xOMBatchLines.generateBatchJobsFromJSONUntyped((Map<String, Object>) JSON.deserializeUntyped(batchLinesJSON));

	        RestContext.response.statusCode = resultObject.resultCode;
	        RestContext.response.responseBody = Blob.valueOf(resultObject.resultMessage);
        }
        catch(Exception ex) {
        	// Error response
	        RestContext.response.statusCode = 500;
	        RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
        }
    }
}