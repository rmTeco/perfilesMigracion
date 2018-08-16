@RestResource(urlMapping='/xom/repro')
global with sharing class xOMReproRESTService  {

    @HttpPost
    global static void initiatePrepaidPreactivation() {
        RestContext.response.addHeader('Context-Type', 'application/json');

        try {
        	String reproLinesJSON = RestContext.request.requestBody.toString();

	        xOMReproLoader.ReproLinesRequestObject reproLinesRequest = (xOMReproLoader.ReproLinesRequestObject) JSON.deserialize(reproLinesJSON, xOMReproLoader.ReproLinesRequestObject.class);
	        xOMReproLoader.ResultObj resultObject = xOMReproLoader.generateReproJobsFromJSON(reproLinesRequest);

	        RestContext.response.statusCode = resultObject.resultCode;
	        RestContext.response.responseBody = Blob.valueOf(resultObject.resultMessage);
        }
        catch(Exception ex) {
        	// Error response
	        RestContext.response.statusCode = 500;
	        //RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
        }
    }

    /*
    {
        "loteID": 5, //cantidad de simcards
        "reproLines": [
            {
                "wholesaleId"; "0016C0000098zq3",
                "wholesaleId"; "ASgsd",
                "msisdn": "1167654354",
                "imsi": "12321430284390",
                "iccid": "23325463452434242454522",
                "offerId": "0016C0000098zq3"
            },
            {
                "wholesaleId"; "0016C0000098zq3",
                "wholesaleName"; "ASDsda",
                "msisdn": "1167654354",
                "imsi": "12321430284390",
                "iccid": "23325463452434242454522",
                "offerId": "0016C0000098zq3"
            }
        ]
    }
    */
}

//loteID
//wholesaleName si no existe la account se crea con este nombre