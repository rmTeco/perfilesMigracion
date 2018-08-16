global with sharing class ta_techCare_contactMOtive_controller {
    List<SelectOption> channelList = new List<SelectOption>();
    List<SelectOption> serviceList = new List<SelectOption>();
    List<SelectOption> incidentList = new List<SelectOption>();
   
    public String selectedService  { get; set; } 
    public String selectedChannel  { get; set; }
    public String selectedIncident  { get; set; }
    public String newIncident { get; set; }
    public String editedIncident { get; set; }
    public String newService { get; set; }
    public String serviceOptionNewInc { get; set; }
    public String error { get; set; }
    public String success { get; set; }

    public boolean newIncidentPopup { get; set; }

    public boolean getNewIncidentPopup(){
      return this.newIncidentPopup;
    }

    public void openNewIncident(){
      newIncidentPopup = true;
    }

    public void closeNewIncident(){
      newIncidentPopup = false;
    }
    
    public List<SelectOption> getChannelList() {
        
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('-', '-'));
        
        for (AggregateResult channel : [SELECT Channel__c 
                                          FROM Contact_Motive__c 
                                         WHERE RecordType.Name = 'Service Incident'
                                           AND Is_Active__c = true
                                        GROUP By Channel__c]){
            options.add(new SelectOption((String)channel.get('Channel__c'),(String)channel.get('Channel__c')));                                
        }
        return options;
    }
    
    public List<SelectOption> getServiceList() {
        
        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('-', '-'));
        
        for (AggregateResult service : [SELECT Service__c 
                                          FROM Contact_Motive__c 
                                         WHERE RecordType.Name = 'Service Incident'
                                           AND Is_Active__c = true
                                           AND Channel__c = :selectedChannel
                                      GROUP By Service__c])
        {
            options.add(new SelectOption((String)service.get('Service__c'),(String)service.get('Service__c')));                                
        }
        return options;
    }

    public List<SelectOption> getIncidentList() {
        newService = selectedService;
        editedIncident = selectedIncident;

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('-', '-'));
        
        for (AggregateResult incident : [SELECT Incident__c 
                                          FROM Contact_Motive__c 
                                         WHERE RecordType.Name = 'Service Incident'
                                           AND Is_Active__c = true
                                           AND Channel__c = :selectedChannel
                                           AND Service__c = :selectedService
                                      GROUP By Incident__c])
        {
            options.add(new SelectOption((String)incident.get('Incident__c'),(String)incident.get('Incident__c')));                                
        }
        System.debug('incidents: ' + options);
        return options;
    }

    public void createIncident(){
        try{
            if(newIncident == '' || newIncident == null)
                throw new FuncException('Debe ingresar un nombre para el nuevo incidente');

            String rtId = Schema.SObjectType.Contact_Motive__c.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId();

            if(serviceOptionNewInc == '1'){
                if(selectedService == '-')
                    throw new FuncException('Debe seleccionar un servicio');

                List<Contact_Motive__c> lstCMS_1 = [SELECT Id 
                                                    FROM Contact_Motive__c 
                                                    WHERE Channel__c = :selectedChannel
                                                    AND Service__c = :selectedService
                                                    AND Incident__c = :newIncident
                                                    AND RecordTypeId = :rtId];
                
                if(lstCMS_1.size() > 0){
                    throw new FuncException('Ya existe el incidente <b>' + newIncident + '</b> para el servicio <b>' + selectedService + '</b>.');
                }
                
                Contact_Motive__c newCM_1 = new Contact_Motive__c(Incident__c=newIncident, 
                                                                  Channel__c=selectedChannel, 
                                                                  Service__c=selectedService,
                                                                  RecordTypeId=rtId,
                                                                  Is_Active__c=true);
                insert newCM_1;

                success = 'Se agregó correctamente el incidente <b>' + newIncident + '</b> al servicio <b>' + selectedService + '</b>';
                error = null;
            } else if(serviceOptionNewInc == '2'){
                if(selectedChannel == '-')
                    throw new FuncException('Debe seleccionar un canal');
                
                List<Contact_Motive__c> newsCMs = new List<Contact_Motive__c>();
                
                for(AggregateResult services : [SELECT Service__c
                                                  FROM Contact_Motive__c 
                                                 WHERE Channel__c = :selectedChannel
                                              GROUP BY Service__c])
                {
                    newsCMs.add(new Contact_Motive__c(Channel__c = selectedChannel,
                                                      Service__c = (String) services.get('Service__c'),
                                                      Incident__c = newIncident,
                                                      RecordTypeId = rtId,
                                                      Is_Active__c = true));
                }

                insert newsCMs;

                success = 'Se agregó correctamente el incidente <b>' + newIncident + '</b> a todos los servicios del canal <b>' + selectedChannel + '</b>';
                error = null;
            } else if(serviceOptionNewInc == '3'){
                List<Contact_Motive__c> lstCMs_3 = new List<Contact_Motive__c>();

                for (AggregateResult channel : [SELECT Channel__c 
                                          FROM Contact_Motive__c 
                                         WHERE RecordType.Name = 'Service Incident'
                                           AND Is_Active__c = true
                                        GROUP By Channel__c]){
                    String selChann = (String) channel.get('Channel__c');

                    for (AggregateResult srv : [SELECT Service__c 
                                                       FROM Contact_Motive__c 
                                                      WHERE RecordType.Name = 'Service Incident'
                                                        AND Is_Active__c = true
                                                        AND Channel__c = :selChann
                                                   GROUP By Service__c])
                    {
                        String selSrv = (String) srv.get('Service__c');
                        
                        lstCMs_3.add(new Contact_Motive__c(
                            Channel__c = selChann,
                            Service__c = selSrv,
                            Incident__c = newIncident,
                            RecordTypeId = rtId,
                            Is_Active__c = true
                        ));
                    }

                }

                insert lstCMs_3;

                success = 'Se agregó correctamente el incidente <b>' + newIncident + '</b> a todos los servicios de todos los canales</br>(' + lstCMs_3.size() + ' records)';
                error = null;
            }
        } catch(Exception ex){
            error = ex.getMessage();
            success = null;
        }
    }

    public void editService(){
        try{
            if(selectedService == '-')
                throw new FuncException('Debe seleccionar un servicio primero');
            if(newService == '' || newService == null)
                throw new FuncException('Debe ingresar un nuevo nombre para el servicio');
            if(newService == selectedService)
                throw new FuncException('No hubo cambios en el nombre');

            List<Contact_Motive__c> exists = [SELECT Id FROM Contact_Motive__c WHERE Service__c = :newService];

            if(exists.size() > 0)
                throw new FuncException('El servicio <b>' + newService + '</b> ya existe');

            List<Contact_Motive__c> updateContactMotives = new List<Contact_Motive__c>();

            for(Contact_Motive__c cmOldService : [SELECT Id 
                                                    FROM Contact_Motive__c 
                                                   WHERE Service__c = :selectedService
                                                     AND Channel__c = :selectedChannel]){
                cmOldService.Service__c = newService;
                updateContactMotives.add(cmOldService);
            }

            update updateContactMotives;

            success = 'Se actualizó el nombre de servicio de <b>' + selectedService + '</b> a <b>' + newService + '</b>.';
            error = null;
        } catch(Exception ex){
            error = ex.getMessage();
            success = null;
        }
    }
    
    public void editIncident(){
        try{
            if(selectedIncident == '-')
                throw new FuncException('Debe seleccionar un incidente primero');
            if(editedIncident == '' || editedIncident == null)
                throw new FuncException('Debe ingresar un nuevo nombre para el incidente');
            if(editedIncident == selectedIncident)
                throw new FuncException('No hubo cambios en el nombre');

            List<Contact_Motive__c> exists = [SELECT Id FROM Contact_Motive__c 
                                               WHERE Incident__c = :editedIncident
                                                 AND Service__c = :selectedService];

            if(exists.size() > 0)
                throw new FuncException('El incidente <b>' + editedIncident + '</b> ya existe en el servicio <b>' + selectedService + '</b>.');

            List<Contact_Motive__c> updateContactMotives = new List<Contact_Motive__c>();

            for(Contact_Motive__c cmOldService : [SELECT Id 
                                                    FROM Contact_Motive__c 
                                                   WHERE Service__c = :selectedService
                                                     AND Channel__c = :selectedChannel
                                                     AND Incident__c = :editedIncident]){
                cmOldService.Incident__c = editedIncident;
                updateContactMotives.add(cmOldService);
            }

            update updateContactMotives;

            success = 'Se actualizó el nombre del incidente de <b>' + selectedIncident + '</b> a <b>' + editedIncident + '</b>.';
            error = null;
        } catch(Exception ex){
            error = ex.getMessage();
            success = null;
        }
    }
    
    public void refreshServices(){
          getServiceList();
      incidentList = new List<SelectOption>();
    }

    public void refreshIncidents(){
      getIncidentList();
    }
}