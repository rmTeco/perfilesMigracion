public with sharing class ta_care_setAdjustment {
 @InvocableMethod(label='Setear Ajuste' description='Confirma el ajuste invocando al IF_S031')
    public static void setAdjustment(List<Case> cases) {
       try
       {  
           System.debug('Inicio proceso SET ADJUSTE');
           System.debug(cases.get(0).Id);

           Map<String, Object> output = new Map<String, Object>();
           Map<String, Object> options2 = new Map<String, Object>();
           vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

           if (cases != null && !cases.isEmpty()) 
           {
               Case myCase = [SELECT AccountId, vlocity_cmt__ServiceId__c, Status, vlocity_cmt__Amount__c, CantidadAjuste__c, TipoOperacionAjuste__c, UnidadAjuste__c, TipoSeleccion__c, Id, Reason, Resolution_Comment__c FROM Case WHERE Id =: cases.get(0).Id];
				System.debug('myCase: ' + myCase);
               if((myCase.Status == 'En espera de ejecución') && (myCase.vlocity_cmt__Amount__c > 0))
               {

                  String codTipoBalance, montoAjustar;
                  //codTipoBalance = 'FU_VMO_NACIONAL';
                  //montoAjustar = '400.0000';

                  if(myCase.TipoSeleccion__c == 'Servicio')
                  {

                    if(myCase.UnidadAjuste__c == 'Credito')
                    {
                      codTipoBalance = 'C_MAIN_ACCOUNT';
                      montoAjustar = myCase.vlocity_cmt__Amount__c + '00';
                    }

                    if(myCase.UnidadAjuste__c == 'SMS')
                    {
                      codTipoBalance = 'FU_SMO_NACIONAL';
                      montoAjustar = myCase.CantidadAjuste__c + '.0000';
                    }
                    
                    if(myCase.UnidadAjuste__c == 'VOZ')
                    {
                      codTipoBalance = 'FU_VMO_NACIONAL';
                      montoAjustar = myCase.CantidadAjuste__c;
                      Integer segundos;
                      if(montoAjustar.Contains(':'))
                        segundos = (Integer.ValueOf(montoAjustar.SUBSTRING(0,2))*3600) + (Integer.ValueOf(montoAjustar.SUBSTRING(3,4))*60) + Integer.ValueOf(montoAjustar.SUBSTRING(6,7));
                      else
                        segundos = (Integer.ValueOf(montoAjustar.SUBSTRING(0,2))*3600) + (Integer.ValueOf(montoAjustar.SUBSTRING(2,4))*60) + Integer.ValueOf(montoAjustar.SUBSTRING(4,6));

                      montoAjustar = String.ValueOf(segundos) + '.0000';
                    }

                    
                    if(myCase.UnidadAjuste__c == 'Datos(Mb)')
                    {
                      codTipoBalance = 'FU_DATA_HS';
                      montoAjustar = String.ValueOf((Integer.ValueOf(myCase.CantidadAjuste__c) * 1024)) + '.0000';
                    }
                  }

                  Map<String, Object> body = new Map<String, Object>();

            try{

                if(myCase.TipoSeleccion__c == 'Servicio') {
                  Asset assetObj = [SELECT Subscription_Id__c FROM Asset WHERE Id =:myCase.vlocity_cmt__ServiceId__c];

                  if(!(assetObj != null && assetObj.Subscription_Id__c != null))
                    throw new FuncException('No existe el codigo de subscripcion.');

                  Map<String, Object> AccesoPorSubscriptor = new Map<String, Object>();
                  AccesoPorSubscriptor.put('codSuscripcion', assetObj.Subscription_Id__c);
                  body.put('accesoPorSubscriptor', AccesoPorSubscriptor);
                }
                else {
                  Account accountObj = [SELECT AccountIntegrationId__c FROM Account WHERE Id =:myCase.AccountId];

                  if(!(accountObj != null && accountObj.AccountIntegrationId__c != null))
                    throw new FuncException('No existe el account integration id.');

                  Map<String, Object> AccesoPorCuenta = new Map<String, Object>();
                  AccesoPorCuenta.put('idCuenta', accountObj.AccountIntegrationId__c);
                  body.put('accesoPorCuenta', AccesoPorCuenta);
                }

                  /*
                    tipoOperacionAjuste Si  1..1  Valores posibles:
                      1: Ajuste de una unidad libre o el balance. 
                         Nota: En este escenario, tipoAjuste y montoAjuste son obligatorios.
                      2: Restablecer la unidad libre o balance.
                         Nota: Si las unidades libres se ponen a cero, el parámetro codPaqueteUnidadesLibres es obligatorio. 
                         Si se restablecen los saldos, el parámetro codBalance es obligatorio y parámetro tipoAjuste es opcional.
                      3: posponer la fecha de caducidad de la instancia.  Ajuste
                  */

                  body.put('tipoOperacionAjuste', '1');
                   
                  if(myCase.TipoSeleccion__c == 'Servicio') {
                      if(myCase.UnidadAjuste__c == 'Credito') {
                         List<Map<String, Object>> listaAjusteBalance = new List<Map<String, Object>>();
                         Map<String, Object> ajusteBalance = new Map<String, Object>();
                         ajusteBalance.put('codTipoBalance',codTipoBalance);
                         ajusteBalance.put('tipoAjuste',myCase.TipoOperacionAjuste__c);
                         ajusteBalance.put('montoAjuste',montoAjustar.replace(',','.'));
                         ajusteBalance.put('codMoneda','ARS');

                         listaAjusteBalance.add(ajusteBalance);
                         body.put('listaAjusteBalance', listaAjusteBalance);
                      }
                      else {
                         List<Map<String, Object>> listaAjusteunidadesLibres = new List<Map<String, Object>>();
                         Map<String, Object> ajusteLibre = new Map<String, Object>();
                         ajusteLibre.put('codUsoUnidadesLibres',codTipoBalance);
                         ajusteLibre.put('tipoAjuste', myCase.TipoOperacionAjuste__c);
                         ajusteLibre.put('montoAjuste',montoAjustar);

                         listaAjusteunidadesLibres.add(ajusteLibre);
                         body.put('listaAjusteunidadesLibres', listaAjusteunidadesLibres);
                      }
                  }
                  else { //Cuenta default
                    if(true) {//Aca se de debe validar cuando se desarrolle si se trata de un Comprobante o Ajuste Libre (actualmente desarrollamos el camino por ajuste libre) 
                       String tipoOperacion = myCase.TipoOperacionAjuste__c == 'NC'?'CREDITO':'DEBITO';
                       List<Map<String, Object>> listaAjusteBalance = new List<Map<String, Object>>();
                       Map<String, Object> ajusteBalance = new Map<String, Object>();
                       ajusteBalance.put('codTipoBalance',codTipoBalance);
                       ajusteBalance.put('tipoAjuste',tipoOperacion);
                       ajusteBalance.put('montoAjuste', myCase.vlocity_cmt__Amount__c + '00');
                       ajusteBalance.put('codMoneda','ARS');

                       listaAjusteBalance.add(ajusteBalance);
                       body.put('listaAjusteBalance', listaAjusteBalance);
                    }
                  } 

                  Map<String, Object> input = new Map<String, Object>();
                  input.put('body', body);
                
                System.debug('input: ' + input);
                System.debug('output: ' + output);
                System.debug('options2: ' + options2);
                   
                  try {
                     integProcService.invokeMethod('IFS_S031', input, output, options2);
                     System.debug('Request: ' + JSON.serialize(input));
                     System.debug('Response: ' + JSON.serialize(output));
                     
                     Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

                     if(response != null) { //este IF esta mal
                        myCase.status = 'Realizada exitosa';
                        myCase.Resolution_Comment__c = 'La Gestión ha sido realizada exitosamente ' + JSON.serialize(output);
                        myCase.Reason = 'Reclamo';
                        update myCase;
                     }
                     else {
                        myCase.status = 'No se pudo realizar';
                        update myCase;
                     }

                     try {
                       getCase(myCase);
                     }
                     catch(Exception ex) { 
                        System.debug('Error al intentar enviar mensaje:' + ex.getMessage());
                     }
                  }
                  catch(Exception ex) //Si falla la integracion por X motivo
                  {
                    myCase.status = 'No se pudo realizar';
                    update myCase;

                    try {
                       getCase(myCase);
                    }
                    catch(Exception error) {
                      System.debug('Error al intentar enviar mensaje por falla tecnica de integracion:' + error.getMessage());
                    } 
                  }

              }
              catch(Exception ex) {
                  myCase.status = 'No se pudo realizar';
                  update myCase;
              }

            }
          }      
       }
       catch(Exception ex) {
           throw ex;
       }
   }


   public static void getCase(Case myCase) {

    try {

        System.debug(myCase);
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

        if(cellphone != null && cellphone != '') {
          System.debug('Estado: '+ myCase.status);

          if(myCase.status == 'Realizada exitosa') {
            communicationText =   msg1 + ' ' +  myCase.Id +' '+ msg2 +' '+  msg4;
          }

          if(myCase.status == 'No se pudo realizar') {
            communicationText =   msg1 + ' ' + myCase.Id + ' ' + msg3 + ' ' +  msg4;
          }

          System.debug('mensaje a enviar  ' + communicationText);

          communicationText =   msg1 + myCase.Id + msg3 +  msg4;
          String jsonString = '{"params": {"nroLinea": "contacto.Phone"},"body": {"bodyFullCodeName": "string","campaignName":"'+SMSSender__c.getInstance('S-Confirmacion-SMS').Sender__c+'","channelName": "SMS","communicationDate": "2017-05-04T02:29:43","communicationText": "string","messageReference": "string","target": {"rawdata": [{"key": "string","value": "string"}],"user": {"customerNumber": 0,"lastName": "string","mail": "string","name": "string"}}}}';
          Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

          vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
          integProcServ.invokeMethod('IFS_S159', input, outMap, options);
          System.debug('Response: ' + JSON.serialize(outMap));
          
        }
      }
      catch(Exception ex) {
        System.debug('Error al enviar el SMS:' + ex.getMessage());
        throw ex;
      }

  }
}