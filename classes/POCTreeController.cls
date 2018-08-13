global class POCTreeController {

    public CustomPermission customPermission {get; set;}
    public static List<String> customPermissionLabelList {get;set;}
    public static Map<String, String> customPermissionsMap {get;set;}
    public static String selectedPermissionName {get; set;}
    public static String selectedPermissionAPIName {get; set;}

    public POCTreeController() {
        setData();
    }

    private static void setData(){
        customPermissionLabelList = new List<String>();
        customPermissionsMap = new Map<String, String>();
        
        List<SetupEntityAccess> setupEntityList = [SELECT Id,ParentId,Parent.Name,Parent.label, SetupEntityId 
                                                    FROM SetupEntityAccess
                                                    WHERE SetupEntityType='CustomPermission'
                                                        AND ParentId IN (SELECT Id 
                                                                        FROM PermissionSet
                                                                        WHERE isOwnedByProfile = false) 
                                                        AND SetupEntityId IN (SELECT Id
                                                                            FROM CustomPermission 
                                                                            WHERE NamespacePrefix = null)];

        for (SetupEntityAccess sea : setupEntityList) {
            customPermissionLabelList.add(sea.Parent.label);
            customPermissionsMap.put(sea.Parent.label, sea.Parent.Name);
        }
    }

    @RemoteAction
    public static String getWorkTeam(String permissionName){
        setData();
        List<WorkTeamTree> wTTList = new List<WorkTeamTree>();
        selectedPermissionName = permissionName;
        selectedPermissionAPIName = customPermissionsMap.get(selectedPermissionName);
        for (WorkTeam__c wT : [SELECT Id, Name, Parent_Team__c, Team_Name__c, 
                                (
                                    SELECT Id, Permission_Set_API_Name__c 
                                    FROM Work_Team_Permissions__r 
                                    WHERE Is_Active__c = true 
                                        AND Permission_Set_API_Name__c = :selectedPermissionAPIName
                                ) 
                                FROM WorkTeam__c 
                                WHERE Is_Active__c = true
                                ORDER BY Parent_Team__c NULLS FIRST]) {

            WorkTeamTree wTT = new WorkTeamTree(wT.Id, wT.Name);
            for (Work_Team_Permission__c wTP : wT.Work_Team_Permissions__r) {
                if (wTP.Permission_Set_API_Name__c != null && wTP.Permission_Set_API_Name__c.equals(selectedPermissionAPIName)) {
                    wTT.state.selected = true;
                }
            }
            if (wT.Parent_Team__c != null) {
                wTT.parent = wT.Parent_Team__c;
            }
            wTTList.add(wTT);
        }
        return JSON.serialize(wTTList);
    }

    @RemoteAction
    public static void checkNodes(Object nodeIdList, String permission){
        try {
            setData();
            selectedPermissionAPIName = customPermissionsMap.get(permission);
            List<String> idsList = extractId(nodeIdList);
            Id recordType = getRecordType();
            List<Work_Team_Permission__c> wTPList = [SELECT Id, Is_Active__c, Work_Team__c FROM Work_Team_Permission__c WHERE Work_Team__c IN :idsList AND Permission_Set_API_Name__c = :selectedPermissionAPIName];
            for(Work_Team_Permission__c wtP : wTPList){
                if(idsList.contains(wtP.Work_Team__c)){
                    wtP.Is_Active__c = true;
                    Integer indexResult = idsList.indexOf(wtP.Work_Team__c);
                    idsList.remove(indexResult);
                }               
            }

            for (Id item : idsList){
                Work_Team_Permission__c wTP = new Work_Team_Permission__c(Work_Team__c = item, RecordTypeId = recordType, Is_Active__c = true, Permission_Set_API_Name__c = selectedPermissionAPIName);
                wTPList.add(wTP);
            }

            upsert wTPList;
        } catch (Exception ex) {
            system.debug('EX: ' + ex +  ' - ' + ex.getLineNumber());
        }

        reloadPage();
    }

    private static List<String> extractId(Object nodesIds){
        List<String> idList = (String.valueOf(((Map<String, Object>)JSON.deserializeUntyped(String.valueOf(nodesIds))).get('ids'))).split(', ');
        List<String> idResultList = new List<String>();
        for(String idValue : idList){
            String value = idValue;
            value = value.replace('(', '');
            value = value.replace(')', '');
            if (value instanceOf Id) {
                idResultList.add(value);
            }
        }
        return idResultList;
    }

    @RemoteAction
    public static void unCheckNodes(Object nodeIdList, String permission){
        setData();
        List<String> idList = extractId(nodeIdList);
        selectedPermissionAPIName = customPermissionsMap.get(permission);
        List<Work_Team_Permission__c> wTPList = [SELECT Id FROM Work_Team_Permission__c WHERE Work_Team__c IN :idList AND Is_Active__c = true AND Permission_Set_API_Name__c = :selectedPermissionAPIName];
        for (Work_Team_Permission__c wTP : wTPList) {
            wTP.Is_Active__c = false;
        }
        update wTPList;

        reloadPage();
    }


    public static PageReference reloadPage(){
        //POCTree
        //PageReference tempPage = ApexPages.currentPage();  
        selectedPermissionName = '';
        PageReference tempPage = new PageReference('/apex/POCTree');    
        tempPage.setRedirect(true);
        return tempPage;
    }

    private static Id getRecordType() {
        return (Id)Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();
    }

    public class WorkTeamTree {
        public String id;
        public String text;
        public String parent = '#';
        public State state;

        public WorkTeamTree(String id, String text){
            this.id = id;
            this.text = text;
            this.state = new State();
        }
    }

    public class State {
        public Boolean selected = false;
    }
}