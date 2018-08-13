trigger ta_masiveIncident_closing on Case (after update) {
	
    /*Case[] incidentsToUpdate = new list<Case>();
    Case[] masiveIncident = [SELECT Id,Contact.Name FROM Case WHERE Id IN :Trigger.New AND Contact.Name = NULL AND Origin = 'IVR' AND Status = 'Cancelada'];
    if (masiveIncident != NULL) {
        for (Case childIncident : [SELECT Id FROM Case WHERE Contact.Name != '' AND Origin = 'IVR' AND Status != 'Cancelada']) {
            Case tempIncident = new Case();
            tempIncident.Id = childIncident.Id;
            tempIncident.Status = 'Cancelada';
            incidentsToUpdate.add(tempIncident);
        }
    }
    update incidentsToUpdate;*/
}