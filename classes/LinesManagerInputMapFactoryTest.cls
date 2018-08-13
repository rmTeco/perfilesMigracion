@isTest
public class LinesManagerInputMapFactoryTest {
    public static Map<String, Object> generateInputMap() {
        Map<String, Object> inputMap = new Map<String, Object>();
        
        Map<String, Object> Order = new Map<String, Object>();
        List<Object> Planes = new List<Object>();
        List<Object> Lineas = new List<Object>();
        Map<String, Object> Account = new Map<String, Object>();
       	Account.put('BillingState', 'SomeRandomValue');
        Account.put('BillingCity', 'SomeRandomValues');
        Map<String, Object> LineAssignment = new Map<String, Object>();
        Map<String, Object> SearchBlock = new Map<String, Object>();
        SearchBlock.put('SelectProvincia', 'SomeRandomValue');
        SearchBlock.put('SelectLocalidad', 'SomeRandomValue');
        SearchBlock.put('Sufijo', 'SomeRandomValue');
        LineAssignment.put('SearchBlock', SearchBlock);
        
       	Map<String, Object> plan = new Map<String, Object>();
        Map<String, Object> linea = new Map<String, Object>();
        linea.put('isSelected', true);
        linea.put('linea', '12345678');
        linea.put('orderItemId', '8026C000000DKxT');
        linea.put('location', 'B1608');
        Lineas.add(linea);
        plan.put('lineas', Lineas);
        Planes.add(plan);
        Order.put('planes', Planes);
        inputMap.put('Account', Account);
        inputMap.put('Order', Order);
        inputMap.put('LineAssignment', LineAssignment);
        
        return inputMap;
    }
}