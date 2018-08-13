/**
 * Created by Alex Lazarev on 9/15/2017.
 *
 * getListObjectsFromMap: Provides logic to handle JSON without List node to return it as one
 * By reflection
 *
 * version 1.0
 */
public class VlocityOpenInterfaceHelper {


	public static List<Object> getListObjectsFromMap(Map<String,Object> objectsMap, String jsonNode) {
		Object obj = objectsMap.get(jsonNode);

		if (obj instanceof List<Object>) {
			return (List<Object>)obj;
		} else {
			List<Object> objList = new List<Object>();
			Object mapSO = (Object) objectsMap.get(jsonNode);

			if (mapSO != null) {
				objList.add(mapSO);

				return objList;
			}

			return null;
		}
	}
}