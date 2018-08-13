vlocity.cardframework.registerModule.filter('tel', function () {
    return function (tel) {
        if (!tel) { return ''; }

        var value = tel.toString().trim().replace(/^\+/, '');
        var country, city, number;

        switch (value.length) {
            case 1:
            case 2:
                city = value;
                break;

            default:
                city = value.slice(0, 2);
                number = value.slice(2);
        }

        if(number){
            if(number.length>4){
                number = number.slice(0, 4) + ' ' + number.slice(4,8);
            }
            else{
                number = number;
            }

            return ("0" + city + " " + number).trim();
        }
        else{
            return "0" + city;
        }

    };
});


vlocity.cardframework.registerModule.controller('LinesController', ['$scope', function($scope) {
    var lc = this;
    lc.checkAll = checkAll;
    lc.verifyChecker = verifyChecker;
    lc.testingMiracle = testingMiracle;

    function testingMiracle()
    {
       passStringToController('new value');
    }

    function checkAll(plan)
    {
      console.info('checkAll: ',plan);
      //lc.testingMiracle();
      planIsSelected = plan.isSelected;
      angular.forEach(plan.lineas, function(lines){
            lines.isSelected = planIsSelected;
        });
    }                                  

    function verifyChecker(plan)
    {
        console.info('verifyChecker',plan);

        var count = 0;
        var checkeds = 0;

        angular.forEach(plan.lineas, function(lines){
            count++;
            if(lines.isSelected) checkeds++;
        });

        plan.isSelected = (count == checkeds);
    }
}]);