vlocity.cardframework.registerModule.controller('taCareMultiSelectController', ['$scope', function ($scope) {
    this.init = init;
    this.handleSelection = handleSelection;

    function init() {
        this.selection = [];
    }

    function handleSelection(option) {
        if (option.selected) {
            this.aggregateOption(option);
        } else {
            this.removeOption(option);
        }
    }

    function aggregateOption(option) {
        this.selection.push(option);
    }

    function removeOption() {
        this.selection.pop(option);
    }
}]);