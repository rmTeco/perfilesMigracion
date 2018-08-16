global class CpqAppHandler_test  implements vlocity_cmt.VlocityOpenInterface2 {
	global Object invokeMethod(String methodName, Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options) {
        system.debug('++++++++ methodname'+methodname);
        system.debug('++++++++ inputMap'+inputs);
        return null;
    }
}