/**
* Created by Alex Lazarev 02/08/2017
* Provides logic support to trigMasterCase trigger
* Object: Case
*
*
* Version: 2.2 GFiore:Cambio la logica de asignacion de creator team
* Version: 2.3 AMontiel: Cambio de método updateChildonMassive
*/

public class CaseTriggerHandler {


    public static void updateCaseDataOnInsert(List<Case> triggerNew) 
    {
        String teamId = '';
        String massiveIncidentRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incidente Masivo').getRecordTypeId();
        Map<String, Integer> affectedCasesAmmount = new Map<String, Integer>();
        try
        {
            teamId = [SELECT Work_Team__c FROM Team_Member__c WHERE User_member__c = :UserInfo.getUserId() AND Is_Active__c = true].Work_Team__c;
            //String teamName = [SELECT Team_Name__c FROM WorkTeam__c WHERE Id = :teamId].Team_Name__c; 
        }
        catch(Exception ex){
        }

        for (Case c : triggerNew) {
            if (teamId != '')
                c.Initiator_Team__c = teamId;
            if (c.RecordTypeId == massiveIncidentRecordType)
                c.AffectedCasesAmount__c = 0; //inicializando cantidad de casos afectados en 0 en caso de ser incidente masivo
            else
                if(c.ParentId  != null)
                    if (affectedCasesAmmount.containsKey(c.ParentId))
                        affectedCasesAmmount.put(c.ParentId, affectedCasesAmmount.get(c.ParentId) + 1);
                    else
                        affectedCasesAmmount.put(c.ParentId, 1);
        }

        List<Case> massiveEvents = [SELECT Id, AffectedCasesAmount__c FROM Case WHERE Id in :affectedCasesAmmount.keySet()];
        for (Case massive: massiveEvents){
            if (massive.AffectedCasesAmount__c != null)
                massive.AffectedCasesAmount__c = massive.AffectedCasesAmount__c + affectedCasesAmmount.get(massive.Id);
            else
                massive.AffectedCasesAmount__c = affectedCasesAmmount.get(massive.Id);
        }

        update massiveEvents;
    }

    

    public static void updateCaseOnUpdate(List<Case> triggerNew){
        String caseChannel = CaseChannelConf__c.getInstance(UserInfo.getProfileId()).Origin__c;
        String userGroupName = '';
        Id userId = UserInfo.getUserId();

        for(GroupMember groupMemberObject : [SELECT Group.Name, Group.Id FROM GroupMember WHERE UserOrGroupId = :userId AND Group.Type = 'Queue']){
            userGroupName = groupMemberObject.Group.Name;
        }

        for (Case caseObj : triggerNew) {
            //if (caseObj.Status == 'Closed' || caseObj.Status == 'Cerrado') {
            if(caseObj.isClosed) {
                caseObj.Closing_Channel__c = caseChannel;
            }
        }
    }

    public static void checkUserProfileOnDelete(List<Case> triggerOld){
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;

        if (profileName != 'System Administrator') {
            for (Case caseObj : triggerOld) {
                caseObj.addError('Solo el administrador puede eliminar casos generados.');
            }
        }
    }

    
    public static void deleteChildonMassive(List<Case> triggerOld) 
    {
        try
        {
            Map<String, Integer> affectedCasesAmmount = new Map<String, Integer>();
            //String teamName = [SELECT Team_Name__c FROM WorkTeam__c WHERE Id = :teamId].Team_Name__c;
            
            for (Case c : triggerOld) {
                if(c.ParentId  != null)
                    if (affectedCasesAmmount.containsKey(c.ParentId))
                        affectedCasesAmmount.put(c.ParentId, affectedCasesAmmount.get(c.ParentId) - 1);
                    else
                        affectedCasesAmmount.put(c.ParentId, -1);
            }
            List<Case> massiveEvents = [SELECT Id, AffectedCasesAmount__c FROM Case WHERE Id in :affectedCasesAmmount.keySet()];
            for (Case massive: massiveEvents){
                if (massive.AffectedCasesAmount__c != null)
                    massive.AffectedCasesAmount__c = massive.AffectedCasesAmount__c + affectedCasesAmmount.get(massive.Id);
                else
                    massive.AffectedCasesAmount__c = affectedCasesAmmount.get(massive.Id);
            }

            update massiveEvents;
        }
        catch(Exception ex){}
    }
   

    public static void updateCaseAfterInsert(List<Case> triggerNew){


        String caseChannel = CaseChannelConf__c.getInstance(UserInfo.getProfileId()).Origin__c;

        Set<Id> recordTypesExcept = new Set<Id>();

        recordTypesExcept.add(Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incidente Masivo').getRecordTypeId());

        Set<Id> cIds = new Set<Id>();
        for (Case c : triggerNew) {

            cIds.add(c.Id);
        }


        Map<String, Double> estimatedRelTimeMap = new Map<String, Double>();
        for (Case_Resolution_Time__c caseResolTime : [SELECT Case_Type__c, Client_Segment__c, Estimated_Resolution_Time__c FROM Case_Resolution_Time__c]){
            estimatedRelTimeMap.put(caseResolTime.Case_Type__c + '**' + caseResolTime.Client_Segment__c, caseResolTime.Estimated_Resolution_Time__c);
        }

        /**
        *  Commented due requirement of Segment__c removal
        
        List<Case> caseObjsToUpdate = [SELECT Id, Type, Account.Segment__c, CreatedDate, Due_Date__c, Origin FROM Case WHERE RecordTypeId != :recordTypesExcept AND Id IN :cIds];
        for (Case caseObj : caseObjsToUpdate) {
            DateTime dueDate = caseObj.CreatedDate;

            if (estimatedRelTimeMap.containsKey(caseObj.Type + '**' + caseObj.Account.Segment__c)) {
                Integer estimatedResolutionMinutes = (Integer)(estimatedRelTimeMap.get(caseObj.Type + '**' + caseObj.Account.Segment__c) * 60);
                dueDate = dueDate.addMinutes(estimatedResolutionMinutes);
            }

            caseObj.Due_Date__c = dueDate;
            caseObj.Origin = caseChannel;
        }
        update caseObjsToUpdate;
        */
    }
    
    public static void updateChildonMassive(List<Case> triggerNew, Map<Id, Case> triggerOldMap){
        // Update child incidents from parent incident (masive) updated to Status 'Resuelta Masiva'
        List <Case> incidentsToUpdate = new List<Case>();
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Incidente Masivo').getRecordTypeId();
    
        Map<String,Case> rightCases = new Map<String,Case>();
        Set<String> externalCaseIdList = new Set<String>();

        for(Case rc : triggerNew){
            try{
                if(rc.Status != triggerOldMap.get(rc.Id).Status && rc.Status == 'Resuelta Masiva' && rc.recordTypeId == recordTypeId){ 
                    rightCases.put(rc.Id,rc);
                    externalCaseIdList.add(rc.ExternalCaseId__c);
                }
            } catch(Exception ex){}
        } 
    
        List<Case>  childIncidents = [SELECT Id, Status, Resolution_Comment__c, ParentId FROM Case WHERE ParentId in :rightCases.keySet()];
        
        for (Case childIncident : childIncidents) {
                childIncident.Status = 'Resuelta Masiva';
                childIncident.Resolution_Comment__c = rightCases.get(childIncident.ParentId).Resolution_Comment__c + '\n\nActualización del envento masivo: ' + rightCases.get(childIncident.ParentId).CaseNumber;
                

                incidentsToUpdate.add(childIncident);
         }

        List<Account> relatedAccountsToUpdate = [SELECT Id FROM Account WHERE Incident_Affected_By__c in :externalCaseIdList];
        for (Account relatedAccount : relatedAccountsToUpdate) 
                relatedAccount.Incident_Affected_By__c = '';
                
    
    update incidentsToUpdate;
    //update relatedAccountsToUpdate;
    }

    public static void updateMassiveonChild(List<Case> triggerNew, Map<Id, Case> triggerOldMap){
        Map<String, Integer> affectedCasesAmmount = new Map<String, Integer>();

        for(Case rc : triggerNew){
            try{
                if(rc.ParentId != triggerOldMap.get(rc.Id).ParentId) {
                    if(affectedCasesAmmount.containsKey(rc.ParentId)) //sumarle 1
                        affectedCasesAmmount.put(rc.ParentId, affectedCasesAmmount.get(rc.ParentId)+1);
                    else
                        affectedCasesAmmount.put(rc.ParentId, 1);

                    if(affectedCasesAmmount.containsKey(triggerOldMap.get(rc.Id).ParentId)) //restar 1 
                        affectedCasesAmmount.put(triggerOldMap.get(rc.Id).ParentId, affectedCasesAmmount.get(rc.ParentId)-1);
                    else
                        affectedCasesAmmount.put(triggerOldMap.get(rc.Id).ParentId, -1);
                }
            } catch(Exception ex){}
        }

            List<Case> massiveEvents = [SELECT Id, AffectedCasesAmount__c FROM Case WHERE Id in :affectedCasesAmmount.keySet()];
            for (Case massive: massiveEvents){
                if (massive.AffectedCasesAmount__c != null)
                    massive.AffectedCasesAmount__c = massive.AffectedCasesAmount__c + affectedCasesAmmount.get(massive.Id);
                else
                    massive.AffectedCasesAmount__c = affectedCasesAmmount.get(massive.Id);
            }

        update massiveEvents; 

    }
    

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo que se consume desde el trigger trigMasterCase, el cual ejecuta los 
    distintos metodos consumidos desde el proceso de Ajustes.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void updateCaseForAdjustment(List<Case> triggerNew, Map<Id, Case> triggerOldMap)
    {
        try {escalarCaso(triggerNew);}catch(Exception ex){}
        try {validateSplitAmount(triggerNew, triggerOldMap );}catch(Exception ex){}
        try {confirmAdjustment(triggerNew);}catch(Exception ex){}
    }


    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Actualizado por: Federico Biaus.
    Descripcion: Se modifica el metodo, anteriormente el metodo se ejecutaba por separado, se unifica en una unica llamada.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void escalarCaso(List<Case> cases) {
        List<Id> myCasesId = new List<Id>();
        List<Id> myCasesApproverId = new List<Id>();
        List<Id> workTeamsParentId = new List<Id>();
        
        for (Case myCase: cases) {
            myCasesId.add(myCase.Id);
            myCasesApproverId.add(myCase.Approver__c);
        }
        
        List<WorkTeam__c> workTeams = [select Parent_Team__c, Manager__c from WorkTeam__c where Manager__c IN: myCasesApproverId];
        
        for (WorkTeam__c workTeam: workTeams) {
            workTeamsParentId.add(workTeam.Parent_Team__c);
        }
        
        List<WorkTeam__c> workTeamParent = [select Manager__c from WorkTeam__c where Id IN: workTeamsParentId];
        
        List<CaseMilestone> caseMilestones = [select CompletionDate, StartDate, CaseId from CaseMilestone where caseId IN: myCasesId];
        Id cmId = null;
        for (Case myCase: cases) {
            if(myCase.Subject == 'Inconvenientes con cargos tasados y facturados' && myCase.Status == 'Expirada') {
                for (WorkTeam__c wtApprover: workTeams) {
                    if (myCase.Approver__c == wtApprover.Manager__c && wtApprover.Parent_Team__c != null) {
                        for (WorkTeam__c wtParent: workTeamParent) {
                            if (wtApprover.Parent_Team__c == wtParent.Id && wtParent.Manager__c != null) {
                                myCase.Approver__c = wtParent.Manager__c;
                                myCase.OwnerId = wtParent.Manager__c;
                                myCase.Status = 'En autorización';
                                for (CaseMilestone cm: caseMilestones) {
                                    if (cm.CaseId == myCase.Id) {
                                        cmId = cm.Id;
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                
            }
        }
        if (cmId != null) CaseTriggerHandler.updateStartDateCaseMilestone(cmId);
                    
    }
    
    @future
    public static void updateStartDateCaseMilestone(Id caseMilestoneId) {
        CaseMilestone caseMilestone = [select StartDate from CaseMilestone where Id =: caseMilestoneId];
        caseMilestone.StartDate = System.now();
        update caseMilestone;
    } 
    

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo que se consume desde el trigger trigMasterCase. El metodo es utilizado para identificar
    cambios sobre el caso, cuando el mismo se trata de un caso de ajuste, de ser asi y en base a los cirterios definidos
    se procede a verificar:
        -   Que el caso este tomado por un usuario.
        -   Que el monto a confirmar no supere el monto maximo de desdoblamiento definido para cada perfil/usuario/cuenta.
        -   Generar el proceso de aprobacion correspondiente y de ser necesario el escalamiento al perfil que corresponda.
        -   Realizar el cambio de estado del caso una vez confirmado el ajuste para ser procesado por la IF S031 quien 
            confirmara el ajuste en huawei.
        -   Envio de las notificaciones via SMS al cliente con el resultado de la operacion de ajuste.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void validateSplitAmount(List<Case> triggerNew, Map<Id, Case> triggerOldMap)
    {   
        try
        {

            System.debug('validateSplitAmount - Inicio');
            List<Case> newCases = new List<Case>();
            List <Case> casesToUpdate = new List<Case>();

            for(Case nCase : triggerNew){
                if(nCase.Subject == 'Inconvenientes con cargos tasados y facturados' && nCase.OwnerId != triggerOldMap.get(nCase.Id).OwnerId && nCase.vlocity_cmt__Amount__c != null && nCase.vlocity_cmt__Amount__c > 0) 
                    newCases.add(nCase);
            } 
            System.debug('Case: '+ newCases.size());

            if(newCases.size() > 0)
            {
                List<Profile> profiles;
                Map<Id, Id> approverCase = new Map<Id, Id>();
                //Nota: Si los usuarios no se encuentran configurados con el perfil adecuado esto puede fallar! Verificar los perfiles.
                Id profileId=userinfo.getProfileId();
                Id profileIdApprover;
                Set<Id> profileIds = new Set<Id>();
                String profileName;

                for(Case tCase : newCases)
                {
                    if(profileId == tCase.approver__c)
                        profileIdApprover = profileId;
                    else if (tCase.approver__c == null)
                            profileIdApprover = profileId;
                        else
                            profileIdApprover = tCase.approver__c;
                    
                    approverCase.put(tCase.Id, profileIdApprover);
                    profileIds.add(profileIdApprover);
                }
                profiles = [Select Id,Name from Profile where Id IN :profileIds];  
                
                for(Case tCase : newCases)
                {
                    System.debug('Entro');   
                    if(!Test.isRunningTest())
                    {
                        Id aprovador = (Id)approverCase.get(tCase.Id);      
                        for(Profile profile : profiles)
                        {   
                            if(profile.get('Id') == aprovador)
                                profileName = (String)profile.get('Name');
                        }
                    }
                    else
                        profileName = 'FAN - Front OOCC';        

                    Map<string, object> inputMap = new Map<string, object>();
                    Map<string, object> outMap = new Map<string, object>();
                    Map<string, object> options = new Map<string, object>();
                    String codError = '0';
                    String descError = 'Ocurrio un error grave, contacte al soporte tecnico.';

                    System.debug('Type: '+tCase.OwnerId.getsobjecttype());
                    //Si el caso paso de una queue a un user, significa que el caso fue tomado por un backoffice, o si el caso ya lo tiene un user.
                    if (tCase.OwnerId.getsobjecttype() == User.sobjecttype)
                    {    
                        System.debug('Tipo user: '+User.sobjecttype);

                        if(tCase.TipoSeleccion__c != 'Cuenta')
                        {
                            options.put('Amount', tCase.vlocity_cmt__Amount__c);
                            options.put('approvalProfile', profileName); //IMPORTANTE: Modificar el hardcode cuando los usuarios esten configurados!!!!!
                            options.put('TipoSeleccion', tCase.TipoSeleccion__c);
                            options.put('ServiceId', tCase.vlocity_cmt__ServiceId__c);
                            options.put('caseId', tCase.Id);
                            try
                            {
                                ta_care_queryAdjustmentsHelper.AmountLimitForUser(inputMap, outMap, options);
                                Map<String, Object> result = (Map<String, Object>)outMap.get('result');
                                codError = (String)result.get('codError');
                                descError = (String)result.get('descError');
                                System.debug('codError: '+ codError);
                                System.debug('descError: '+ descError);
                            }catch(Exception ex)
                            {  
                                System.debug('Error en ta_care_queryAdjustmentsHelper.AmountLimitForUser: '+ex.getMessage());
                            }
                        }
                        
                        System.debug('codError: '+codError);
                        if(codError != '0')
                        {
                            tCase.Status = 'No se pudo realizar';
                            tCase.Resolution_Comment__c = descError;
                        }
                        else 
                        {
                            if(tCase.Approver__c == null && tCase.Owner_Team__c != null && tCase.vlocity_cmt__Amount__c > 0 && tCase.Status != 'No se pudo realizar') //Teams
                                submitApprovalProcess('RAV_Escalamiento_a_Equipo', tCase.Id);

                            if(tCase.Approver__c != null && tCase.vlocity_cmt__Amount__c > 0 && tCase.Status != 'No se pudo realizar') //Users
                                submitApprovalProcess('RAV_Escalamiento_a_Usuario', tCase.Id);
                        }
                    }       
                }
            }
        }
        catch(Exception ex)
        { 
            System.debug('Error general: '+ex.getMessage());
        }
    }
    
    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de generar el submit del approval process sobre el caso correspondiente.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void submitApprovalProcess(String escalamiento, Id caseId)
    {
        try
        {
            System.debug('Proceso al que llamo: '+ escalamiento);
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Envio de pedido de aprobación.');
            req1.setObjectId(caseId);
            req1.setSubmitterId(UserInfo.getUserId());
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId(escalamiento);
            req1.setSkipEntryCriteria(true);
            
            Approval.ProcessResult result = Approval.process(req1);  
        }catch(Exception ex){}
    }

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de verificar si el caso se encuentra en el estado correspondiente para confirmar el ajuste.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void confirmAdjustment(List<Case> triggerNew)
    {
        SET<Id> ids = new SET<Id>();

        for(Case nCase : triggerNew){
            if(nCase.Subject == 'Inconvenientes con cargos tasados y facturados' && nCase.Status == 'En espera de ejecución' && nCase.vlocity_cmt__Amount__c > 0) 
                   ids.add(nCase.Id);
        } 

        if(ids.size() > 0)
            setAdjustment(ids);
    }


    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado generar el ajuste invocando a la integracion S031, de ser exitoso o no el ajuste, 
    se realiza la llamada al integracion S159 el cual envia el SMS con la notificacion del resultado de la operacion 
    al cliente.
    */
    /***************************************************************************/
    /***************************************************************************/
    @future (callout=true)
    public static void setAdjustment(SET<Id> ids) {
       try
       {  
            System.debug('Inicio proceso confirmar ajuste.');
            List<Case> listCaseToUpdate = new List<Case>();
            
            for(Case myCase : [SELECT AccountId,AssetId,CantidadAjuste__c,ContactId,FechaDesde__c,FechaHasta__c,Id,Initiator_team__c,Motivo__c,VoucherNumber__c,OwnerId,Owner_Team__c,RecordTypeId,Resolution_Comment__c,Status,Subject,TipoAjuste__c,TipoConcepto__c,TipoItem__c,TipoOperacionAjuste__c,TipoSeleccion__c,Tipo__c,UnidadAjuste__c,vlocity_cmt__Amount__c, vlocity_cmt__ServiceId__c, Account.AccountIntegrationId__c, vlocity_cmt__ServiceId__r.Subscription_Id__c FROM Case WHERE Id =:ids])
            {
                try
                {

                    Map<String, Object> output = new Map<String, Object>();
                    Map<String, Object> options = new Map<String, Object>();
                    Map<String, Object> body = new Map<String, Object>();
                    Map<String, Object> input = new Map<String, Object>();

                    String codTipoBalance, montoAjustar;
                    //codTipoBalance = 'FU_VMO_NACIONAL';
                    //montoAjustar = '400.0000';

                    if(myCase.TipoSeleccion__c == 'Servicio')
                    {   
                        System.debug('Servicio');
                        String tipoOperacion = myCase.TipoOperacionAjuste__c;

                        if(myCase.UnidadAjuste__c == 'Credito')
                        {
                            System.debug('Credito');
                            codTipoBalance = 'C_MAIN_ACCOUNT';
                            montoAjustar = myCase.vlocity_cmt__Amount__c + '00';
                        }

                        if(myCase.UnidadAjuste__c == 'SMS')
                        {
                            codTipoBalance = 'C_FU_SMO_NACIONAL';
                            montoAjustar = myCase.CantidadAjuste__c + '.0000';
                        }
                            
                        if(myCase.UnidadAjuste__c == 'VOZ')
                        {
                            Integer segundos;
                            codTipoBalance = 'C_FU_VMO_NACIONAL';
                            montoAjustar = myCase.CantidadAjuste__c;

                            if(montoAjustar.Contains(':'))
                                segundos = (Integer.ValueOf(montoAjustar.SUBSTRING(0,2))*3600) + (Integer.ValueOf(montoAjustar.SUBSTRING(3,4))*60) + Integer.ValueOf(montoAjustar.SUBSTRING(6,7));
                            else
                                segundos = (Integer.ValueOf(montoAjustar.SUBSTRING(0,2))*3600) + (Integer.ValueOf(montoAjustar.SUBSTRING(2,4))*60) + Integer.ValueOf(montoAjustar.SUBSTRING(4,6));

                            montoAjustar = String.ValueOf(segundos) + '.0000';
                        }

                        if(myCase.UnidadAjuste__c == 'Datos(Mb)')
                        {
                            codTipoBalance = 'C_FU_DATA_HS';
                            montoAjustar = String.ValueOf((Integer.ValueOf(myCase.CantidadAjuste__c) * 1024)) + '.0000';
                        }

                        System.debug('Obtengo los assets');
                        //Asset assetObj = [SELECT Subscription_Id__c FROM Asset WHERE Id =:myCase.vlocity_cmt__ServiceId__c];
                        //System.debug('assetObj: '+assetObj);
                        
                        if(myCase.vlocity_cmt__ServiceId__r.Subscription_Id__c == null)
                            throw new FuncException('No existe el codigo de subscripcion.');

                        Map<String, Object> AccesoPorSubscriptor = new Map<String, Object>();
                        AccesoPorSubscriptor.put('codSuscripcion', myCase.vlocity_cmt__ServiceId__r.Subscription_Id__c);
                        body.put('accesoPorSubscriptor', AccesoPorSubscriptor);

                        body.put('tipoOperacionAjuste', '1');

                        if(myCase.UnidadAjuste__c == 'Credito') 
                        {
                            List<Map<String, Object>> listaAjusteBalance = new List<Map<String, Object>>();
                            Map<String, Object> ajusteBalance = new Map<String, Object>();
                            //PFTA-11312 - INI
                            //Para Credito el tipo de ajuste es numerico ver IDD.
                            //Para Cuenta (unidades libres) el tipo de ajuste es String (CREDITO / DEBITO).
                            if(tipoOperacion == 'CREDITO')
                                tipoOperacion = '1';
                            else {
                                if(tipoOperacion == 'DEBITO')
                                    tipoOperacion = '2';
                                else 
                                    throw new FuncException('No se pudo determinar el tipo de ajuste.');
                            }
                            //PFTA-11312 - FIN
                            
                            ajusteBalance.put('codTipoBalance', codTipoBalance);
                            ajusteBalance.put('tipoAjuste', tipoOperacion);
                            ajusteBalance.put('montoAjuste', montoAjustar.replace(',','.'));
                            ajusteBalance.put('codMoneda','ARS');

                            listaAjusteBalance.add(ajusteBalance);
                            body.put('listaAjusteBalance', listaAjusteBalance);
                        }
                        else 
                        {
                            List<Map<String, Object>> listaAjusteunidadesLibres = new List<Map<String, Object>>();
                            Map<String, Object> ajusteLibre = new Map<String, Object>();
                            ajusteLibre.put('codUsoUnidadesLibres', codTipoBalance);
                            ajusteLibre.put('tipoAjuste', tipoOperacion);
                            ajusteLibre.put('montoAjuste', montoAjustar);

                            listaAjusteunidadesLibres.add(ajusteLibre);
                            body.put('listaAjusteUnidadesLibres', listaAjusteunidadesLibres);
                        }

                        input.put('body', body);
                        System.debug('Input: '+input);
                        //CALL IFS031
                        callToIntegrationS031(myCase, input, output, options);
                    }
                    else 
                    {  
                        if(myCase.TipoSeleccion__c == 'Cuenta')
                        {
                            System.debug('Cuenta');

                            /*
                            tipoOperacionAjuste Si  1..1  Valores posibles:
                              1: Ajuste de una unidad libre o el balance. 
                                 Nota: En este escenario, tipoAjuste y montoAjuste son obligatorios.
                              2: Restablecer la unidad libre o balance.
                                 Nota: Si las unidades libres se ponen a cero, el parámetro codPaqueteUnidadesLibres es obligatorio. 
                                 Si se restablecen los saldos, el parámetro codBalance es obligatorio y parámetro tipoAjuste es opcional.
                              3: posponer la fecha de caducidad de la instancia.  Ajuste
                            */

                            String operacion = myCase.TipoOperacionAjuste__c;
                            String tipoOperacion = operacion.split('-')[0].trim();
                            String tipoAjuste = operacion.split('-')[1].trim();

                            System.debug('tipoOperacion: '+ tipoOperacion);
                            System.debug('tipoAjuste: '+ tipoAjuste);

                            if((tipoOperacion == 'NC' || tipoOperacion == 'ND') && tipoAjuste == 'Libre')  //Aca se de debe validar cuando se desarrolle si se trata de un Comprobante o Ajuste Libre (actualmente desarrollamos el camino por ajuste libre) 
                            {     

                                System.debug('NC - Libre');
                                //Account accountObj = [SELECT AccountIntegrationId__c FROM Account WHERE Id =:myCase.AccountId];

                                if(myCase.Account.AccountIntegrationId__c == null)
                                    throw new FuncException('No existe el account integration id.');

                                Map<String, Object> AccesoPorCuenta = new Map<String, Object>();
                                AccesoPorCuenta.put('idCuenta', myCase.Account.AccountIntegrationId__c);
                                AccesoPorCuenta.put('codSuscripcion', myCase.Account.AccountIntegrationId__c);
                                body.put('accesoPorCuenta', AccesoPorCuenta);
                                
                                body.put('tipoOperacionAjuste', '1');

                                List<Map<String, Object>> listaAjusteBalance = new List<Map<String, Object>>();
                                Map<String, Object> ajusteBalance = new Map<String, Object>();
                                ajusteBalance.put('codTipoBalance', 'C_MAIN_ACCOUNT');
                                ajusteBalance.put('tipoAjuste', '1'); //tipoOperacion);
                                ajusteBalance.put('montoAjuste', myCase.vlocity_cmt__Amount__c + '00');
                                ajusteBalance.put('codMoneda','ARS');

                                listaAjusteBalance.add(ajusteBalance);
                                body.put('listaAjusteBalance', listaAjusteBalance);

                                input.put('body', body);

                                //CALL IFS031
                                callToIntegrationS031(myCase, input, output, options);
                            }
                            else
                            {    
                                if(tipoOperacion == 'NC' && tipoAjuste == 'Comprobante')
                                {
                                    System.debug('NC - Comprobante');
                                    callToIntegrationS479(myCase, output);
                                }
                            }
                        }
                    }
                }
                catch(Exception ex)
                {
                    System.debug('Error general: '+ ex.getMessage());
                    myCase.status = 'No se pudo realizar';
                    myCase.Resolution_Comment__c = 'Ups, ocurrio un error al intentar confirmar el ajuste. '+ ex.getMessage();
                }

                listCaseToUpdate.add(myCase);
            }

            if(listCaseToUpdate.size() > 0)
                Update listCaseToUpdate;
        }      
        catch(Exception ex) 
        {
            
        }
    }
    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de impactar el ajuste contra la S031.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void callToIntegrationS031(Case myCase, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) 
    {        
        try 
            {
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

                integProcService.invokeMethod('IFS_S031', input, output, options);
                System.debug('Request: ' + JSON.serialize(input));
                System.debug('Response: ' + JSON.serialize(output));
                System.debug('Options: '+JSON.serialize(options));
                Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

                if(response.get('detalle') == null)
                { 
                    myCase.status = 'Realizada exitosa';
                    myCase.Resolution_Comment__c = 'La Gestión ha sido realizada exitosamente.';
                    //myCase.Reason = 'Reclamo'; //Se quita a pedido de la US PFTA-10052 modifica PFTA-9470
                }
                else 
                {
                    myCase.status = 'No se pudo realizar';
                    myCase.Resolution_Comment__c = 'No se pudo confirmar el ajuste.';
                }
                

                try 
                {
                    sendNotificationSMS(myCase);
                }
                catch(Exception ex){
                    myCase.Resolution_Comment__c = 'Ocurrio un error al intentar enviar el SMS.';
                }
                
            }
            catch(Exception ex) 
            {
                myCase.status = 'No se pudo realizar';
                myCase.Resolution_Comment__c = 'Ocurrio un error al intentar generar el ajuste.'; 
            }
    }


    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 24/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de obtener los items de la factura para un comprobante dado.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void callToIntegrationS479(Case myCase, Map<String, Object> output) 
    {        
        try 
            {
                Account myAccount = [SELECT AccountIntegrationId__c FROM Account WHERE Id=:myCase.AccountId];
                System.debug('callToIntegrationS479 - Inicio');
                Double totalItemsAmount = 0;
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
                Map<String, Object> options = new Map<String, Object>();
                Map<String, Object> body = new Map<String, Object>();
                Map<String, Object> input = new Map<String, Object>();

                Map<String, Object> SolicitudCorreccionInformacion = new Map<String, Object>();
                Map<String, Object> ObjetoConsulta = new Map<String, Object>();
                Map<String, Object> CodigoDeAccesoCuenta = new Map<String, Object>();

                CodigoDeAccesoCuenta.put('idCuenta', myAccount.AccountIntegrationId__c); //Modificar
               
                ObjetoConsulta.put('codigoDeAccesoCuenta',CodigoDeAccesoCuenta);

                SolicitudCorreccionInformacion.put('objetoConsulta', ObjetoConsulta);
                SolicitudCorreccionInformacion.put('numeroComprobante', myCase.VoucherNumber__c); //Modificar
                SolicitudCorreccionInformacion.put('cantidadItemsConsulta', '1');
                SolicitudCorreccionInformacion.put('referenciaItemPaginado', '1');
                SolicitudCorreccionInformacion.put('cantidadMaxConsulta', '1');
                body.put('solicitudCorreccionInformacion', SolicitudCorreccionInformacion);
                
                input.put('body', body);

                if(!Test.isRunningTest())
                {
                    integProcService.invokeMethod('IFS_S479', input, output, options);
                    System.debug('Request S479: ' + JSON.serialize(input));
                    System.debug('Response S479: ' + JSON.serialize(output));
                }       
                else 
                {
                    Map<String,Object> IPResultTest = new Map<String,Object>();
                    String response = '{"solicitudCorreccionInformacion":{"numeroComprobante":"10006200230002","listaDetalle":{"elementoDetalle":[{"codCargo":"C_OT_MB_EQUIPMENT_SIM","idItemCorreccion":{"nroItemComprobante":"1"},"importeFacturaOriginal":{"importeItemComprobanteNeto":"121.0000","importeItemComprobanteBruto":"100.0000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"121.0000","importeItemComprobante":"100.0000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"},{"codCargo":"C_OT_MB_SIM","idItemCorreccion":{"nroItemComprobante":"2"},"importeFacturaOriginal":{"importeItemComprobanteNeto":"242.0000","importeItemComprobanteBruto":"200.0000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"242.0000","importeItemComprobante":"200.0000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"},{"codCargo":"C_OT_XM_SIM","idItemCorreccion":{"nroItemComprobante":"3"},"importeFacturaOriginal":{"importeItemComprobanteNeto":"342.0000","importeItemComprobanteBruto":"300.0000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"342.0000","importeItemComprobante":"300.0000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"},{"codCargo":"C_OT_XM_EQUIPMENT_SIM","idItemCorreccion":{"nroItemComprobante":"4"},"importeFacturaOriginal":{"importeItemComprobanteNeto":"442.0000","importeItemComprobanteBruto":"400.0000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"442.0000","importeItemComprobante":"400.0000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"},{"codCargo":"C_OS_MB_EQUIPMENT_SIM","idItemCorreccion":{"nroItemComprobante":"5"},"importeFacturaOriginal":{"importeItemComprobanteNeto":"542.0000","importeItemComprobanteBruto":"500.0000"},"montoNetoAjuste":"0.0000","montoAjuste":"0.0000","importeFacturaFinal":{"importeItemComprobanteSinImp":"542.0000","importeItemComprobante":"500.0000"},"codMoneda":"ARS","descripcionServicio":"Plan Nacional Prepago"}]},"cantidadItemsConsulta":1,"referenciaItemPaginado":1,"cantidadMaxConsulta":1}}';
                    output.put('IPResult',(Map<String, Object>)JSON.deserializeUntyped(response));
                }

                Map<String, Object> response = (Map<String, Object>)output.get('IPResult');
                System.debug('response 479: '+ response);

                if(!(response.get('detalle') == null))
                {
                    myCase.status = 'No se pudo realizar';
                    myCase.Resolution_Comment__c = 'No se pudieron obtener los items del comprobante.';
                }
                else 
                    getTotalItemsForVouchers(myCase, myAccount, response);
               
            }
            catch(Exception ex) 
            {
                System.debug('Error: ' + ex.getMessage());
                myCase.status = 'No se pudo realizar';
                myCase.Resolution_Comment__c = 'Ocurrio un error al intentar obtener los items de la factura.'; 
            }
    }

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 20/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de calcular el importe a ajustar en base a la respuesta de la S479.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void getTotalItemsForVouchers(Case myCase, Account myAccount, Map<String, Object> response)
    {
        Double importeTotal = 0;
        try
        {   
            
            Map<String, Object> SCI = (Map<String, Object>)response.get('solicitudCorreccionInformacion');
            Map<String, Object> listaDetalle = (Map<String, Object>)SCI.get('listaDetalle');
            List<Object> elementoDetalle = (List<Object>)listaDetalle.get('elementoDetalle');
            //String strListaDetalle = JSON.serialize(elementoDetalle);
            //strListaDetalle =  strListaDetalle.substring(1,strListaDetalle.length()-1);
            //System.debug('ListaDetalle: '+strListaDetalle);
            System.debug('Nro: Comprobante: '+SCI.get('numeroComprobante'));
            
            if(SCI.get('numeroComprobante') != null) //Las respuestas de las integraciones estan mal no se como verificar si hubo un error.
            { 
                List<Map<String, Object>> listaDetalleList = new List<Map<String, Object>>();

                for(Object element : elementoDetalle)
                {   
                    //Calculo del monto total de items.
                    Map<String, Object> listaDetalleItems = new Map<String, Object>();
                    Map<String, Object> nroComprobante = new Map<String, Object>();
                    
                    Map<String, Object> elementMap = (Map<String, Object>)element;
                    System.debug('Elemento: ' +elementMap);
                    Double importeAjuste = Double.valueOf(elementMap.get('montoNetoAjuste'));
                    
                    Map<String, Object> importeFacturaFinal = (Map<String, Object>)elementMap.get('importeFacturaFinal');
                    Double importeItemComprobanteSinImp = Double.valueOf(importeFacturaFinal.get('importeItemComprobanteSinImp'));
                    importeTotal += importeItemComprobanteSinImp;

                    //Generacion de JSON para confirmar Ajuste.
                    nroComprobante.put('codCargo', String.valueOf(elementMap.get('codCargo')));
                    listaDetalleItems.put('nroComprobante', nroComprobante);
                    Map<String, Object> idItemCorreccion = (Map<String, Object>)elementMap.get('idItemCorreccion');
                    listaDetalleItems.put('nroItemComprobante', String.valueOf(idItemCorreccion.get('nroItemComprobante')));
                    listaDetalleItems.put('montoNetoAjuste', '-'+String.valueOf(elementMap.get('montoNetoAjuste')));
                    listaDetalleList.add(listaDetalleItems);
                }
                System.debug('listaDetalle: '+listaDetalleList);
                System.debug('ImporteCaso: ' + myCase.vlocity_cmt__Amount__c);
                System.debug('importeTotal: '+ importeTotal);

                String strListaDetalle = JSON.serialize(listaDetalleList);
                System.debug('strListaDetalle: '+strListaDetalle);
                if(importeTotal != 0)
                    callToIntegrationS485(myCase, myAccount, strListaDetalle, importeTotal, elementoDetalle);
                else
                {
                    myCase.status = 'No se pudo realizar';
                    myCase.Resolution_Comment__c = 'No se pudo obtener el total de los items del comprobante.'; 
                }

            }
            else 
            {
                myCase.status = 'No se pudo realizar';
            }
        }
        catch(Exception ex)
        {
            throw ex;
        }
    }

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 20/04/2018
    Creado por: Federico Biaus.
    Descripcion: Metodo encargado de impactar el ajuste contra la S485.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void callToIntegrationS485(Case myCase, Account myAccount, String strListaDetalle, Double totalAmountItems, List<Object> elementoDetalle) 
    {        
        try 
            {
                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                String body = '{"body":{"solicitudCorreccionInformacion":{"objetoConsulta":{"codigoDeAccesoCuenta":{"idCuenta":"'+myAccount.AccountIntegrationId__c+'"}},"facturaInfo":{"numeroComprobante":"'+myCase.VoucherNumber__c+'","nivelCorreccion":"D","tipoAjuste":"CREDITO","listaDetalle":'+strListaDetalle+',"codMoneda":"ARS"},"codPuntoDeVenta":"","codMotivoAjuste":"6","datosAdicionales":{"nombreParametro":"Adj_Flag","valorParametro":"N"},"comentario":"Ajuste x excepcion"}}}';
                input = (Map<String, Object>)JSON.deserializeUntyped(body);
                
                vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

                if(!Test.isRunningTest())
                {
                    integProcService.invokeMethod('IFS_S485', input, output, options);
                    System.debug('Request: ' + JSON.serialize(input));
                    System.debug('Response: ' + JSON.serialize(output));
                }
                else 
                {
                   output.put('IPResult',(Map<String, Object>)JSON.deserializeUntyped('{}'));
                }

                Map<String, Object> response = (Map<String, Object>)output.get('IPResult');
                System.debug('response 479: '+ response);

                if(!(response.get('detalle') == null))
                {
                    myCase.status = 'No se pudo realizar';
                    myCase.Resolution_Comment__c = 'No se pudo confirmar el ajuste.';
                }
                else 
                {
                    myCase.status = 'Realizada exitosa';
                    myCase.Resolution_Comment__c = 'La Gestión ha sido realizada exitosamente. Se genero un ajuste por $'+totalAmountItems;
                    //myCase.Reason = 'Reclamo'; //Se quita a pedido de la US PFTA-10052 modifica PFTA-9470
                }

                try 
                {
                    sendNotificationSMS(myCase);
                }
                catch(Exception ex){
                    myCase.Resolution_Comment__c = 'Ocurrio un error al intentar enviar el SMS.';
                }
            }
            catch(Exception ex)
            {   
                myCase.status = 'No se pudo realizar';
                myCase.Resolution_Comment__c = 'Ocurrio un error al intentar generar el ajuste.'; 
            }
    }

    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 12/04/2018
    Modificado por: Federico Biaus.
    Descripcion: Metodo encargado de realizar el envio del SMS.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void sendNotificationSMS(Case myCase) 
    {
        try 
        {
            Map<String, Object> outMap        = new Map<String, Object>();
            Map<String, Object> options       = new Map<String, Object>();
            String communicationText        = '';
            String msg1               = 'Te informamos que tu Gestión con el número';
            String msg2               = ' por (*AJUSTE UNIDAD o MONTO*) ha sido Aprobada';
            String msg3               = ' por (*AJUSTE UNIDAD o MONTO*) ha sido Rechazada';
            String msg4               = 'Para mayor información diríjase al portal Mi Cuenta de Telecom Personal.';

            System.debug(myCase.AccountId);
            Account cuenta = [SELECT  vlocity_cmt__PrimaryContactId__c, Id FROM Account WHERE Id =:myCase.AccountId];
            Contact contacto = [SELECT Phone, Id FROM Contact WHERE Id =:cuenta.vlocity_cmt__PrimaryContactId__c];

            String cellphone = contacto.Phone;

            if(cellphone != null && cellphone != '')
            {
                if(myCase.status == 'Realizada exitosa')
                    communicationText =   msg1 + ' ' +  myCase.Id +' '+ msg2 +' '+  msg4;

                if(myCase.status == 'No se pudo realizar')
                    communicationText =   msg1 + ' ' + myCase.Id + ' ' + msg3 + ' ' +  msg4;
                  

                  System.debug('mensaje a enviar  ' + communicationText);

                  communicationText =   msg1 + myCase.Id + msg3 +  msg4;
                  String jsonString = '{"params": {"nroLinea": "contacto.Phone"},"body": {"bodyFullCodeName": "string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName": "SMS","communicationDate": "2017-05-04T02:29:43","communicationText": "string","messageReference": "string","target": {"rawdata": [{"key": "string","value": "string"}],"user": {"customerNumber": 0,"lastName": "string","mail": "string","name": "string"}}}}';
                  Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

                  vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                  integProcServ.invokeMethod('IFS_S159', input, outMap, options);
                  System.debug('Response: ' + JSON.serialize(outMap));
            }
        }
        catch(Exception ex) 
        {
            System.debug('Error al enviar el SMS:' + ex.getMessage());
            throw ex;
        }
    }
    
    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 14/05/2018
    Creado por: Leandro Desiata.
    Descripcion: Metodo encargado de asignar el entitlement y la primer cola de backOffice al caso
                 de servicio técnico, cuando sea necesario.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void updateCaseTechServiceCriteria(List<Case> triggerNew, Map<Id, Case> triggerOldMap) {
        try {
            final String THREE_CHARACTERS_QUEUE = '00G';
            List <Case> casesToChangeEntitlement = New List<Case>();
            
            Set<Id> setIds = New Set<Id>();
            Map<Id,Case> casesToChangeOwnerMap = New Map<Id,Case>();
            Map<Id,Boolean> foundMap = New Map<Id,Boolean>();
            Set<Id> accIdsSet = New Set<Id>();
            
            for(Case caseTest : triggerNew){
                system.debug('SUBJECT --> '+caseTest.Subject);
                system.debug('STATUS--> '+caseTest.Status);
                system.debug('ORDEN STATUS --> '+caseTest.RelatedTechQuoteStatus__c);
                system.debug('ORDEN ID EN CASE --> '+caseTest.Order__c);
                if(caseTest.Subject == 'Gestión de Servicio Técnico' && caseTest.Status == 'En espera del cliente' && caseTest.RelatedTechQuoteStatus__c == 'Pendiente de aprobación'){
                    casesToChangeEntitlement.add(caseTest);
                    accIdsSet.add(caseTest.AccountId);
                }
                if(caseTest.Status == 'Derivada' && caseTest.Status != triggerOldMap.get(caseTest.Id).Status &&  caseTest.Subject == 'Gestión de Servicio Técnico' && caseTest.RelatedTechQuoteStatus__c == 'Pendiente de aprobación'){
                    setIds.add(caseTest.Id);
                    casesToChangeOwnerMap.put(caseTest.Id, caseTest);
                    foundMap.put(caseTest.Id, false);
                }
            }
            if(casesToChangeEntitlement.size() > 0){
                SlaProcess entitleProcess = [SELECT id,name,IsVersionDefault FROM SlaProcess WHERE name = 'TechCare-OrderAcceptanceSLA' AND IsVersionDefault = true LIMIT 1];
                system.debug('ENTITLEMENT PROCESS'+entitleProcess);
                Map <Id,Entitlement> accEntitleMap;
                if(entitleProcess != null){
                    accEntitleMap = EntitlementManager.GetExistentEntitlementMap(accIdsSet, entitleProcess.Id);
                    system.debug('ENTITLEMENT EXISTENCE'+accEntitleMap);
                }
                if(accEntitleMap.size() > 0 ){
                    for(Case caseObj : casesToChangeEntitlement){
                        caseObj.EntitlementId = accEntitleMap.get(caseObj.AccountId).Id;
                    }   
                }   
            }
            if(casesToChangeOwnerMap.size() > 0 && triggerOldMap != null){
                List<CaseHistory> caseHistoryList = [SELECT CreatedById,CreatedDate,Field,Id,NewValue,OldValue,CaseId FROM CaseHistory WHERE CaseId IN: setIds  AND Field = 'Owner' ORDER BY CreatedDate ASC NULLS LAST];
                
                Map<id,String> casesMap= New Map<id,String>();
                Map<id,id> idQueueMap= New Map<id,id>();
                
                for(CaseHistory ch: caseHistoryList){
                    String oldValueString = String.valueOf(ch.OldValue);
                    String threeFirstCharacters = oldValueString.left(3);
                    if(!foundMap.get(ch.CaseId) && !oldValueString.isAlphaSpace() && oldValueString.length() == 18 && threeFirstCharacters == THREE_CHARACTERS_QUEUE){
                        foundMap.put(ch.CaseId,true);
                        Id idQueue = Id.valueOf(oldValueString);
                        String caseString = Json.serialize(casesToChangeOwnerMap.get(ch.CaseId));
                        casesMap.put(ch.CaseId,caseString);
                        idQueueMap.put(ch.CaseId,idQueue);
                    }
                
                }
                setFirstBackOfficeQueueFuture(casesMap, idQueueMap);    
            }
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }

    @future
    public static void setFirstBackOfficeQueueFuture(Map<id,String> casesMap, Map<id,id> idQueueMap) {
        try{
            Set <Id> setIds = New Set<Id>();
            List<Case> casesToUpdate = New List<Case>();
            for(String cases: casesMap.values()){
                Case caseObj = (Case)Json.deserialize(cases,System.Type.forName('Case'));
                setIds.add(caseObj.Id);
                caseObj.OwnerId = idQueueMap.get(caseObj.id);
                casesToUpdate.add(caseObj);
            }
    
            /*List<CaseMilestone> cmsToUpdate = [SELECT Id, completionDate FROM CaseMilestone cm WHERE caseId IN: setIds  AND cm.MilestoneType.Name='TechCare10Days' AND completionDate = null];
            if (cmsToUpdate.size() > 0){
                for (CaseMilestone cm : cmsToUpdate){
                    cm.completionDate = System.now();
                }
                update cmsToUpdate;
            }*/
            
            EntitlementManager.UpdateCompletionDateMilestone('TechCare10Days',setIds);
            update casesToUpdate;
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }
    
    /***************************************************************************/
    /***************************************************************************/
    /*
    Fecha: 14/05/2018
    Creado por: Leandro Desiata.
    Descripcion: Metodo encargado de updatear el OrderApprovalStatus de la orden para auto rechazar el presupuesto
                 de servicio tecnico.
    */
    /***************************************************************************/
    /***************************************************************************/
    public static void updateOrderBudgetStatus(List<Case> triggerNew, Map<Id, Case> triggerOldMap) {
        try{
            Set <Id> setCaseId= New Set<Id>();
            List <Order> ordersToUpdate = New List <Order>();
            for(Case caseTest : triggerNew){
                if(caseTest.Status == 'Derivada' && caseTest.Status != triggerOldMap.get(caseTest.Id).Status &&  caseTest.Subject == 'Gestión de Servicio Técnico' && caseTest.RelatedTechQuoteStatus__c == 'Pendiente de aprobación'){
                    setCaseId.add(caseTest.Order__c);
                }   
            }
            if(setCaseId.size() > 0){
                List <Order> ordersList = [SELECT Id,OrderApprovalStatus__c FROM Order WHERE Id IN: setCaseId];
                for(Order orden: ordersList){
                   if(orden.OrderApprovalStatus__c == 'Pendiente de aprobación'){
                       orden.OrderApprovalStatus__c = 'Rechazado por Cliente';
                       ordersToUpdate.add(orden);
                   } 
                }
            }
            update ordersToUpdate;
        }
        catch(Exception ex) 
        {
            System.debug('Error:' + ex.getMessage());
        }
    }
    
    public static void createEntitlementToTechServiceCase(List<Case> triggerNew) {
           system.debug('ENTRO');
           List <Case> casesToChangeEntitlement = New List<Case>();
           Set<Id> accIdsSet = New Set<Id>();
           
           for(Case caseTest : triggerNew){
                if(caseTest.Subject == 'Gestión de Servicio Técnico' && caseTest.Status == 'En espera del cliente' && caseTest.RelatedTechQuoteStatus__c == 'Pendiente de aprobación'){
                    casesToChangeEntitlement.add(caseTest);
                    accIdsSet.add(caseTest.AccountId);
                }
           }
           if(casesToChangeEntitlement.size() > 0){
                SlaProcess entitleProcess = [SELECT id,name,IsVersionDefault FROM SlaProcess WHERE name = 'TechCare-OrderAcceptanceSLA' AND IsVersionDefault  = true LIMIT 1];
                Map <Id,Entitlement> accEntitleMap;
                if(entitleProcess != null){
                    accEntitleMap = EntitlementManager.GetExistentEntitlementMap(accIdsSet, entitleProcess.Id);
                }
                if(accEntitleMap.size() ==0 && entitleProcess != null){
                    for(Case caseObj : casesToChangeEntitlement){
                        String entitleName = caseObj.AccountId  +'Entitlement';
                        Date startDate = Date.valueOf(date.today());
                        Entitlement entObj = EntitlementManager.CreateEntitlement(entitleName,caseObj.AccountId,startDate,entitleProcess.Id);
                        insert entObj;
                    }   
                }   
            }
    }

    public static void SetOwnerTeam(List<Case> triggerNew, Map<Id, Case> triggerOldMap) {
        Set<Id> ownerIds = New Set<Id>();
        List <Case> casesToWork = New List<Case>();
        List <Team_Member__c> teamMembers;
        for(Case cs : triggerNew){
        System.debug('Caso: '+cs);
        System.debug('Valdiacion: '+ cs.Subject != 'Inconvenientes con cargos tasados y facturados');
            if(cs.Subject != 'Inconvenientes con cargos tasados y facturados' && (triggerOldMap == null || (cs.OwnerId != triggerOldMap.get(cs.Id).OwnerId && string.valueOf(cs.OwnerId).startsWith('005')))){
                ownerIds.add(cs.OwnerId);
                casesToWork.add(cs);
            }else if (cs.Subject != 'Inconvenientes con cargos tasados y facturados' && (cs.Owner_Team__c != null && string.valueOf(cs.OwnerId).startsWith('00G'))){
                cs.Owner_Team__c = null;
            }
        }
        if(casesToWork.size() > 0){
            Map<id,id> teamMemberOwnerMap = New Map<Id,Id>();
            teamMembers = [SELECT id,Work_Team__c,Is_Active__c,User_member__c FROM Team_Member__c WHERE User_member__c IN:ownerIds AND Is_Active__c = true];
            for(Team_Member__c tm: teamMembers){
                teamMemberOwnerMap.put(tm.User_member__c,tm.Work_Team__c);
            }
            for(Case cases :casesToWork){
                cases.Owner_Team__c = teamMemberOwnerMap.get(cases.OwnerId);
            }
        }
    }
}