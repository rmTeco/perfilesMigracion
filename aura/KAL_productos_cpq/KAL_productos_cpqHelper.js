({
	getParameter : function() {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            
            if (sParameterName[0] === 'id') { //lets say you are looking for param name - id
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        return sParameterName[1];
	},
    
	blockButton : function() {
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        }
    },
    
    removeParam : function (key, sourceURL) {
        var rtn = sourceURL.split("?")[0],
            param,
            params_arr = [],
            queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
        if (queryString !== "") {
            params_arr = queryString.split("&");
            for (var i = params_arr.length - 1; i >= 0; i -= 1) {
                param = params_arr[i].split("=")[0];
                if (param === key) {
                    params_arr.splice(i, 1);
                }
            }
            rtn = rtn + "?" + params_arr.join("&");
        }
        return rtn;
    },
    
    changeURL : function(event) {
        var originalURL = location.href;
        var newURL = this.removeParam('id', originalURL);
        if(originalURL != newURL) {
            window.history.pushState(
                "",
                "",
                newURL
			);
        }
    },

    crearObtenerOrden : function(component) {
        var action = component.get("{!c.crearOrdenParaCarrito}");
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                component.set("v.datosOrden", response.getReturnValue());
                //Ahora que tengo la orden agrego el item.
                this.agregarProducto(component);
                console.log( component.get("v.datosOrden") );
            } else {
                if(response.getError()) {
                    console.warn(response.getError());
                }
            }
            // Consigo el carrito
            this.conseguirCarrito(component, true);
        });
        $A.enqueueAction(action);
    },
    
    conseguirCarrito : function(component, detenerSpinner){
        var action = component.get("c.conseguirCarrito");
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
                var jsonString = response.getReturnValue();
                component.set("v.items", jsonString.Productos);
                component.set("v.subtotal", jsonString.Subtotal);
                component.set("v.total", jsonString.Subtotal);
            } else {
                if(response.getError()) {
                    console.warn('Error: ' + response.getError());
                }
            }
            if(detenerSpinner) 
                component.set("v.Spinner", false);
        });
        $A.enqueueAction(action);
        //KAL-113 - Prueba
        var itemsList = component.get("v.items");
        var tam = itemsList.length;
        var booleanList = [];
        var i = 0;
        for(i; i < tam; i++){
            booleanList.push(false);
        }
        component.set("v.flagValuesList", booleanList);
        console.log(booleanList);
    },

    agregarProducto : function(component){
        var IdPBE = component.get("v.IdPBE");
        if(IdPBE) {
            var action = component.get("c.agregarUnProducto");
            action.setParams({
                PriceBookId : IdPBE
            });
            action.setCallback(this, function(response) {
                if(response.getState() === 'ERROR') {
                    if(response.getError()[0].message) {
                        console.warn('Error: ' + response.getError()[0].message);
                    }
                }
            })
            $A.enqueueAction(action);
        }
    },

    efectuarEliminar : function(component, action, idPBE){
        var itemsList = component.get("v.items");
        // Consigo el indice del idPBE que voy a eliminar
        var index = itemsList.map( function(e) {return e.IdPBE;} ).indexOf(idPBE);
        var itemActual = itemsList[index];

        var flagQuitar = itemActual.flagDeshacer;
        if(flagQuitar){
            $A.enqueueAction(action);
            itemsList.splice(index, 1);
            component.set("v.items", itemsList);
            console.log('Eliminé :' + itemActual + ' indice ' + index);
            //Una vez que se elimina el item de la parte visual, actualizo el resumen de compra
            //con la lista actualizada (la del lado del cliente, no la del servidor).
            var clientSideItems = component.get("v.items");
            var subtotal = 0;
            var total = 0;
            var i = 0;
            for(i; i < clientSideItems.length; i++){
                var itemIterado = clientSideItems[i];
                subtotal += itemIterado.TotalPrice;
                total += itemIterado.TotalPrice;
            }
            component.set("v.subtotal", subtotal);
            component.set("v.total", total);
        }
    },

    /*Lo que realiza este método ahora se hace en 'efectuarEliminar' ya que 
      actualiza el resumen de compra más rápidamente
    conseguirCarritoDespuesDeEliminar : function(component){
        var clientSideItems = component.get("v.items");
        var subtotal = 0;
        var total = 0;
        var i = 0;
        for(i; i < clientSideItems.length; i++){
            var itemIterado = clientSideItems[i];
            subtotal += itemIterado.TotalPrice;
            total += itemIterado.TotalPrice;
        }
        component.set("v.subtotal", subtotal);
        component.set("v.total", total);
    }*/
})