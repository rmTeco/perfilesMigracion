vlocity
    .cardframework
    .registerModule
    .controller('InternetMoreDetailsController', InternetMoreDetailsController);
    
    InternetMoreDetailsController.$inject = ['$scope', '$rootScope'];
    
    function InternetMoreDetailsController($scope, $rootScope) {
        var imdc = this;
        
        imdc.init = init;
        imdc.attributes;
        imdc.details = {};
        
        function init() {
            imdc.attributes = $scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c;
            _setDetailsValues();
        }
        
        function _setDetailsValues() {
            console.info('Atributes details: ', imdc.attributes);
            for (var i = 0; i < imdc.attributes.taART.length; i++) {
                var attr = imdc.attributes.taART[i];
                switch(attr.attributedisplayname__c) {
                    case "Upload speed":
                    case "Download Speed":
                        console.info('Speed: ', attr.attributeRunTimeInfo.default[0].displayText);
                        imdc.details[attr.attributedisplayname__c] = attr.attributeRunTimeInfo.default[0].displayText;
                        break;
                    case "Ancho":
                    case "Grosor":
                    case "Gama":
                    case "Peso":
                        imdc.details[attr.attributedisplayname__c] = attr.value__c;
                }
            }
            console.info('Details: ', imdc.details);
        }
        
    }