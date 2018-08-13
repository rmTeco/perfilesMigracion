vlocity.cardframework.registerModule
    .filter('rounddown', function () {
        return function (value, mult, dir) {
            dir = dir || 'nearest';
            mult = mult || 1;
            value = !value ? 0 : Number(value);
            return Math.floor(value / mult) * mult;
        };
    });
    
vlocity.cardframework.registerModule
	.controller('AvailablesModuleCtrl', AvailablesModuleCtrl);

    AvailablesModuleCtrl.$inject = ['$scope'];

    function AvailablesModuleCtrl($scope) {
        var amc = this;

        amc.init = init;
        amc.mobile = false;

        function init() {
            if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
                // Take the user to a different screen here.
                amc.mobile = true;
            }
            datos();
        }

        function datos() {
            var record = $scope.records.unidadLibre;
            
            var voice = '0';
            var sms = '0';
            var data = '0';

            if (record === undefined) {
                voice = '0';
                sms = '0';
                data = '0';

            } else {
                for (var i=0; i < record.length; i++) {
                    if (record[i].codUsoUnidadesLibres == 'Voice') {
                        voice = record[i].cantUnidadesRemanentes;
                        console.info(voice);
                    }
                    if (record[i].codUsoUnidadesLibres == 'SMS') {
                        sms = record[i].cantUnidadesRemanentes;
                        console.info(sms);
                    }
                    if (record[i].codUsoUnidadesLibres == 'Data') {
                        data = record[i].cantUnidadesRemanentes;
                        console.info(data);
                    }
                }
            }

            $scope.dato = {
              voice: voice,
              sms: sms,
              data: data
            };
        }
}