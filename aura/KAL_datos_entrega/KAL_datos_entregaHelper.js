({
    armarStringDireccion : function(data) {
        var dirCompleta = data.Calle;
        if(data.Numero) {
            dirCompleta += ' ' + ' ' +  data.Numero;
        }
        if(data.CodigoPostal) {
            dirCompleta += ', CP' + ' ' + data.CodigoPostal;
         }
        if(data.Piso) {
            dirCompleta += ', ' + ' ' + data.Piso;
        }
        if(data.Provincia) {
            dirCompleta += ', ' + ' ' + data.Provincia;
        }
        if(data.Localidad) {
            dirCompleta += ', ' + ' ' + data.Localidad;
        }
        
        return dirCompleta;
    },
    
    autocompletarInput: function(component) {
        var input = document.getElementById('emailId');
        var options = component.get('v.dominios');
        window.autocomplete(input, options, component);
    },

    conseguirDominios: function(component) {
        var action = component.get("c.APEXconseguirDominios");
        action.setCallback(this, function(response) {
            console.log('Entre a conseguir dominio');
            if(response.getState() === 'SUCCESS') {
                component.set("v.dominios", response.getReturnValue());
                this.autocompletarInput(component);
            }
        });
        $A.enqueueAction(action);
    }
})