(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
;(function() {
    'use strict';

    /* JSHINT globals */
    /* globals vlocCommunities, forcetk */

    var modules = ['vlocity', 'CardFramework' ,'ngSanitize', 'forceng', 'tmh.dynamicLocale', 'cfp.hotkeys', 'sldsangular'];

    angular.module('communityApp', modules)

    .config(['tmhDynamicLocaleProvider',function(tmhDynamicLocaleProvider) {
        var localeFileUrlPattern = vlocCommunities.localeFileUrlPattern;

        /* Set the pattern that locale files follow */
        tmhDynamicLocaleProvider.localeLocationPattern(localeFileUrlPattern);
    }])

    .run(['$sce', '$rootScope', 'force', 'timeStampInSeconds', 'networkService', 'debugService', 'API_VERSION', 'userProfileService', 'tmhDynamicLocale', function($sce, $rootScope, force, timeStampInSeconds, networkService, debugService, API_VERSION, userProfileService, tmhDynamicLocale) {

        console.log('inside run');

        // this is used to determine the sf instance url in the community environment.
        // it is stored in localStorage such that later on vloc-card action can retrieve this url
        // without this url, we would not be able to do any services/data or serevices/apexrest api call
        var sfInstanceUrl = vlocCommunities.sfInstanceUrl;
        console.log('sfInstanceUrl fetched from CardCanvasController: ' + sfInstanceUrl);
        localStorage.setItem('sfInstanceUrl', sfInstanceUrl);
        console.log('sfInstanceUrl value stored in localStorage: ' + localStorage.getItem('sfInstanceUrl'));

        // this is used for launching Omniscript from community
        // because in community we launch Omniscript in iframe using getInstanceUrl(), in case the Omniscript
        // inside the iframe needs to communicate with the parent community page which the iframe is embedded in,
        // both the community page url and the iframe url must be the same to avoid cross domain issues
        var currentInstanceUrlWithPath = vlocCommunities.currentInstanceUrlWithPath;
        console.log('currentInstanceUrlWithPath fetched from CardCanvasController: ' + currentInstanceUrlWithPath);
        localStorage.setItem('currentInstanceUrlWithPath', currentInstanceUrlWithPath);
        console.log('currentInstanceUrlWithPath value stored in localStorage: ' + localStorage.getItem('currentInstanceUrlWithPath'));

        var nsPrefix = vlocCommunities.nsPrefix;
        console.log('nsPrefix fetched from CardCanvasController: ' + debugService.valueOfNameSpacePrefix(nsPrefix));
        localStorage.setItem('nsPrefix', nsPrefix);
        console.log('nsPrefix value stored in localStorage: ' + localStorage.getItem('nsPrefix'));

        // soql does not accept customer community url, must use SF instance url
        // but the first time when you use soql, it will give you a CORS error,
        // you need to put the community url (the origin of the CORS error url) in the CORS whitelist
        force.init({
                accessToken: vlocCommunities.accessToken,
                apiVersion: API_VERSION,
                useProxy: false,
                instanceURL: sfInstanceUrl // use sf instance url to do api call instead of the community site url
            });

        // use of communityInd to indicate this is coming from community and forcetk need to
        // add community path anme to proxyUrl
        var communityInd = true;
        $rootScope.forcetkClient = new forcetk.Client(null, null, null, communityInd);

        // use sf instance url to do api call instead of the community site url
        $rootScope.forcetkClient.setSessionToken(vlocCommunities.accessToken, API_VERSION, sfInstanceUrl);

        $rootScope.loggedUser = vlocCommunities.loggedUser;
        $rootScope.nsPrefix = nsPrefix; // needed for the getNsPrefixedObjFieldValue() in the vloc-card controller

        userProfileService.getUserProfile().then(
            function(data) {
                //set the i18n file path based on the user's locale in sfdc
                tmhDynamicLocale.set(data.anlocale);
                moment.locale(data.anlocale);

            });

    }])

    .controller('CommunityController', function($scope, $rootScope, force, dataService, pageService) {
        $scope.accounts = [];
        $scope.layouts = {};
        $scope.accountId = $rootScope.loggedUser;
        //$scope.order = '';
        $rootScope.layouts = {};

        $rootScope.staticResourceURL = vlocCommunities.staticResourceURL;

        //Used for preview mode
        $rootScope.layoutName = pageService.params.layout;
        $rootScope.layoutId = pageService.params.layoutId;
        $rootScope.loggedUser.AccountId = ($rootScope.loggedUser.AccountId) ? $rootScope.loggedUser.AccountId : pageService.params.Id;
    })

    .controller('infoCtrl', function($scope, $rootScope, remoteActions, force, $sce, $interpolate) {
        $scope.loaded = false;
        $rootScope.$on('actionSelected',function(event, toBeLaunchedUrl) {
            console.log(toBeLaunchedUrl);
            $scope.loaded = false;
            $rootScope.showContent = false;
            $scope.url = $sce.trustAsResourceUrl(toBeLaunchedUrl);

            // create iframe on the fly instead of harcoding it in the template
            // otherwise, when we launch the same Omniscript in community it will not be loaded in the iframe
            var myEl = angular.element(document.querySelector('#community-frame-container'));
            var c = $interpolate('<iframe id="community-frame" src="{{url}}"></iframe>')($scope);
            console.log(c);
            myEl.append(c);
        });

        // this will be invoked from the template containing the iframe when user clicks on the BACK button
        $scope.removeFrame = function() {
            var myEl = angular.element(document.querySelector('#community-frame'));
            myEl.remove();
        };

        window.iframeLoaded = function() {
            if ($scope.url) {
                console.log('Community frame loaded');
                $scope.loaded = true;
                $scope.$apply();
            }
        };
    });

})();
},{}]},{},[1]);

})();