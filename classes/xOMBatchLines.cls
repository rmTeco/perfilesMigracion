public with sharing class xOMBatchLines {
	public static Integer LINES_PER_BULK_JOB = 1000;
	public static Set<String> validJobTypes = new Set<String>{'Repro', 'Nominatividad', 'Rehabilitacion'};

	public static ResultObj generateBatchJobsFromJSON(BatchLinesRequestObject batchLineRequest) {
		ResultObj resultObject;

		if(!validateRequest(batchLineRequest)) {
			resultObject = new ResultObj(400, 'Request failed validations');
			return resultObject;
		}

		List<XOMBatchLineJob__c> reproLinesSObjectList = new List<XOMBatchLineJob__c>();
		
		for(Object bl : batchLineRequest.lines) {
			XOMBatchLineJob__c xomBLJ = new XOMBatchLineJob__c();
			xomBLJ.JSON__c = JSON.serialize(bl);
			xomBLJ.OrderProcessed__c = false;
			xomBLJ.Type__c = batchLineRequest.typeOfJob;
			reproLinesSObjectList.add(xomBLJ);
		}

		insert reproLinesSObjectList;

		resultObject = new ResultObj(200, 'Lines added to the queue.');

		return resultObject;

	}

	public static ResultObj generateBatchJobsFromJSONUntyped(Map<String, Object> batchLineRequest) {
		ResultObj resultObject;

		if(!validateRequestUntyped(batchLineRequest)) {
			resultObject = new ResultObj(400, 'Request failed validations');
			return resultObject;
		}

		List<XOMBatchLineJob__c> reproLinesSObjectList = new List<XOMBatchLineJob__c>();

		String jobType = (String) batchLineRequest.get('typeOfJob');
		List<Object> objectList = (List<Object>) batchLineRequest.get('lines');
		
		for(Object bl : objectList) {
			XOMBatchLineJob__c xomBLJ = new XOMBatchLineJob__c();
			xomBLJ.JSON__c = JSON.serialize(bl);
			xomBLJ.OrderProcessed__c = false;
			xomBLJ.Type__c = jobType;
			reproLinesSObjectList.add(xomBLJ);
		}

		insert reproLinesSObjectList;

		resultObject = new ResultObj(200, 'Lines added to the queue.');

		return resultObject;
	}

	public static Boolean validateRequest(BatchLinesRequestObject batchLineRequest) {
		return batchLineRequest != null && 
				batchLineRequest.lines != null && 
				batchLineRequest.lines.size() <= 1000 &&
				batchLineRequest.typeOfJob != null &&
				validJobTypes.contains(batchLineRequest.typeOfJob);
	}

	public static Boolean validateRequestUntyped(Map<String, Object> batchLineRequest) {
		return batchLineRequest != null && 
				batchLineRequest.containsKey('typeOfJob') &&
				validJobTypes.contains((String) batchLineRequest.get('typeOfJob')) &&
				batchLineRequest.containsKey('lines') && 
				batchLineRequest.get('lines') != null &&
				((List<Object>)batchLineRequest.get('lines')).size() <= 1000;
	}

	public class ResultObj {
		public Integer resultCode;
		public String resultMessage;

		public ResultObj(Integer code, String msg) {
			this.resultCode = code;
			this.resultMessage = msg;
		}
	}

	
	public class BatchLinesRequestObject {
		public Integer numLines;
		public String typeOfJob;
		public List<Object> lines;
	}
/*
	public class activateNominatedService {
		public String codCliente;
		public String ticket;
		public String nroLinea;
		public String numeroDocumento;
		public String tipoDocumento;

	}*/

}