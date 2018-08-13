@isTest
private class GuidUtilTest{

 @isTest static void runUUIDGenerate() {
     String xGlobalTransactionOneId = GuidUtil.NewGuid();
     String xGlobalTransactionTwoId = GuidUtil.NewGuid();
     System.assertNotEquals(xGlobalTransactionOneId,xGlobalTransactionTwoId);
  }
  
}