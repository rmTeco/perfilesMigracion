({
    fireEntregaEvent: function (component, event, helper) {
        var picklistValue = component.find("picklistId").get("v.value");
        component.set("v.picklistValue", picklistValue);
        var dameValor = component.get("v.picklistValue");
        var myEvent = $A.get("e.c:KAL_datos_entregaEvent");
        if (dameValor == 'sucursal') {
            myEvent.setParams({ "tipoEntrega": "Sucursal" });
            myEvent.setParams({ "precioEntrega": "0,00" });
        } else {
            myEvent.setParams({ "tipoEntrega": "Standard" });
            myEvent.setParams({ "precioEntrega": "0,00" });
        }
        myEvent.fire();
    },

    handleClick: function (component, event, helper) {
        var valorBoolean = component.get("v.soyBoolean");
        var nuevoBoolean = !valorBoolean;
        component.set("v.soyBoolean", nuevoBoolean);

    },

    doInit: function (component, event, helper) {
        var action = component.get("c.getUserComunidad");
        action.setCallback(this, function (data) {
            if (data.getReturnValue() != null) {
                var direccionCompleta = helper.armarStringDireccion(data.getReturnValue());
                component.set("v.dirCompleta", direccionCompleta);
                component.set("v.userInfo", data.getReturnValue());
                var retorno = data.getReturnValue();
                if (retorno.MobilePhone != '') {
                    component.set("v.mobilePhone", retorno.MobilePhone);
                }
                if (retorno.Email != null) {
                    component.set("v.Email", retorno.Email);
                }
            }
        });

        $A.enqueueAction(action);
        console.log(action);
        helper.conseguirDominios(component, event, helper);

        // var envio = component.get("c.agregarProductoEnvio");
        // envio.setCallback(this, function(data){
        //     console.log("entra");
        //     var state = data.getState();
        //     if (state == "SUCCESS") {
        //         alert('Mensaje: ');           
        //     } else if(data.getState() === 'ERROR') {
        //             if(data.getError()[0].message) {
        //                 alert('Error: ' + data.getError()[0].message);
        //             }
        //         }
        // });
        // $A.enqueueAction(envio)
    },

    getTipoDocumento: function (component, event, helper) {
        var action = component.get("c.getDocumentTypes");

        action.setCallback(this, function (data) {
            var tipoDocumento = data.getReturnValue();
            component.set("v.tipoDocumento", tipoDocumento);

        });

        $A.enqueueAction(action);
    },

    updateDatosAutorizado: function (component, event, helper) {
        var action = component.get("c.updateDatosAutorizado");
        var DocumentNumber = component.get("v.nroDocumento").trim();
        var DocumentType = component.get("v.idTipoDocumento").trim();
        var FirstName = component.get("v.nombre").trim();
        var LastName = component.get("v.apellido").trim();
        var datosUser = "({DocumentNumber=" + DocumentNumber + ", " +
            "DocumentType=" + DocumentType + ", " +
            "FirstName=" + FirstName + ", " +
            "LastName=" + LastName + "})";

        action.setParams({
            param: datosUser
        });
        action.setCallback(this, function (response) {
            if (response.getState() === 'ERROR') {
                if (response.getError()[0].message) {
                    alert('Error: ' + response.getError()[0].message);
                }
            }
        })
        $A.enqueueAction(action);
    },

    /* Metodo para validar expresion regular */

    validarNroDocumento: function (component, event, helper) {

        var validarDoc = true;
        var nroDoc = component.find("nroDocumentoID");
        var nroDocValue = nroDoc.get("v.value");
        var expression = /^[^0]\d{6,7}$/;

        if (nroDocValue == undefined || nroDocValue == "") {
            return validarDoc;
        }

        if (!nroDocValue.match(expression)) {
            validarDoc = false;
        }
        return validarDoc;
    },

    validateEmail: function (component, event, helper) {
        var isValidEmail = false;
        var emailField = component.find("emailId");
        var emailFieldValue = component.get("v.Email");
        // Expresiones Regulares
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        // Verifica si Email no esta VACIO
        // Y si el Email es valido entonce el error es Null y Remueve la clase CSS
        // ELSE, SI el EMAIL es invalido llama a la clase CSS
        // Y muestra un mensaje de error en el input
        // Y la variable 'isValidEmail' Toma valor FALSE Y no permite continuar
        if (!$A.util.isEmpty(emailFieldValue)) {
            if (emailFieldValue.match(regExpEmailformat)) {
                emailField.set("v.errors", null);
                //$A.util.removeClass(emailField, 'slds-has-error');
                isValidEmail = true;
            }
            else {
                //$A.util.addClass(emailField, 'slds-has-error');
                emailField.set("v.errors", [{ message: "Por favor, ingrese un EMAIL valido" }]);
            }

        }
        else {
            emailField.set("v.errors", [{ message: "Por favor, ingrese un EMAIL, el campo no puede estar Vacio" }]);

        }
        //Si la direccion de Email es valida entonces se ejecuta el codigo 
        //component.set("v.ValidacionEmail", isValidEmail);
        return isValidEmail;
    },

    validatePhone: function(component, event, helper){
        var isValidPhone = false;
        var phoneField = component.find("mobilePhone");
        var phoneFieldValue = component.get("v.mobilePhone");
        // Expresiones Regulares
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        
        if (!$A.util.isEmpty(phoneFieldValue)) {
            if(phoneFieldValue.length == 10){
                phoneField.set("v.errors", null);            
                isValidPhone = true;
            }else{
                phoneField.set("v.errors", [{ message: "Por favor, ingrese un número de teléfono válido" }]);   
            }                                               
        } 
        else {        
            phoneField.set("v.errors", [{ message: "Por favor, ingrese un número de teléfono" }]);
        }
        return isValidPhone;
    },

    getPlazosEntregaJS: function (component, event, helper) {
        var action = component.get("c.getPlazosEntrega");

        action.setCallback(this, function (data) {
            var result = data.getReturnValue();
            var jsonString = result.matrizEnvio;
            var varStandardInicioAM = "";
            var varStandardFinAM = "";
            var varStandardInicioCP = "";
            var varStandardFinCP = "";

            var varRetiroInicioAM = "";
            var varRetiroFinAM = "";
            var varRetiroInicioCP = "";
            var varRetiroFinCP = "";

            for (var i = 0; i < jsonString.length; i++) {

                if (jsonString[i].in) {
                    if (jsonString[i].in.ShippingMode == 'Retiro' && jsonString[i].in.DistributionZone == 'AMBA') {

                        varRetiroInicioAM = jsonString[i].out.MinimumShippingDays;
                        component.set("v.RetiroInicioAM", varRetiroInicioAM);
                        varRetiroFinAM = jsonString[i].out.ShippingDays;
                        component.set("v.RetiroFinAM", varRetiroFinAM);
                    }
                    if (jsonString[i].in.ShippingMode == 'Retiro' && jsonString[i].in.DistributionZone == 'CIUDADES PRINCIPALES') {

                        varRetiroInicioCP = jsonString[i].out.MinimumShippingDays;
                        component.set("v.RetiroInicioCP", varRetiroInicioCP);
                        varRetiroFinCP = jsonString[i].out.ShippingDays;
                        component.set("v.RetiroFinCP", varRetiroFinCP);
                    }
                    if (jsonString[i].in.ShippingMode == 'Standard' && jsonString[i].in.DistributionZone == 'AMBA') {

                        varStandardInicioAM = jsonString[i].out.MinimumShippingDays;
                        component.set("v.StandardInicioAM", varStandardInicioAM);
                        varStandardFinAM = jsonString[i].out.ShippingDays;
                        component.set("v.StandardFinAM", varStandardFinAM);
                    }
                    if (jsonString[i].in.ShippingMode == 'Standard' && jsonString[i].in.DistributionZone == 'CIUDADES PRINCIPALES') {

                        varStandardInicioCP = jsonString[i].out.MinimumShippingDays;
                        component.set("v.StandardInicioCP", varStandardInicioCP);
                        varStandardFinCP = jsonString[i].out.ShippingDays;
                        component.set("v.StandardFinCP", varStandardFinCP);
                    }
                }
            }





        });

        $A.enqueueAction(action);
    },

    // autocompleteInput: function(component, event, helper) {
    //     helper.autocompletarInput(component);
    // },

    updateValue: function (component, event, helper) {
        var valorDeVerdadActual = component.get("v.valorCheckboxADomicilio");
        var nuevoValodDeVerdadActual = !valorDeVerdadActual;
        //var valorDeVerdadActual = event.currentTarget.dataset.value;
        component.set("v.valorCheckboxADomicilio", nuevoValodDeVerdadActual);
    },


})