@isTest(seeAllData = true)
public class POCTreeControllerTest {

	@isTest
	private static void checkNodesTest(){
		Id RecordTypePermissions = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();

		//obtener permission
		PermissionSet perSet = [SELECT CreatedDate, Id, Label, Name
								FROM PermissionSet
								ORDER BY CreatedDate, Name 
								ASC NULLS FIRST LIMIT 1];

        SetupEntityAccess setupEntity = [SELECT Id,ParentId,Parent.Name,Parent.label, SetupEntityId 
										FROM SetupEntityAccess
										WHERE SetupEntityType='CustomPermission'
										AND ParentId IN (SELECT Id 
														FROM PermissionSet
														WHERE isOwnedByProfile = false) 
										AND SetupEntityId IN (SELECT Id
															FROM CustomPermission 
															WHERE NamespacePrefix = null)
										LIMIT 1];								

		String permissionLabel = setupEntity.Parent.label;
		String permissionApiName = setupEntity.Parent.Name;

		//crear workteam padre
		WorkTeam__c parentWT = new WorkTeam__c();
		parentWT.Name = 'Test Parent WT Permission';
		parentWT.Team_Name__c = 'Test_Parent_WT_Permission';
		parentWT.Is_Active__c = true;
		parentWT.WorkteamLevel__c = 1;

		insert parentWT;

		//crear work team permission
		Work_Team_Permission__c wtPermission = new Work_Team_Permission__c();
		wtPermission.Permission_Set_API_Name__c = permissionApiName;
		wtPermission.Work_Team__c = parentWT.Id;
		wtPermission.RecordTypeId = RecordTypePermissions;		
		wtPermission.Is_Active__c = false;

		insert wtPermission;

		Test.startTest();
		jsonObject jObject = new jsonObject();
		jObject.ids = parentWT.Id;
		system.debug('parentWT.Id: ' + JSON.serialize(jObject));
		POCTreeController.checkNodes(JSON.serialize(jObject), permissionLabel);
		Work_Team_Permission__c wtPtest = [SELECT Id, Is_Active__c FROM Work_Team_Permission__c WHERE Is_Active__c = true AND Id =: wtPermission.Id LIMIT 1];
		System.assertNotEquals(null, wtPtest); 
		Test.stopTest();
	}

	@isTest
	private static void getWorkTeamTest(){
		Id RecordTypePermissions = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();
		//obtener permission
        SetupEntityAccess setupEntity = [SELECT Id,ParentId,Parent.Name,Parent.label, SetupEntityId 
										FROM SetupEntityAccess
										WHERE SetupEntityType='CustomPermission'
										AND ParentId IN (SELECT Id 
														FROM PermissionSet
														WHERE isOwnedByProfile = false) 
										AND SetupEntityId IN (SELECT Id
															FROM CustomPermission 
															WHERE NamespacePrefix = null)
										LIMIT 1];								

		String permissionLabel = setupEntity.Parent.label;
		String permissionApiName = setupEntity.Parent.Name;

		//crear workteam padre
		WorkTeam__c parentWT = new WorkTeam__c();
		parentWT.Name = 'Test Parent WT Permission';
		parentWT.Team_Name__c = 'Test_Parent_WT_Permission';
		parentWT.Is_Active__c = true;
		parentWT.WorkteamLevel__c = 1;

		insert parentWT;

		//crear work team permission
		Work_Team_Permission__c wtPermission = new Work_Team_Permission__c();
		wtPermission.Permission_Set_API_Name__c = permissionApiName;
		wtPermission.Work_Team__c = parentWT.Id;
		wtPermission.RecordTypeId = RecordTypePermissions;
		wtPermission.Is_Active__c= true;

		insert wtPermission;
		Test.startTest();
		System.assertNotEquals('', POCTreeController.getWorkTeam(permissionApiName));
		Test.stopTest();
	}

	@isTest
	private static void unCheckNodesTest(){
		Id RecordTypePermissions = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();

		//obtener permission
        SetupEntityAccess setupEntity = [SELECT Id,ParentId,Parent.Name,Parent.label, SetupEntityId 
										FROM SetupEntityAccess
										WHERE SetupEntityType='CustomPermission'
										AND ParentId IN (SELECT Id 
														FROM PermissionSet
														WHERE isOwnedByProfile = false) 
										AND SetupEntityId IN (SELECT Id
															FROM CustomPermission 
															WHERE NamespacePrefix = null)
										LIMIT 1];								

		String permissionLabel = setupEntity.Parent.label;
		String permissionApiName = setupEntity.Parent.Name;

		//crear workteam padre
		WorkTeam__c parentWT = new WorkTeam__c();
		parentWT.Name = 'Test Parent WT Permission';
		parentWT.Team_Name__c = 'Test_Parent_WT_Permission';
		parentWT.Is_Active__c = true;
		parentWT.WorkteamLevel__c = 1;

		insert parentWT;

		//crear work team permission
		Work_Team_Permission__c wtPermission = new Work_Team_Permission__c();
		wtPermission.Permission_Set_API_Name__c = permissionApiName;
		wtPermission.Work_Team__c = parentWT.Id;
		wtPermission.RecordTypeId = RecordTypePermissions;		
		wtPermission.Is_Active__c= true;

		insert wtPermission;

		Test.startTest();
		jsonObject jObject = new jsonObject();
		jObject.ids = parentWT.Id;
		system.debug('parentWT.Id: ' + JSON.serialize(jObject));
		POCTreeController.unCheckNodes(JSON.serialize(jObject), permissionLabel);
		Work_Team_Permission__c wtPtest = [SELECT Id, Is_Active__c FROM Work_Team_Permission__c WHERE Is_Active__c = false AND Id =: wtPermission.Id LIMIT 1];
		System.assertNotEquals(null, wtPtest); 		
		Test.stopTest();		
	}

	public class jsonObject{
		String ids {get; set;}
	}	
}