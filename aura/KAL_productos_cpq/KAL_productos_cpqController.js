({
    doInit: function (component, event, helper) {
        helper.conseguirCarrito(component, false);
        helper.blockButton();
        var IdPBE = helper.getParameter();
        component.set("v.IdPBE", IdPBE);

        helper.changeURL();
        helper.crearObtenerOrden(component);
    },

    /*volverAInternaDeProducto: function (component, event, helper) {
        var elId = component.get("v.idUltimoEliminado");
        var laUrl = 'https://mocks-mockfan.cs59.force.com/vtexMock/s/kal-vtexmock';
        if(elId) {
            laUrl = 'https://mocks-mockfan.cs59.force.com/vtexMock/s/intProd' + elId;
        }
        window.location.href = laUrl;
    },*/

    volverATiendaPersonal: function (component, event, helper) {
        window.location.href = 'https://mocks-mockfan.cs59.force.com/vtexMock/s/kal-vtexmock';
    },

    //Agregado por Pablo - Inicio
    completarCompra: function (component, event, helper) {
        window.location.href = '/clientes/s/checkout';
    },

    setButtonDisable: function (component, event, helper) {
        var booleano = true;
        component.set("v.disableConfirmar", booleano);
    },

    cambiarBooleano: function (component, event, helper) {
        var booleano = true;
        if (component.get("v.items.length") > 0) {
            booleano = false;
        }
        component.set("v.disableConfirmar", booleano);
    },
    //Agregado por Pablo - Fin

    eliminarProducto: function (component, event, helper) {
        var ctarget = event.currentTarget;
        var idPBE = ctarget.dataset.value;

        var listaItems = component.get("v.items");
        var index = listaItems.map( function(e) {return e.IdPBE;} ).indexOf(idPBE);
        var currentItem = listaItems[index];

        var actualFlagValue = currentItem.flagDeshacer;
        
        currentItem.flagDeshacer = true;

        component.set("v.items", listaItems);

        var action = component.get("c.eliminarDeCarrito");
        action.setParams({
            IdItem: idPBE
        });
        action.setCallback(this, function (response) {
            if(response.getState() != 'SUCCESS') {
                helper.conseguirCarrito(component);
            }
            //Comentado ya que ahora se actualiza el resumen en el método 'efectuarEliminar'
            //helper.conseguirCarrito(component);//Actualiza desde la base
            //helper.conseguirCarritoDespuesDeEliminar(component);//Actualiza desde la vista

        });

        var delayInMilliseconds = 5000; //5 seconds

        window.setTimeOutFunction = setTimeout(
            helper.efectuarEliminar.bind(null, component, action, idPBE),
            delayInMilliseconds
        );
        

    },

    handleDeshacer : function (component, event, helper){
        //Este método setea en false el flagDeshacer del item correspondiente a la iteración en curso
        //y actualiza la lista de items en la parte visual
        clearTimeout(window.setTimeOutFunction);
        var ctarget = event.currentTarget;
        var idPBE = ctarget.dataset.value;

        var listaItems = component.get("v.items");
        var index = listaItems.map( function(e) {return e.IdPBE;} ).indexOf(idPBE);
        var currentItem = listaItems[index];

        var actualFlagValue = currentItem.flagDeshacer;
        
        currentItem.flagDeshacer = false;

        component.set("v.items", listaItems);
    },

    // this function automatic call by aura:waiting event  
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
    },

    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    // Inicio Kal-93
    subCantidad : function(component, event, helper) {
        
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        
        var items = component.get('v.items');
        var total = component.get('v.total');
        var subtotal = component.get('v.subtotal');
        for(var i=0; i<items.length; i++){
            if(items[i].IdItem == id_str){
                var cantidad = parseInt(items[i].Cant);
                cantidad--;
                var precio = parseInt(items[i].Price);
                var totalPrice = cantidad * precio;
                items[i].Cant = cantidad; 
                items[i].TotalPrice = totalPrice;

                total = total - precio;
                subtotal = subtotal - precio;
            }    
        }
        component.set('v.items', items);
        component.set('v.total', total);
        component.set('v.subtotal', subtotal);
        
        var action = component.get("c.restarCantidad");
        action.setParams({
            IdItem : id_str
        });
        action.setCallback(this, function(response) {
            console.log('Cantidad modificada: ' + response.getState());
        });
        $A.enqueueAction(action);
        
    },

    addCantidad : function(component, event, helper) {              
        
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        
        var items = component.get('v.items');
        var total = component.get('v.total');
        var subtotal = component.get('v.subtotal');
        for(var i=0; i<items.length; i++){
            if(items[i].IdItem == id_str){
                var cantidad = parseInt(items[i].Cant);

                if(cantidad <= 98){
                    cantidad++;
                    var precio = parseInt(items[i].Price);
                    var totalPrice = cantidad * precio;
                    items[i].Cant = cantidad; 
                    items[i].TotalPrice = totalPrice;

                    total += precio;
                    subtotal += precio;
                }else{
                    document.getElementById('botonCantidad').disabled=true;                   
                }
            }    
        }
        component.set('v.items', items);
        component.set('v.total', total);
        component.set('v.subtotal', subtotal);
        
        var action = component.get("c.sumarCantidad");
        action.setParams({
            IdItem : id_str
        });
        action.setCallback(this, function(response) {
            console.log('Cantidad modificada: ' + response.getState());
        });
        $A.enqueueAction(action);

    },
    //Fin Kal-93
})