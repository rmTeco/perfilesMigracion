(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var templates = {};

angular.module('vlocTemplates', ['vlocity'])
  .value('vlocTemplateInternalCache', {
      names: null,
      pending: {initialize:[]},
      resolved:{}
  })
  .config(['remoteActionsProvider', function(remoteActionsProvider) {
      remoteActionsProvider.setRemoteActions({
          getActiveTemplateNames: {
              action: fileNsPrefixDot() + 'CardCanvasController.getActiveTemplateNames'
          },
          getTemplate: {
              action: fileNsPrefixDot() + 'CardCanvasController.getTemplate'
          }
      });
  }]).config(['$compileProvider', function ($compileProvider) {
      $compileProvider.debugInfoEnabled(false);
  }]).run(function(remoteActions, vlocTemplateInternalCache, force) {
      //this only runs on the init of the module, in mobile we do not have the session token yet
        if(typeof Visualforce !== 'undefined') {
            remoteActions.getActiveTemplateNames().
                then(function(templatesNames) {
                    vlocTemplateInternalCache.names = templatesNames;
                    if (vlocTemplateInternalCache.pending.initialize) {
                        vlocTemplateInternalCache.pending.initialize.forEach(function(callback) {
                        callback();
                    });
                }
                delete vlocTemplateInternalCache.pending.initialize;
            });
        } else {
            var query = 'SELECT  Name FROM '+fileNsPrefix()+'VlocityUITemplate__c WHERE '+fileNsPrefix()+'Active__c = true';
            var promise = force.query(query)
            .then(function(data) {
                var templateNames = [];
                angular.forEach(data.records, function(template){
                    templateNames.push(template.Name);
                })
                vlocTemplateInternalCache.names = templateNames;
                  if (vlocTemplateInternalCache.pending.initialize) {
                      vlocTemplateInternalCache.pending.initialize.forEach(function(callback) {
                          callback();
                      });
                  }
                  delete vlocTemplateInternalCache.pending.initialize;
    
            }, function(err){
              console.error(err);
            });
        }
  }).config(['$provide', function($provide) {
    var escape = document.createElement('textarea');
    function unescapeHTML(html) {
        if (angular.isString(html)) {
            escape.innerHTML = html;
            return escape.value;
        } else {
            return html;
        }
    }

    function insertCSS(templateName, cssContent) {
        var head = document.getElementsByTagName('head')[0];
        var cssId = templateName + '.css';
        var existingStyle = document.getElementById(cssId);
        if (!existingStyle) { //style does not exist
            existingStyle = document.createElement('style');
            existingStyle.setAttribute('type', 'text/css');
            existingStyle.setAttribute('id', cssId);
            head.appendChild(existingStyle);
        } else {
            while (existingStyle.firstChild) {
                existingStyle.removeChild(existingStyle.firstChild);
            }
        }
        if (existingStyle.styleSheet) {
            existingStyle.styleSheet.cssText = cssContent;
        } else {
            existingStyle.appendChild(document.createTextNode(cssContent));
        }
    }

    function registerController(templateName, controllerJS) {

      var tryHeader = '(function() { try { \n';
      var catchBlock = '\n } catch(e) { console.log(\'error in '+templateName+'.js \',e); } })();\n//# sourceURL=vlocity/dynamictemplate/' + templateName + '.js\n';
      var head = document.getElementsByTagName('head')[0];
      var jsId = templateName + '.js';
      var existingScript = document.getElementById(jsId);
      if (!existingScript) { //style does not exist
          existingScript = document.createElement('script');
          existingScript.setAttribute('type', 'text/javascript');
          existingScript.setAttribute('id', jsId);
          head.appendChild(existingScript);
          existingScript.appendChild(document.createTextNode(tryHeader + controllerJS + catchBlock));
      }
    }

    $provide.decorator('$templateCache', ['$delegate', 'vlocTemplateInternalCache',
            function($delegate, vlocTemplateInternalCache) {
              var original = $delegate.get;
              $delegate.get = function(name) {
                  if (vlocTemplateInternalCache.resolved[name]) {
                      // Before inserting CSS tag check whether it is defined or not
                      if(vlocTemplateInternalCache.resolved[name][fileNsPrefix() + 'CSS__c']) {
                        insertCSS(name, vlocTemplateInternalCache.resolved[name][fileNsPrefix() + 'CSS__c']);
                      }
                      // Before inserting script tag check whether it is defined or not
                      if(vlocTemplateInternalCache.resolved[name][fileNsPrefix() + 'CustomJavascript__c']) {
                        registerController(name, vlocTemplateInternalCache.resolved[name][fileNsPrefix() + 'CustomJavascript__c']);
                      }
                      return vlocTemplateInternalCache.resolved[name][fileNsPrefix() + 'HTML__c'];
                  } else {
                      if (vlocTemplateInternalCache.names && vlocTemplateInternalCache.names.indexOf(name) > -1) {
                          try {
                              console.warn(name + ' was expected to be in cache but not found - has it been downloaded via $templateRequest yet? Will trigger request in backgroud');
                          } catch (e) {
                              //
                          }
                      }
                      return original.apply($delegate, Array.prototype.slice.call(arguments));
                  }
              };
              return $delegate;
          }]);
    $provide.decorator('$templateRequest',['$delegate', 'vlocTemplateInternalCache', 'remoteActions', '$q', 'force', 'pageService','$log',
            function($delegate, vlocTemplateInternalCache, remoteActions, $q, force, pageService, $log) {
              var original = $delegate;
              var useCache = (pageService.params.useCache)?(pageService.params.useCache === 'true'):true; // default is to use cache
              return function vlocTemplateRequest(name) {
                  var originalArgs = Array.prototype.slice.call(arguments),
                      me = this;
                  if (!vlocTemplateInternalCache.names) {
                      // need to wait to initialize our internal list
                      return $q(function(resolve) {
                          vlocTemplateInternalCache.pending.initialize.push(function() {
                              resolve(vlocTemplateRequest.apply(me, originalArgs));
                          });
                      });
                  }
                  //internal cache is already resolved from loading templates externally
                  if(vlocTemplateInternalCache.resolved[name]) {
                      return original.apply(me, originalArgs);
                  }
                  if (vlocTemplateInternalCache.names.indexOf(name) > -1 && !vlocTemplateInternalCache.resolved[name]) {
                      if (vlocTemplateInternalCache.pending[name]) {
                          return vlocTemplateInternalCache.pending[name];
                      }

                      // this internal cache would be cleared everytime user refresh browser, so we need to use cache
                      // in session storage to avoid retrieving of templates over and over again

                      var templateDefinitionStringFromCache = sessionStorage.getItem('template::' + name);
                      var templateDefinitionJsonFromCache;

                      if (useCache && templateDefinitionStringFromCache) {

                          templateDefinitionJsonFromCache = JSON.parse(templateDefinitionStringFromCache);
                          vlocTemplateInternalCache.resolved[name] = templateDefinitionJsonFromCache;
                          return original.apply(me, originalArgs);

                      } else {

                        if(typeof Visualforce !== 'undefined'){
                          var promise = remoteActions.getTemplate(name)
                            .then(function(template) {
                                delete vlocTemplateInternalCache.pending[name];
                                template[fileNsPrefix() + 'HTML__c'] = unescapeHTML(template[fileNsPrefix() + 'HTML__c']);
                                template[fileNsPrefix() + 'Sass__c'] = unescapeHTML(template[fileNsPrefix() + 'Sass__c']);
                                template[fileNsPrefix() + 'CSS__c'] = unescapeHTML(template[fileNsPrefix() + 'CSS__c']);
                                sessionStorage.setItem('template::' + name, JSON.stringify(template));
                                vlocTemplateInternalCache.resolved[name] = template;
                                return original.apply(me, originalArgs);
                          }, function(err){
                              $log.debug('error retrieving template ',name, err);
                          });
                        } else {
                              var query = 'SELECT Id,  Name, '+fileNsPrefix()+'HTML__c, '+fileNsPrefix()+'Type__c, '+fileNsPrefix()+'CSS__c, '+fileNsPrefix()+'CustomJavascript__c FROM '+fileNsPrefix()+'VlocityUITemplate__c WHERE Name = \''+name+'\' AND '+fileNsPrefix()+'Active__c = true';
                              var promise = force.query(query)
                              .then(function(data) {
                                var template = data.records[0];
                                delete vlocTemplateInternalCache.pending[name];
                                template[fileNsPrefix() + 'HTML__c'] = unescapeHTML(template[fileNsPrefix() + 'HTML__c']);
                                template[fileNsPrefix() + 'Sass__c'] = unescapeHTML(template[fileNsPrefix() + 'Sass__c']);
                                template[fileNsPrefix() + 'CSS__c'] = unescapeHTML(template[fileNsPrefix() + 'CSS__c']);
                                sessionStorage.setItem('template::' + name, JSON.stringify(template));//
                                vlocTemplateInternalCache.resolved[name] = template;
                                return original.apply(me, originalArgs);
                              }, function(err){
                                console.error(err);
                              });
                        }
                        vlocTemplateInternalCache.pending[name] = promise;
                        return promise;
                      }

                  } else {
                      return original.apply(me, originalArgs)
                        .then(function(responseText) {
                          if (/(<title>Visualforce Error ~ Salesforce - Developer Edition<\/title>|sendTitleToParent\('Visualforce Error'\))/.test(responseText)) {
                            throw new Error('Failed to load template: ' + name);
                          } else {
                            return responseText;
                          }
                        })
                  }
              };
          }]);
  }]).service('pageService', function() {
    this.params = function() {
        // This function is anonymous, is executed immediately and
        // the return value is assigned to QueryString!
        var queryString = {};
        var query, vars;
        // for Desktop
        if (typeof Visualforce !== 'undefined') {
            query = window.location.search.substring(1);
        // for Mobile Hybrid Ionic
        } else {
            query = window.location.hash.split('?')[1];
        }

        if (query) {
            vars = query.split('&');
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split('=');
                // If first entry with this name
                if (typeof queryString[pair[0]] === 'undefined') {
                    queryString[pair[0]] = decodeURIComponent(pair[1].replace(/\+/g, ' '));
                      // If second entry with this name
                } else if (typeof queryString[pair[0]] === 'string') {
                    var arr = [queryString[pair[0]],decodeURIComponent(pair[1].replace(/\+/g, ' '))];
                    queryString[pair[0]] = arr;
                      // If third or later entry with this name
                } else {
                    queryString[pair[0]].push(decodeURIComponent(pair[1].replace(/\+/g, ' ')));
                }
            }
        }

        return queryString;
    }();

    // Method to be used to add/update params object
    this.updateParams = function(attr, value){
        if(attr) {
            this.params[attr] = value;
        }
    };

    // Method to be used to delete property from params object
    this.deleteParams = function(attr){
        if(attr) {
            delete this.params[attr];
        }
    };
  });

},{}]},{},[1]);

})();