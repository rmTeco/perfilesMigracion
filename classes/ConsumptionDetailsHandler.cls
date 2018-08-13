global with sharing class ConsumptionDetailsHandler implements vlocity_cmt.VlocityOpenInterface{

   global ConsumptionDetailsHandler(){}

   global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) 
   {
    Boolean result = true;
      try {

         if (methodName.equals('filterDataByFamily')) {

            filterDataByFamily(methodName, input, outMap, options);
         }
         return result;

      }
      catch(Exception e) {
         System.debug('ConsumptionDetailsHandler: invokeMethod -> exception: '+e);
         return false;
      }
      
   }

   @RemoteAction
   global static void filterDataByFamily(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options)
   {    
      String familyScope = (String) input.get('familyFilter');
      String startDateScope = (String) input.get('startDateFilter');
      String endDateScope = (String) input.get('endDateFilter');
      String facturaScope = (String) input.get('facturaFilter');
      // Este string esta para que no pinche, sacar y cambiar por inputmap y recorrerlo, setear si es Internet en el outmap el scope
      
      Map<String, String> node;
      Map<String, Object> jsonNode = new Map<String, Object>();
      
      //lista para que regrese una array en vez de un solo objeto
      List<Map<String, String>> nodeList = new List<Map<String, String>>();

        String [] arrayListConsumoFixed  = new List<String>();
        arrayListConsumoFixed.add('Llamadas locales');
        arrayListConsumoFixed.add('Llamadas larga distancia Nacional');
        arrayListConsumoFixed.add('Llamadas larga distancia Internacional');
        arrayListConsumoFixed.add('Terceros');
        arrayListConsumoFixed.add('SMS-0810');
        arrayListConsumoFixed.add('Calling Party Pays');


        String [] arrayListConsumoPrepago = new List<String>();
        arrayListConsumoPrepago.add('Llamadas de voz');
        arrayListConsumoPrepago.add('SMS');
        arrayListConsumoPrepago.add('MMS');
        arrayListConsumoPrepago.add('Datos');
        arrayListConsumoPrepago.add('Recarga SOS');
        arrayListConsumoPrepago.add('Recarga');
        arrayListConsumoPrepago.add('Tarifa recurrente');

        String [] arrayListConsumoPospago = new List<String>();
        arrayListConsumoPospago.add('Llamadas de voz');
        arrayListConsumoPospago.add('SMS');
        arrayListConsumoPospago.add('MMS');
        arrayListConsumoPospago.add('Datos');

        String [] arrayListConsumo = new List<String>();
        arrayListConsumo.add('Otro servicio 1');
        arrayListConsumo.add('Otro servicio 2');
        arrayListConsumo.add('Otro servicio 3');
        arrayListConsumo.add('Otro servicio 4');
        arrayListConsumo.add('Otro servicio 5');
        arrayListConsumo.add('Otro servicio 6');
        arrayListConsumo.add('Otro servicio 7');
        arrayListConsumo.add('Otro servicio 8');

        String [] arrayListServiceType = new List<String>();
        arrayListServiceType.add('Ilimitado');
        arrayListServiceType.add('Limitado');
        arrayListServiceType.add('Libre');

        String [] arrayListInvoceType = new List<String>();
        arrayListInvoceType.add('Facturado');
        arrayListInvoceType.add('No Facturado');

        String [] arrayListIO = new List<String>();
        arrayListIO.add('Entrante');
        arrayListIO.add('Saliente');
        arrayListIO.add('Saliente');
        arrayListIO.add('Saliente');
        arrayListIO.add('Entrante');


        String [] arrayListMobileOperator = new List<String>();
        arrayListMobileOperator.add('Movistar');
        arrayListMobileOperator.add('Personal');
        arrayListMobileOperator.add('Nextel');
        arrayListMobileOperator.add('Claro');

        String [] arrayListCountry = new List<String>();
        arrayListCountry.add('Argentina');
        arrayListCountry.add('Uruguay');

        String [] arrayListCost = new List<String>();
        arrayListCost.add('0');
        arrayListCost.add('2600');
        arrayListCost.add('27');

        String [] arrayListCodePlan= new List<String>();
        arrayListCodePlan.add('10371');
        arrayListCodePlan.add('20193');
        arrayListCodePlan.add('20192');
        arrayListCodePlan.add('13201');
        arrayListCodePlan.add('43123');
        arrayListCodePlan.add('41234');

        String [] arrayListProduct = new List<String>();
        arrayListProduct.add('Triple de Crédito');
        arrayListProduct.add('InternetXDia');
        arrayListProduct.add('Plan con Trajeta Repro.');
        arrayListProduct.add('Número gratis');
        arrayListProduct.add('Promoción Personal');
        arrayListProduct.add('Pack Internet x 30 dias');
       

        /*PFTA-6865*/
       	List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		Boolean isAgent=PROFILE[0].Name.contains('Venta');
       	
       	String [] arrayListDestinationNumber = new List<String>();
        for(Integer i = 0 ; i<20; i++){
            arrayListDestinationNumber.add('1554676'+ randomWithLimit(999999));
        }
      
      system.debug('familyScope: '+familyScope);
      system.debug('startDateScop: '+startDateScope);
      system.debug('endDateScope: '+endDateScope);
      system.debug('facturaScope: '+facturaScope);    
            
      if(familyScope == 'Internet')
      {
          if(String.isNotBlank(startDateScope) && String.isNotBlank(endDateScope))
          {
              for(Integer i = 0; i < 10; i++)
              {
                if(((system.today()-i) >= date.parse(startDateScope)) && (system.today()) <= date.parse(endDateScope))
                {
                  node = new Map<String, String>();
                  node.put('Family', 'Internet');
                  node.put('StartDate', ((system.today()-2).format()));
                  node.put('EndDate', (system.today()).format());
                  node.put('Usage', String.valueOf(randomWithLimit(999999)));
                  node.put('Cost', String.valueOf(randomWithLimit(999999)));
                  node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
                  node.put('IO', arrayListIO[randomWithLimit(4)]);

                  nodeList.add(node);
                }
              } 
          }
          else
          {
            if(String.isNotBlank(facturaScope))
            {
              for(Integer i = 0; i < 15 ; i++)
              {
                node = new Map<String, String>();
                node.put('Family', 'Internet');
                node.put('StartDate', ((system.today()-4).format()));
                node.put('EndDate', (system.today()).format());
                node.put('Usage', String.valueOf(randomWithLimit(999999)));
                node.put('Cost', String.valueOf(randomWithLimit(999999)));
                node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
                node.put('IO', arrayListIO[randomWithLimit(4)]);

                nodeList.add(node);
              }
            }
            else
            {
              for(Integer i = 0; i < 20; i++)
              {
                node = new Map<String, String>();
                node.put('Family', 'Internet');
                node.put('StartDate', ((system.today()-1).format()));
                node.put('EndDate', (system.today()).format());
                node.put('Usage', String.valueOf(randomWithLimit(999999)));
                node.put('Cost', String.valueOf(randomWithLimit(999999)));
                node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
                node.put('IO', arrayListIO[randomWithLimit(4)]);

                nodeList.add(node);
              }
            }
          }
      }

      if(familyScope == 'Prepaid' || familyScope == 'Movil')
      {

          for(Integer i = 0; i < 50; i++)
          {
            node = new Map<String, String>();
            String io=  arrayListIO[randomWithLimit(4)];
            String phone=  arrayListMobileOperator[randomWithLimit(3)];
            String tipo=  arrayListConsumoPrepago[randomWithLimit(7)];
              
              
            //https://vlocity.atlassian.net/browse/PFTA-7395
            //se simula con un random que puede llegar o no un sms tipo 'premium'
            //NOTA: Consideramos que un SMS es Premium cuando de la interfaz se obtiene: 
			//"descripcionTipoEvento" = "SMS" 
			//"subTipoServicio" = "SMS_PREMIUM"
            Integer randN = Math.round(Math.random()*10);
            boolean istPremium=false;
            if(randN<5){
               istPremium=true;
            }
            if(io=='Saliente' && (tipo=='Llamadas de voz' || tipo=='SMS') && isAgent){
                if(tipo=='SMS' && istPremium)
                	node.put('DestinationNumber','*'+arrayListDestinationNumber[randomWithLimit(19)]);
                else
                    node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)]));
            }
              
            else if (io=='Entrante' && tipo=='Llamadas de voz' && isAgent) {
                node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)])); 
           	}
            else{
                node.put('DestinationNumber',arrayListDestinationNumber[randomWithLimit(19)]); 
           	}
                
            node.put('Family', 'Prepaid');
            node.put('ConsumptionType', tipo);
            node.put('StartDate', '17/10/2017 14:30:03');
            node.put('EndDate', '17/10/2017 14:30:03');
            //node.put('Usage', String.valueOf(randomWithLimit(999999)));
            //node.put('DestinationNumber', arrayListDestinationNumber[randomWithLimit(19)]);
            //node.put('ServiceType', arrayListServiceType[randomWithLimit(2)]);
            node.put('Cost', String.valueOf(randomWithLimitNegative(999999)));
            //node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
            //node.put('Product', arrayListProduct[randomWithLimit(5)]);
            node.put('IO', io);
            node.put('AvailableCredit', String.valueOf(randomWithLimit(999999)));
            node.put('MobileOperator', arrayListMobileOperator[randomWithLimit(3)]);
            node.put('Description','Alguna descripción');
            //node.put('Country', arrayListCountry[randomWithLimit(1)]);
            //node.put('CodePlan', arrayListCodePlan[randomWithLimit(5)]);
			
              
              
              
             
            //https://vlocity.atlassian.net/browse/PFTA-7384
            String product=arrayListProduct[randomWithLimit(5)];
            node.put('Product', product);
              
              
            Integer hr=randomWithLimit(1);
            Integer mn=randomWithLimit(59);
            Integer sg=randomWithLimit(59);
            String times='';
            if(hr<10){
            	times='0'+hr+':';
            }
            else{
                times=hr+':';
            } 
            if(mn<10){
                times=times+'0'+mn+':';
            }
            else{
                times=times+mn+':';
            }
            if(sg<10){
                times=times+'0'+sg;
            }
            else{
                times=times+sg;
            }
            
            if(product=='Triple de Crédito'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		//node.put('Usage',randomWithLimit(1)+':'+randomWithLimit(59)+':'+randomWithLimit(59));
                    node.put('Usage',times);
                }
                else if(tipo=='Datos'){
                    node.put('Usage',randomWithLimit(1023)+' Kb');
                }
                else{
                    node.put('Usage',randomWithLimit(9)+'');
                }
            }
            else if(product=='InternetXDia'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		node.put('Usage','00:00:00');
                }
                else if(tipo=='Datos'){
                    node.put('Usage',randomWithLimit(1023)+' Kb');
                }
                else{
                    node.put('Usage',0+'');
                }
            }
            else if(product=='Plan con Trajeta Repro.'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		//node.put('Usage',randomWithLimit(1)+':'+randomWithLimit(59)+':'+randomWithLimit(59));
                    node.put('Usage',times);
                }
                else if(tipo=='Datos'){
                    node.put('Usage',0+' Kb');
                }
                else{
                    node.put('Usage',randomWithLimit(9)+'');
                }
            }
            else if(product=='Número gratis'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		//node.put('Usage',randomWithLimit(1)+':'+randomWithLimit(59)+':'+randomWithLimit(59));
                    node.put('Usage',times);
                }
                else if(tipo=='Datos'){
                    node.put('Usage',0+' Kb');
                }
                else{
                    node.put('Usage',randomWithLimit(9)+'');
                }
            }
            else if(product=='Promoción Personal'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		//node.put('Usage',randomWithLimit(1)+':'+randomWithLimit(59)+':'+randomWithLimit(59));
                    node.put('Usage',times);
                }
                else if(tipo=='Datos'){
                    node.put('Usage',0+' Kb');
                }
                else{
                    node.put('Usage',randomWithLimit(9)+'');
                }
            }
            else if(product=='Pack Internet x 30 dias'){
                if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            		node.put('Usage','00:00:00');
                }
                else if(tipo=='Datos'){
                    node.put('Usage',randomWithLimit(1023)+' Kb');
                }
                else{
                    node.put('Usage',0+'');
                }
            }  
              
              
              
            
                
            nodeList.add(node);
          }
      }
      if(familyScope == 'Fixed')
      {
            for(Integer i = 0; i < 25; i++)
            {
              node = new Map<String, String>();
                
              String io=  arrayListIO[randomWithLimit(4)];
              String phone=  arrayListMobileOperator[randomWithLimit(3)];
              String tipo=  arrayListConsumoPrepago[randomWithLimit(7)];
                  
              if(io=='Saliente' && (tipo=='Llamadas de voz' || tipo=='SMS') && isAgent){
                  node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)])); 
              }
              else if (io=='Entrante' && tipo=='Llamadas de voz' && isAgent) {
                  node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)])); 
              }
              else{
                  node.put('DestinationNumber',arrayListDestinationNumber[randomWithLimit(19)]); 
              }
                
              node.put('Family', 'Fixed');
              node.put('ConsumptionType', tipo);
              node.put('StartDate', ((system.today()-i).format()));
              node.put('EndDate', system.today().format());
             // node.put('DestinationNumber', arrayListDestinationNumber[randomWithLimit(19)]);
              node.put('TimeZone', 'ARG');
              node.put('ServiceType', arrayListServiceType[randomWithLimit(2)]);
              node.put('Cost', String.valueOf(randomWithLimitNegative(999999))+'.'+String.valueOf(randomWithLimit(99)));
              node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
              node.put('Product', arrayListProduct[randomWithLimit(5)]);
              node.put('IO', io);
              node.put('AvailableCredit', String.valueOf(randomWithLimit(999999)));
              node.put('MobileOperator', arrayListMobileOperator[randomWithLimit(3)]);
              node.put('Country', arrayListCountry[randomWithLimit(1)]);
              node.put('CodePlan', arrayListCodePlan[randomWithLimit(5)]);
                
              if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
                  
                  Integer hr=randomWithLimit(1);
                  Integer mn=randomWithLimit(59);
                  Integer sg=randomWithLimit(59);
                  String times='';
                  if(hr<10){
                      times='0'+hr+':';
                  }
                  else{
                      times=hr+':';
                  } 
                  
                  if(mn<10){
                      times=times+'0'+mn+':';
                  }
                  else{
                      times=times+mn+':';
                  }
                  if(sg<10){
                      times=times+'0'+sg;
                  }
                  else{
                      times=times+sg;
                  }
                  
            	  node.put('Usage',times);
                  
           	  }
              else if(tipo=='Datos'){
                   node.put('Usage',randomWithLimit(1023)+' Kb');
              }
              else{
                  node.put('Usage',randomWithLimit(9)+'');
              }

              nodeList.add(node);
            } 
       }


       if(familyScope == 'Pospaid')
      {
            for(Integer i = 0; i < 25; i++)
            {
              node = new Map<String, String>();
                
              String io=  arrayListIO[randomWithLimit(4)];
              String phone=  arrayListMobileOperator[randomWithLimit(3)];
              String tipo=  arrayListConsumoPospago[randomWithLimit(7)];
                  
              if(io=='Saliente' && (tipo=='Llamadas de voz' || tipo=='SMS') && isAgent){
                  node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)])); 
              }
              else if (io=='Entrante' && (tipo=='Llamadas de voz') && isAgent) {
                  node.put('DestinationNumber',phoneMask( arrayListDestinationNumber[randomWithLimit(19)])); 
              }
              else{
                  node.put('DestinationNumber',arrayListDestinationNumber[randomWithLimit(19)]); 
              }
                
              node.put('Family', 'Pospaid');
              node.put('ConsumptionType', tipo);
              node.put('StartDate', ((system.today()-i).format()));
              node.put('EndDate', system.today().format());
              //node.put('Usage', String.valueOf(randomWithLimit(999999)));
              //node.put('DestinationNumber', arrayListDestinationNumber[randomWithLimit(19)]);
              node.put('TimeZone', 'ARG');
              node.put('ServiceType', arrayListServiceType[randomWithLimit(2)]);
              node.put('Cost', String.valueOf(randomWithLimit(999999)));
              node.put('InvoceType', arrayListInvoceType[randomWithLimit(1)]);
              node.put('Product', arrayListProduct[randomWithLimit(5)]);
              node.put('IO', io);
              node.put('AvailableCredit', String.valueOf(randomWithLimit(999999)));
              node.put('MobileOperator', arrayListMobileOperator[randomWithLimit(3)]);
              node.put('Country', arrayListCountry[randomWithLimit(1)]);
              node.put('CodePlan', arrayListCodePlan[randomWithLimit(5)]);
              
              if(tipo=='Llamadas de voz' || tipo=='Tarifa recurrente'){
            	  node.put('Usage',randomWithLimit(1)+':'+randomWithLimit(59)+':'+randomWithLimit(59));
           	  }
              else if(tipo=='Datos'){
                   node.put('Usage',randomWithLimit(1023)+' Kb');
              }
              else{
                  node.put('Usage',randomWithLimit(9)+'');
              }
                
              nodeList.add(node);
            } 
       }


     outMap.put('Result',nodeList);

   }

   static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }
    
    static Integer randomWithLimitNegative(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        Integer randN = Math.round(Math.random()*10);
        //system.debug('randN: '+randN);
        if(randN<5){
            return Math.mod(rand, upperLimit);
        }
        else{
            return (Math.mod(rand, upperLimit)) * (-1);
        }
    }
    
    /*PFTA-6865*/
    static String phoneMask(String phoneNumber){
       if(phoneNumber.length()>=4){
        String part1=phoneNumber.substring(0,phoneNumber.length()-3);
        String part2=phoneNumber.substring(phoneNumber.length()-3,phoneNumber.length());
        if(part1.length()>=4){
            String part1_1=part1.substring(0,part1.length()-3);
            return part1_1+'XXX'+part2;
        }
        else{
            return 'XXX'+part2;
        }
	   }
       else{
           return phoneNumber;    
       }
	}

}