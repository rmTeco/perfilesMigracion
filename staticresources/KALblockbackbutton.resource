window.extJS = (function() {
    return {
        blockButton : function() {
            history.pushState(null, null, location.href);
            window.onpopstate = function () {
                history.go(1);
            }
        }
    };
}());