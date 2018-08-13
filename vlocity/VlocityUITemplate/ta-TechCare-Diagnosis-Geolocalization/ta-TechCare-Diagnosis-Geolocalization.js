vlocity
	.cardframework
	.registerModule
	.controller('geoMapsCtrl', geoMapsCtrl);

geoMapsCtrl.$inject = ['$scope', '$timeout'];

function geoMapsCtrl($scope, $timeout) {

	var GMCtrl = this;
	var $mapEl;
	var map;
	var _mapInitialized = false;

	GMCtrl.response = {};
	GMCtrl.mockData = {};
	GMCtrl.initMap = initMap;
	GMCtrl.userPosition = {};	

	$scope.bpTree.response.mapInitialized = _mapInitialized;

	GMCtrl.init = function() {
		$scope.$watch("bpTree.response.Address", function (newValue, oldValue) {
			// console.info('newValue: ', newValue, 'oldValue: ', oldValue);
			_mapInitialized = false;
			GMCtrl.initMap();
			google.maps.event.trigger(map, 'resize');
		}, true);
		GMCtrl.initMap();			
	}

	function initMap() {
		if (!_mapInitialized && !$('#busSearchMap').is(':visible')) {
			$timeout(initMap, 300);
			return;
		}
		GMCtrl.mockData = $scope.bpTree.response.Antennas;
		_mapInitialized = true;
		$scope.bpTree.response.mapInitialized = _mapInitialized;
		GMCtrl.response = $scope.bpTree.response.Address;
		GMCtrl.userPosition.lat = $scope.bpTree.response.Address.lat;
		GMCtrl.userPosition.lng = $scope.bpTree.response.Address.lng;		
		setMap(GMCtrl.userPosition, 16);	
	}

	function setMap(coordinates, zoom) {	
		position = new google.maps.LatLng(coordinates.lat, coordinates.lng);	
		$mapEl = $('#busSearchMap');
		map = new google.maps.Map($mapEl[0],
			{
				center: position, 
				zoom: zoom,
				minZoom: 10, 
				maxZoom: 18,
				streetViewControl: false,
				zoomControl: true,
				fullscreenControl: true,
				mapTypeControl: true,
				mapTypeControlOptions: {
					style: google.maps.MapTypeControlStyle.DROPDOWN_MENU,
					position: google.maps.ControlPosition.TOP_LEFT,
					mapTypeIds: ['roadmap', 'terrain']
				}
			}
		);		
		
		addMarker(coordinates);
		addCircles();
	}

	function addMarker(coordinates) {
		var marker = new google.maps.Marker({
			position: coordinates,
			title:"Ubicacioón del cliente"
		});
		
		// To add the marker to the map, call setMap();
		marker.setMap(map);		
	}

	function addCircles() {
		var infowindow = new google.maps.InfoWindow();
		for (var i=0; i < GMCtrl.mockData.length; i++) {
			// console.info('antena: ', GMCtrl.mockData[i]);
			var radioColor = GMCtrl.mockData[i].status == "Operativo" ? "#00ff00" : '#FF0000';
			var cityCircle = new google.maps.Circle({
				strokeColor: radioColor,
				strokeOpacity: 0.8,
				strokeWeight: 2,
				fillColor: radioColor,
				fillOpacity: 0.35,
				map: map,
				center: GMCtrl.mockData[i].coordinates,
				radius: GMCtrl.mockData[i].coverage
			});		
			createClickableCircle(
				map, 
				cityCircle, 
				GMCtrl.mockData[i].name, 
				GMCtrl.mockData[i].technology,
				GMCtrl.mockData[i].status,
				GMCtrl.mockData[i].massiveIncident);
		}	
	}
	function createClickableCircle(map, circle, infoName, infoTech, infoStatus, infoMassiveInc) {
			
		var infowindow = new google.maps.InfoWindow({
			content: 
				'<div>Nombre: <strong>' + infoName + '</strong><br>' +
					'Technología: <strong>' + infoTech + '</strong><br>' +
					'Estado: <strong>' + infoStatus + '</strong><br>' +
					(infoMassiveInc !== '' ? 'Incidente: <strong>' + infoMassiveInc + '</strong><br>' : '') + 
				'</div>'
		});  
		google.maps.event.addListener(circle, 'click', function(ev) {
			// alert(infowindow.content);
			infowindow.setPosition(circle.getCenter());
			infowindow.open(map);
		});
	}
}