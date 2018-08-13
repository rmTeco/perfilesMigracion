public with sharing class ta_techCare_communities_controller {
    Case inpCase;
    Boolean accepted = false;
    Boolean rejected = false;
    List<String> messages {get; set;}

    public List<String> getMessages(){
        return messages;
    }

    public Integer getMessagesSize(){
        return messages.size();
    }

    public Case getInpCase(){
        return inpCase;
    }

    public Boolean getAccepted(){
        return accepted;
    }

    public Boolean getRejected(){
        return rejected;
    }

    public ta_techCare_communities_controller(ApexPages.StandardController stdController) {
        Case pageCase = (Case)stdController.getRecord();
        this.inpCase = [SELECT Id,
                               Order__r.vlocity_cmt__OneTimeTotal__c,
                               Status,
                               Contact_Channel__c,
                               AccountId,
                               SuppliedEmail,
                               SuppliedPhone,
                               AssetId
                          FROM Case
                         WHERE Id = :pageCase.Id];
         this.accepted = this.inpCase.Status.equals('En espera de ejecución');
         this.rejected = this.inpCase.Status.equals('No aceptada');
        this.messages = new List<String>();
    }

    public PageReference noAceptar(){
        messages.clear();

        try{

            Account acc = [SELECT Id, 
                                  Name,
                                  vlocity_cmt__PrimaryContactId__r.FirstName,
                                  vlocity_cmt__PrimaryContactId__r.Email,
                                  vlocity_cmt__PrimaryContactId__r.MobilePhone
                             FROM Account 
                            WHERE Id = :this.inpCase.AccountId];

            String msj = 'Hola ' + acc.vlocity_cmt__PrimaryContactId__r.FirstName + ';\n\n' +
                         'Te escribimos para avisarte que puedes retirar tu equipo dentro de los próximos 30 días.';

            //Notification
            this.sendNotification(msj, acc);

            //Status update
            this.inpCase.Status = 'No aceptada';
            update inpCase;

            messages.add('Se cambió correctamente el estado a <b>No aceptada</b>');

            //Order update
            Order ord = new Order(Id=inpCase.Order__r.Id);
            ord.Estimate_Acceptance__c = 'Rechazado';
            update ord;

            messages.add('Se cambió correctamente la aceptación de la orden a <b>Rechazado</b>');

        } catch(Exception ex){
            messages.add('Error en el proceso: ' + ex.getMessage());
        }

        return null;
    }

    public PageReference aceptar(){
        messages.clear();

        try{

            Account acc = [SELECT Id, 
                                  Name,
                                  vlocity_cmt__PrimaryContactId__r.FirstName,
                                  vlocity_cmt__PrimaryContactId__r.Email,
                                  vlocity_cmt__PrimaryContactId__r.MobilePhone
                             FROM Account 
                            WHERE Id = :this.inpCase.AccountId];
//            String assetId = [Select Id, AssetId 
//                            From Case
//                            WHERE Id= :this.inpCase.Id limit 1].AssetId;
            Asset equipo = [Select Id, assetModel__c, Asset_Brand__c 
                             FROM Asset
                            Where Id = :this.inpCase.AssetId];

            String msj = 'Te informamos que el presupuesto para la reparación de tu equipo '+equipo.Asset_Brand__c+' y '+equipo.assetModel__c+' fue aceptado y el mismo se encuentra en proceso de reparación';

            //Notification
            this.sendNotification(msj, acc);

            //Status update
            this.inpCase.Status = 'En espera de ejecución';
            update inpCase;

            messages.add('Se cambió correctamente el estado a <b>En espera de ejecución</b>');

            //Order update
            Order ord = new Order(Id=inpCase.Order__r.Id);
            ord.Estimate_Acceptance__c = 'Aceptado';
            update ord;

            messages.add('Se cambió correctamente la aceptación de la orden a <b>Aceptado</b>');

        } catch(Exception ex){
            messages.add('Error en el proceso: ' + ex.getMessage());
        }

        return null;
    }

    private void sendNotification(String msj, Account acc){
        if(this.inpCase.Contact_Channel__c == 'Mail'){
            //Mail
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String body = msj;

            String address = '';
            if(this.inpCase.SuppliedEmail != '' && this.inpCase.SuppliedEmail != null)
                address = this.inpCase.SuppliedEmail;
            else
                address = acc.vlocity_cmt__PrimaryContactId__r.Email;

            email.setPlainTextBody(body);
            email.setSubject('Gestión de Servicio Técnico');
            email.setToAddresses(new String[] {address});

            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

            if(r[0].isSuccess())
                messages.add('Email enviado correctamente a la dirección: <b>' + address + '</b>');
            else{
                messages.add('Falló el envío de mail a la dirección <b>' + address + '</b>');

                for(Messaging.SendEmailError err : r[0].getErrors()){
                    messages.add(err.getMessage());
                }
            }
        } else if(this.inpCase.Contact_Channel__c == 'SMS'){
            //Send SMS
            String phone = '';

            if(this.inpCase.SuppliedPhone != null){
                phone = ta_techCare_technical_service.GetValidatedPhone(this.inpCase.SuppliedPhone);
            } else{
                phone = acc.vlocity_cmt__PrimaryContactId__r.MobilePhone;
            }

            try{
                ta_techCare_communities_controller.SendSMS(phone, msj);

                messages.add('SMS enviado correctamente al número: <b>' + phone + '</b>');
            } catch(Exception ex){
                messages.add('Error al enviar SMS al número: <b>' + phone + '</b>');
                messages.add('Error: ' + ex.getMessage());
            }
        } else if(this.inpCase.Contact_Channel__c == 'Telefono/celular'){
            messages.add('No se avisa al usuario (canal de contacto: Telefono/celular)');
        } else{
            messages.add('El usuario no seleccionó un canal de contacto');
        }
    }

    public static void SendSMS(String phone, String msj){
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, String> parms = new Map<String, String>();
        parms.put('nroLinea', phone);
        input.put('params', parms);

        Map<String, Object> body = new Map<String, Object>();
        body.put('communicationText', msj);
        body.put('communicationDate', DateTime.now());
        body.put('channelName', 'SMS');
        body.put('campaignName', SMSSender__c.getInstance('S-Confirmacion-SMS'));

        input.put('body', body);

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        integProcServ.invokeMethod('IFS_S159_2', input, output, options);

        Map<String, Object> response = (Map<String, Object>) output.get('IPResult');

        String execCode = (String) response.get('executionCode');

        if(execCode != 'OK')
            throw new FuncException('Error inesperado al enviar el SMS: ' + output);
    }
}