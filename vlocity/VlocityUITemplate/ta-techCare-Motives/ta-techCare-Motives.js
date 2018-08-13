/*
 * List View Controller
 * Contains logic for:
 * - Fields Actions Logic
 */ 
(function() {
    
     angular
        .module('omniscriptDesigner')
        .controller('testCtrl', testCtrl);

    function testCtrl() {
        // Public Fields
        var ts = this;
        ts.test = "asd";
    }
})();