({
	//FUNCION QUE BLOQUEA EL BOTON DE BACK DEL EXPLORADOR
		blockButton : function() {
			history.pushState(null, null, location.href);
			window.onpopstate = function () {
				history.go(1);
			}
		}
	
})