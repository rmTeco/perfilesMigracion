({

    obtenerBancos : function(component, event, helper) {
        console.log('obtenerBancos entre3');

        var action = component.get("c.conseguirPromocionesFinancieras");
        action.setCallback(this, function(response) {
            

            if(response.getState() === 'SUCCESS') {
                var jsonPuro = response.getReturnValue();
                var jsonString = JSON.parse(response.getReturnValue());
                
                console.log(jsonString);
				//scx
                var bancos = [];
                var listaDeBancos = [];
                console.log(jsonString['options'].length);

                for (var i = 0; i < jsonString['options'].length; i++) {
                    
                    if(!listaDeBancos.includes(jsonString['options'][i]['BankEntities__c'])){
                        listaDeBancos.push(jsonString['options'][i]['BankEntities__c']);
                    }

                 }

                 for (var i = 0; i < listaDeBancos.length; i++) {                
                    bancos.push({
                        "label": listaDeBancos[i],
                        "value": listaDeBancos[i],
                    });
                }

                component.set("v.OpcionesBancos", bancos);
                component.set("v.ListDeBancosTarjetaDocumento", jsonPuro);
            } else {
                console.log('fail');
                if(response.getError()) {
                    alert('Error: ' + response.getError());
                } 
            }
        })

        $A.enqueueAction(action);
    },
    
    seleccionoUnBancoYMuestroLasTarjetas: function (component, event, helper) {
        
        console.log('SELECCIONOUNBANCOYMUESTROLASTARJETAS');

        var bancoSeleccionado = event.getParam("value");
        var jsonBancoTarjetaCuota = JSON.parse(component.get("v.ListDeBancosTarjetaDocumento"));
        
        console.log(jsonBancoTarjetaCuota);
        
        var listaDeTarjetas = [];
        for (var i = 0; i < jsonBancoTarjetaCuota['options'].length; i++) {
           if(jsonBancoTarjetaCuota['options'][i]['BankEntities__c'] == bancoSeleccionado &&
              !listaDeTarjetas.includes(jsonBancoTarjetaCuota['options'][i]['CreditCards__c'])){
                listaDeTarjetas.push(jsonBancoTarjetaCuota['options'][i]['CreditCards__c']);
              }
        }

        console.log(listaDeTarjetas);

        var tarjetas = [];
        for (var i = 0; i < listaDeTarjetas.length; i++) {                
            tarjetas.push({
                "label": listaDeTarjetas[i],
                "value": listaDeTarjetas[i],
            });
        }
        

        component.set("v.OpcionesTarjetas", tarjetas);
    },
    
    seleccionoUnaTarjetaYMuestroLasCuotas: function (component, event, helper) {
        
        console.log('SELECCIONOUNATARJETAYMUESTROLASCUOTAS');

        var tarjetaSeleccionada = event.getParam("value");
        var bancoSeleccionado = component.find("bancoSeleccionado").get("v.value");
        var jsonBancoTarjetaCuota = JSON.parse(component.get("v.ListDeBancosTarjetaDocumento"));
        console.log(bancoSeleccionado);
        console.log(jsonBancoTarjetaCuota);
        
        
        var listaDeCuotas = [];
        for (var i = 0; i < jsonBancoTarjetaCuota['options'].length; i++) {
           if(jsonBancoTarjetaCuota['options'][i]['BankEntities__c'] == bancoSeleccionado &&
              jsonBancoTarjetaCuota['options'][i]['CreditCards__c'] == tarjetaSeleccionada){
                
                var valor = jsonBancoTarjetaCuota['Monto']/jsonBancoTarjetaCuota['options'][i]['Instalment__c'];
                console.log(valor);
                listaDeCuotas.push({
                    "label": 'En '+jsonBancoTarjetaCuota['options'][i]['Instalment__c']+' cuotas fijas de $'+valor.toFixed(2),
                    "value": '{"cuotas": "'+jsonBancoTarjetaCuota['options'][i]['Instalment__c']+'", "valorDeCadaCuota": "'+valor.toFixed(2)+'" }',
                });
            }
        }

        console.log(listaDeCuotas);
        

        component.set("v.OpcionesCoutas", listaDeCuotas);
    },
    
        

	obtenerTerms : function(component, event, helper){
	    var action = component.get("c.getTerminosycondiciones");
	    action.setCallback(this, function(response) {
            var laUrl = response.getReturnValue();
            component.set('v.urlTerms', laUrl);
        })

        $A.enqueueAction(action);
	},

    redirigirConfirmacion : function(component, event, helper) {
        window.location.href = 'https://desa01-desa01.cs63.force.com/clientes/s/confirmacion';
	},

    handleChangeCuota : function(component, event, helper){
        
        var selectedVal=JSON.parse(event.getParam("value"));        
        var cuotas = selectedVal['cuotas'];
        var valorDeCadaCuota = selectedVal['valorDeCadaCuota'];
        console.log('valor cuota'+cuotas);
        console.log('valor de cada cuota'+valorDeCadaCuota);
        //var compResumen = component.find('resumen'); 
        var parentComp=  component.getConcreteComponent('kal_confirmation');

        console.log('super'+parentComp);
        var myEvent = $A.get("e.c:KAL_datos_entregaEvent");
        myEvent.setParams({"cuotas": cuotas});
        myEvent.setParams({"precio": valorDeCadaCuota});
        myEvent.fire();        
    }
    
    /*Se modificó la historia, ya no hace falta aceptar términos y condiciones, por lo cual
    no hay más checkbox;
    clickCheckbox : function(component, event, helper){
        component.set("v.valorCheckbox", document.getElementById("checkbox-6").checked );
        var valorFlagValidacion = false;
        component.set("v.flagValidacion", valorFlagValidacion);
    }*/

})