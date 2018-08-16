public with sharing class DebugInfo {
    
    public static void AddDebugInfoEntry(String processName, String methodName, String debugData) {
        AddDebugEntry(processName, methodName, debugData, 'Info');
    }

    public static void AddDebugWarningEntry(String processName, String methodName, String debugData) {
        AddDebugEntry(processName, methodName, debugData, 'Warning');
    }

    public static void AddDebugErrorEntry(String processName, String methodName, String debugData) {
        AddDebugEntry(processName, methodName, debugData, 'Error');
    }

    private static void AddDebugEntry(String processName, String methodName, String debugData, String debugType) {
        DebugInfo__c debugInfo = new DebugInfo__c(
            ProcessName__c = processName,
            MethodName__c = methodName,
            DebugData__c = String.valueOf(debugData),
            DebugLabel__c = debugType
        );

        insert debugInfo;
    }
}