public class MarketingUtil {
	
    public static List<String> obtainPicklistValues(String objectName, String fieldName) {
      List<String> values = new List<String>();
      String[] types = new String[]{objectName};
          
      Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
      for(Schema.DescribeSobjectResult res : results) {
         for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
            if (entry.isActive()) {
                values.add(entry.getValue());
            }
         }
      }
      return values;
   }
}