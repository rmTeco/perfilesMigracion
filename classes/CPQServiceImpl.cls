public class CPQServiceImpl implements ICPQService {
    private vlocity_cmt.CpqAppHandler cpqApi;
    @TestVisible private Id orderId = '8016C0000000hj1';
    @TestVisible private String decomposeOrderResponse = 'OK';

    public CPQServiceImpl() {
        cpqApi = new vlocity_cmt.CpqAppHandler();
    }

    public Id AssetToOrder(Id accountId, DateTime requestDate, Set<Id> assetIds) {
        try {

            Id orderId;
            Map<String, Object> input = this.GenerateAssetToOrderInputJSON(accountId, requestDate, assetIds);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();

            if (Test.IsRunningTest()) {
                orderId = this.orderId;
            }
            else {

                cpqApi.InvokeMethod('assetToOrder', input, output, options);
                
                vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) output.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
                Map<String, Object> fields = (Map<String, Object>) result.records[0].fields;
                orderId = (Id) fields.get('cartId');
               
            }

            return orderId;
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    public String SubmitOrder(Id orderId) {
        try {
            String response;

            if (Test.IsRunningTest())
                response = this.decomposeOrderResponse;
            else
                response = vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(orderId, true); 

            return response;
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private Map<String, Object> GenerateAssetToOrderInputJSON(Id accountId, DateTime requestDate, Set<Id> assetIds) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            String assets = String.Join(new List<Id>(assetIds), ',');
            
            input.put('id', assets);
            input.put('accountId', String.ValueOf(accountId));
            input.put('requestDate', requestDate.format('YYYY-MM-dd'));
            input.put('subaction', 'assetToOrder');
            input.put('methodName', 'assetToOrder');

            return input;
        }
        catch (Exception ex) {
            throw ex;
        }
    }
}