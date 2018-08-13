public with sharing class xOMReproPostImportReportController {

  public List<xOMReproJobLoteResults> reproLines {get; set;}
  public xOMReproJobLoteResults reproLinesLoteDetail {get; set;}

  public String selectedLoteId {get; set;}

  public Date startDate {get; set;}
  public Date endDate {get; set;}

  public Id wholesaleId;

  private final String aggregateQueryFields = 'SELECT Lote_Id__c, Account__c wholesaleId, min(Account__r.Name) wholesaleName, count(Id) loteSize, sum(ProcessingFailedCount__c) failedCount, sum(OrderCreatedCount__c) createdCount, sum(ItemsAddedToOrderCount__c) withProductsCount, sum(OrderDecomposedCount__c) decomposedCount, sum(OrderActivatedCount__c) activatedCount ';
  private final String aggregateQueryFromClause = ' FROM XOMBatchLineJob__c WHERE Type__c = \'Repro\' ';
  private final String aggregateQueryGroupByClause = ' GROUP BY Lote_Id__c, Account__c ';

  public List<xOMReproJobLoteResults> jobResultsForWholesaleId;

  public xOMReproPostImportReportController() {

    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:reproReporter/lotesDetails');
    req.setMethod('GET');
    String authorizationHeader = 'Basic ' + 'dmxvY2l0eTpzR25ZbW1jdGp2VEtOemNzazlLNg==';
    req.setHeader('Authorization', authorizationHeader);
    Http http = new Http();
    String responseBody;
    if(Test.isRunningTest()) {
      responseBody = '[{"loteId": "3065","wholesaleAccount": "0016C000009KUy8","totalLineas": "3","ordenesCreadas": "3","ordenesConProductos": "3","ordenesDescompuestas": "3","ordenesActivadas": "0","ordenesFallidas": "3","percentageOrdenesCreadas": "100","percentageOrdenesConProductos": "100","percentageOrdenesDescompuestas": "100","percentageOrdenesActivadas": "0","percentageOrdenesFallidas": "100","initTimestamp": "2018-05-16T19:37:24.255Z","endTimestamp": null}]';
    }
    else {
      HTTPResponse res = http.send(req);
      responseBody = res.getBody();
    }
    
    System.debug(responseBody);

    reproLines = (List<xOMReproJobLoteResults>) JSON.deserialize(responseBody, List<xOMReproJobLoteResults>.class);
    getLoteDetail();

  }

  public void getLoteDetail() {

    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:reproReporter/loteDetailsOrders/'+selectedloteid);
    req.setMethod('GET');
    String authorizationHeader = 'Basic ' + 'dmxvY2l0eTpzR25ZbW1jdGp2VEtOemNzazlLNg==';
    req.setHeader('Authorization', authorizationHeader);
    Http http = new Http();
    String responseBody;
    if(Test.isRunningTest()) {
      responseBody = '[{"registro": "3307481d-3b51-46ff-862c-26522c021419-003065","orden": "ad917ba5-28e4-4a51-a312-59c4c2b0d445","statusOrden": "COMPLETED","statusLegacy": "Not yet implemented","ordenCreada": "YES","productosAdded": "YES","ordenDescompuesta": "YES","ordenActivada": "NO","ordenFallida": "YES","mensaje": "Success","orchPlanId": "2913547483941901313","reported": null,"conclusiontimestamp": "2018-05-16T19:45:28.769Z"}]';
    }
    else {
      HTTPResponse res = http.send(req);
      responseBody = res.getBody();
    }
    

    List<xOMReproJobLoteResultsDetail> loteLineDetail = (List<xOMReproJobLoteResultsDetail>) JSON.deserialize(responseBody, List<xOMReproJobLoteResultsDetail>.class);

    for(xOMReproJobLoteResults reproline: reproLines){

      if(reproline.loteId == selectedLoteId){
        reproLinesLoteDetail = reproline;
        reproLinesLoteDetail.listOfLines = loteLineDetail;

      }

    }

  }

  public List<SelectOption> getWholesaleAccounts() {
    List<SelectOption> options = new List<SelectOption>();
    for(Account a : [Select Id, Name From Account]) {
      options.add(new SelectOption(a.Name, a.Id));
    }
    return options;
  }

  public class xOMReproJobLoteResults {
    public String wholesaleAccount {get; set;}
    public String wholesaleName {get; set;}
    public String loteId {get; set;}
    public Integer totalLineas {get; set;}
    public Integer ordenesFallidas {get; set;}
    public Integer ordenesCreadas {get; set;}
    public Integer ordenesConProductos {get; set;}
    public Integer ordenesDescompuestas {get; set;}
    public Integer ordenesActivadas {get; set;}
    public String initTimestamp {get; set;} 
    public String endTimestamp {get; set;}     
    public List<xOMReproJobLoteResultsDetail> listOfLines {get; set;}
  }

  public class xOMReproJobLoteResultsDetail {
  
    public String statusOrden {get; set;}
    public String ordenCreada {get; set;}
    public String productosAdded {get; set;} 
    public String ordenDescompuesta {get; set;} 
    public String ordenActivada {get; set;} 
    public String ordenFallida {get; set;} 
    public String mensaje {get; set;}
    public String registro {get; set;}
    public String orden {get; set;}
    public String orchPlanId {get; set;}
    
             
  }
/*
  public class xOMReproJobResult {
    public Boolean orderCreated {get; set;}
    public Boolean itemsAddedToOrder {get; set;}
    public Boolean orderDecomposed {get; set;}
    public Boolean orderActivated {get; set;}
    public Boolean failed {get; set;}
    public String errorMessage {get; set;}
    public String orderId {get; set;}
    public String recordName {get; set;}
    public String recordId {get; set;}
    public xOMReproLoader.ReproLine lineDetails;
  }*/

}