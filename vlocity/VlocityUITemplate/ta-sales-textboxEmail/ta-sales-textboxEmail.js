vlocity.cardframework.registerModule.controller('EmailCtrl', ['$scope', function($scope) {
    var ec = this;
    ec.inputValue = '';
    ec.emailSplited = '';
    ec.getSplitedEmailInput = getSplitedEmailInput;
    ec.validateEmail = validateEmail;
    ec.selectedEmail = selectedEmail;
    ec.emailPattern = new RegExp(/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/);
    ec.validateFieldByRegEx = false;
    ec.checkboxChecked = checkboxChecked;
    
    
    $scope.$watch('bpTree.response.Contact.Email', function (newVal, oldVal) {
        if (newVal != oldVal) {
            getSplitedEmailInput(newVal, $scope.bpTree.response.Contact);
        }
    });

    function getSplitedEmailInput(value, contact) {
        console.info('value: ', value);
        ec.inputValue = value;
        contact.isEmailValidated = validateEmail(ec.inputValue);
        ec.validateFieldByRegEx = contact.isEmailValidated;
        if (ec.inputValue) {
            ec.emailSplited = ec.inputValue.split('@')[0];
        }
    }

    function validateEmail(email){
        return ec.emailPattern.test(email);
    }

    function selectedEmail(contact, selectedEmail) {
        contact.Email = ec.emailSplited+selectedEmail;
        contact.isEmailValidated = ec.validateEmail(contact.Email);
    }

    function checkboxChecked(contact) {
        contact.Email = '';
        if (contact.EmailCheck) {
            contact.isEmailValidated = true;
        } else {
            contact.isEmailValidated = false;
        }
    }
}]);

vlocity.cardframework.registerModule.filter("emailTypeahead", ['$filter', function($filter) {
    return function(input, email) {
        console.info(input, email)
        var auxInput = input;
        var emailDomainEntered = '';
        if (email) {
            emailDomainEntered = email.split('@')[1];
        }
    return $filter('filter')(auxInput, emailDomainEntered);
    };
}]);