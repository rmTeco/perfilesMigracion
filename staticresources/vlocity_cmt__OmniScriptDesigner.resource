(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
require('./dependencies/native.history.js');
require('./polyfills/Array.find.js');
require('./polyfills/Array.findIndex.js');
require('./polyfills/Array.from.js');
require('./sharedObjectService.js');

angular.module('omniscriptDesigner', ['vlocity', 'oui', 'mgcrea.ngStrap',
                                      'ui-rangeSlider','dndLists', 'ngSanitize', 'sldsangular',
                                      'viaExpressionEngine', 'ui.tinymce', 'dataraptor', 'drvcomp', 'ouihome', 'sharedObjectService'])
  .config(['remoteActionsProvider', function(remoteActionsProvider) {
      remoteActionsProvider.setRemoteActions(window.remoteActions || {});
  }]).config(function($locationProvider) {
      $locationProvider.html5Mode({
          enabled: !!(window.history && history.pushState),
          requireBase: false
      });
  }).config(['$compileProvider', function ($compileProvider) {
      $compileProvider.debugInfoEnabled(false);
  }]).config(['$localizableProvider', function($localizableProvider) {
      $localizableProvider.setLocalizedMap(window.i18n);
      $localizableProvider.setDebugMode(window.ns === '');
      $localizableProvider.setSyncModeOnly();
  }]).config(function($typeaheadProvider) {
      angular.extend($typeaheadProvider.defaults, {
          watchOptions: true,
          minLength: 0,
          limit: 1000
      });
  }).config(function($tooltipProvider) {
      angular.extend($tooltipProvider.defaults, {
          delay:{show:0,hide:100}
      });
  })
  .value('isIntegrationProcedure', false);
require('./modules/oui/Oui.js');

require('./modules/designer/controller/OmniScriptDesigner.js');
require('./modules/designer/controller/ElementPalette.js');
require('./modules/designer/controller/StructureCanvas.js');
require('./modules/designer/controller/TabbedController.js');
require('./modules/designer/controller/PropertiesController.js');
require('./modules/designer/controller/ScriptFormController.js');

require('./modules/designer/directive/NumberInputNullValueFix.js');
require('./modules/designer/directive/ViaScreenHeight.js');
require('./modules/designer/directive/PreventDeleteBack.js');
require('./modules/designer/directive/PaletteGroup.js');
require('./modules/designer/directive/ViaAffix.js');
require('./modules/designer/directive/dynamic-tooltip.js');
require('./modules/designer/directive/vlc-draggable.js');
require('./modules/designer/directive/vlc-bubble-canceller.js');
require('./modules/designer/directive/vlc-expand-collapse.js');


require('./modules/designer/filter/ActiveElementTitle.js');
require('./modules/designer/filter/ClassName.js');
require('./modules/designer/filter/ElementLabel.js');
require('./modules/designer/filter/GetTypeForElement.js');
require('./modules/designer/filter/FixMissingProperties.js');
require('./modules/designer/filter/Placeholder.js');
require('./modules/designer/filter/PropertyLayout.js');
require('./modules/designer/filter/propertyLayoutConfigurations.js');
require('./modules/designer/filter/ReadablePropertyName.js');
require('./modules/designer/filter/TemplateForProperty.js');
require('./modules/designer/filter/OptionsForProperty.js');
require('./modules/designer/filter/LinkForProperty.js');
require('./modules/designer/filter/ControlType.js');

require('./modules/designer/factory/InterTabMsgBus.js');
require('./modules/designer/factory/Delete.js');
require('./modules/designer/services/tinyMCEImageInsert.js');
require('./modules/designer/services/propertyEditorModalService.js');
require('./modules/designer/services/customViewModalService.js');
require('./modules/designer/oui_tinymce_plugins/smart_link.js');
require('./modules/designer/oui_tinymce_plugins/doc_insert.js');

require('./modules/designer/templates/templates.js');
require('./modules/designer/directive/logging.js');
require('./modules/designer/directive/treeView.js')
require('./modules/designer/directive/changeLabel.js');
require('./modules/designer/directive/typeaheadOptions.js');
require('./modules/designer/directive/vlcCollapsible.js');
require('./modules/designer/directive/vlcClipboard.js');
require('./modules/designer/factory/tObjectFactory.js');

angular.module('ouihome', ['vlocity']);
require('./modules/ouihome/factory/BackcompatExport.js');
},{"./dependencies/native.history.js":2,"./modules/designer/controller/ElementPalette.js":3,"./modules/designer/controller/OmniScriptDesigner.js":4,"./modules/designer/controller/PropertiesController.js":5,"./modules/designer/controller/ScriptFormController.js":6,"./modules/designer/controller/StructureCanvas.js":7,"./modules/designer/controller/TabbedController.js":8,"./modules/designer/directive/NumberInputNullValueFix.js":9,"./modules/designer/directive/PaletteGroup.js":10,"./modules/designer/directive/PreventDeleteBack.js":11,"./modules/designer/directive/ViaAffix.js":12,"./modules/designer/directive/ViaScreenHeight.js":13,"./modules/designer/directive/changeLabel.js":14,"./modules/designer/directive/dynamic-tooltip.js":15,"./modules/designer/directive/logging.js":16,"./modules/designer/directive/treeView.js":17,"./modules/designer/directive/typeaheadOptions.js":18,"./modules/designer/directive/vlc-bubble-canceller.js":19,"./modules/designer/directive/vlc-draggable.js":20,"./modules/designer/directive/vlc-expand-collapse.js":21,"./modules/designer/directive/vlcClipboard.js":22,"./modules/designer/directive/vlcCollapsible.js":23,"./modules/designer/factory/Delete.js":24,"./modules/designer/factory/InterTabMsgBus.js":25,"./modules/designer/factory/tObjectFactory.js":26,"./modules/designer/filter/ActiveElementTitle.js":27,"./modules/designer/filter/ClassName.js":28,"./modules/designer/filter/ControlType.js":29,"./modules/designer/filter/ElementLabel.js":30,"./modules/designer/filter/FixMissingProperties.js":31,"./modules/designer/filter/GetTypeForElement.js":32,"./modules/designer/filter/LinkForProperty.js":33,"./modules/designer/filter/OptionsForProperty.js":34,"./modules/designer/filter/Placeholder.js":35,"./modules/designer/filter/PropertyLayout.js":36,"./modules/designer/filter/ReadablePropertyName.js":37,"./modules/designer/filter/TemplateForProperty.js":38,"./modules/designer/filter/propertyLayoutConfigurations.js":39,"./modules/designer/oui_tinymce_plugins/doc_insert.js":40,"./modules/designer/oui_tinymce_plugins/smart_link.js":41,"./modules/designer/services/customViewModalService.js":42,"./modules/designer/services/propertyEditorModalService.js":43,"./modules/designer/services/tinyMCEImageInsert.js":44,"./modules/designer/templates/templates.js":45,"./modules/oui/Oui.js":46,"./modules/ouihome/factory/BackcompatExport.js":58,"./polyfills/Array.find.js":59,"./polyfills/Array.findIndex.js":60,"./polyfills/Array.from.js":61,"./sharedObjectService.js":63}],2:[function(require,module,exports){
typeof JSON!="object"&&(JSON={}),function(){"use strict";function f(e){return e<10?"0"+e:e}function quote(e){return escapable.lastIndex=0,escapable.test(e)?'"'+e.replace(escapable,function(e){var t=meta[e];return typeof t=="string"?t:"\\u"+("0000"+e.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+e+'"'}function str(e,t){var n,r,i,s,o=gap,u,a=t[e];a&&typeof a=="object"&&typeof a.toJSON=="function"&&(a=a.toJSON(e)),typeof rep=="function"&&(a=rep.call(t,e,a));switch(typeof a){case"string":return quote(a);case"number":return isFinite(a)?String(a):"null";case"boolean":case"null":return String(a);case"object":if(!a)return"null";gap+=indent,u=[];if(Object.prototype.toString.apply(a)==="[object Array]"){s=a.length;for(n=0;n<s;n+=1)u[n]=str(n,a)||"null";return i=u.length===0?"[]":gap?"[\n"+gap+u.join(",\n"+gap)+"\n"+o+"]":"["+u.join(",")+"]",gap=o,i}if(rep&&typeof rep=="object"){s=rep.length;for(n=0;n<s;n+=1)typeof rep[n]=="string"&&(r=rep[n],i=str(r,a),i&&u.push(quote(r)+(gap?": ":":")+i))}else for(r in a)Object.prototype.hasOwnProperty.call(a,r)&&(i=str(r,a),i&&u.push(quote(r)+(gap?": ":":")+i));return i=u.length===0?"{}":gap?"{\n"+gap+u.join(",\n"+gap)+"\n"+o+"}":"{"+u.join(",")+"}",gap=o,i}}typeof Date.prototype.toJSON!="function"&&(Date.prototype.toJSON=function(e){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(e){return this.valueOf()});var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={"\b":"\\b","	":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},rep;typeof JSON.stringify!="function"&&(JSON.stringify=function(e,t,n){var r;gap="",indent="";if(typeof n=="number")for(r=0;r<n;r+=1)indent+=" ";else typeof n=="string"&&(indent=n);rep=t;if(!t||typeof t=="function"||typeof t=="object"&&typeof t.length=="number")return str("",{"":e});throw new Error("JSON.stringify")}),typeof JSON.parse!="function"&&(JSON.parse=function(text,reviver){function walk(e,t){var n,r,i=e[t];if(i&&typeof i=="object")for(n in i)Object.prototype.hasOwnProperty.call(i,n)&&(r=walk(i,n),r!==undefined?i[n]=r:delete i[n]);return reviver.call(e,t,i)}var j;text=String(text),cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(e){return"\\u"+("0000"+e.charCodeAt(0).toString(16)).slice(-4)}));if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),typeof reviver=="function"?walk({"":j},""):j;throw new SyntaxError("JSON.parse")})}(),function(e,t){"use strict";var n=e.History=e.History||{};if(typeof n.Adapter!="undefined")throw new Error("History.js Adapter has already been loaded...");n.Adapter={handlers:{},_uid:1,uid:function(e){return e._uid||(e._uid=n.Adapter._uid++)},bind:function(e,t,r){var i=n.Adapter.uid(e);n.Adapter.handlers[i]=n.Adapter.handlers[i]||{},n.Adapter.handlers[i][t]=n.Adapter.handlers[i][t]||[],n.Adapter.handlers[i][t].push(r),e["on"+t]=function(e,t){return function(r){n.Adapter.trigger(e,t,r)}}(e,t)},trigger:function(e,t,r){r=r||{};var i=n.Adapter.uid(e),s,o;n.Adapter.handlers[i]=n.Adapter.handlers[i]||{},n.Adapter.handlers[i][t]=n.Adapter.handlers[i][t]||[];for(s=0,o=n.Adapter.handlers[i][t].length;s<o;++s)n.Adapter.handlers[i][t][s].apply(this,[r])},extractEventData:function(e,n){var r=n&&n[e]||t;return r},onDomLoad:function(t){var n=e.setTimeout(function(){t()},2e3);e.onload=function(){clearTimeout(n),t()}}},typeof n.init!="undefined"&&n.init()}(window),function(e,t){"use strict";var n=e.document,r=e.setTimeout||r,i=e.clearTimeout||i,s=e.setInterval||s,o=e.History=e.History||{};if(typeof o.initHtml4!="undefined")throw new Error("History.js HTML4 Support has already been loaded...");o.initHtml4=function(){if(typeof o.initHtml4.initialized!="undefined")return!1;o.initHtml4.initialized=!0,o.enabled=!0,o.savedHashes=[],o.isLastHash=function(e){var t=o.getHashByIndex(),n;return n=e===t,n},o.isHashEqual=function(e,t){return e=encodeURIComponent(e).replace(/%25/g,"%"),t=encodeURIComponent(t).replace(/%25/g,"%"),e===t},o.saveHash=function(e){return o.isLastHash(e)?!1:(o.savedHashes.push(e),!0)},o.getHashByIndex=function(e){var t=null;return typeof e=="undefined"?t=o.savedHashes[o.savedHashes.length-1]:e<0?t=o.savedHashes[o.savedHashes.length+e]:t=o.savedHashes[e],t},o.discardedHashes={},o.discardedStates={},o.discardState=function(e,t,n){var r=o.getHashByState(e),i;return i={discardedState:e,backState:n,forwardState:t},o.discardedStates[r]=i,!0},o.discardHash=function(e,t,n){var r={discardedHash:e,backState:n,forwardState:t};return o.discardedHashes[e]=r,!0},o.discardedState=function(e){var t=o.getHashByState(e),n;return n=o.discardedStates[t]||!1,n},o.discardedHash=function(e){var t=o.discardedHashes[e]||!1;return t},o.recycleState=function(e){var t=o.getHashByState(e);return o.discardedState(e)&&delete o.discardedStates[t],!0},o.emulated.hashChange&&(o.hashChangeInit=function(){o.checkerFunction=null;var t="",r,i,u,a,f=Boolean(o.getHash());return o.isInternetExplorer()?(r="historyjs-iframe",i=n.createElement("iframe"),i.setAttribute("id",r),i.setAttribute("src","#"),i.style.display="none",n.body.appendChild(i),i.contentWindow.document.open(),i.contentWindow.document.close(),u="",a=!1,o.checkerFunction=function(){if(a)return!1;a=!0;var n=o.getHash(),r=o.getHash(i.contentWindow.document);return n!==t?(t=n,r!==n&&(u=r=n,i.contentWindow.document.open(),i.contentWindow.document.close(),i.contentWindow.document.location.hash=o.escapeHash(n)),o.Adapter.trigger(e,"hashchange")):r!==u&&(u=r,f&&r===""?o.back():o.setHash(r,!1)),a=!1,!0}):o.checkerFunction=function(){var n=o.getHash()||"";return n!==t&&(t=n,o.Adapter.trigger(e,"hashchange")),!0},o.intervalList.push(s(o.checkerFunction,o.options.hashChangeInterval)),!0},o.Adapter.onDomLoad(o.hashChangeInit)),o.emulated.pushState&&(o.onHashChange=function(t){var n=t&&t.newURL||o.getLocationHref(),r=o.getHashByUrl(n),i=null,s=null,u=null,a;return o.isLastHash(r)?(o.busy(!1),!1):(o.doubleCheckComplete(),o.saveHash(r),r&&o.isTraditionalAnchor(r)?(o.Adapter.trigger(e,"anchorchange"),o.busy(!1),!1):(i=o.extractState(o.getFullUrl(r||o.getLocationHref()),!0),o.isLastSavedState(i)?(o.busy(!1),!1):(s=o.getHashByState(i),a=o.discardedState(i),a?(o.getHashByIndex(-2)===o.getHashByState(a.forwardState)?o.back(!1):o.forward(!1),!1):(o.pushState(i.data,i.title,encodeURI(i.url),!1),!0))))},o.Adapter.bind(e,"hashchange",o.onHashChange),o.pushState=function(t,n,r,i){r=encodeURI(r).replace(/%25/g,"%");if(o.getHashByUrl(r))throw new Error("History.js does not support states with fragment-identifiers (hashes/anchors).");if(i!==!1&&o.busy())return o.pushQueue({scope:o,callback:o.pushState,args:arguments,queue:i}),!1;o.busy(!0);var s=o.createStateObject(t,n,r),u=o.getHashByState(s),a=o.getState(!1),f=o.getHashByState(a),l=o.getHash(),c=o.expectedStateId==s.id;return o.storeState(s),o.expectedStateId=s.id,o.recycleState(s),o.setTitle(s),u===f?(o.busy(!1),!1):(o.saveState(s),c||o.Adapter.trigger(e,"statechange"),!o.isHashEqual(u,l)&&!o.isHashEqual(u,o.getShortUrl(o.getLocationHref()))&&o.setHash(u,!1),o.busy(!1),!0)},o.replaceState=function(t,n,r,i){r=encodeURI(r).replace(/%25/g,"%");if(o.getHashByUrl(r))throw new Error("History.js does not support states with fragment-identifiers (hashes/anchors).");if(i!==!1&&o.busy())return o.pushQueue({scope:o,callback:o.replaceState,args:arguments,queue:i}),!1;o.busy(!0);var s=o.createStateObject(t,n,r),u=o.getHashByState(s),a=o.getState(!1),f=o.getHashByState(a),l=o.getStateByIndex(-2);return o.discardState(a,s,l),u===f?(o.storeState(s),o.expectedStateId=s.id,o.recycleState(s),o.setTitle(s),o.saveState(s),o.Adapter.trigger(e,"statechange"),o.busy(!1)):o.pushState(s.data,s.title,s.url,!1),!0}),o.emulated.pushState&&o.getHash()&&!o.emulated.hashChange&&o.Adapter.onDomLoad(function(){o.Adapter.trigger(e,"hashchange")})},typeof o.init!="undefined"&&o.init()}(window),function(e,t){"use strict";var n=e.console||t,r=e.document,i=e.navigator,s=e.sessionStorage||!1,o=e.setTimeout,u=e.clearTimeout,a=e.setInterval,f=e.clearInterval,l=e.JSON,c=e.alert,h=e.History=e.History||{},p=e.history;try{s.setItem("TEST","1"),s.removeItem("TEST")}catch(d){s=!1}l.stringify=l.stringify||l.encode,l.parse=l.parse||l.decode;if(typeof h.init!="undefined")throw new Error("History.js Core has already been loaded...");h.init=function(e){return typeof h.Adapter=="undefined"?!1:(typeof h.initCore!="undefined"&&h.initCore(),typeof h.initHtml4!="undefined"&&h.initHtml4(),!0)},h.initCore=function(d){if(typeof h.initCore.initialized!="undefined")return!1;h.initCore.initialized=!0,h.options=h.options||{},h.options.hashChangeInterval=h.options.hashChangeInterval||100,h.options.safariPollInterval=h.options.safariPollInterval||500,h.options.doubleCheckInterval=h.options.doubleCheckInterval||500,h.options.disableSuid=h.options.disableSuid||!1,h.options.storeInterval=h.options.storeInterval||1e3,h.options.busyDelay=h.options.busyDelay||250,h.options.debug=h.options.debug||!1,h.options.initialTitle=h.options.initialTitle||r.title,h.options.html4Mode=h.options.html4Mode||!1,h.options.delayInit=h.options.delayInit||!1,h.intervalList=[],h.clearAllIntervals=function(){var e,t=h.intervalList;if(typeof t!="undefined"&&t!==null){for(e=0;e<t.length;e++)f(t[e]);h.intervalList=null}},h.debug=function(){(h.options.debug||!1)&&h.log.apply(h,arguments)},h.log=function(){var e=typeof n!="undefined"&&typeof n.log!="undefined"&&typeof n.log.apply!="undefined",t=r.getElementById("log"),i,s,o,u,a;e?(u=Array.prototype.slice.call(arguments),i=u.shift(),typeof n.debug!="undefined"?n.debug.apply(n,[i,u]):n.log.apply(n,[i,u])):i="\n"+arguments[0]+"\n";for(s=1,o=arguments.length;s<o;++s){a=arguments[s];if(typeof a=="object"&&typeof l!="undefined")try{a=l.stringify(a)}catch(f){}i+="\n"+a+"\n"}return t?(t.value+=i+"\n-----\n",t.scrollTop=t.scrollHeight-t.clientHeight):e||c(i),!0},h.getInternetExplorerMajorVersion=function(){var e=h.getInternetExplorerMajorVersion.cached=typeof h.getInternetExplorerMajorVersion.cached!="undefined"?h.getInternetExplorerMajorVersion.cached:function(){var e=3,t=r.createElement("div"),n=t.getElementsByTagName("i");while((t.innerHTML="<!--[if gt IE "+ ++e+"]><i></i><![endif]-->")&&n[0]);return e>4?e:!1}();return e},h.isInternetExplorer=function(){var e=h.isInternetExplorer.cached=typeof h.isInternetExplorer.cached!="undefined"?h.isInternetExplorer.cached:Boolean(h.getInternetExplorerMajorVersion());return e},h.options.html4Mode?h.emulated={pushState:!0,hashChange:!0}:h.emulated={pushState:!Boolean(e.history&&e.history.pushState&&e.history.replaceState&&!/ Mobile\/([1-7][a-z]|(8([abcde]|f(1[0-8]))))/i.test(i.userAgent)&&!/AppleWebKit\/5([0-2]|3[0-2])/i.test(i.userAgent)),hashChange:Boolean(!("onhashchange"in e||"onhashchange"in r)||h.isInternetExplorer()&&h.getInternetExplorerMajorVersion()<8)},h.enabled=!h.emulated.pushState,h.bugs={setHash:Boolean(!h.emulated.pushState&&i.vendor==="Apple Computer, Inc."&&/AppleWebKit\/5([0-2]|3[0-3])/.test(i.userAgent)),safariPoll:Boolean(!h.emulated.pushState&&i.vendor==="Apple Computer, Inc."&&/AppleWebKit\/5([0-2]|3[0-3])/.test(i.userAgent)),ieDoubleCheck:Boolean(h.isInternetExplorer()&&h.getInternetExplorerMajorVersion()<8),hashEscape:Boolean(h.isInternetExplorer()&&h.getInternetExplorerMajorVersion()<7)},h.isEmptyObject=function(e){for(var t in e)if(e.hasOwnProperty(t))return!1;return!0},h.cloneObject=function(e){var t,n;return e?(t=l.stringify(e),n=l.parse(t)):n={},n},h.getRootUrl=function(){var e=r.location.protocol+"//"+(r.location.hostname||r.location.host);if(r.location.port||!1)e+=":"+r.location.port;return e+="/",e},h.getBaseHref=function(){var e=r.getElementsByTagName("base"),t=null,n="";return e.length===1&&(t=e[0],n=t.href.replace(/[^\/]+$/,"")),n=n.replace(/\/+$/,""),n&&(n+="/"),n},h.getBaseUrl=function(){var e=h.getBaseHref()||h.getBasePageUrl()||h.getRootUrl();return e},h.getPageUrl=function(){var e=h.getState(!1,!1),t=(e||{}).url||h.getLocationHref(),n;return n=t.replace(/\/+$/,"").replace(/[^\/]+$/,function(e,t,n){return/\./.test(e)?e:e+"/"}),n},h.getBasePageUrl=function(){var e=h.getLocationHref().replace(/[#\?].*/,"").replace(/[^\/]+$/,function(e,t,n){return/[^\/]$/.test(e)?"":e}).replace(/\/+$/,"")+"/";return e},h.getFullUrl=function(e,t){var n=e,r=e.substring(0,1);return t=typeof t=="undefined"?!0:t,/[a-z]+\:\/\//.test(e)||(r==="/"?n=h.getRootUrl()+e.replace(/^\/+/,""):r==="#"?n=h.getPageUrl().replace(/#.*/,"")+e:r==="?"?n=h.getPageUrl().replace(/[\?#].*/,"")+e:t?n=h.getBaseUrl()+e.replace(/^(\.\/)+/,""):n=h.getBasePageUrl()+e.replace(/^(\.\/)+/,"")),n.replace(/\#$/,"")},h.getShortUrl=function(e){var t=e,n=h.getBaseUrl(),r=h.getRootUrl();return h.emulated.pushState&&(t=t.replace(n,"")),t=t.replace(r,"/"),h.isTraditionalAnchor(t)&&(t="./"+t),t=t.replace(/^(\.\/)+/g,"./").replace(/\#$/,""),t},h.getLocationHref=function(e){return e=e||r,e.URL===e.location.href?e.location.href:e.location.href===decodeURIComponent(e.URL)?e.URL:e.location.hash&&decodeURIComponent(e.location.href.replace(/^[^#]+/,""))===e.location.hash?e.location.href:e.URL.indexOf("#")==-1&&e.location.href.indexOf("#")!=-1?e.location.href:e.URL||e.location.href},h.store={},h.idToState=h.idToState||{},h.stateToId=h.stateToId||{},h.urlToId=h.urlToId||{},h.storedStates=h.storedStates||[],h.savedStates=h.savedStates||[],h.normalizeStore=function(){h.store.idToState=h.store.idToState||{},h.store.urlToId=h.store.urlToId||{},h.store.stateToId=h.store.stateToId||{}},h.getState=function(e,t){typeof e=="undefined"&&(e=!0),typeof t=="undefined"&&(t=!0);var n=h.getLastSavedState();return!n&&t&&(n=h.createStateObject()),e&&(n=h.cloneObject(n),n.url=n.cleanUrl||n.url),n},h.getIdByState=function(e){var t=h.extractId(e.url),n;if(!t){n=h.getStateString(e);if(typeof h.stateToId[n]!="undefined")t=h.stateToId[n];else if(typeof h.store.stateToId[n]!="undefined")t=h.store.stateToId[n];else{for(;;){t=(new Date).getTime()+String(Math.random()).replace(/\D/g,"");if(typeof h.idToState[t]=="undefined"&&typeof h.store.idToState[t]=="undefined")break}h.stateToId[n]=t,h.idToState[t]=e}}return t},h.normalizeState=function(e){var t,n;if(!e||typeof e!="object")e={};if(typeof e.normalized!="undefined")return e;if(!e.data||typeof e.data!="object")e.data={};return t={},t.normalized=!0,t.title=e.title||"",t.url=h.getFullUrl(e.url?e.url:h.getLocationHref()),t.hash=h.getShortUrl(t.url),t.data=h.cloneObject(e.data),t.id=h.getIdByState(t),t.cleanUrl=t.url.replace(/\??\&_suid.*/,""),t.url=t.cleanUrl,n=!h.isEmptyObject(t.data),(t.title||n)&&h.options.disableSuid!==!0&&(t.hash=h.getShortUrl(t.url).replace(/\??\&_suid.*/,""),/\?/.test(t.hash)||(t.hash+="?"),t.hash+="&_suid="+t.id),t.hashedUrl=h.getFullUrl(t.hash),(h.emulated.pushState||h.bugs.safariPoll)&&h.hasUrlDuplicate(t)&&(t.url=t.hashedUrl),t},h.createStateObject=function(e,t,n){var r={data:e,title:t,url:n};return r=h.normalizeState(r),r},h.getStateById=function(e){e=String(e);var n=h.idToState[e]||h.store.idToState[e]||t;return n},h.getStateString=function(e){var t,n,r;return t=h.normalizeState(e),n={data:t.data,title:e.title,url:e.url},r=l.stringify(n),r},h.getStateId=function(e){var t,n;return t=h.normalizeState(e),n=t.id,n},h.getHashByState=function(e){var t,n;return t=h.normalizeState(e),n=t.hash,n},h.extractId=function(e){var t,n,r,i;return e.indexOf("#")!=-1?i=e.split("#")[0]:i=e,n=/(.*)\&_suid=([0-9]+)$/.exec(i),r=n?n[1]||e:e,t=n?String(n[2]||""):"",t||!1},h.isTraditionalAnchor=function(e){var t=!/[\/\?\.]/.test(e);return t},h.extractState=function(e,t){var n=null,r,i;return t=t||!1,r=h.extractId(e),r&&(n=h.getStateById(r)),n||(i=h.getFullUrl(e),r=h.getIdByUrl(i)||!1,r&&(n=h.getStateById(r)),!n&&t&&!h.isTraditionalAnchor(e)&&(n=h.createStateObject(null,null,i))),n},h.getIdByUrl=function(e){var n=h.urlToId[e]||h.store.urlToId[e]||t;return n},h.getLastSavedState=function(){return h.savedStates[h.savedStates.length-1]||t},h.getLastStoredState=function(){return h.storedStates[h.storedStates.length-1]||t},h.hasUrlDuplicate=function(e){var t=!1,n;return n=h.extractState(e.url),t=n&&n.id!==e.id,t},h.storeState=function(e){return h.urlToId[e.url]=e.id,h.storedStates.push(h.cloneObject(e)),e},h.isLastSavedState=function(e){var t=!1,n,r,i;return h.savedStates.length&&(n=e.id,r=h.getLastSavedState(),i=r.id,t=n===i),t},h.saveState=function(e){return h.isLastSavedState(e)?!1:(h.savedStates.push(h.cloneObject(e)),!0)},h.getStateByIndex=function(e){var t=null;return typeof e=="undefined"?t=h.savedStates[h.savedStates.length-1]:e<0?t=h.savedStates[h.savedStates.length+e]:t=h.savedStates[e],t},h.getCurrentIndex=function(){var e=null;return h.savedStates.length<1?e=0:e=h.savedStates.length-1,e},h.getHash=function(e){var t=h.getLocationHref(e),n;return n=h.getHashByUrl(t),n},h.unescapeHash=function(e){var t=h.normalizeHash(e);return t=decodeURIComponent(t),t},h.normalizeHash=function(e){var t=e.replace(/[^#]*#/,"").replace(/#.*/,"");return t},h.setHash=function(e,t){var n,i;return t!==!1&&h.busy()?(h.pushQueue({scope:h,callback:h.setHash,args:arguments,queue:t}),!1):(h.busy(!0),n=h.extractState(e,!0),n&&!h.emulated.pushState?h.pushState(n.data,n.title,n.url,!1):h.getHash()!==e&&(h.bugs.setHash?(i=h.getPageUrl(),h.pushState(null,null,i+"#"+e,!1)):r.location.hash=e),h)},h.escapeHash=function(t){var n=h.normalizeHash(t);return n=e.encodeURIComponent(n),h.bugs.hashEscape||(n=n.replace(/\%21/g,"!").replace(/\%26/g,"&").replace(/\%3D/g,"=").replace(/\%3F/g,"?")),n},h.getHashByUrl=function(e){var t=String(e).replace(/([^#]*)#?([^#]*)#?(.*)/,"$2");return t=h.unescapeHash(t),t},h.setTitle=function(e){var t=e.title,n;t||(n=h.getStateByIndex(0),n&&n.url===e.url&&(t=n.title||h.options.initialTitle));try{r.getElementsByTagName("title")[0].innerHTML=t.replace("<","&lt;").replace(">","&gt;").replace(" & "," &amp; ")}catch(i){}return r.title=t,h},h.queues=[],h.busy=function(e){typeof e!="undefined"?h.busy.flag=e:typeof h.busy.flag=="undefined"&&(h.busy.flag=!1);if(!h.busy.flag){u(h.busy.timeout);var t=function(){var e,n,r;if(h.busy.flag)return;for(e=h.queues.length-1;e>=0;--e){n=h.queues[e];if(n.length===0)continue;r=n.shift(),h.fireQueueItem(r),h.busy.timeout=o(t,h.options.busyDelay)}};h.busy.timeout=o(t,h.options.busyDelay)}return h.busy.flag},h.busy.flag=!1,h.fireQueueItem=function(e){return e.callback.apply(e.scope||h,e.args||[])},h.pushQueue=function(e){return h.queues[e.queue||0]=h.queues[e.queue||0]||[],h.queues[e.queue||0].push(e),h},h.queue=function(e,t){return typeof e=="function"&&(e={callback:e}),typeof t!="undefined"&&(e.queue=t),h.busy()?h.pushQueue(e):h.fireQueueItem(e),h},h.clearQueue=function(){return h.busy.flag=!1,h.queues=[],h},h.stateChanged=!1,h.doubleChecker=!1,h.doubleCheckComplete=function(){return h.stateChanged=!0,h.doubleCheckClear(),h},h.doubleCheckClear=function(){return h.doubleChecker&&(u(h.doubleChecker),h.doubleChecker=!1),h},h.doubleCheck=function(e){return h.stateChanged=!1,h.doubleCheckClear(),h.bugs.ieDoubleCheck&&(h.doubleChecker=o(function(){return h.doubleCheckClear(),h.stateChanged||e(),!0},h.options.doubleCheckInterval)),h},h.safariStatePoll=function(){var t=h.extractState(h.getLocationHref()),n;if(!h.isLastSavedState(t))return n=t,n||(n=h.createStateObject()),h.Adapter.trigger(e,"popstate"),h;return},h.back=function(e){return e!==!1&&h.busy()?(h.pushQueue({scope:h,callback:h.back,args:arguments,queue:e}),!1):(h.busy(!0),h.doubleCheck(function(){h.back(!1)}),p.go(-1),!0)},h.forward=function(e){return e!==!1&&h.busy()?(h.pushQueue({scope:h,callback:h.forward,args:arguments,queue:e}),!1):(h.busy(!0),h.doubleCheck(function(){h.forward(!1)}),p.go(1),!0)},h.go=function(e,t){var n;if(e>0)for(n=1;n<=e;++n)h.forward(t);else{if(!(e<0))throw new Error("History.go: History.go requires a positive or negative integer passed.");for(n=-1;n>=e;--n)h.back(t)}return h};if(h.emulated.pushState){var v=function(){};h.pushState=h.pushState||v,h.replaceState=h.replaceState||v}else h.onPopState=function(t,n){var r=!1,i=!1,s,o;return h.doubleCheckComplete(),s=h.getHash(),s?(o=h.extractState(s||h.getLocationHref(),!0),o?h.replaceState(o.data,o.title,o.url,!1):(h.Adapter.trigger(e,"anchorchange"),h.busy(!1)),h.expectedStateId=!1,!1):(r=h.Adapter.extractEventData("state",t,n)||!1,r?i=h.getStateById(r):h.expectedStateId?i=h.getStateById(h.expectedStateId):i=h.extractState(h.getLocationHref()),i||(i=h.createStateObject(null,null,h.getLocationHref())),h.expectedStateId=!1,h.isLastSavedState(i)?(h.busy(!1),!1):(h.storeState(i),h.saveState(i),h.setTitle(i),h.Adapter.trigger(e,"statechange"),h.busy(!1),!0))},h.Adapter.bind(e,"popstate",h.onPopState),h.pushState=function(t,n,r,i){if(h.getHashByUrl(r)&&h.emulated.pushState)throw new Error("History.js does not support states with fragement-identifiers (hashes/anchors).");if(i!==!1&&h.busy())return h.pushQueue({scope:h,callback:h.pushState,args:arguments,queue:i}),!1;h.busy(!0);var s=h.createStateObject(t,n,r);return h.isLastSavedState(s)?h.busy(!1):(h.storeState(s),h.expectedStateId=s.id,p.pushState(s.id,s.title,s.url),h.Adapter.trigger(e,"popstate")),!0},h.replaceState=function(t,n,r,i){if(h.getHashByUrl(r)&&h.emulated.pushState)throw new Error("History.js does not support states with fragement-identifiers (hashes/anchors).");if(i!==!1&&h.busy())return h.pushQueue({scope:h,callback:h.replaceState,args:arguments,queue:i}),!1;h.busy(!0);var s=h.createStateObject(t,n,r);return h.isLastSavedState(s)?h.busy(!1):(h.storeState(s),h.expectedStateId=s.id,p.replaceState(s.id,s.title,s.url),h.Adapter.trigger(e,"popstate")),!0};if(s){try{h.store=l.parse(s.getItem("History.store"))||{}}catch(m){h.store={}}h.normalizeStore()}else h.store={},h.normalizeStore();h.Adapter.bind(e,"unload",h.clearAllIntervals),h.saveState(h.storeState(h.extractState(h.getLocationHref(),!0))),s&&(h.onUnload=function(){var e,t,n;try{e=l.parse(s.getItem("History.store"))||{}}catch(r){e={}}e.idToState=e.idToState||{},e.urlToId=e.urlToId||{},e.stateToId=e.stateToId||{};for(t in h.idToState){if(!h.idToState.hasOwnProperty(t))continue;e.idToState[t]=h.idToState[t]}for(t in h.urlToId){if(!h.urlToId.hasOwnProperty(t))continue;e.urlToId[t]=h.urlToId[t]}for(t in h.stateToId){if(!h.stateToId.hasOwnProperty(t))continue;e.stateToId[t]=h.stateToId[t]}h.store=e,h.normalizeStore(),n=l.stringify(e);try{s.setItem("History.store",n)}catch(i){if(i.code!==DOMException.QUOTA_EXCEEDED_ERR)throw i;s.length&&(s.removeItem("History.store"),s.setItem("History.store",n))}},h.intervalList.push(a(h.onUnload,h.options.storeInterval)),h.Adapter.bind(e,"beforeunload",h.onUnload),h.Adapter.bind(e,"unload",h.onUnload));if(!h.emulated.pushState){h.bugs.safariPoll&&h.intervalList.push(a(h.safariStatePoll,h.options.safariPollInterval));if(i.vendor==="Apple Computer, Inc."||(i.appCodeName||"")==="Mozilla")h.Adapter.bind(e,"hashchange",function(){h.Adapter.trigger(e,"popstate")}),h.getHash()&&h.Adapter.onDomLoad(function(){h.Adapter.trigger(e,"hashchange")})}},(!h.options||!h.options.delayInit)&&h.init()}(window)
},{}],3:[function(require,module,exports){
var PaletteElement = require('../../oui/util/PaletteElement.js');
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module("omniscriptDesigner")
.controller("elementPalette", function($rootScope, $scope, remoteActions, isIntegrationProcedure) {
  $scope.groupedControlsGroupCollapse = $scope.navigationGroupCollapse = $scope.inputControlsGroupCollapse = false;

  if (isIntegrationProcedure) {
    remoteActions.loadIntegrationProcedureElementTypes().then(function(elementTypes){
      $scope.allElements = elementTypes.filter(function(element){
                              return !/(Button)/gi.test(element);
                            }).sort().map(function(element){
                              return PaletteElement.factory(element);
                            });
      $rootScope.$broadcast("elementTypesLoaded");
    });
  } else {
    remoteActions.getReusableOmniScripts().then(function(reusableScripts){
      $scope.reusableScripts = reusableScripts.map(function(script){
        return PaletteElement.factory(new ScriptElement(script));
      }).sort();
    });

    remoteActions.loadElementTypes().then(function(elementTypes){
      $scope.allElements = elementTypes.filter(function(element){
                              return !/(Button)/gi.test(element);
                            }).sort().map(function(element){
                              return PaletteElement.factory(element);
                            });
      $rootScope.$broadcast("elementTypesLoaded");
    });
  }
});
},{"../../oui/util/CanvasElement.js":48,"../../oui/util/PaletteElement.js":51,"../../oui/util/ScriptElement.js":53}],4:[function(require,module,exports){
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module("omniscriptDesigner")
.controller("omniscriptDesignerController", function($rootScope, $scope, $q, remoteActions, fixMissingPropertiesFilter,
                                                      $location, $timeout, save, $localizable, $modal, isIntegrationProcedure) {

  var urlPrefix = window.location.protocol + "//" + window.location.hostname;

  var omniScriptId = window.location ? window.location.href.split(/[?&]/).find(function(item){
    return /^id\=/.test(item);
  }) : null;

  function sortByOrder(a, b){
    if (a.Order__c === undefined) {
      return (b.Order__c === undefined) ? 0 : 1;
    } else if (b.Order__c === undefined) {
      return -1;
    }
    return a.Order__c - b.Order__c;
  }

  var defaultConfigForScriptElement = {
    "Name": $localizable(isIntegrationProcedure ? "IntProcNewIntProc" : "OmniDesNewOmniScript")
  };
  defaultConfigForScriptElement[fileNsPrefix() + 'IsProcedure__c'] = !!isIntegrationProcedure;

  // Fix weird sandbox issue where this file does not exist
  remoteActions.ensureDocumentUploads();

  if (omniScriptId) {
    omniScriptId = omniScriptId.replace(/^id=/, '');
    remoteActions.getOmniScript(omniScriptId)
      .then(function(omniScriptResult){
        if (omniScriptResult) {
          $rootScope.scriptElement = new ScriptElement(omniScriptResult);
          if ($rootScope.scriptElement.IsActive__c) {
            var pageDescription = $(".pageDescription");
            pageDescription.append("&nbsp;<span class='active text-success'>" + $localizable("OmniDesActive") + "</span>");
            pageDescription.addClass("vlocity");
          }
        } else {
          $rootScope.scriptElement = new ScriptElement(defaultConfigForScriptElement);
        }
        $rootScope.$broadcast("activeElementInCanvas", $rootScope.scriptElement);
      });
      $rootScope.$on("elementTypesLoaded", function() {
        remoteActions.getElements(omniScriptId)
          .then(function(elements){
            var transformedElements = [],
                inProgressMap = {};
            elements.forEach(function(elementPreConvert) {
              var element = CanvasElement.fromJson(elementPreConvert);
              if (element) {
                fixMissingPropertiesFilter(element);
                transformedElements.push(element);
                inProgressMap[element.Id] = element;
              }
            });
            for (i = 0; i < transformedElements.length; i++) {
              var transformedElement = transformedElements[i];
              if (transformedElement.ParentElementId__c) {
                if (inProgressMap[transformedElement.ParentElementId__c]) {
                  inProgressMap[transformedElement.ParentElementId__c].children.push(transformedElement);
                }
                transformedElements.splice(i, 1);
                i--;
              }
            }
            transformedElements.forEach(function(transformedElement) {
              $rootScope.scriptElement.children.push(transformedElement);
            });
            $rootScope.scriptElement.each(function(element){
              if (element.children) {
                element.children.sort(sortByOrder);
              }
            });
          });
      });
  } else {
    $rootScope.scriptElement = new ScriptElement(defaultConfigForScriptElement);
    $timeout(function() {
      $rootScope.$broadcast("activeElementInCanvas", $rootScope.scriptElement);
    }, 100);
  }

  $scope.saveOmniScript = function() {
    return save($rootScope.scriptElement);
  };

  $scope.toggleCollapsePalette = function() {
    $rootScope.collapsePalette = !$rootScope.collapsePalette;
  };

  $scope.toggleFullScreen = function() {
    $rootScope.fullScreen = !$rootScope.fullScreen;
  };

  $scope.showHowToUse = function() {
    var modal = $modal({
        title: 'How to launch',
        templateUrl: 'modal-how-to-use-this.tpl.html',
        show: false, html:true,
        controller: function($scope, $timeout) {
          var pageToMode = {
            "Universal Page": "OmniScriptUniversalPage",
            "Universal Page with Header": "OmniScriptUniversalPageWHeader",
            "Universal Page with Header/Sidebar": "OmniScriptUniversalPageWHeaderSidebar",
            "Mobile": "OmniScriptUniversalMobilePage",
            "Communities": "OmniScriptUniversalCommunitiesPage",
            "Console": "OmniScriptUniversalPageConsole"
          };
          $scope.modes = Object.keys(pageToMode);
          $scope.currentMode = $scope.modes[0];
          $scope.vertOrHoriz = "vertical";
          $scope.$watch("currentMode", buildUrl);
          $scope.$watch("vertOrHoriz", buildUrl);

          function buildUrl() {
            var lightningParam = ($scope.vertOrHoriz === 'lightning' && ($scope.currentMode !== 'Mobile' || $scope.currentMode !== 'Communities')) ? '&layout=lightning' :'',
                verHor = ($scope.vertOrHoriz === "vertical");
            if($scope.vertOrHoriz === 'lightning' && ($scope.currentMode !== 'Mobile' || $scope.currentMode !== 'Communities'))
                verHor = true;

            $scope.url = urlPrefix + "/apex/" + window.ns +
              pageToMode[$scope.currentMode] + "?id={0}" + lightningParam + "#/OmniScriptType/" + $rootScope.scriptElement.Type__c +
              "/OmniScriptSubType/" + $rootScope.scriptElement.SubType__c +
              "/OmniScriptLang/" + $rootScope.scriptElement.Language__c +
              "/ContextId/{0}/PrefillDataRaptorBundle//" + verHor;

            if($scope.vertOrHoriz === 'lightning' && ($scope.currentMode === 'Mobile' || $scope.currentMode === 'Communities'))
                $scope.vertOrHoriz = 'vertical';
            lightningParam = ($scope.vertOrHoriz === 'lightning' && ($scope.currentMode !== 'Mobile' || $scope.currentMode !== 'Communities'))  ? "&scriptMode=vertical&layout=" + $scope.vertOrHoriz : "&scriptMode=" + $scope.vertOrHoriz;

            $scope.urlWithParam = urlPrefix + "/apex/" + window.ns +
              pageToMode[$scope.currentMode] + "?id={0}&OmniScriptType=" + encodeURIComponent($rootScope.scriptElement.Type__c) +
              "&OmniScriptSubType=" + encodeURIComponent($rootScope.scriptElement.SubType__c) +
              "&OmniScriptLang=" + encodeURIComponent($rootScope.scriptElement.Language__c) +
              "&PrefillDataRaptorBundle=" + lightningParam + '&ContextId={0}';
          }

          var nsPrefix = window.ns.replace(/__$/, "");
          var appName = $rootScope.scriptElement.Name.replace(/( |_|-)/gi, "");
          var elementPrefix = (nsPrefix || nsPrefix === '' ? nsPrefix : "c") + ":" ;

          $scope.onChangeisLightning = function(scp) {
               if($scope.isLightning)
                   $scope.textarea = $scope.txtareaLightning;
               else
                   $scope.textarea = $scope.txtarea;
          };

          var xmls = 'http://www.w3.org/2000/svg',
              xlink = 'http://www.w3.org/1999/xlink';

          $scope.txtareaLightning = "<apex:page standardStylesheets=\"false\" "+
                              "showHeader=\"false\" sidebar=\"false\" docType=\"html-5.0\">\n" +
                            "\t<div class=\"vlocity via-slds\" xmlns=\"" + xmls + "\" xmlns:xlink=\"" + xlink + "\" ng-app=\"" + appName + "\">\n" +
                            "\t\t<"+elementPrefix+"BusinessProcessComponent\n" +
                              "\t\t\tstrOmniScriptType=\"" + $rootScope.scriptElement.Type__c + "\"\n" +
                              "\t\t\tstrOmniScriptSubType=\"" + $rootScope.scriptElement.SubType__c + "\"\n" +
                              "\t\t\tstrOmniScriptLang=\"" + $rootScope.scriptElement.Language__c + "\"\n" +
                              "\t\t\tpreviewMode=\"{!$CurrentPage.parameters.previewEmbedded}\"\n" +
                              "\t\t\tverticalMode=\"{!$CurrentPage.parameters.verticalMode}\"\n" +
                              "\t\t\tstrOmniScriptId=\"{!$CurrentPage.parameters.designerPreviewId}\"\n" +
                              "\t\t\tscriptLayout=\"lightning\"/>\n" +
                              "\t\t<script type=\"text/javascript\">\n" +
                              "\t\t\tvar modules = ['vlocity-business-process'];\n" +
                              "\t\t\tvar myModule = angular.module('" + appName + "', modules);\n" +
                              "\t\t</script>\n" +
                              ($rootScope.scriptElement.CustomJavaScript__c && $rootScope.scriptElement.CustomJavaScript__c !== '' ?
                                ("\t\t<script type=\"text/javascript\">\n" +
                                $rootScope.scriptElement.CustomJavaScript__c +
                                "\n\t\t</script>\n") : '') +
                              $rootScope.scriptElement.TestHTMLTemplates__c +
                            "\n\t</div>\n" +
                            "\t<"+elementPrefix+"VFActionFunction/> \n" +
                          "</apex:page>";

          $scope.txtarea = "<apex:page standardStylesheets=\"false\" "+
                              "showHeader=\"true\" sidebar=\"true\" docType=\"html-5.0\">\n" +
                            "\t<div class=\"vlocity via-slds\" xmlns=\"" + xmls + "\" xmlns:xlink=\"" + xlink + "\" ng-app=\"" + appName + "\">\n" +
                            "\t\t<"+elementPrefix+"BusinessProcessComponent\n" +
                              "\t\t\tstrOmniScriptType=\"" + $rootScope.scriptElement.Type__c + "\"\n" +
                              "\t\t\tstrOmniScriptSubType=\"" + $rootScope.scriptElement.SubType__c + "\"\n" +
                              "\t\t\tstrOmniScriptLang=\"" + $rootScope.scriptElement.Language__c + "\"\n" +
                              "\t\t\tpreviewMode=\"{!$CurrentPage.parameters.previewEmbedded}\"\n" +
                              "\t\t\tverticalMode=\"{!$CurrentPage.parameters.verticalMode}\"\n" +
                              "\t\t\tstrOmniScriptId=\"{!$CurrentPage.parameters.designerPreviewId}\"/>\n" +
                              "\t\t<script type=\"text/javascript\">\n" +
                              "\t\t\tvar modules = ['vlocity-business-process'];\n" +
                              "\t\t\tvar myModule = angular.module('" + appName + "', modules);\n" +
                              "\t\t</script>\n" +
                              ($rootScope.scriptElement.CustomJavaScript__c && $rootScope.scriptElement.CustomJavaScript__c !== '' ?
                                ("\t\t<script type=\"text/javascript\">\n" +
                                $rootScope.scriptElement.CustomJavaScript__c +
                                "\n\t\t</script>\n") : '') +
                              $rootScope.scriptElement.TestHTMLTemplates__c +
                            "\n\t</div>\n" +
                            "\t<"+elementPrefix+"VFActionFunction/> \n" +
                          "</apex:page>";

          $scope.textarea = $scope.txtarea;
        }});
    modal.$promise.then(modal.show)
        .then(function(done) {
            $timeout(function() {
              var clipboard = new Clipboard('.copy-btn');
              clipboard.on('success', function(e) {
                showTooltip(e.trigger, 'Copied!');
              });

              function showTooltip(elem, msg) {
                $(elem).addClass('tooltipped tooltipped-s');
                elem.setAttribute('aria-label', msg);
                $(elem).on('mouseleave', function(e) {
                    $(elem).removeClass('tooltipped tooltipped-s');
                    elem.removeAttribute('aria-label');
                });
              }
            });
        });
  };

  $scope.viewFullDataJson = function() {
    var modal = $modal({
        title: $localizable("OmniDesFullDataJsonModalTitle"),
        templateUrl: 'modal-view-full-data-json.tpl.html',
        show: false, html:true,
        controller: function($scope, $timeout) {
            $scope.initFullDataJson = function(){
                $scope.loading = true;
                var scriptId = window.location ? window.location.href.split(/[?&]/).find(function(item){return /^id\=/.test(item);}) : null;
                if (scriptId) {
                    scriptId = scriptId.replace(/^id=/, '');
                    remoteActions.viewFullDataJson(scriptId)
                        .then(function(omniScriptResult){
                        $scope.loading = false;
                        $scope.dataJson =  omniScriptResult.replace(/&quot;/g, '"');
                        $scope.dataJson = JSON.stringify(JSON.parse($scope.dataJson), null, 4);
                    });
                }
            }
        }});

    modal.$promise.then(modal.show)
        .then(function(done) {
            $timeout(function() {
              var clipboard = new Clipboard('.copy-btn');
              clipboard.on('success', function(e) {
                showTooltip(e.trigger, 'Copied!');
              });

              function showTooltip(elem, msg) {
                $(elem).addClass('tooltipped tooltipped-s');
                elem.setAttribute('aria-label', msg);
                $(elem).on('mouseleave', function(e) {
                    $(elem).removeClass('tooltipped tooltipped-s');
                    elem.removeAttribute('aria-label');
                });
              }
            });
        });
  };
});
},{"../../oui/util/CanvasElement.js":48,"../../oui/util/ScriptElement.js":53}],5:[function(require,module,exports){
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');
var Property = require('../../oui/util/Property.js');

(function () {
    'use strict';
    var angular = window.angular;

    angular.module('omniscriptDesigner')
        .controller('propertiesController', function($rootScope, $scope, $modal, remoteActions, propertyLayoutFilter,
						                             save, $timeout, templateForPropertyFilter, optionsForPropertyFilter,
						                             $localizable, tinyMCEService, propertyEditorModalService, linkForPropertyFilter, isIntegrationProcedure) {
            $scope.showJsonEditor = false;
            $scope.testTemplatesCollapse = $scope.customJsCollapse = true;
            $scope.propertySetAsText = '';
            $scope.allFieldsForObjects = {};
            $scope.viewModel = {
                filterOptions: [
                    '=', '<', '>', '<=', '>=',
                    'LIKE', 'NOT LIKE', '<>', 'INCLUDES', 'EXCLUDES'
                ]
            };

            var stylesheetref = $('link[rel=stylesheet]').filter(function() {
                return /vlocity\.css/.test(this.getAttribute('href'));
            });

            var tinyMCE = window.tinyMCE;

            $scope.tinymceOptions = {
                body_class: 'vlocity',
                menubar: true,
                elementpath: false,
                plugins: [
                    'code advlist autolink lists link image charmap preview hr anchor pagebreak',
                    'searchreplace wordcount visualblocks visualchars code fullscreen',
                    'insertdatetime table media nonbreaking contextmenu directionality',
                    'template paste textcolor colorpicker textpattern imagetools ' + tinyMCEService.plugins
                ],
                imagetools_toolbar: 'imageoptions',
                menu: {
                    edit: {title: 'Edit', items: 'undo redo | cut copy paste pastetext | selectall'},
                    insert: {title: 'Insert', items: 'link image | anchor hr charmap insertdatetime'},
                    view: {title: 'View', items: 'visualaid preview '},
                    format: {title: 'Format', items: 'bold italic underline strikethrough superscript subscript | formats | removeformat'},
                    table: {title: 'Table', items: 'inserttable tableprops deletetable | cell row column'},
                    tools: {title: 'Tools', items: 'spellchecker code'}
                },
                default_link_target: '_blank',
                file_browser_callback: function(field_name, url, type, win) {
                    tinyMCEService.openDocInsertWindow(tinyMCE, field_name, type);
                },
                toolbar1: 'undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
                toolbar2: 'preview | forecolor backcolor | code | example | ltr rtl',
                content_css : stylesheetref[0].getAttribute('href'),
                extended_valid_elements: 'button[*],a[*],p[*],ul[*],input[*],li[*],nav[*],script[language|type|src|defer],select[*]',
                forced_root_block: 'p'
            };

            $scope.conditions = [
	            {
                    value: '=',
                    label: $localizable('OmniDesIsEqualTo')
	            },{
                    value: '<>',
                    label: $localizable('OmniDesDoesNotEqual')
	            },{
                    value: '<',
                    label: $localizable('OmniDesIsLessThan')
	            },{
                    value: '>',
                    label: $localizable('OmniDesIsGreaterThan')
	            },{
                    value: '<=',
                    label: $localizable('OmniDesIsLessThanEqual')
	            },{
                    value: '>=',
                    label: $localizable('OmniDesIsGreaterThanEqual')
	            }
            ];

            $scope.operators = [
	            {
                    value: 'AND',
                    label: $localizable('OmniDesAnd')
	            },{
                    value: 'OR',
                    label: $localizable('OmniDesOr')
	            }
            ];

            $scope.dataSourceTypes = [{
                label: $localizable('OmniDesSObject'),
                value: 'SObject'
            } ,{
                label: $localizable('OmniDesCustom'),
                value: 'Custom'
            }];

            $scope.tooltips = {
                inputParameters: {
                    title: $localizable('OmniDesTipInputParam')
                },
                dataSource: {
                    title: $localizable('OmniDesTipDataSource')
                },
                lookupQueryConfiguration: {
                    title: $localizable('OmniDesTipLookupQryCfg')
                },
                filterValue: {
                    title: $localizable('OmniDesTipFilterValue')
                },
                lookupObjectName: {
                    title: $localizable('OmniDesTipLookupObjectName')
                },
                jsonPath: {
                    title: $localizable('OmniDesTipJsonPath')
                },
                populateLookupElementWithQueryResult: {
                    title: $localizable('OmniDesTipPopulate')
                },
                jsonPathFieldNameName: {
                    title: $localizable('OmniDesTipJsonPathFieldNameName')
                },
                jsonPathFieldNameValue: {
                    title: $localizable('OmniDesTipJsonPathFieldNameValue')
                },
                docuSignRoutingOrder: {
                    title: $localizable('OmniDesDocuRoutingTooltip')
                },
                docuSignReturnUrl: {
                    title: $localizable('OmniDesDocuSignReturnPageTooltip')
                },
                docuSignIncludeToSend: {
                    title: $localizable('OmniDesDocuIncludeTooltip')
                },
                // NEW TOOLTIP LABELS
                fieldNameName: {
                    title: $localizable('OmniDesTipFieldNameName')
                },
                fieldNameValue: {
                    title: $localizable('OmniDesTipFieldNameValue')
                },
                autoAdvance: {
                    title: $localizable('OmniDesTipAutoAdvance')
                },
                svgSprite: {
                    title: $localizable('OmniDesEditBlockSvgSpriteTooltip')
                },
                elementName: {
                    title: $localizable('OmniDesEditBlockElementNameTooltip')
                },
                selectCheckBox: {
                    title: $localizable('OmniDesEditBlockSelectCheckBoxTooltip')
                },
                lightningDesignOnly: {
                    title: $localizable('OmniDesLightningDesignOnlyTooltip')
                },
                sumElement: {
                    title: $localizable('OmniDesEditBlockSumElementTooltip')
                }
            };

            $scope.tooltipElements = {
                'svgSprite':'svgSprite',
                'elementName':'elementName',
                'selectCheckBox':'selectCheckBox',
                'showInputWidth': 'showInputWidth',
                'Script Configuration': 'Script Configuration',
                'sumElement': 'sumElement'
            }

            $scope.toggleJsonEditor = function() {
                $scope.showJsonEditor = !$scope.showJsonEditor;
            };

            remoteActions.getAllObjects().then(function(allObjects) {
                $scope.sobjectTypes = allObjects.sort(function(a, b) {
                    return a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
                });
                if ($scope.sobjectTypes.length > 0) {
                    $scope.loadFieldsFor($scope.sobjectTypes[0].name);
                }
            });

            $scope.loadFieldsFor = function(object) {
                remoteActions.getFieldsForObject(object).then(function(fields) {
                    $scope.allFieldsForObjects[object] = fields;
                });
            };

            $scope.onJsonChange = function(propSetAsText) {
                $scope.propertySetAsText = propSetAsText;
            };

            $scope.addNewMapping = function(mappingArray) {
                mappingArray.push({
                    'InterfaceObjectLookupOrder__c':1,
                    'InterfaceObjectName__c':'',
                    'DomainObjectFieldAPIName__c':'',
                    'FilterValue__c':'',
                    'InterfaceFieldAPIName__c':'',
                    'FilterOperator__c':'='
                });
            };

            $scope.deleteMapping = function(mapping, mappingArray) {
                mappingArray.splice(mappingArray.indexOf(mapping), 1);
                if (mappingArray.length === 0) {
                    $scope.addNewMapping(mappingArray);
                }
            };

            $scope.addNewInputParameter = function(inputParamArray) {
                inputParamArray.push({
                    'inputParam':'',
                    'element':''
                });
            };

            $scope.deleteInputParameter = function(inputParam, inputParamArray) {
                inputParamArray.splice(inputParamArray.indexOf(inputParam), 1);
            };

            $scope.$watch('activeElement.Type__c', function() {
                if ($scope.activeElement instanceof ScriptElement) {
                    var subTypeFound = false;
                    for(var i=0; i<$scope.layoutrows.length&&!subTypeFound; i++){
                        for(var j=0; j<$scope.layoutrows[i].length&&!subTypeFound; j++){
                            if ($scope.layoutrows[i][j] && /SubType__c/.test($scope.layoutrows[i][j].label)){
                                $scope.layoutrows[i][j].currentValue = null;
                                $scope.layoutrows[i][j].update();
                                subTypeFound=true;
                            }
                        }
                    }
                }
            });

            $scope.$watch('activeElement.Language__c', function() {
                if ($scope.activeElement instanceof ScriptElement) {
                    $scope.layoutrows.forEach(function(row) {
                        row.forEach(function(property) {
                            if (property && /Language__c/.test(property.label)) {
                                property.currentValue = $scope.activeElement.Language__c;
                                property.update();
                            }
                        });
                    });
                }
            });

            $scope.$watch('propertySetAsText', function(newValue, oldValue) {
                try {
                    if ($scope.showJsonEditor) {
                        $scope.activeElement.PropertySet__c = JSON.parse($scope.propertySetAsText);
                        $scope.propertySetInvalid = false;
                        $scope.layoutrows.forEach(function(row) {
                            row.forEach(function(property) {
                                if (property) {
                                    property.initializeCurrentValue();
                                    property.update();
                                }
                            });
                        });
                    }
                } catch (exp) {
                    $scope.propertySetInvalid = true;
                }

                /* jshint -W030 */
                $scope.layoutrows && ($scope.layoutrows.forEach(function(row) {
                    if (row[0] && row[0].label === 'visualforcePagesAvailableInPreview') {
                        $scope.$emit('customViewUpdated', row[0].currentValue);
                    }
                }));

            });

            $scope.asProperty = function(key, property, activeElement, index) {
                return new Property('' + key, property, activeElement, true);
            };

            $rootScope.$on('activeElementInCanvas', function(event, args) {
                if (angular.isString(args)) {
                    $scope.activeElement = CanvasElement.getById(args);
                } else {
                    $scope.activeElement = args;                    
                    if($scope.activeElement && $scope.activeElement.Type__c && /Checkbox/.test($scope.activeElement.Type__c.label) &&
                       $scope.activeElement.PropertySet__c) {
                        $scope.activeElement.PropertySet__c.checkLabel =  $scope.activeElement.PropertySet__c.checkLabel || $scope.activeElement.PropertySet__c.label;
                    }
                }
                if (!$scope.activeElement) {
                    $scope.activeElement = $rootScope.scriptElement;
                }
                var isScriptElement = $scope.activeElement === $rootScope.scriptElement;
                $scope.layoutrows = [[new Property(window.i18n.OmniDesPropertySetLoading, 'spinner')]];

                var type = isScriptElement ? $rootScope.scriptElement.CanvasType : (
                    (!isScriptElement && $scope.activeElement.Type__c.type == 'OmniScript') ?
                        $scope.activeElement.Type__c.type : $scope.activeElement.type());

                remoteActions.loadPropertySetForElement(type, $rootScope.scriptElement.IsProcedure__c)
	                .then(function(textJson) {
                        if (!textJson || textJson.result === '') {
                            textJson = JSON.stringify($scope.activeElement.PropertySet__c);
                        }
                        var defaultProperties = JSON.parse(textJson.replace(/\&quot;/gi, '"'));
                        $scope.activeElement.setDefaultPropertySet(textJson.replace(/\&quot;/gi, '"'));
                        var properties = [
                            new Property('Name', $scope.activeElement.Name, $scope.activeElement, true)
                        ];
                        if (!isScriptElement && $scope.activeElement.Type__c && $scope.activeElement.Type__c.type != 'OmniScript') {
                            properties = properties.concat([
                                new Property('InternalNotes__c', $scope.activeElement.Name, $scope.activeElement, true)
                            ]);
                        }
                        if (isScriptElement) {
                            properties = properties.concat([
                                                   new Property('Type__c', $scope.activeElement.Type__c, $scope.activeElement, true),
                                                   new Property('SubType__c', $scope.activeElement.SubType__c, $scope.activeElement, true),
                                                   new Property('DataRaptorBundleId__c', $scope.activeElement.DataRaptorBundleId__c, $scope.activeElement, true)]);
                            if (!isIntegrationProcedure) {
                                properties = properties.concat([
                                    new Property('Language__c', $scope.activeElement.Language__c, $scope.activeElement, true),
                                    new Property('IsReusable__c', $scope.activeElement.IsReusable__c, $scope.activeElement, true)
                                ]);
                            }
                            properties = properties.concat([   
                                new Property('AdditionalInformation__c', $scope.activeElement.AdditionalInformation__c, $scope.activeElement, true)
                            ]);
                        } else if (!isScriptElement && $scope.activeElement.Type__c && $scope.activeElement.Type__c.type == 'OmniScript') {
                            // we're intentionally removing the "Name" property for OmniScripts
                            // the Name is the name of the matching OmniScript - this can't be changed.
                            properties = [
                                                   new Property('Type', $scope.activeElement.PropertySet__c.Type, $scope.activeElement, true),
                                                   new Property('Sub Type', $scope.activeElement.PropertySet__c['Sub Type'], $scope.activeElement, true),
                                                   new Property('Language', $scope.activeElement.PropertySet__c.Language, $scope.activeElement, true)
                            ];
                            // wipe out the values on the server for this
                            defaultProperties.Type = defaultProperties['Sub Type'] = defaultProperties.Language = undefined;
                        }
                        for (var prop in defaultProperties) {
                            if (defaultProperties.hasOwnProperty(prop)) {
                                properties.push(new Property(prop, defaultProperties[prop], $scope.activeElement, true));
                                if (angular.isUndefined($scope.activeElement.PropertySet__c[prop])) {
                                    $scope.activeElement.PropertySet__c[prop] = defaultProperties[prop];
                                }
                                if (prop === 'show') {
                                    $scope.showProperty = properties[properties.length - 1];
                                    $scope.rule = $scope.activeElement.PropertySet__c[$scope.showProperty.label];
                                } else if (prop === 'conditionType') {
                                    $scope.showPropertyConditionType = properties[properties.length - 1];
                                }
                                if (prop === 'dataSource' &&
                                    $scope.activeElement.PropertySet__c[prop] &&
                                    $scope.activeElement.PropertySet__c[prop].type === 'SObject') {
                                    // load fields for all sObjects for UI
                                    var existingMapItems = $scope.activeElement.PropertySet__c[prop].mapItems.phase1MapItems,
                                        objectsBeingLoaded = {};
                                    for (var i = 0; i < existingMapItems.length; i++) {
                                        if (!objectsBeingLoaded[existingMapItems[i].InterfaceObjectName__c]) {
                                            $scope.loadFieldsFor(existingMapItems[i].InterfaceObjectName__c);
                                            objectsBeingLoaded[existingMapItems[i].InterfaceObjectName__c] = true;
                                        }
                                    }
                                }
                            }
                        }
                        $scope.layoutrows = propertyLayoutFilter(properties, $scope.activeElement);

                        //emits an event and then the select updates the list
                        angular.forEach($scope.layoutrows, function(row) {
                            if (row[0] && row[0].label === 'visualforcePagesAvailableInPreview') {
                                $scope.$emit('customViewUpdated', row[0].currentValue);
                            }
                        });

                        $scope.propertySetAsText = JSON.stringify($scope.activeElement.PropertySet__c, null, 4);

	                });

                $scope.showJsonEditor = false;
            });

            function without(obj, keys) {
                return Object.keys(obj).filter(function (key) {
                    return keys.indexOf(key) === -1;
                }).reduce(function (result, key) {
                    result[key] = obj[key];
                    return result;
                }, {});
            }

            // save changes on every call
            var timeouts = {};
            $scope.$watch(function() {
                if ($scope.activeElement) {
                    return without($scope.activeElement, ['parent', 'children', 'saving', 'collapse',
						                                  'errors', 'allowDrop', 'originalJson', 'filter', 'deleted', 'deleting']);
                } else {
                    return [];
                }
            }, _.debounce(function(newValue, oldValue) {
                if (newValue !== oldValue) {
                    var elementToSave = $scope.activeElement;
                    if (elementToSave &&
                        // only autosave script element if it has an ID,
                        //i.e. it has been explicitly saved already
                        !(elementToSave instanceof ScriptElement && !elementToSave.Id)) {
                        if (elementToSave.Id && timeouts[elementToSave.Id]) {
                            $timeout.cancel(timeouts[elementToSave.Id]);
                        }
                        timeouts[elementToSave.Id] = $timeout(function() {
                            save(elementToSave);
                            $rootScope.$broadcast('elementPropertyChanged');
                        }, 750);
                        $scope.propertySetAsText = JSON.stringify($scope.activeElement.PropertySet__c, null, 4);
                    }
                }
            }, 250), true);

            $scope.$watch('activeElement.PropertySet__c.dataSource.type', function(newValue, oldValue) {
                if (!$scope.activeElement) {
                    return;
                }
                var existingDatasourceCfg = $scope.activeElement.PropertySet__c.dataSource;
                if (newValue && $scope.activeElement.PropertySet__c.dataSource.type === 'Custom') {
                    if (!existingDatasourceCfg ||
                        (existingDatasourceCfg.source === '' ||
                         !existingDatasourceCfg.source)) {
                        $scope.activeElement.PropertySet__c.dataSource = {
                            type: 'Custom',
                            source: '',
                            mapItems: {}
                        };
                    }
                } else if (newValue) {
                    // only reset if there's no existing items
                    if (!existingDatasourceCfg || !existingDatasourceCfg.mapItems ||
                        (!existingDatasourceCfg.mapItems.phase1MapItems || existingDatasourceCfg.mapItems.phase1MapItems.length === 0) &&
                        (!existingDatasourceCfg.mapItems.phase2MapItems ||  existingDatasourceCfg.mapItems.phase2MapItems.length === 0)) {
                        $scope.activeElement.PropertySet__c.dataSource = {
                            type: 'SObject',
                            source: '',
                            mapItems: {
                                phase1MapItems: [{
                                    'InterfaceObjectLookupOrder__c': 1,
                                    'InterfaceObjectName__c':null,
                                    'DomainObjectFieldAPIName__c':'',
                                    'FilterValue__c':'',
                                    'InterfaceFieldAPIName__c':'',
                                    'FilterOperator__c':'='
                                }],
                                phase2MapItems: [
		                            {
                                    'DomainObjectFieldAPIName__c':'name',
                                    'InterfaceFieldAPIName__c':'',
                                    'DomainObjectAPIName__c':'JSON',
                                    'DomainObjectCreationOrder__c':1
		                            },
		                            {
                                    'DomainObjectFieldAPIName__c':'value',
                                    'InterfaceFieldAPIName__c':'',
                                    'DomainObjectAPIName__c':'JSON',
                                    'DomainObjectCreationOrder__c':1
		                            }],
                                inputParameters:[]
                            }
                        };
                    } else {
                        // first fix up broken ones that were created in the designer (missed the name)
                        if (existingDatasourceCfg.mapItems.phase2MapItems[0].DomainObjectFieldAPIName__c === '') {
                            existingDatasourceCfg.mapItems.phase2MapItems[0].DomainObjectFieldAPIName__c = 'name';
                        }
                        if (existingDatasourceCfg.mapItems.phase2MapItems[1].DomainObjectFieldAPIName__c === '') {
                            existingDatasourceCfg.mapItems.phase2MapItems[1].DomainObjectFieldAPIName__c = 'value';
                        }
                        // fix up the sort order of the existing phase2MapItems so the "name" comes first
                        existingDatasourceCfg.mapItems.phase2MapItems.sort(function(mapItem) {
                            if (mapItem.DomainObjectFieldAPIName__c === 'name') {
                                return -1;
                            } else if (mapItem.DomainObjectFieldAPIName__c === 'value') {
                                return 1;
                            }
                            return 0;
                        });
                    }
                }
            });

            $scope.getTemplateForProperty = templateForPropertyFilter;

            $scope.optionsForProperty = optionsForPropertyFilter;

            $scope.getClassForProperty = function(property) {
                if (!property) {
                    return '';
                }
                var cls = '';
                switch (property.type) {
                case 'checkbox' : cls = 'checkbox';
                    break;
                case 'object'   : cls = 'objectGroup';
                    break;
                case 'array'    : cls = 'arrayGroup';
                    break;
                default         : cls = 'form-group';
                }
                if (property.isKeyValue && property.isKeyValue()) {
                    cls += ' col-md-12';
                }
                return cls;
            };

            /* lazy loads support parameters like key value label names and tooltip values
            valName is the name of the value you want to get
            property is the property object for which you are getting it
            Zachary Sohn zsohn@vlocity.com
            */
            $scope.getMiscForProperty = function(property){
                if (property.misc===undefined){
                    var misc = new Object();
                    switch(property.label){
                        case 'saveURLPatterns':
                            misc = {
                                keyLabel:   $localizable('OmniDesFieldAPIName'),
                                valLabel:   $localizable('OmniDesURLPattern'),
                                tooltip:    $localizable('OmniDesTipSavePattern')
                            };
                            break;
                        case 'visualforcePagesAvailableInPreview':
                            misc = {
                                tooltip:    $localizable('OmniDesTipVFPagesInPreview')
                            };
                            break;
                        case 'showInputWidth':
                            misc = {
                                tooltip:    $localizable('OmniDesTipLightningOnly')
                            };break;
                        default: misc = null;
                    }
                        property.misc = misc;
                }
                return property.misc;
            }

            $scope.addNewArrayProperty = function(parentProperty) {
                var resolvedArray = parentProperty.getResolvedObject();
                var firstElement = resolvedArray[0];
                if (typeof firstElement === 'boolean') {
                    resolvedArray.push(false);
                } else if (angular.isString(firstElement)) {
                    resolvedArray.push('');
                } else {
                    resolvedArray.push(angular.copy(firstElement));
                }
            };

            $scope.deleteArrayProperty = function(parentProperty, $index) {
                var resolvedArray = parentProperty.getResolvedObject();
                resolvedArray.splice($index, 1);
                parentProperty.currentValue = resolvedArray;
                parentProperty.update();
            };

            $scope.addNewOption = function(parentProperty) {
                $scope.activeElement.PropertySet__c[parentProperty.label].push({
                    'name': null,
                    'value': null
                });
            };

            $scope.propDocSel=function(parentObject, tgtProp, imageInsert) {
                propertyEditorModalService.prepDocInsert(parentObject, tgtProp, imageInsert);
            };

            $scope.editAsExpression = function(parentObject, tgtProp, expressionOnly){
                // include elementNames as function
                propertyEditorModalService.prepExpressionEditor($scope.elementNames, parentObject, tgtProp, expressionOnly);
            };

            function NameValuePair(originalObject, parentArray, originalArray, property) {
                if (/dataRaptor Input Parameters/.test(property.label)) {
                    this.name = originalObject.element;
                    this.value = originalObject.inputParam;
                } else {
                    this.name = originalObject.name;
                    this.value = originalObject.value;
                }
                this.property = property;
                this.originalObject = originalObject;
                this.$parentArray = parentArray;
                this.originalArray = originalArray;
            }

            NameValuePair.prototype.delete = function () {
                this.originalArray.splice(this.originalArray.indexOf(this), 1);
                this.$parentArray.splice(this.$parentArray.indexOf(this), 1);
            };

            function getStringToActualType(value) {
                /* jshint eqnull:true */
                if (value == null) {
                    return value;
                } else if (value.toUpperCase() === 'TRUE' || value.toUpperCase() === 'FALSE') {
                    return (/true/i.test(value)).valueOf();
                } else {
                    var asNum = Number(value);
                    if (isNaN(asNum)) {
                        return value;
                    } else {
                        return asNum.valueOf();
                    }
                }
            }

            NameValuePair.prototype.update = function () {
                if (/dataRaptor Input Parameters/.test(this.property.label)) {
                    this.originalObject.element = this.name;
                    this.originalObject.inputParam = getStringToActualType(this.value);
                } else {
                    this.originalObject.name = this.name;
                    this.originalObject.value = getStringToActualType(this.value);
                }
            };

            var newArrayWrappers = {};
            var previousObjects = {};
            $scope.makeKeyValuePropWrapper = function(propertySet, property) {
                var originalObject = propertySet[property.label];
                if (!angular.equals(previousObjects[property.label], originalObject)) {
                    if (!newArrayWrappers[property.label]) {
                        newArrayWrappers[property.label] = [];
                    }
                    newArrayWrappers[property.label].splice(0, newArrayWrappers[property.label].length);
                    for (var i = 0; i < originalObject.length; i++) {
                        newArrayWrappers[property.label].push(new NameValuePair(originalObject[i], newArrayWrappers[property.label], originalObject, property));
                    }
                    previousObjects[property.label] = originalObject;
                }
                return newArrayWrappers[property.label];
            };

            $scope.addNewKeyValueWrapper = function(propertySet, property) {
                var newObj = null;
                if (/dataRaptor Input Parameters/.test(property.label)) {
                    newObj = {
                        inputParam: '',
                        element: ''
                    };
                } else {
                    newObj = {
                        name: '',
                        value: ''
                    };
                }
                propertySet[property.label].push(newObj);
                newArrayWrappers[property.label].push(new NameValuePair(newObj, newArrayWrappers[property.label], propertySet[property.label], property));
            };

            $scope.addCondition = function(group) {
                group.rules.push({
                    'condition': '=',
                    'field': null,
                    'data': null
                });
            };

            $scope.addGroup = function(group) {
                group.rules.push({
                    'group': {
                        operator: 'AND',
                        'rules': [{
                            'condition': '=',
                            'field': null,
                            'data': null
                        }]
                    }
                });
            };

            $scope.deleteRule = function(rule, ruleSet) {
                ruleSet = ruleSet || $scope.activeElement.PropertySet__c.show.group.rules;
                for (var i = 0; i < ruleSet.length; i++) {
                    if (ruleSet[i] === rule) {
                        ruleSet.splice(i, 1);
                        return;
                    } else if (ruleSet[i].group) {
                        $scope.deleteRule(rule, ruleSet[i].group.rules);
                    }
                }
            };

            $scope.deleteGroup = function(group, ruleset) {
                $scope.deleteRule(group, ruleset);
            };

            var names = [];
            var unwatch = $scope.$watch('scriptElement', function(element) {
                if (element) {
                    $scope.elementNames = function(asObject) {
                        names.splice(0, names.length);
                        $rootScope.scriptElement.each(function(element) {
                            if (element !== $rootScope.scriptElement) {
                                if (asObject) {
                                    names.push({
                                        label: element.Name
                                    });
                                } else {
                                    names.push(element.Name);
                                }
                            }
                        });
                        return names;
                    };
                    unwatch();
                }
            });

            $scope.onDrop =  function(event, index, item, list) {
                var oldIndex = list.findIndex(function(existing) {
                    return existing.name === item.name && existing.value === item.value;
                });
                var newIndex = index; // 0
                list.splice(newIndex, 0, list[oldIndex]);
                list.splice((newIndex <= oldIndex ? oldIndex + 1 : oldIndex), 1);
                return null;
            };

            $scope.onDragStart = function(value, index, event) {};

            $scope.addTab = function(property, index) {
                property.handleTabClick(index);
                property.$canvasElement.each(save);
            };

            $scope.deleteTab = function(property, index) {
                property.deleteTab(index);
                property.$canvasElement.each(save);
            };

            $scope.getShowTemplate = function(element) {
                if (!element) {
                    return 'show-property-template.tpl.html';
                }
                var prop = Object.keys(element.PropertySet__c).find(function(key) {
                    return (key == 'conditionType');
                });
                return !!prop ? 'adv-show-property-template.tpl.html' : 'show-property-template.tpl.html';
            };

            $scope.addDocuSignSigner = function(activeElement, ind) {
                var obj = {signerName:'', signerEmail:'', templateRole:'', routingOrder: ''};
                $scope.initTemplateRoles(activeElement, this.nsPrefix, ind);
                if(!activeElement.PropertySet__c.docuSignTemplatesGroup[ind].signerList)
                    activeElement.PropertySet__c.docuSignTemplatesGroup[ind].signerList = [];
                activeElement.PropertySet__c.docuSignTemplatesGroup[ind].signerList.push(obj);
            };

            $scope.initTemplateRoles = function(activeElement, nsPrefix, ind) {
                var options = [],
                    templates = $scope.docuSignTemplates,
                    roleName = {roles:''},
                    templateGroup = activeElement.PropertySet__c.docuSignTemplatesGroupSig ? activeElement.PropertySet__c.docuSignTemplatesGroupSig :activeElement.PropertySet__c.docuSignTemplatesGroup,
                    templateId;
                if(activeElement.PropertySet__c.docuSignTemplatesGroupSig && !templateGroup[ind].docuSignTemplate)
                    return;
                templateId = templateGroup[ind].docuSignTemplate;
                if (!templateGroup[ind].templateRoleName) {
                    for (var i = 0; i < templates.length; i++) {
                        if (templates[i][nsPrefix + 'TemplateIdentifier__c'] === templateId) {
                            var roleArray = angular.fromJson(templates[i][nsPrefix + 'RolesData__c'].replace(/&quot;/g,'"'));
                            for (var j = 0; j < roleArray.length; j++) {
                                options[j] = {};
                                options[j].name = roleArray[j];
                            }
                            roleName.roles = options;
                            templateGroup[ind].templateRoleName = roleName;
                        }
                    }
                }
            }

            $scope.deleteDocuSignSigner = function(ind, activeElement) {
                if(activeElement.PropertySet__c.docuSignTemplatesGroupSig)
                    activeElement.PropertySet__c.docuSignTemplatesGroupSig[this.$parent.$index].signerList.splice(ind, 1);
                else
                    activeElement.PropertySet__c.docuSignTemplatesGroup[this.$parent.$index].signerList.splice(ind, 1);
            };

            $scope.onChangeDocusignTemplate = function(activeElement, ind) {
                if (activeElement.PropertySet__c.docuSignTemplatesGroupSig) {
                    activeElement.PropertySet__c.docuSignTemplatesGroupSig[ind].templateRoleName = null;
                    activeElement.PropertySet__c.docuSignTemplatesGroupSig[ind].templateRole = null;
                    $scope.initTemplateRoles(activeElement, this.nsPrefix, ind);
                } else if (activeElement.PropertySet__c.docuSignTemplatesGroup[ind].signerList) {
                    activeElement.PropertySet__c.docuSignTemplatesGroup[ind].signerList = [];
                    activeElement.PropertySet__c.docuSignTemplatesGroup[ind].templateRoleName = null;
                }
            };

            $scope.optionsDocuSignTransform = function(property, activeElement) {
                var lab = property.label;
                property.label = 'transformBundle';
                var opt = $scope.optionsForProperty(property, activeElement);
                property.label = lab;
                return opt;
            };

            $scope.addDocuSignTemplate = function(activeElement){
                var obj = {docuSignTemplate:'', transformBundle:'', sendJSONPath:'', sendJSONNode:'', includeToSend:true};
                if(activeElement.PropertySet__c.docuSignTemplatesGroupSig) {
                    obj.templateRole = '';
                    activeElement.PropertySet__c.docuSignTemplatesGroupSig.push(obj);
                }
                else {
                    obj.signerList = [];
                    activeElement.PropertySet__c.docuSignTemplatesGroup.push(obj);
                }
            }

            $scope.deleteDocuSignTemplate = function(ind, activeElement) {
                if(activeElement.PropertySet__c.docuSignTemplatesGroupSig)
                    activeElement.PropertySet__c.docuSignTemplatesGroupSig.splice(ind, 1);
                else
                    activeElement.PropertySet__c.docuSignTemplatesGroup.splice(ind, 1);
            };

            $scope.onInitDocuSignTemplates = function(activeElement){
                if(activeElement.PropertySet__c.docuSignTemplate) {
                    var obj = {};
                    obj.docuSignTemplate = activeElement.PropertySet__c.docuSignTemplate;
                    obj.transformBundle = activeElement.PropertySet__c.transformBundle;
                    obj.sendJSONPath = activeElement.PropertySet__c.sendJSONPath;
                    obj.sendJSONNode = activeElement.PropertySet__c.sendJSONNode;
                    obj.includeToSend = true;
                    if(activeElement.PropertySet__c.docuSignTemplatesGroupSig) {
                        obj.templateRole = activeElement.PropertySet__c.signerInformation.templateRole;
                        activeElement.PropertySet__c.docuSignTemplatesGroupSig.push(obj);
                        delete activeElement.PropertySet__c.signerInformation.templateRole;
                    } else {
                        obj.signerList = activeElement.PropertySet__c.signerList;
                        activeElement.PropertySet__c.docuSignTemplatesGroup.push(obj);
                        delete activeElement.PropertySet__c.signerList
                    }
                    delete activeElement.PropertySet__c.docuSignTemplate;
                    delete activeElement.PropertySet__c.transformBundle;
                    delete activeElement.PropertySet__c.sendJSONPath;
                    delete activeElement.PropertySet__c.sendJSONNode;
                }
            }

            $scope.performAction = function(property, actionType) {
                if (actionType === 'link') {   
                    linkForPropertyFilter(property);
                }
            };

            $scope.googleCountryOptions = [
                {
                    "name": "All",
                    "value": "all"
                }, {
                    "name": "Afghanistan",
                    "value": "af"
                }, {
                    "name": "Åland Islands",
                    "value": "ax"
                }, {
                    "name": "Albania",
                    "value": "al"
                }, {
                    "name": "Algeria",
                    "value": "dz"
                }, {
                    "name": "American Samoa",
                    "value": "as"
                }, {
                    "name": "Andorra",
                    "value": "ad"
                }, {
                    "name": "Angola",
                    "value": "ao"
                }, {
                    "name": "Anguilla",
                    "value": "ai"
                }, {
                    "name": "Antarctica",
                    "value": "aq"
                }, {
                    "name": "Antigua and Barbuda",
                    "value": "ag"
                }, {
                    "name": "Argentina",
                    "value": "ar"
                }, {
                    "name": "Armenia",
                    "value": "am"
                }, {
                    "name": "Aruba",
                    "value": "aw"
                }, {
                    "name": "Ascension Island",
                    "value": "ac"
                }, {
                    "name": "Australia",
                    "value": "au"
                }, {
                    "name": "Austria",
                    "value": "at"
                }, {
                    "name": "Azerbaijan",
                    "value": "az"
                }, {
                    "name": "Bahamas",
                    "value": "bs"
                }, {
                    "name": "Bahrain",
                    "value": "bh"
                }, {
                    "name": "Bangladesh",
                    "value": "bd"
                }, {
                    "name": "Barbados",
                    "value": "bb"
                }, {
                    "name": "Belarus",
                    "value": "by"
                }, {
                    "name": "Belgium",
                    "value": "be"
                }, {
                    "name": "Belize",
                    "value": "bz"
                }, {
                    "name": "Benin",
                    "value": "bj"
                }, {
                    "name": "Bermuda",
                    "value": "bm"
                }, {
                    "name": "Bhutan",
                    "value": "bt"
                }, {
                    "name": "Bolivia",
                    "value": "bo"
                }, {
                    "name": "Bosnia and Herzegovina",
                    "value": "ba"
                }, {
                    "name": "Botswana",
                    "value": "bw"
                }, {
                    "name": "Bouvet Island",
                    "value": "bv"
                }, {
                    "name": "Brazil",
                    "value": "br"
                }, {
                    "name": "British Indian Ocean Territory",
                    "value": "io"
                }, {
                    "name": "British Virgin Islands",
                    "value": "vg"
                }, {
                    "name": "Brunei Darussalam",
                    "value": "bn"
                }, {
                    "name": "Bulgaria",
                    "value": "bg"
                }, {
                    "name": "Burkina Faso",
                    "value": "bf"
                }, {
                    "name": "Burundi",
                    "value": "bi"
                }, {
                    "name": "Cambodia",
                    "value": "kh"
                }, {
                    "name": "Cameroon",
                    "value": "cm"
                }, {
                    "name": "Canada",
                    "value": "ca"
                }, {
                    "name": "Canary Islands",
                    "value": "ic"
                }, {
                    "name": "Cape Verde",
                    "value": "cv"
                }, {
                    "name": "Caribbean Netherlands",
                    "value": "bq"
                }, {
                    "name": "Cayman Islands",
                    "value": "ky"
                }, {
                    "name": "Central African Republic",
                    "value": "cf"
                }, {
                    "name": "Ceuta & Melilla",
                    "value": "ea"
                }, {
                    "name": "Chad",
                    "value": "td"
                }, {
                    "name": "Chile",
                    "value": "cl"
                }, {
                    "name": "China",
                    "value": "cn"
                }, {
                    "name": "Christmas Island",
                    "value": "cx"
                }, {
                    "name": "Clipperton Island",
                    "value": "cp"
                }, {
                    "name": "Cocos (Keeling) Islands",
                    "value": "cc"
                }, {
                    "name": "Colombia",
                    "value": "co"
                }, {
                    "name": "Comoros",
                    "value": "km"
                }, {
                    "name": "Congo - Brazzaville",
                    "value": "cg"
                }, {
                    "name": "Congo - Kinshasa",
                    "value": "cd"
                }, {
                    "name": "Cook Islands",
                    "value": "ck"
                }, {
                    "name": "Costa Rica",
                    "value": "cr"
                }, {
                    "name": "Cote D'Ivoire",
                    "value": "ci"
                }, {
                    "name": "Croatia",
                    "value": "hr"
                }, {
                    "name": "Cuba",
                    "value": "cu"
                }, {
                    "name": "Curaçao", 
                    "value": "cw"
                }, {
                    "name": "Cyprus",
                    "value": "cy"
                }, {
                    "name": "Czech Republic",
                    "value": "cz"
                }, {
                    "name": "Côte d’Ivoire",
                    "value": "ci"
                }, {
                    "name": "Denmark",
                    "value": "dk"
                }, {
                    "name": "Diego Garcia",
                    "value": "dg"
                }, {
                    "name": "Djibouti",
                    "value": "dj"
                }, {
                    "name": "Dominica",
                    "value": "dm"
                }, {
                    "name": "Dominican Republic",
                    "value": "do"
                }, {
                    "name": "Ecuador",
                    "value": "ec"
                }, {
                    "name": "Egypt",
                    "value": "eg"
                }, {
                    "name": "El Salvador",
                    "value": "sv"
                }, {
                    "name": "Equatorial Guinea",
                    "value": "gq"
                }, {
                    "name": "Eritrea",
                    "value": "er"
                }, {
                    "name": "Estonia",
                    "value": "ee"
                }, {
                    "name": "Ethiopia",
                    "value": "et"
                }, {
                    "name": "Falkland Islands (Malvinas)",
                    "value": "fk"
                }, {
                    "name": "Faroe Islands",
                    "value": "fo"
                }, {
                    "name": "Fiji",
                    "value": "fj"
                }, {
                    "name": "Finland",
                    "value": "fi"
                }, {
                    "name": "France",
                    "value": "fr"
                }, {
                    "name": "French Guiana",
                    "value": "gf"
                }, {
                    "name": "French Polynesia",
                    "value": "pf"
                }, {
                    "name": "French Southern Territories",
                    "value": "tf"
                }, {
                    "name": "Gabon",
                    "value": "ga"
                }, {
                    "name": "Gambia",
                    "value": "gm"
                }, {
                    "name": "Georgia",
                    "value": "ge"
                }, {
                    "name": "Germany",
                    "value": "de"
                }, {
                    "name": "Ghana",
                    "value": "gh"
                }, {
                    "name": "Gibraltar",
                    "value": "gi"
                }, {
                    "name": "Greece",
                    "value": "gr"
                }, {
                    "name": "Greenland",
                    "value": "gl"
                }, {
                    "name": "Grenada",
                    "value": "gd"
                }, {
                    "name": "Guadeloupe",
                    "value": "gp"
                }, {
                    "name": "Guam",
                    "value": "gu"
                }, {
                    "name": "Guatemala",
                    "value": "gt"
                }, {
                    "name": "Guernsey",
                    "value": "gg"
                }, {
                    "name": "Guinea",
                    "value": "gn"
                }, {
                    "name": "Guinea-Bissau",
                    "value": "gw"
                }, {
                    "name": "Guyana",
                    "value": "gy"
                }, {
                    "name": "Haiti",
                    "value": "ht"
                }, {
                    "name": "Heard Island and Mcdonald Islands",
                    "value": "hm"
                }, {
                    "name": "Holy See (Vatican City State)",
                    "value": "va"
                }, {
                    "name": "Honduras",
                    "value": "hn"
                }, {
                    "name": "Hong Kong",
                    "value": "hk"
                }, {
                    "name": "Hungary",
                    "value": "hu"
                }, {
                    "name": "Iceland",
                    "value": "is"
                }, {
                    "name": "India",
                    "value": "in"
                }, {
                    "name": "Indonesia",
                    "value": "id"
                }, {
                    "name": "Iran, Islamic Republic Of",
                    "value": "ir"
                }, {
                    "name": "Iraq",
                    "value": "iq"
                }, {
                    "name": "Ireland",
                    "value": "ie"
                }, {
                    "name": "Isle of Man",
                    "value": "im"
                }, {
                    "name": "Israel",
                    "value": "il"
                }, {
                    "name": "Italy",
                    "value": "it"
                }, {
                    "name": "Jamaica",
                    "value": "jm"
                }, {
                    "name": "Japan",
                    "value": "jp"
                }, {
                    "name": "Jersey",
                    "value": "je"
                }, {
                    "name": "Jordan",
                    "value": "jo"
                }, {
                    "name": "Kazakhstan",
                    "value": "kz"
                }, {
                    "name": "Kenya",
                    "value": "ke"
                }, {
                    "name": "Kiribati",
                    "value": "ki"
                }, {
                    "name": "Korea, Democratic People'S Republic of",
                    "value": "kp"
                }, {
                    "name": "Korea, Republic of",
                    "value": "kr"
                }, {
                    "name": "Kuwait",
                    "value": "kw"
                }, {
                    "name": "Kyrgyzstan",
                    "value": "kg"
                }, {
                    "name": "Lao People'S Democratic Republic",
                    "value": "la"
                }, {
                    "name": "Latvia",
                    "value": "lv"
                }, {
                    "name": "Lebanon",
                    "value": "lb"
                }, {
                    "name": "Lesotho",
                    "value": "ls"
                }, {
                    "name": "Liberia",
                    "value": "lr"
                }, {
                    "name": "Libya",
                    "value": "ly"
                }, {
                    "name": "Liechtenstein",
                    "value": "li"
                }, {
                    "name": "Lithuania",
                    "value": "lt"
                }, {
                    "name": "Luxembourg",
                    "value": "lu"
                }, {
                    "name": "Macao",
                    "value": "mo"
                }, {
                    "name": "Macedonia, The Former Yugoslav Republic of",
                    "value": "mk"
                }, {
                    "name": "Madagascar",
                    "value": "mg"
                }, {
                    "name": "Malawi",
                    "value": "mw"
                }, {
                    "name": "Malaysia",
                    "value": "my"
                }, {
                    "name": "Maldives",
                    "value": "mv"
                }, {
                    "name": "Mali",
                    "value": "ml"
                }, {
                    "name": "Malta",
                    "value": "mt"
                }, {
                    "name": "Marshall Islands",
                    "value": "mh"
                }, {
                    "name": "Martinique",
                    "value": "mq"
                }, {
                    "name": "Mauritania",
                    "value": "mr"
                }, {
                    "name": "Mauritius",
                    "value": "mu"
                }, {
                    "name": "Mayotte",
                    "value": "yt"
                }, {
                    "name": "Mexico",
                    "value": "mx"
                }, {
                    "name": "Micronesia, Federated States of",
                    "value": "fm"
                }, {
                    "name": "Moldova, Republic of",
                    "value": "md"
                }, {
                    "name": "Monaco",
                    "value": "mc"
                }, {
                    "name": "Mongolia",
                    "value": "mn"
                }, {
                    "name": "Montserrat",
                    "value": "ms"
                }, {
                    "name": "Morocco",
                    "value": "ma"
                }, {
                    "name": "Mozambique",
                    "value": "mz"
                }, {
                    "name": "Myanmar",
                    "value": "mm"
                }, {
                    "name": "Namibia",
                    "value": "na"
                }, {
                    "name": "Nauru",
                    "value": "nr"
                }, {
                    "name": "Nepal",
                    "value": "np"
                }, {
                    "name": "Netherlands",
                    "value": "nl"
                }, {
                    "name": "Netherlands Antilles",
                    "value": "an"
                }, {
                    "name": "New Caledonia",
                    "value": "nc"
                }, {
                    "name": "New Zealand",
                    "value": "nz"
                }, {
                    "name": "Nicaragua",
                    "value": "ni"
                }, {
                    "name": "Niger",
                    "value": "ne"
                }, {
                    "name": "Nigeria",
                    "value": "ng"
                }, {
                    "name": "Niue",
                    "value": "nu"
                }, {
                    "name": "Norfolk Island",
                    "value": "nf"
                }, {
                    "name": "Northern Mariana Islands",
                    "value": "mp"
                }, {
                    "name": "Norway",
                    "value": "no"
                }, {
                    "name": "Oman",
                    "value": "om"
                }, {
                    "name": "Pakistan",
                    "value": "pk"
                }, {
                    "name": "Palau",
                    "value": "pw"
                }, {
                    "name": "Palestinian Territory, Occupied",
                    "value": "ps"
                }, {
                    "name": "Panama",
                    "value": "pa"
                }, {
                    "name": "Papua New Guinea",
                    "value": "pg"
                }, {
                    "name": "Paraguay",
                    "value": "py"
                }, {
                    "name": "Peru",
                    "value": "pe"
                }, {
                    "name": "Philippines",
                    "value": "ph"
                }, {
                    "name": "Pitcairn Islands",
                    "value": "pn"
                }, {
                    "name": "Poland",
                    "value": "pl"
                }, {
                    "name": "Portugal",
                    "value": "pt"
                }, {
                    "name": "Puerto Rico",
                    "value": "pr"
                }, {
                    "name": "Qatar",
                    "value": "qa"
                }, {
                    "name": "Reunion",
                    "value": "re"
                }, {
                    "name": "Romania",
                    "value": "ro"
                }, {
                    "name": "Russian Federation",
                    "value": "ru"
                }, {
                    "name": "RWANDA",
                    "value": "rw"
                }, {
                    "name": "Saint Helena",
                    "value": "sh"
                }, {
                    "name": "Saint Kitts and Nevis",
                    "value": "kn"
                }, {
                    "name": "Saint Lucia",
                    "value": "lc"
                }, {
                    "name": "Saint Pierre and Miquelon",
                    "value": "pm"
                }, {
                    "name": "Saint Vincent and the Grenadines",
                    "value": "vc"
                }, {
                    "name": "Samoa",
                    "value": "ws"
                }, {
                    "name": "San Marino",
                    "value": "sm"
                }, {
                    "name": "Sao Tome and Principe",
                    "value": "st"
                }, {
                    "name": "Saudi Arabia",
                    "value": "sa"
                }, {
                    "name": "Senegal",
                    "value": "sn"
                }, {
                    "name": "Serbia and Montenegro",
                    "value": "cs"
                }, {
                    "name": "Seychelles",
                    "value": "sc"
                }, {
                    "name": "Sierra Leone",
                    "value": "sl"
                }, {
                    "name": "Singapore",
                    "value": "sg"
                }, {
                    "name": "Sint Maarten",
                    "value": "sx"
                }, {
                    "name": "Slovakia",
                    "value": "sk"
                }, {
                    "name": "Slovenia",
                    "value": "si"
                }, {
                    "name": "Solomon Islands",
                    "value": "sb"
                }, {
                    "name": "Somalia",
                    "value": "so"
                }, {
                    "name": "South Africa",
                    "value": "za"
                }, {
                    "name": "South Georgia and the South Sandwich Islands",
                    "value": "gs"
                }, {
                    "name": "Spain",
                    "value": "es"
                }, {
                    "name": "Sri Lanka",
                    "value": "lk"
                }, {
                    "name": "Sudan",
                    "value": "sd"
                }, {
                    "name": "Suriname",
                    "value": "sr"
                }, {
                    "name": "Svalbard and Jan Mayen",
                    "value": "sj"
                }, {
                    "name": "Swaziland",
                    "value": "sz"
                }, {
                    "name": "Sweden",
                    "value": "se"
                }, {
                    "name": "Switzerland",
                    "value": "ch"
                }, {
                    "name": "Syrian Arab Republic",
                    "value": "sy"
                }, {
                    "name": "Taiwan, Province of China",
                    "value": "tw"
                }, {
                    "name": "Tajikistan",
                    "value": "tj"
                }, {
                    "name": "Tanzania, United Republic of",
                    "value": "tz"
                }, {
                    "name": "Thailand",
                    "value": "th"
                }, {
                    "name": "Timor-Leste",
                    "value": "tl"
                }, {
                    "name": "Togo",
                    "value": "tg"
                }, {
                    "name": "Tokelau",
                    "value": "tk"
                }, {
                    "name": "Tonga",
                    "value": "to"
                }, {
                    "name": "Trinidad and Tobago",
                    "value": "tt"
                }, {
                    "name": "Tunisia",
                    "value": "tn"
                }, {
                    "name": "Turkey",
                    "value": "tr"
                }, {
                    "name": "Turkmenistan",
                    "value": "tm"
                }, {
                    "name": "Turks and Caicos Islands",
                    "value": "tc"
                }, {
                    "name": "Tuvalu",
                    "value": "tv"
                }, {
                    "name": "Uganda",
                    "value": "ug"
                }, {
                    "name": "Ukraine",
                    "value": "ua"
                }, {
                    "name": "United Arab Emirates",
                    "value": "ae"
                }, {
                    "name": "United Kingdom",
                    "value": "gb"
                }, {
                    "name": "United States",
                    "value": "us"
                }, {
                    "name": "United States Minor Outlying Islands",
                    "value": "um"
                }, {
                    "name": "Uruguay",
                    "value": "uy"
                }, {
                    "name": "Uzbekistan",
                    "value": "uz"
                }, {
                    "name": "Vanuatu",
                    "value": "vu"
                }, {
                    "name": "Venezuela",
                    "value": "ve"
                }, {
                    "name": "Viet Nam",
                    "value": "vn"
                }, {
                    "name": "Virgin Islands, British",
                    "value": "vg"
                }, {
                    "name": "Virgin Islands, U.S.",
                    "value": "vi"
                }, {
                    "name": "Wallis and Futuna",
                    "value": "wf"
                }, {
                    "name": "Western Sahara",
                    "value": "eh"
                }, {
                    "name": "Yemen",
                    "value": "ye"
                }, {
                    "name": "Zambia",
                    "value": "zm"
                }, {
                    "name": "Zimbabwe",
                    "value": "zw"
                }
            ];

            $scope.initGoogleDefaultCountry = function(activeElement){
                if(activeElement.PropertySet__c.googleAddressCountry.toLowerCase() === 'all')
                    activeElement.PropertySet__c.googleAddressCountry = $scope.googleCountryOptions[0].value;
            };

            $scope.getGoogleTransOptions = function(activeElement, eleId){
                var options =[],
                    googleTransformation = activeElement.PropertySet__c.googleTransformation,
                    objKey;
                options.push('');
                for(var i=0; i<activeElement.children.length; i++) {
                    if(activeElement.children[i].Active__c === true)
                        options.push(activeElement.children[i].Name);
                }
                for(objKey in googleTransformation) {
                    if(options.indexOf(googleTransformation[objKey]) === -1 && googleTransformation[objKey] !== '' && $('#'+eleId).find('option').length > 0) {
                        googleTransformation[objKey] = options[0];
                        if($('#'+eleId).find('option')[0].value === '?')
                            $('#'+eleId).find('option')[0].remove();
                    }
                }
                return options;
            };

            $scope.addAddress = function(activeElement, addr) {
                var resolvedArray = activeElement.getResolvedObject(),
                    listProp = resolvedArray[addr],
                    firstElement = listProp[0];
                if (angular.isString(firstElement)) {
                    resolvedArray[addr].push('');
                } else {
                    resolvedArray[addr].push(angular.copy(firstElement));
                }
            };

            $scope.deleteAddress = function(ind, list) {
                list.splice(ind, 1);
            };

            $scope.onChangeEmailUseTemplate = function(activeElement) {
                if(activeElement.PropertySet__c.useTemplate) {
                    activeElement.PropertySet__c.emailInformation.toAddressList =[];
                    activeElement.PropertySet__c.emailInformation.ccAddressList =[];
                    activeElement.PropertySet__c.emailInformation.bccAddressList =[];
                    activeElement.PropertySet__c.emailInformation.emailSubject = "";
                    activeElement.PropertySet__c.emailInformation.emailBody = "";
                    activeElement.PropertySet__c.emailInformation.setHtmlBody = false;
                } else {
                    activeElement.PropertySet__c.emailTemplateInformation.emailTemplateName = "";
                    activeElement.PropertySet__c.emailTemplateInformation.emailTargetObjectId = "";
                    activeElement.PropertySet__c.emailTemplateInformation.saveAsActivity = false;
                    activeElement.PropertySet__c.emailTemplateInformation.whatId = "";
                }
            };

            $scope.addValueSvgMap = function(activeElement) {
                var obj = {value:'', svgSprite:'', svgSprite:''};
                if(activeElement.PropertySet__c.valueSvgMap) {
                    activeElement.PropertySet__c.valueSvgMap.push(obj);
                }
            };

            $scope.deleteValueSvgMap = function(ind, activeElement) {
                if(activeElement.PropertySet__c.valueSvgMap)
                    activeElement.PropertySet__c.valueSvgMap.splice(ind, 1);
            };
            
            $scope.addAdvancedMergeMap = function(activeElement) {
                var obj = {listKey:'', matchingPath:'', normalizeKey:''};
                if(activeElement.PropertySet__c.advancedMergeMap) {
                    activeElement.PropertySet__c.advancedMergeMap.push(obj);
                }
            };

            $scope.deleteAdvancedMergeMap = function(ind, activeElement) {
                if(activeElement.PropertySet__c.advancedMergeMap)
                    activeElement.PropertySet__c.advancedMergeMap.splice(ind, 1);
            };
            
            $scope.addColumnsPropertyMap = function(activeElement) {
                var obj = {name:'', label:'', description:'', sortable:true, filterable:true, type:'', length:255, decimalPlaces:0};
                if(activeElement.PropertySet__c.columnsPropertyMap) {
                    activeElement.PropertySet__c.columnsPropertyMap.push(obj);
                }
            };

            $scope.deleteColumnsPropertyMap = function(ind, activeElement) {
                if(activeElement.PropertySet__c.columnsPropertyMap)
                    activeElement.PropertySet__c.columnsPropertyMap.splice(ind, 1);
            };
            
            $scope.addRelationshipFieldsMap = function(activeElement) {
                var obj = {name : '', label : '', description : '', sortable : true, filterable : true, type : '', length : 255, referenceTo : '', referenceTargetField : ''};
                if(activeElement.PropertySet__c.relationshipFieldsMap) {
                    activeElement.PropertySet__c.relationshipFieldsMap.push(obj);
                }
            };

            $scope.deleteRelationshipFieldsMap = function(ind, activeElement) {
                if(activeElement.PropertySet__c.relationshipFieldsMap)
                    activeElement.PropertySet__c.relationshipFieldsMap.splice(ind, 1);
            };
            
            $scope.columnPropertyTypes = ['Boolean','Date/Time','Text','Number','Long text area','URL'];
            $scope.relationshipTypes = ['External lookup relationship','Indirect lookup relationship','Lookup relationship'];
            
            remoteActions.getExternalObjects().then(function(externalObjects) {
                $scope.externalObjectTypes = externalObjects.sort(function(a, b) { 
                    return a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
                });
            });
            
            remoteActions.getObjectsWithExternalFields().then(function(obj) { 
                $scope.objectWithExternalFields = function(name) {
                    return obj[name];
                };
                
                $scope.objectsWithExternalFieldsName = Object.keys(obj);
            });
            
            $scope.openLink = function(objectName) {
                if (objectName === 'ExternalObjectsPage') {
                    window.open('/p/setup/custent/' + objectName);   
                }
            }

            $scope.addsObjectMap = function(activeElement) {
                var obj = {osElement:'', sObjectField:'', duplicateKey:false};
                if(activeElement.PropertySet__c.sobjectMapping) {
                    activeElement.PropertySet__c.sobjectMapping.push(obj);
                }
            };

            $scope.deletesObjectMap = function(ind, activeElement) {
                if(activeElement.PropertySet__c.sobjectMapping)
                    activeElement.PropertySet__c.sobjectMapping.splice(ind, 1);
            };

            $scope.getAllFieldsForObjects = function(obj, eleId) {
                if($('#'+eleId).find('option').length > 0 && $('#'+eleId).find('option')[0].value.indexOf('?') > -1 && $('#'+eleId).find('option')[0].value.lastIndexOf('?') > 0)
                    $('#'+eleId).find('option')[0].remove();
                return $scope.allFieldsForObjects[obj];
            };

            $scope.getTypeAheadEleOptions = function(activeElement) {
                var options =[],
                    sobjectMapping = activeElement.PropertySet__c.sobjectMapping;

                for(var i=0; i<activeElement.children.length; i++) {
                    if(/Block$/i.test(activeElement.children[i].Type__c.label)) {
                        var child = activeElement.children[i].children;
                        for(var j=0; j<child.length; j++) {
                            options.push(activeElement.children[i].Name+':'+child[j].Name);
                        }
                    } else if(activeElement.children[i].Active__c === true && !(/(Action$|^Set|^Submit)/i.test(activeElement.children[i].Type__c.label)))
                        options.push(activeElement.children[i].Name);
                }
                return options.sort();

            };

        });
}());

},{"../../oui/util/CanvasElement.js":48,"../../oui/util/Property.js":52,"../../oui/util/ScriptElement.js":53}],6:[function(require,module,exports){
angular.module('omniscriptDesigner')
.controller('scriptFormController', function($scope, $rootScope, $window, $modal, remoteActions, $localizable, $drvExport, backcompatExport, isIntegrationProcedure) {

    $scope.createVersion = function() {
        remoteActions.createVersion($rootScope.scriptElement.Id)
        .then(function(response) {
            if (typeof sforce !== 'undefined') {
                sforce.one.navigateToURL(response);
            } else {
                $window.location.href = response;
            }
        });
    };

    $scope.activateVersion = function(scriptElement) {

        $rootScope.scriptElement.saving = true;
        $rootScope.scriptElement.activating = true;
        var input = angular.toJson({ 
            Id: $rootScope.scriptElement.Id
        });
        var options = angular.toJson({url: isIntegrationProcedure ? 'integrationproceduredesigner' : 'omniscriptdesigner'});
        var className = fileNsPrefixDot() + 'BusinessProcessController.BusinessProcessControllerOpen';
        
        vlocityVFActionFunctionControllerHandlers.runServerMethod(className, 'ActivateVersion', input, options, false)
        .then(function(response) {
          var responseObj = JSON.parse(response);

          if (typeof sforce !== 'undefined') {
              sforce.one.navigateToURL(responseObj.url);
          } else {
              $window.location.href = responseObj.url;
          }
      });
    };

    $scope.deactivateVersion = function() {

        $rootScope.scriptElement.saving = true;
        $rootScope.scriptElement.activating = true;
        var input = angular.toJson({ 
            Id: $rootScope.scriptElement.Id
        });
        var options = angular.toJson({url: isIntegrationProcedure ? 'integrationproceduredesigner' : 'omniscriptdesigner'});
        var className = fileNsPrefixDot() + 'BusinessProcessController.BusinessProcessControllerOpen';
        
        vlocityVFActionFunctionControllerHandlers.runServerMethod(className, 'DeactivateVersion', input, options, false)
        .then(function(response) {
          var responseObj = JSON.parse(response);

          if (typeof sforce !== 'undefined') {
              sforce.one.navigateToURL(responseObj.url);
          } else {
              $window.location.href = responseObj.url;
          }
      });
    };

    $scope.delete = function() {
        var modalScope = $scope.$new();
        modalScope.ok = function() {
            remoteActions.deleteOmniScript($rootScope.scriptElement.Id)
                   .then(function(response) {
                       if (typeof sforce !== 'undefined') {
                           sforce.one.navigateToURL(response);
                       } else {
                           $window.location.href = response;
                       }
                   });
        };
        $modal({
            title: $localizable('OmniDesConfirmDeleteTitle'),
            template: 'confirmationModal.tpl.html',
            content: $localizable(isIntegrationProcedure ? 'IntDesConfirmDeleteContent' : 'OmniDesConfirmDeleteContent'),
            scope: modalScope,
            show: true
        });
    };

    $scope.export = function($event) {
        if ($event.altKey) {
            backcompatExport($rootScope.scriptElement);
            return;
        }
        $drvExport({
            scope: $scope,
            drvExport: $rootScope.scriptElement.Id,
            drvSuggestedName: $rootScope.scriptElement.Name,
            drvDataPackType: isIntegrationProcedure ? 'IntegrationProcedure' : 'OmniScript'
        });
    }

});

},{}],7:[function(require,module,exports){
var PaletteElement = require('../../oui/util/PaletteElement.js');
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module('omniscriptDesigner')
.controller('structureCanvas', function($rootScope, $scope, $q, remoteActions, save,
                                        deleteElement, $timeout, $interval, $modal, $localizable, NotSupportedElmService) {
  'use strict';

  $scope.notDispOnTmltObj = NotSupportedElmService.getList();

  $scope.onDNDDrop =  function(event, index, item, external, type, allowedType) {
    var elementBeingDragged, parent;
    // we're moving an existing element
    if (angular.isString(item)) {
      elementBeingDragged = CanvasElement.getById(item);
      if (elementBeingDragged.saving) {
        return false;
      }

      parent = elementBeingDragged.parent();
      var oldIndex = parent.children.indexOf(elementBeingDragged);
      var removed = parent.children.splice(oldIndex, 1);
      if (removed.length === 0) {
        console.log('Could not delete element');
      }
      elementBeingDragged.ParentElementId__c = null;
    } else {
      var paletteElementBeingDragged = PaletteElement.getPaletteElement(item.label, item.scriptElement ? {
        Type: item.scriptElement.Type__c,
        'Sub Type': item.scriptElement.SubType__c,
        'Language': item.scriptElement.Language__c
      } : {});
      elementBeingDragged = new CanvasElement(paletteElementBeingDragged);
    }
    $timeout(function() {
      // in addition any elements we've dropped it in front of
      // need their Order__c updated so we need to save them too
      var parent = elementBeingDragged.parent();
      // we'll go through all the children because if some came with an existing
      // Order__c which was using base 10 or 100 they will be completely out of place now
      // - there's logic in Save to avoid resending unchanged data which will avoid
      //   the performance hit of unnecessary requests
      for (var i = 0; i < parent.children.length; i++) {
        save(parent.children[i]);
      }

      $rootScope.$broadcast('activeElementInCanvas', elementBeingDragged);
      $scope.setDisOnTpltPrp(elementBeingDragged);
    }, 200);

    return elementBeingDragged;
  };


  var debounce = null;
  $scope.onDNDMove = function(event, index, item, external, type, allowedType) {
    // scroll the structure panel if we need to on mouse over while dragging
    var lastMouseEvent = null;
    var config = {
        activationDistance: 30,
        scrollDistance: 50,
        scrollInterval: 250
    };

    if (debounce) {
      $timeout.cancel(debounce);
    }
    debounce = $timeout(function() {
      if (!lastMouseEvent) return;
      var viewportHeight = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
      var scrollY = 0;
      if (lastMouseEvent.clientY < config.activationDistance) {
          // If the mouse is on the top of the viewport within the activation distance.
          scrollY = -config.scrollDistance;
      }
      else if (lastMouseEvent.clientY > viewportHeight - config.activationDistance) {
        // If the mouse is on the bottom of the viewport within the activation distance.
        scrollY = config.scrollDistance;
      }

      if (scrollY !== 0) {
          var structureCanvas = angular.element('.structureCanvas')[0];
          structureCanvas.scrollTop += scrollY;
      }
    }, 250);

    lastMouseEvent = event;
    return true; // always return true because we can always drop here
  };

  $scope.onCanvasElementClick = function(element, $event) {
    $rootScope.$broadcast('activeElementInCanvas', element);
    if ($event) {
      $event.stopPropagation();
    }
  };

  /**
   * [onCanvasCheckboxElementClick save the updated element based on updated value of disOnTplt]
   * @param  {[type]} element [checked element which is dragged element from omniscript component to Script Configuration ]
   * @param  {[type]} evnt  [event after clicking on element]
   * @return {[type]}         [None]
   */
  $scope.onCanvasCheckboxElementClick = function(element, evnt) {
    save(element);
    $rootScope.$broadcast('elementPropertyChanged');
    if (evnt) {
      evnt.stopPropagation();
    }
  };


  /**
   * [setDisOnTpltPrp Initialize checkbox model value based disOnTplt and non-supported element list]
   * @param {[type]} element [element of editBlock]
   */
  $scope.setDisOnTpltPrp = function(element) {
    if(element.PropertySet__c.disOnTplt === undefined) {
      element.PropertySet__c.disOnTplt = false;
      save(element);
      return;
    }
  };

 
  $scope.delete = function(element) {
    return $q(function(resolve, reject){
      var modalScope = $scope.$new();
      modalScope.ok = function() {
        deleteElement(element).then(function() {
          $rootScope.$broadcast('activeElementInCanvas', element.ParentElementId__c || element.OmniScriptId__c);
          resolve(true);
        });
      };
      return $modal({
        title: $localizable('OmniDesConfirmDeleteTitle'),
        templateUrl: 'confirmationModal.tpl.html',
        content: $localizable('OmniDesConfirmDeleteElContent'),
        scope: modalScope,
        show: true
      });
    });
  };

  $scope.clone = function(element) {
    var clone = element.clone();
    var parent = clone.parent();
    parent.children.splice(parent.children.indexOf(element) + 1, 0, clone);
    // we'll go through all the children because if some came with an existing
    // Order__c which was using base 10 or 100 they will be completely out of place now
    // - there's logic in Save to avoid resending unchanged data which will avoid
    //   the performance hit of unnecessary requests
    var promises = [];
    for (var i = 0; i < parent.children.length; i++) {
      promises.push(save(parent.children[i]));
    }
    $q.all(promises).then(function() {
      $rootScope.$broadcast('activeElementInCanvas', clone);
    });
  };

  // removing to prevent OMNI-893 from happening
  // $(window).on('message', function(e) {
  //   var data = e.originalEvent.data;
  //   try {
  //     data = JSON.parse(data);
  //     if (data.name && data.type) {
  //       $rootScope.scriptElement.each(function(element) {
  //         if (element.Name === data.name) {
  //           $timeout(function() {
  //             $scope.activeElement = element;
  //             $rootScope.$broadcast('activeElementInCanvas', $scope.activeElement, true);
  //           });
  //         }
  //       });
  //     }
  //   } catch (err) {}
  // });

  $rootScope.$on('activeElementInCanvas', function(event, args){
    if (angular.isString(args)) {
      $scope.activeElement = CanvasElement.getById(args);
    } else {
      $scope.activeElement = args;
    }
    if (!$scope.activeElement) {
      $scope.activeElement = $rootScope.scriptElement;
    }
  });

  var getNextColor = (function(){
    var colors = ['pink', 'orange', '#008ab3', '#f65327', '#05a6df', '#eac438', '#58a300'];
    var index = 0,
        mapOfKeysToColor = {};
    return function(key) {
      if (!mapOfKeysToColor[key]) {
        if (index === colors.length) {
          index = 0;
        }
        mapOfKeysToColor[key] = colors[index++];
      }
      return mapOfKeysToColor[key];
    };
  })();

  function compileShowGroup(group, element) {
    var evalString = ['('],
        evalStringIfUndefined = ['('];
    var colorMap = $scope.popover.controllingElementsColors;
    for (var i = 0; i < group.rules.length; i++) {
      if (i > 0) {
        if (group.rules[i].group || group.rules[i].field) {
          evalString.push(group.operator === 'AND' ? '&&\n' : '||\n');
        }
        if (group.rules[i].field) {
          evalStringIfUndefined.push(group.operator === 'AND' ? '&&\n' : '||\n');
        }
      }
      if (group.rules[i].group) {
        evalString.push(compileShowGroup(group.rules[i].group, element));
      } else if (group.rules[i].field) {
        var fieldName = group.rules[i].field.split('|')[0];
        var key = '$scope[\'' + fieldName + '\']',
            nextColor = getNextColor(fieldName);
        if (colorMap[fieldName].indexOf(nextColor) < 0) {
          colorMap[fieldName].push(nextColor);
        }
        if (!colorMap[element.Name]) {
          colorMap[element.Name] = [nextColor];
        } else if (colorMap[element.Name].indexOf(nextColor) < 0) {
          colorMap[element.Name].push(nextColor);
        }
        evalString.push(key);
        var condition = group.rules[i].condition;
        evalStringIfUndefined.push(key + ' != undefined');
        evalString.push(condition === '=' ? '==' : (condition === '<>' ? '!=' : condition));
        evalString.push('\'' + group.rules[i].data + '\'');
      }
    }
    evalString.push(')');
    evalStringIfUndefined.push(')');
    if (evalStringIfUndefined.length < 3) {
      return evalString.join(' ');
    }
    return '(' + evalString.join(' ') + '&&' + evalStringIfUndefined.join(' ') + ')';
  }

  function compileShow(element) {
    var evalString = compileShowGroup(element.PropertySet__c.show.group, element);
    if (element.PropertySet__c.show) {
      evalString = evalString.replace(/(\|\||\&\&)*\s*\(\s*\)/g, '');
      if (!/^(\(\s*\)|\(\(\s*\)(\|\|\(\s*\))*\)|)$/.test(evalString)) {
        /*jshint evil:true */
        try {
          return new Function('$scope', 'return ' + evalString + ';');
        } catch (e) {
          console.log('Could not compile show rules into function', e, 
                      'function($scope) {\n\treturn '+evalString + ';\n}');
        }
      }
    }
    return function() {
      return true;
    };
  }

  function evaluateShowRules(rules) {
    var scope = {}, noRules = true;
    for (var i = 0; i < rules.length; i++) {
      if (rules[i].element) {
        noRules = false;
        scope[rules[i].element]  = rules[i].value;
      }
    }
    if ($rootScope.scriptElement) {
      Object.keys($scope.popover.controllingElementsColors).forEach(function(key){
        $scope.popover.controllingElementsColors[key] = [];
      });
      // filter the Structure Element and it's children to hide filtered out rules
      $rootScope.scriptElement.each(function(element){
        if (element instanceof CanvasElement) {
          if (noRules) {
            element.filter = false;
            compileShow(element)(scope);
            if (angular.isObject(element.collapse) && element.collapse.automated) {
              element.collapse = false;
            }
          } else {
            var dontCollapseAgain = false;
            if (element.filter === true) {
              dontCollapseAgain = true;
            }
            element.filter = !compileShow(element)(scope);
            if (element.filter === true && !dontCollapseAgain) {
              element.collapse = {automated: true};
            } else if (angular.isObject(element.collapse) && element.collapse.automated) {
              element.collapse = false;
            }
          }
        }
      });
    }
  }

  $scope.$watch('popover.rules', evaluateShowRules, true);

  $rootScope.$on('elementPropertyChanged', function(event, args){
    $scope.popover.controllingEntities();
    evaluateShowRules($scope.popover.rules);
  });

  $scope.popover = {
    rules: [{
      element: null,
      value: ''
    }],
    controllingElementsColors: {
    },
    addRule: function() {
      $scope.popover.rules.push({
        element: null,
        value: ''
      });
    },
    clear: function() {
      $scope.popover.rules = [{
        element: null,
        value: ''
      }];
    },
    deleteRule: function(rule) {
      var indexToRemove = $scope.popover.rules.indexOf(rule);
      $scope.popover.rules.splice(indexToRemove, 1);
      if ($scope.popover.rules.length === 0) {
        $scope.popover.clear();
      }
    },
    controllingEntities: function() {
      function getAllEntitiesForGroup(group) {
        var names = [];
        if (group.rules) {
          for (var i = 0; i < group.rules.length; i++) {
            if (group.rules[i].group) {
              names = names.concat(getAllEntitiesForGroup(group.rules[i].group));
            }
            if (group.rules[i].field) {
              names.push(group.rules[i].field.split('|')[0]);
            }
          }
        }
        return names;
      }
      function getAllNamesForElement(element) {
        var controllingEntityNames = element.PropertySet__c &&
                          element.PropertySet__c.show ? getAllEntitiesForGroup(element.PropertySet__c.show.group) : [];
        var children = element.children;
        for (var i = 0; i < children.length; i++) {
          controllingEntityNames = controllingEntityNames.concat(getAllNamesForElement(children[i]));
        }
        return controllingEntityNames;
      }
      var allNames = getAllNamesForElement($rootScope.scriptElement);

      for (var i = 0; i < allNames.length; i++) {
        var nextColor = getNextColor(allNames[i]);
        if (!$scope.popover.controllingElementsColors[allNames[i]]) {
          $scope.popover.controllingElementsColors[allNames[i]] = [nextColor];
        } else if ($scope.popover.controllingElementsColors[allNames[i]].indexOf(nextColor) < 0) {
          $scope.popover.controllingElementsColors[allNames[i]].push(nextColor);
        }
        var existingIndex = allNames.indexOf(allNames[i]);
        if (existingIndex !== i && existingIndex > -1) {
          allNames.splice(i--, 1);
        }
      }
      return allNames;
    }
  };

  $scope.collapseAll = function() {
    $rootScope.scriptElement.each(function(element) {
      element.collapse = true;
    });
  };

  $scope.expandAll = function() {
    $rootScope.scriptElement.each(function(element) {
      element.collapse = false;
    });
  };

  $scope.allExpanded = function() {
    var allExpanded = true;
    if ($rootScope.scriptElement) {
      $rootScope.scriptElement.each(function(element) {
        if (element.collapse) {
          allExpanded = false;
        }
      });
    }
    return allExpanded;
  };

});
},{"../../oui/util/CanvasElement.js":48,"../../oui/util/PaletteElement.js":51,"../../oui/util/ScriptElement.js":53}],8:[function(require,module,exports){
angular.module('omniscriptDesigner')
    .controller('tabbedController', function($rootScope, $scope, $timeout,
                                             interTabMsgBus, $localizable, customViewModalService) {
        'use strict';

        $scope.tabs = [{title:$localizable('OmniDesTabProperties'), content: ''}];
        $scope.tabs.activeTab = 0;
        $scope.currentScriptElementInPreview = null;
        $scope.viewModel = {
            testJSON: '',
            resetData: true,
            contextId: ''
        };

        var pageToMode = {
            'Lightning Universal Page': 'OmniScriptUniversalPage',
            'Lightning': 'OmniScriptPreviewPage',
            'Mobile (iPad)': 'OmniScriptUniversalPage',
            /*"Mobile (iPad Portrait)": "OmniScriptUniversalMobilePage",*/
            'Mobile (iPhone)': 'OmniScriptUniversalPage',
            'Communities': 'OmniScriptUniversalCommunitiesPage',
            'Classic Universal Page': 'OmniScriptUniversalPage'
        };
        var customViews = {};
        var newOptions = {};

        pageToMode[$localizable('OmniDesTabPreviewVertMode')] = 'OmniScriptPreviewPage';
        pageToMode[$localizable('OmniDesTabPreviewHorizMode')] = 'OmniScriptHoriPreviewPage';
        $scope.previewModes = Object.keys(pageToMode);
        $scope.previewMode = 'Lightning Universal Page';

        var needsReload = true;

        //this was added by me
        $scope.$on('customViewUpdated', function(event,data) {

            //if the current selection is the one in the custom script
            //then and only then refresh the select dropdown3
            if ($scope.previewMode in customViews) {
                $scope.previewMode = $localizable('OmniDesTabPreviewVertMode');
            }

            customViews = {};

            /* jshint -W030 */
            angular.forEach(data, function(view) {
                if (view.key) {
                    customViews[view.key] = (view.currentValue || '');
                }

            });

        });

        //when the selected tab is preview then and only then populate the preview select
        $scope.$watch(function() {
            return $scope.tabs.activeTab;
        }, function(newValue, oldValue) {
            if (newValue === 1 && $rootScope.scriptElement.Id) {
                //this will reset the select control so that the model does not goff up new comment
                $scope.previewModes = Object.keys(angular.extend({},pageToMode, customViews));

                if (($rootScope.scriptElement !== $scope.currentScriptElementInPreview) || needsReload) {
                    $scope.currentScriptElementInPreview = $rootScope.scriptElement;
                    loadPreviewPage();
                }
                $rootScope.collapsePalette = true;
            } else {
                $rootScope.collapsePalette = $rootScope.fullScreen = false;
            }
        });

        $rootScope.$on('activeElementInCanvas', function(event, element, skipTabChange) {
            if ($scope.tabs.activeTab !== 0 && !skipTabChange) {
                $scope.tabs.activeTab = 0;
            }
        });

        $scope.$watch('scriptElement.Id', function(id) {
            if (id && $scope.tabs.length < 2) {
                $scope.tabs.push({
                    title: $localizable('OmniDesTabPreview'),
                    content: ''
                });
            }
        });

        $rootScope.$on('save', function(element) {
            needsReload = true;
        });

        var changeJson = false;
        $rootScope.$on('delete', function(event, element) {
            needsReload = true;
            // need to wipe out existing element in JSON
            var pathToElement = [element.Name];
            while (element.parent().Id !== $rootScope.scriptElement.Id) {
                element = element.parent();
                pathToElement.splice(0,0,element.Name);
            }
            if ($scope.viewModel && $scope.viewModel.testJSON) {
                var testJSON = JSON.parse($scope.viewModel.testJSON);
                // traverse json to find the element we need to delete
                var currentObj = testJSON;
                while (pathToElement.length > 1) {
                    if (!currentObj[pathToElement[0]]) {
                        return;
                    }
                    currentObj = currentObj[pathToElement.splice(0, 1)[0]];
                }
                delete currentObj[pathToElement[0]];
                interTabMsgBus.set('ouiTestJson', JSON.stringify(testJSON, null, 2));
                $scope.viewModel.testJSON = JSON.stringify(testJSON, null, 2);
                changeJson = true;
            }
        });

        $rootScope.$on('saved', function(element) {
            if ($scope.tabs.activeTab === 1) {
                loadPreviewPage();
            }
        });

        $rootScope.$on('deleted', function(element) {
            if ($scope.tabs.activeTab === 1) {
                loadPreviewPage();
            }
        });

        var triggeredReload = false,
            pendingLoad = null;
        function loadPreviewPage() {
            if (pendingLoad) {
                $timeout.cancel(pendingLoad);
            }
            pendingLoad = $timeout(function() {
                triggeredReload = true;
                var element = $('.iframe-holder');

                var apexPageUrl = pageToMode[$scope.previewMode];
                if (customViews.hasOwnProperty($scope.previewMode)) {
                    apexPageUrl = customViews[$scope.previewMode];
                }
                var previewContainsquestion = apexPageUrl && apexPageUrl.indexOf('?') >= 0;
                if (!previewContainsquestion) {
                    apexPageUrl += '?';
                }

                var iframeURL = '<iframe  src="/apex/' + apexPageUrl;
                if (/Lightning|Mobile \(iPad\)|Mobile \(iPhone\)/.test($scope.previewMode)) {
                    iframeURL += 'layout=lightning';
                }
                iframeURL += '&id=' + $rootScope.scriptElement.Id + '&designerPreviewId=' +
                             $rootScope.scriptElement.Id + '&previewEmbedded=true&tabKey=' +
                             interTabMsgBus.tabKey() +
                             ($scope.viewModel.contextId ? '&testContextId=' + $scope.viewModel.contextId : '') +
                                '"></iframe>';

                element[0].innerHTML = iframeURL;

                needsReload = false;
                var iFrames = $('.iframe-holder iframe');
                var timer = null;
                iFrames.load(function() {
                    //var localDoc = this.contentWindow.document,
                    //  lastHeight = localDoc.documentElement.offsetHeight,
                    var iframe = this;
                    interTabMsgBus.setTarget(this.contentWindow);
                    iframe.style.height = '100%'; /* OMNI 1251 */

                    if (timer) {
                        clearInterval(timer);
                    }
                    // handle reload of page with prep'd data to use
                    timer = setInterval(function() {
                        if (/Mobile/.test($scope.previewMode)) {
                            // make mobile match iPad dimensions
                            element.addClass('mobile');
                            if (/iPad/i.test($scope.previewMode)) {
                                element.addClass('ipad');
                                element.removeClass('iphone');
                            } else if (/iPhone/i.test($scope.previewMode)) {
                                element.addClass('iphone');
                                element.removeClass('ipad');
                            }
                            if (/iPad/i.test($scope.previewMode)) {
                                element.addClass('landscape');
                                element.removeClass('portrait');
                            }
                            if (/iPhone/i.test($scope.previewMode)) {
                                element.addClass('portrait');
                                element.removeClass('landscape');
                            }
                        } else {
                            element.removeClass('mobile', 'ipad', 'iphone', 'portrait', 'landscape');
                            iframe.style.width = '100%';
                            /* commented out for OMNI 1251
                            //var newHeight = localDoc.documentElement.scrollHeight;
                            //if (newHeight !== lastHeight &&
                            //    (newHeight - 50) !== lastHeight)  {
                            //    iframe.style.height = (newHeight + 50) + 'px';
                            //}
                            //lastHeight = $(iframe).height();
                            */
                        }
                    }, 500);
                });
            }, 500);
        }

        $scope.$watch('previewMode', function(newValue, oldValue) {
            if (newValue && newValue !== oldValue) {
                loadPreviewPage();
            }
        });

        $scope.fetchDataForContextId = function(contextId, resetDataJson) {
            if (contextId) {
                needsReload = true;
                loadPreviewPage();

                if (resetDataJson) {
                    $scope.viewModel.testJSON = '';
                    interTabMsgBus.delete('ouiTestJson');
                }

                try {
                    var testJSON = JSON.parse($scope.viewModel.testJSON);
                    if (testJSON.ContextId !== contextId) {
                        testJSON.ContextId = contextId;
                        $scope.viewModel.testJSON = JSON.stringify(testJSON, null, 2);
                    }
                } catch (e) {
                    // swallow JSON parse exception
                }
                $scope.viewModel.contextId = contextId;
            }
        };

        $scope.onPreviewJSONChange = function(newValue, oldValue) {
            if (newValue && newValue !== oldValue) {
                try {
                    var asJson = JSON.parse(newValue);
                    interTabMsgBus.set('ouiTestJson', newValue);
                } catch (e) {
                    // swallow invalid JSON
                }
            }
        };

        $scope.clearData = function() {
            $scope.viewModel.testJSON = '';
            $scope.viewModel.contextId = '';
            interTabMsgBus.delete('ouiTestJson');
            loadPreviewPage();
        };

        var pending = null;
        interTabMsgBus.on('ouiTestJson', function(newJson, oldJson, wasDelete) {
            // if (wasDelete && oldJson !== null) {
            //     return;
            // }
            // if (!triggeredReload || !oldJson || changeJson) {
            //     changeJson = false;
            if (pending) {
                $timeout.cancel(pending);
            }
            if (newJson === $scope.viewModel.testJSON) {
                return;
            }
            pending = $timeout(function() {
                if (angular.isString(newJson)) {
                    newJson = JSON.stringify(JSON.parse(newJson), null, 2);
                }
                $scope.$apply(function() {
                    $scope.viewModel.testJSON = newJson;
                });
            });
            // } else {
            //     if (!$scope.viewModel.contextId || JSON.parse(oldJson).ContextId === $scope.viewModel.contextId) {
            //         interTabMsgBus.set('ouiTestJson', oldJson + ' ');
            //     }
            // }
            triggeredReload = false;
        });

        interTabMsgBus.on('initialLoad', function() {
            if ($scope.viewModel.testJSON) {
                interTabMsgBus.set('ouiTestJson', $scope.viewModel.testJSON);
            } else {
                interTabMsgBus.set('ouiTestJson', null);
            }
        });

        // clear old localStorage values
        interTabMsgBus.delete('ouiTestJson');

    });

},{}],9:[function(require,module,exports){
angular.module("omniscriptDesigner")
.directive('input', function () {
    return {
        restrict: 'E',
        require: '?ngModel',
        link: function (scope, elem, attrs, ctrl) {
            if (attrs.type.toLowerCase() !== 'number') {
                return;
            } //only augment number input!
            ctrl.$formatters.push(function (value) {
                return !isNaN(value) ? parseFloat(value) : null;
            });
        }
    };
});
},{}],10:[function(require,module,exports){
angular.module("omniscriptDesigner")
.directive("paletteGroup", function() {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      group: "=elements",
      grouptitle: "=",
      expanded: '=?'
    },
    templateUrl: 'paleteElementGroup.tpl.html',
    link: function($scope) {
      $scope.model = {
        expand: $scope.expanded == true
      };
    }
  };
});
},{}],11:[function(require,module,exports){
angular.module("omniscriptDesigner")
.directive("preventDeleteBack", function($window){
    return function (scope, element, attrs) {
      /*
       * this swallows backspace keys on any non-input element.
       * stops backspace -> back
       */
      var rx = /INPUT|SELECT|TEXTAREA/i;

      angular.element(document).bind("keydown keypress", function(e){
        if( e.which == 8 ){ // 8 == backspace
          if(!rx.test(e.target.tagName) || e.target.disabled || e.target.readOnly ){
            e.preventDefault();
          }
        }
      });
    };
  });
},{}],12:[function(require,module,exports){
angular.module("omniscriptDesigner")
.directive("viaAffix", function($window){
    if ($window.parent && $window.parent !== $window) {
      return {};
    }
    return function (scope, element, attrs) {
      var stickyTop = $(element).offset().top; 
      $(window).scroll(function() {
        var windowTop = $(window).scrollTop();
        if (stickyTop < windowTop) {
          $(element).parent().height($(window).height());
          $(element).css({ position: 'fixed', top: 0, width: "calc(100% - 20px)" });
          $(element).addClass("viaAffix");
        } else {
          $(element).removeClass("viaAffix");
          $(element).css({'position':'static', width: '100%'});
        }
      });
    };
  });
},{}],13:[function(require,module,exports){
angular.module("omniscriptDesigner")
.directive('viaScreenHeight', function($window) {
  if ($window.parent && $window.parent !== $window) {
    return {};
  }
  return function(scope, element, attrs) {
    var el = element[0];
    el.style.height = $window.document.documentElement.clientHeight + "px";
    scope.$watch(function() {
      return $window.document.documentElement.clientHeight;
    }, function(newValue, oldValue) {
      el.style.height = $window.document.documentElement.clientHeight + "px";
    });
  };
});
},{}],14:[function(require,module,exports){
(function(){
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('changeLabel', [function(){
        return{
            restrict: 'A',
            link: function(scope,element, attrs){
                if (!scope.property){
                    return ;
                }
                var label = scope.property.label ;

                if ( /elementValueMap/.test(label)  || /elementErrorMap/.test(label) ) {
                    setTimeout(function(){
                        element.html(i18n[attrs.changeLabel]);
                    });
                }

            },
        };
    }]);
    
}());

},{}],15:[function(require,module,exports){
(function() {
    'use strict';
    /*jshint -W030 */
    angular.module('omniscriptDesigner')
        .directive('vlcTooltip', function($compile) {
            return {
                priority: 1001,
                terminal: true,
                compile: function(el, attrs) {
                    el.attr('compiled-tooltip', attrs.vlcTooltip);
                    el.removeAttr('vlc-tooltip');
                    el.attr('bs-tooltip', 'toolTipContent');
                    el.attr('data-placement','top');
                    el.attr('data-html','true');
                    el.attr('data-container', 'div.info'); //parent div should have the class info
                    var f = $compile(el);
                    return function(scope, el, attr) {
                        scope.toolTipContent = scope.$eval(el[0].getAttribute('compiled-tooltip'));
                        if (!scope.toolTipContent){
                            el.remove();
                        }else{
                            el.removeAttr('vlc-tooltip')
                        }
                        f(scope);
                    };
                }
            };
        });
}());

},{}],16:[function(require,module,exports){
(function(){
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('enableLogging', ['$compile', 'tObjectFactory', function($compile, tObjectFactory){
        return{
            restrict: 'A',
            priority: '10001',
            compile: function(element, attrs){
                element.removeAttr('enable-logging');
                var initValue = attrs['ngClick'] ;
                element.attr('ng-click', 'startLogging()');
                var fn = $compile(element);
                
                return function(scope) {
                    scope.startLogging = function(){
                        tObjectFactory.visible = !tObjectFactory.visible;

                        //send an event to the iframe below to set bpService in debug mode
//                        var win = document.getElementsByTagName('iframe')[0].contentWindow;
//                        /*jshint -W030 */
//                        win && win.postMessage && (function(){
//                            if (tObjectFactory.debug){
//                                console.log('debug Start message send to frame');
//                                win.postMessage('debugStart', '*');
//                            }else{
//                                console.log('debug Stop message send to frame');
//                                win.postMessage('debugStop', '*');
//
//                                //clear tObjects and starts afresh for the next time use
//                                tObjectFactory.clearTObjects();
//                            }
//                        }());

                    };
                    
                    fn(scope);
                };
            },
        };
    }]);
    
}());

},{}],17:[function(require,module,exports){
(function(){
    /*jshint -W030 */
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcDebugJsonTreeView', ['$compile', 'tObjectFactory', function($compile, tObjectFactory){
        return {
            restrict: 'E',
            scope:{
                jsonData: '=',
            },
            transclude: true,
            controller: function($scope, $element) {
                $scope.clear = function() {
                    tObjectFactory.clearTObjects();
                    $scope.jsonData = tObjectFactory.tObjects();
                };
                
                $scope.tPanel = function(tObject, flag) {
                    if (flag) {
                        tObject.visible = !tObject.visible;
                    }
                };

                //close the debug panel based on this switch
                $scope.toggleVisibility = function() {
                    tObjectFactory.visible = false;
                    $scope.$broadcast('eScroll'); //OMNI-2176
                };

                $scope.getClass = function(tObject) {
                    if (tObject.visible) {
                        return 'spreadOut';
                    }else {
                        return '';
                    }
                };

                //property on scope displays the prop based on the json object
                $scope.display = function(key) {
                    if(key === 'stage' || key === 'visible' || key === 'created' || key === 'name') {
                        return false;
                    }
                    return true;
                };

                //pre formatting the json 
                $scope.beautify = function(value,innerObject){
                    if (!innerObject.oneLineItem){
                        return '<pre>' + angular.toJson(value, true) + '</pre>';
                    }else{
                        return angular.toJson(value); 
                    }
                };
            },
            template: //comment
            '<div class="vlc-debug-panel modal-content" ng-if=visible vlc-modal-draggable vlc-bubble-canceller>'+
                '<div class="hexpand" vlc-expand-collapse prop="width"></div>'+
                '<div class="modal-header">'+
                '  <button type="button" class="close" aria-label="Close" ng-click="toggleVisibility()">'+
                '    X'+
                '  </button>'+
                '  <h4 class="modal-title vlc-debug-console-header"><strong>Omniscript Debug Console</strong></h4>'+
                '  <div class="vlc-debug-controls">'+
                '    <input type="text" class="form-control" ng-model="input.search" placeholder="Search"/>'+
                '  </div>'+
                '</div>'+
                '<div class="modal-body">'+
                '    <ul class="debug-object-list">' +
                '      <li ng-repeat="tObject in jsonData | filter:{name:input.search}" ng-click="tPanel(tObject,true)" ng-class="getClass(tObject)">'+
                '        <strong>{{tObject.name}}</strong>( {{tObject.stage}}{{tObject.created | date:"yyyy-MM-dd HH:mm:ss Z"}} )'+
                '        <button style="background:none;padding:0;margin:0" class="btn" vlc-clipboard="{}" vlc-clipboard-value="tObject">'+
                '        <span style="position:relative;top: -1px" class="glyphicon icon-v-copy" aria-hidden="true"></span>'+
                '        </button>'+
                '        <ul ng-show="tObject.visible" class="sublist">'+
                '          <li ng-repeat="(key,value) in tObject" ng-if="display(key)" vlc-collapsible>'+
                '            <strong>{{key}}</strong>'+
                '            <button ng-hide="innerObject.oneLineItem" obj=innerObject style="background:none;padding:0;margin:0" class="btn"'+
                '              vlc-clipboard="{}" vlc-clipboard-value="value">'+
                '              <span style="position:relative;top: -1px" class="glyphicon icon-v-copy" aria-hidden="true"></span>'+
                '            </button>'+
                '            <div ng-class=innerObject.oneLineItem?"li-flat":"" ng-show="innerObject.visible" class="sublist">'+
                '              <span vlc-bubble-canceller click="true" ng-bind-html="beautify(value, innerObject)"></span>'+ 
                '            </div>'+
                '          </li>'+
                '        </ul>'+
                '      </li>'+
                '    </ul>'+
                '</div>'+
                '<div class="modal-footer">'+
                '  <button ng-click="clear()" class="btn btn-default">Clear</button>' +
                '  <div class="expand" vlc-expand-collapse="" classes="vlc-debug-panel, modal-body" prop="min-height">'+
                '  </div>'+
                '</div>'+
                '</div>', //div ends for modal content
                compile: function(element, attrs, transclude){
                    var contents = element.contents().remove();
                    var compiledContents;
                    
                    return function(scope, iElement, iAttrs){
                        scope.visible = tObjectFactory.visible;
                        
                        //this watch toggles  the modal window
                        scope.$watch(function(){
                            return tObjectFactory.visible;
                        },function(newValue, oldValue){
                            if (newValue !== oldValue){
                                scope.visible = tObjectFactory.visible;
                            }
                        });

                        //puts the objects into the queue - would only work in ie 9 and above 
                        window.addEventListener && (function(){
                            window.addEventListener('message', function(event){
                                tObjectFactory.createNetTransObject(angular.fromJson(event.data));
                                //view only needs to be updated if the console is up
                                if (scope.visible){
                                    scope.$apply(); //will fire the watchers on the updated flag
                                }
                            }, false);
                        }());

                        //preveent scroll bubbling
                        /*angular.element(iElement).bind('mouseenter', function(e){
                            angular.element('body').addClass('noScroll');
                        });

                        angular.element(iElement).bind('mouseleave', function(e){
                            angular.element('body').removeClass('noScroll');
                        });*/

                        //watches the queue to repaint the tree
                        scope.$watch(function(){
                            return tObjectFactory.factoryUpdated();
                        },function(newValue, oldValue){
                            scope.jsonData = tObjectFactory.tObjects();
                        });
                        
                        if(!compiledContents) {
                            compiledContents = $compile(contents, transclude);
                        }
                        compiledContents(scope, function(clone, scope) {
                            iElement.append(clone); 
                        });
                    };

                }
        };

    }]);
}());

},{}],18:[function(require,module,exports){
(function(){
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('typeaheadOptions', [function(){
        function link(scope, element, attrs){
            // this directive is designed to work with OptionsForProperty(property, element, asArray).
            // if you would like to use another function make sure that it accepts the same arguments.
            // when !asArray there cannot be any manipulation of the scope that would trigger a digest

            // assign options variable
            scope.options = scope.$eval(attrs.typeaheadOptions+'(property, activeElement, true)',scope);
            // create watch on variable
            scope.$watch(
                function (scope){
                    return scope.$eval(attrs.typeaheadOptions+'(property, activeElement)',scope);
                },
                scope.updateOptions,
                true
            );
            return;
        };
        return{
            link: link
        };
    }]);
    
}());
},{}],19:[function(require,module,exports){
(function(){
    'use strict';
    /*the purpose of this directive is to cancel the bubbling of scrolling events
      this could be extended for other events in the future by passing attributes*/
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcBubbleCanceller', function(){
        return {
            restrict: 'A',
            scope:false,
            link: function(scope, elem, attrs){

                if (attrs.click){
                    elem.bind('click', function(e){
                        return false;
                    });
                    elem.bind('mouseenter', function(e){
                        return false;
                    });
                    return;
                }
                //preveent scroll bubbling
                angular.element(elem).bind('mouseenter', function(e){
                    angular.element('body').addClass('noScroll');
                });

                angular.element(elem).bind('mouseleave', function(e){
                    angular.element('body').removeClass('noScroll');
                });

                //OMNI-2176
                scope.$on('eScroll', function(){
                     angular.element('body').removeClass('noScroll');
                });

            }
        };
    });
}());

},{}],20:[function(require,module,exports){
(function(){
    /*the purpose of this directive is to drag elements with position fixed across the screen
      dnd draggable requires the position to be relative */
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcModalDraggable', ['$compile', '$document', function($compile, $document){
        return {
            restrict: 'A',
            scope:false,
            link: function(scope, elem){
                var startX, startY, x, y;
                var width = elem[0].offsetWidth;
                var height = elem[0].offsetHeight;
                var header = elem.find('.modal-header');
                header.on('mousedown', function(e){
                    startX = e.clientX - elem[0].offsetLeft;
                    startY = e.clientY - elem[0].offsetTop;
                    $document.on('mousemove', mousemove);
                    $document.on('mouseup', mouseup);

                });

                // Handle drag event
                function mousemove(e) {
                    y = e.clientY - startY;
                    x = e.clientX - startX;
                    setPosition();
                }

                // Unbind drag events
                function mouseup(e) {
                    $document.unbind('mousemove', mousemove);
                    $document.unbind('mouseup', mouseup);
                }

                function setPosition(){
                    elem.css({
                        top: y + 'px',
                        left:  x + 'px'
                    });
                }
                
            }
        };
    }]);
}());

},{}],21:[function(require,module,exports){
(function(){
    /*jshint -W030 */
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcExpandCollapse', ['$document', 'tObjectFactory', function($document, tObjectFactory){
        var startX, startY, x, deltaX;
        return {
            restrict:'A',
            scope:'false',
            link: function(scope, element, attrs){
                element.bind('mousedown', function(event){
                    event.stopPropagation();
                    event.preventDefault();
                    $document.on('mousemove', mousemove);
                    $document.on('mouseup', mouseup);
                });

                function mousemove($event) {

                    //whenever there is a mouse down event deactivate the iframe
                    $('.iframe-holder').css({
                        'opacity': 0.3,//
                        'z-index':-1
                    });
                    
                    if (attrs.prop === 'width'){
                        //calculates  the start X and Y and calculates
                        //the dist travelled by the mouse and adds to the width
                        x = $event.pageX;
                        startX = element.offset().left;
                        startX = parseInt(startX);
                        deltaX = x  - startX;
                        var top = element.parent();
                    
                        top.css({
                            'width': parseInt(top.css('width')) + deltaX + 'px'
                        });
                        
                    }else{
                        //calculates the height of parent div - vlc-debug-modal
                        //cals mouse position , then dist moved by the mouse and adds it to the initial height
                        //diagonal drag

                        x = $event.pageX;
                        startX = element.offset().left;
                        startX = parseInt(startX);
                        deltaX = x  - startX;
                        
                        var y = $event.pageY;
                        startY = element.offset().top;
                        startY = parseInt(startY); //
                        var delta = y - startY;
                        var topP = element.parent().parent();
                        topP.css({
                            'width': parseInt(topP.css('width')) + deltaX + 'px',
                            'height': parseInt(topP.css('height')) + delta + 'px'
                        });

                        //120 is the min height of the parent div
                        var mBody = element.parent().parent().find('.modal-body');
                        mBody.css({
                            'height': parseInt(topP.css('height')) - 120 + 'px'
                        });
                    } 
                }

                function mouseup($event){
                    $document.unbind('mousemove', mousemove);
                    $document.unbind('mouseup', mouseup);

                    //whenever there is a mouse down event deactivate the iframe
                    $('.iframe-holder').css({
                        'opacity': 'initial',
                        'z-index':'auto'
                    });
                    
                }

            }
        };
    }]);
}());

},{}],22:[function(require,module,exports){
(function(){
    'use strict';
    var Clipboard = window.Clipboard;

    
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcClipboard', function() {
        console.log('inside the clipboard directive');
        return {
            restrict: 'A',
            scope:{
                vlcClipboardValue: '='
            },
            controller: function($scope){
                $scope.select  = function(element){
                    if (Clipboard.selectedElement){ //this stores the previous selection
                        Clipboard.selectedElement.nextElementSibling.firstElementChild.style = '';
                    }
                    element.nextElementSibling.firstElementChild.style = 'background:#dedede';
                    Clipboard.selectedElement = element;
                };
            },
            link: function(scope, element, attr, ctrl) {
                var clipboard = new Clipboard(element[0], {
                    text: function(trigger) {
                        return '' + JSON.stringify(scope.vlcClipboardValue);
                    }
                });
                var btn = angular.element;

                //this will make click event not bubbble thereby not toggling the sublist
                element.bind('click', function(){
                    return false;
                });

                clipboard.on('success', function(e) {
                    var elem = e.trigger;
                    scope.select(elem);
                    

                    /* this is for the tooltip to show up on the right */
                    $(elem).addClass('tooltipped tooltipped-e');
                    elem.setAttribute('aria-label', 'copied to clipboard');
                    
                    $(elem).on('mouseleave', function(e) {
                        $(elem).removeClass('tooltipped tooltipped-e');
                        elem.removeAttribute('aria-label');
                    });
                    
                    console.log('copy success');
                });

                clipboard.on('error', function(e) {
                    console.log('copy error');
                });

            }
        };
    });
    
}());

},{}],23:[function(require,module,exports){
(function() {
    'use strict';
    var dModule = angular.module('omniscriptDesigner');
    dModule.directive('vlcCollapsible', ['$compile', function($compile) {
        var keys = ['remoteClass', 'remoteMethod', 'apexRestPath' ,
                    'apexRestMethod','extRestUrl', 'httpVerb']; //these
        //keys
        //will
        //not
        //toggle
        //should
        //refactor
        //them
        //to
        //be
        //attributes
        return {
            restrict: 'A',
            scope:false,
            compile: function(element,attr) {
                //new comment which is added
                element.removeAttr('vlc-collapsible');
                ////element.attr('ng-click', 'toggle()');
                element.addClass('collapsible');
                var fn = $compile(element);
                return function($scope, element,attrs, ctrl, transclude) {
                    $scope.innerObject = {};

                    if (keys.indexOf($scope.key || '') !== -1) {
                        //disable the toggle behaviour
                        $scope.innerObject.visible = true;
                        $scope.innerObject.oneLineItem = true;
                        element.bind('click', function(event) {
                            if (!event.spanClicked) {
                                event.stopPropagation();
                            }
                        });

                        return fn($scope);
                    }

                    element.bind('click', function(event) {
                        if (!event.spanClicked) {
                            element.toggleClass('spreadOut');
                            event.stopPropagation();
                            $scope.$apply();
                        }
                    });

                    $scope.$watch(function() {
                        return /spreadOut/.test (element.attr('class'));
                    }, function(newValue, oldValue) {
                        if (newValue !== oldValue) {
                            $scope.innerObject.toggle();// new o
                        }
                    });

                    $scope.innerObject.visible =  false;
                    $scope.innerObject.toggle =  function() {
                        $scope.innerObject.visible = !$scope.innerObject.visible;
                    };

                    fn($scope);
                };
            },
        };
    }]);
}());

},{}],24:[function(require,module,exports){
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module("omniscriptDesigner")
.factory('deleteElement', function($q, remoteActions, $rootScope) {
  return function deleteVisitor(element) {
    if ($rootScope.scriptElement.IsActive__c) {
      return $q(function(resolve, reject){
        reject();
      });
    }
    element.deleting = true;
    element.setSaving();
    $rootScope.$broadcast("delete", element);

    var allPromises = [];
    if (element.children.length > 0) {
      for (var i = 0; i < element.children.length; i++) {
        allPromises.push(deleteVisitor(element.children[i]));
      }
    }

    if (allPromises.length === 0) {
      allPromises.push($q.when(true));
    }
    return $q.all(allPromises).then(function() {
      return remoteActions.deleteElement(element.Id);
    }).then(function(result) {
      element.saving = false;
      if (angular.isArray(result) && (result.length === 0 || result[0].success))  {
        $rootScope.$broadcast("deleted", element);
        element.deleting = true;
        element.delete();
      } else {
        element.setErrors(result.errors);
      }
      return element;
    });
  };
});
},{"../../oui/util/ScriptElement.js":53}],25:[function(require,module,exports){
(function() {
    'use strict';
    angular.module('omniscriptDesigner')
        .factory('interTabMsgBus', function($q, $rootScope) {
            var listeners = {};
            var tabKey = Date.now().toString();
            var keysAdded = [];
            var objKeys = []; //adding the custom view layout

            //$(window).on('storage', handleStorageEvent);
            $(window).on('beforeunload', emptySessionStorage);
            $(window).on('message', handlePostMessageEvent);

            function handleStorageEvent(e) {
                e = e.originalEvent;
                var keyParts = e.key.split('.');
                if (keyParts[0] === tabKey) {
                    if (listeners[keyParts[1]]) {
                        listeners[keyParts[1]].forEach(function(callbackConfig) {
                            callbackConfig.fn.apply(callbackConfig.scope, [e.newValue, e.oldValue, wasDelete]);
                        });
                    }
                }
                wasDelete = false;
            }

            function handlePostMessageEvent(e) {
                e = e.originalEvent;
                var data = e.data;
                if (angular.isString(data)) {
                    data = JSON.parse(data);
                }
                if (!data.key) {
                    return;
                }
                var keyParts = data.key.split('.');
                if (keyParts[0] === tabKey) {
                    if (listeners[keyParts[1]]) {
                        listeners[keyParts[1]].forEach(function(callbackConfig) {
                            callbackConfig.fn.apply(callbackConfig.scope, [data.newValue, data.oldValue, wasDelete]);
                        });
                    }
                }
            }

            function emptySessionStorage() {
                keysAdded.forEach(function(key) {
                    localStorage.removeItem(tabKey + '.' + key);
                });

                //deleting the obj containing window layout details
                objKeys.forEach(function(key) {
                    localStorage.removeItem(key);
                });
            }

            var wasDelete = false,
                targetWindow = null;

            return {
                setTarget: function(_targetWindow) {
                    targetWindow = _targetWindow;
                },
                tabKey: function() {
                    return tabKey;
                },
                on: function(key, listener, scope) {
                    if (!listeners[key]) {
                        listeners[key] = [];
                    }
                    listeners[key].push({
                        fn: listener,
                        scope: scope
                    });
                },
                set: function(key, value, isObject) {
                    keysAdded.push(key);
                    if (isObject === true) {
                        //localStorage.setItem(tabKey + '.' + key, JSON.stringify(value));
                        targetWindow.postMessage({
                            key: tabKey + '.' + key,
                            newValue: JSON.stringify(value)
                        }, '*');
                    }else {
                        //localStorage.setItem(tabKey + '.' + key, value);
                        targetWindow.postMessage({
                            key: tabKey + '.' + key,
                            newValue: value
                        }, '*');
                    }
                },
                get: function(key, isObject) {
                    if (isObject === true) {
                        return JSON.parse(localStorage.getItem(tabKey + '.' + key));
                    }else {
                        return localStorage.getItem(tabKey + '.' + key);
                    }
                },
                delete: function(key) {
                    // if (localStorage.getItem(tabKey + '.' + key)) {
                    //     wasDelete = true;
                    // }
                    // localStorage.removeItem(tabKey + '.' + key);
                }
            };
        });
}());

},{}],26:[function(require,module,exports){
(function() {
    /*jshint -W030 */
    'use strict';
    angular.module('omniscriptDesigner')
        .factory('tObjectFactory', function() {
            /*
              input: arguement object passed from the bpService decorator
            */

            var classNamesToBeHidden = ['invokeInboundDR',
                                        'invokeTransformDR',
                                        'invokeOutboundDR',
                                       ];

            var containsString = function(sString){
                for(var i = 0 ; i < this.length; i++){
                    if (this[i].indexOf(sString) !== -1){
                        return true;
                    }
                }
                return false;
            };

            var tObjectsMap = [];
            var _factoryUpdated = false;

            function isValidObject(input) {
                if (input.response && input.response.name && input.response.type) {
                    return false;
                }

                if (input.args && input.args.name && input.args.type) {
                    return false;
                }

                return true;
            }

            function beautify(input){
                var request;
                try{
                    var test  = input && input[2] && input[2].replace(/\\\"/g,'\"');

                    if(test === input[2]){
                        request = (input && input[2] && angular.fromJson(input[2])) || {} ;
                        return request;
                    }
                    
                    test = test.replace(/\"{/g,'{');
                    test = test.replace(/}\"/g,'}'); 
                    request = angular.fromJson(test);

                } catch(err){
                    console.log('error in json parser ' + err);
                    request = (input && input[2] && angular.fromJson(input[2])) || {} ;
                }

                return request;
            }

            function CreateTObject(input, element) {
                var path = (input && input[0]) || 'anonymous';
                var restMethod = (input && input[1]) || 'anonymous';
                var self = this;

                //these names should be visible in the window
                !containsString.call(classNamesToBeHidden, restMethod) && (function(){
                    (element.type === 'web') && (function() {
                        self.extRestUrl = path;
                        self.httpVerb = restMethod;
                    }());
                    (element.type === 'apex') && (function() {
                        self.apexRestPath = path;
                        self.apexRestMethod = restMethod;
                    }());
                    (!element.type) && (function() {
                        self.remoteClass = (input && input[0]) || 'anonymous';
                        self.remoteMethod = (input && input[1]) || 'anonymous';
                    }());
                }());
                
                this.remoteOptions = (input && input[3] && angular.fromJson(input[3])) || {} ;

                //replaces the escaped json with beautified one 
                this.request = beautify(input);

                this.response = {};
                this.stage = (element.stage && element.stage + '-') || '';
                this.name = element.label || 'anonymous';
                this.created = Date.now();
            }

            //takes out the non display properties before copying the clipboard
            CreateTObject.prototype.toJSON = function() {
                var copy = {};
                angular.copy(this,copy);
                delete copy.visible;
                delete copy.stage;
                delete copy.name;
                delete copy.created;
                return copy;
            };

            function createRequestObject(input, element) {
                var tObject = new CreateTObject(input, element);
                //tObjectsMap.unshift(tObject);
                tObjectsMap.push(tObject);
                
            }

            function createResponseObject(input, element) {

                var tObject ;
                //check the element name of the last object matches
                /* jshint -W030 */
                var output = (tObject = tObjectsMap[tObjectsMap.length-1]) && (function() {
                    //stage has been lower cased in the above if clause
                    tObject.response  = input;
                    return true;
                }());

                if (!output) {
                    console.log('orphan response : something is wrong');
                }

            }

            function remoteCallObject(input) {

                //the step and type calls are also getting logged thats why - this check
                if (!(isValidObject(input))) {
                    return {
                        invalidObject: true
                    };
                }

                //this is a request object
                if (input.args) {
                    createRequestObject(input.args, input.element);
                }

                if (input.response) {
                    createResponseObject(input.response, input.element);
                }

                _factoryUpdated = !_factoryUpdated;

            }

            return {
                createNetTransObject: function(input) {
                    remoteCallObject(input);
                    _factoryUpdated = _factoryUpdated;
                },

                clearTObjects: function() {
                    tObjectsMap = [];
                    _factoryUpdated = _factoryUpdated;
                },

                factoryUpdated: function() {
                    return _factoryUpdated;
                },

                tObjects: function() {
                    return tObjectsMap;
                }

            };

        });

}());

},{}],27:[function(require,module,exports){
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module("omniscriptDesigner")
.filter("activeElementTitle", function($localizable, isIntegrationProcedure) {
    return function(canvasElement) {
      if (!canvasElement) {
        return "";
      }
      if (canvasElement instanceof ScriptElement) {
        if (isIntegrationProcedure) {
          return $localizable('IntProcHeaderProps');
        }
        return $localizable("OmniDesScriptHeaderProps", "Script Header Properties");
      }
      return canvasElement.CanvasType ? canvasElement.CanvasType : canvasElement.Name;
    };
  });
},{"../../oui/util/CanvasElement.js":48,"../../oui/util/ScriptElement.js":53}],28:[function(require,module,exports){
var CanvasElement = require('../../oui/util/CanvasElement.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module("omniscriptDesigner")
.filter("className", function() {
  return function(canvasElement) {
    if (!canvasElement) {
      return "";
    }
    if (!(canvasElement instanceof CanvasElement) && !(canvasElement instanceof ScriptElement)) {
      if (angular.isString(canvasElement)) {
        canvasElement = CanvasElement.getById(canvasElement);
      } else {
        canvasElement = CanvasElement.getById(canvasElement.Id);
      }
    }
    var className = '';
    if (canvasElement instanceof CanvasElement) {
      className = canvasElement.type().replace(/ /gi, "").toLowerCase() + "Element" + (canvasElement.isInput() ? " inputElement" : "");
    } else {
      className = canvasElement.CanvasType;
    }
    if (canvasElement.hasErrors()) {
      className += " bg-danger";
    }
    if (!canvasElement.Active__c && (canvasElement instanceof CanvasElement)) {
      className += " inactive";
    }
    return className;
  };
});
},{"../../oui/util/CanvasElement.js":48,"../../oui/util/ScriptElement.js":53}],29:[function(require,module,exports){
var PaletteElement = require('../../oui/util/PaletteElement.js');

angular.module("omniscriptDesigner")
.filter("controlType", function() {
  function isInGroup(element) {
    return /Step/.test(element.label) || /filterblock|inputblock|selectable-items|typeahead-block|edit-block/.test(element.type) || element.isGroupedControl();
  }

  function isInInput(element) {
    return !/Submit/.test(element.label) && (/Filter/.test(element.label) || element.isInput()) &&
           !isInFunction(element) && !isInDisplay(element) && !isInGroup(element);
  }

  function isInDisplay(element) {
    return /Headline|Text Block|Line Break/.test(element.label);
  }

  function isInFunction(element) {
    return /Aggregate|Formula|Geolocation|Validation/.test(element.label);
  }

  function isInAction(element) {
    return /Submit/.test(element.label) || (!/OmniScript/.test(element.label) && !isInInput(element) &&
           !isInGroup(element) && !isInDisplay(element) && !isInFunction(element));
  }

  var funcs = {
    group: isInGroup,
    input: isInInput,
    action: isInAction,
    display: isInDisplay,
    func: isInFunction
  };

  var arrayCache = {
    empty: []
  };

  return function(elements, type) {
    if (!arrayCache[type]) {
      arrayCache[type] = [];
    } else {
      arrayCache[type].splice(0, arrayCache[type].length);
    }
    if (elements) {
      elements.forEach(function(element){
        if (funcs[type](element)) {
          arrayCache[type].push(element);
        }
      });
      return arrayCache[type];
    } else {
      return arrayCache.empty;
    }
  };
});

},{"../../oui/util/PaletteElement.js":51}],30:[function(require,module,exports){
angular.module("omniscriptDesigner")
.filter("elementLabel", function() {
    return function(paletteElement) {
      if (!paletteElement) {
        return "";
      }
      if (paletteElement.prettyName) {
        return paletteElement.prettyName();
      }
      if (/Rest/i.test(this.label)) {
        if (/^rest action$/i.test(this.label))
            return this.label.replace(/\brest\b/i, 'HTTP');
        else 
            return this.label.replace(/\brest\b/i, 'REST');
      } else if (/^Validation$/.test(paletteElement.label)) {
        return "Messaging";
      // OMNI-2769
      } else if (/^Date\/Time \(Local\)$/.test(paletteElement.label)) {
        return "Date\/Time";
      } else {
        return paletteElement.label;
      }
    };
  });
},{}],31:[function(require,module,exports){
// jscs:disable requireCamelCaseOrUpperCaseIdentifiers
var CanvasElement = require('../../oui/util/CanvasElement.js');
var requiredProperties = require('../../oui/util/requiredProperties.js');

angular.module('omniscriptDesigner')
.filter('fixMissingProperties', function($rootScope, remoteActions, save) {
    'use strict';
    var pendingPropertySetPromises = {};
    return function(canvasElement) {
        if (!canvasElement) {
            return '';
        }
        if (requiredProperties[canvasElement.type()]) {
          if (!pendingPropertySetPromises[canvasElement.type()]) {
            pendingPropertySetPromises[canvasElement.type()] = remoteActions.loadPropertySetForElement(canvasElement.type(), $rootScope.scriptElement.IsProcedure__c);
          }
          pendingPropertySetPromises[canvasElement.type()].then(function(textJson) {
              if (!textJson || textJson.result === '') {
                  // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
                  textJson = JSON.stringify(canvasElement.PropertySet__c);
              }
              // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
              var defaultProperties = JSON.parse(textJson.replace(/\&quot;/gi, '\"'));
              var needsSaving = false;
              requiredProperties[canvasElement.type()].forEach(function(requiredPropName) {
                  /* jshint eqnull:true */
                  if (canvasElement.PropertySet__c[requiredPropName] == null) {
                      canvasElement.PropertySet__c[requiredPropName] = defaultProperties[requiredPropName];
                      needsSaving = true;
                  }
              });
              if (needsSaving) {
                  // this is to help with batching
                  setTimeout(function() {
                    save(canvasElement);
                  }, 1000 * (Math.floor((Math.random() * 10) + 1)));
              }
          });
        }
        return canvasElement;
    };
});

},{"../../oui/util/CanvasElement.js":48,"../../oui/util/requiredProperties.js":56}],32:[function(require,module,exports){
angular.module("omniscriptDesigner")
.filter("getTypeForElement", function($localizable, $rootScope, elementLabelFilter) {
    return function(elementName) {
      var matchingElement = null;
      $rootScope.scriptElement.each(function(element){
        if (element.Name === elementName) {
          matchingElement = element;
        }
      });
      if (matchingElement) {
        return elementLabelFilter(matchingElement.Type__c);
      } else if (elementName !== '') {
        return 'JSON Node';
      } else {
        return '';
      }
    };
  });
},{}],33:[function(require,module,exports){
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module('omniscriptDesigner')
.filter('linkForProperty', function($rootScope, $dataraptor, remoteActions, save) {
    function idForName(objectName, collection, property) {
        var object;
        if ($rootScope.drBundles) {
            object = collection.find(function(obj) {
                return obj[property] === objectName;
            });
        }
        return object ? object.Id : '';
    }
    function doWindowOpen(url) {
        if (window.location.search.indexOf('sfdcIFrameOrigin') > 1) {
            var urlObj = {
                componentDef : 'one:alohaPage',
                attributes: {
                    values: {
                        address : url
                    },
                    history: []
                }
            };
            var lightningRedirect = JSON.stringify(urlObj);
            url = '/one/one.app#' + window.btoa(lightningRedirect);
        }
        window.open(url);
    }
    return function(property) {
        if (property.isForDataRaptor()) {
            property.loading = true;
            var id;
            if (property.$canvasElement instanceof ScriptElement && property.label === 'DataRaptorBundleId__c') {
                id = property.currentValue;
            } else {
                id = idForName(property.currentValue, $rootScope.drBundles, 'Name');
            }
            if (id) {
                doWindowOpen('/apex/' + window.ns + 'DRMapper' + (id ? '?bundleId=' + id : ''));
                property.loading = false;
            } else {
                alert('DataRaptor ' + property.currentValue + ' Does Not Exist');
                property.loading = false;
            }
        } else if (property.$canvasElement.Type__c.type=="OmniScript"){
            property.loading = true;
            remoteActions.getReusableOmniScripts().then(function(reusableScripts){
                // Getting specification for reusable omniscript
                var spec = {
                    Type__c: property.$canvasElement.PropertySet__c.Type,
                    SubType__c: property.$canvasElement.PropertySet__c['Sub Type'],
                    Language__c: property.$canvasElement.PropertySet__c.Language
                };

                // Adding namespace
                for(key in spec){
                    spec[window.ns+key]=spec[key];
                    delete spec[key];
                }

                try{
                    id = reusableScripts.find(function(reusableScript){
                        for (key in spec){
                            if(reusableScript[key]!=spec[key]){
                                return false;
                            }
                        }
                        return true;
                    }).Id;
                    doWindowOpen('/apex/' + window.ns + 'omniscriptdesigner' + (id ? '?id=' + id : ''));
                } catch(e){
                    window.alert('Reusable OmniScript '+property.$canvasElement.PropertySet__c.Type+'/'+property.$canvasElement.PropertySet__c['Sub Type']+': '+property.$canvasElement.PropertySet__c.Language+' not Found.\n');
                }
                property.loading = false
            });
        } else{
            window.location = '/' + idForName(property.currentValue, $rootScope.pdfs, 'DeveloperName');
            property.loading = false;
        }
    };
});

},{"../../oui/util/ScriptElement.js":53}],34:[function(require,module,exports){
require('../../../polyfills/Array.includes.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');
var templateMgr = require('../../oui/util/vlcUiTempMgr.js');
var htmlEncodeDecode = require('../../oui/util/HtmlEncodeDecode.js');

angular.module('omniscriptDesigner')
.filter('optionsForProperty', function($rootScope, remoteActions, $localizable, isIntegrationProcedure) {
    'use strict';

    var validationRequired = {
        'Step': 'Step',
        'Submit': 'Submit',
        'None': null
    };
    $rootScope.drBundles = $rootScope.languages = $rootScope.scriptElementTypes = [];
    
    // Load from OmniScript Picklists
    if(!isIntegrationProcedure){
        remoteActions.loadScriptElementTypes().then(function(types) {
            addTypes(types, $rootScope.scriptElementTypes);
        });
    }

    // Load from Existing Scripts
    remoteActions.getOmniScriptTypes(isIntegrationProcedure).then(function(types) {
        addTypes(types, $rootScope.scriptElementTypes);
    });

    var equalsLabel = function equalsLabel (a){
        var label = typeof a == "string" ? a : a.label;
        return this && label == this || (typeof label == 'string' && typeof this == 'string' && label.trim() == this.trim());
    };

    function compareLabels (a,b){
        return String(a.label).localeCompare(b.value);
    }

    function addTypes(types, target){
        delete types['null'];
        delete types[''];
        var i = -1;
        for (var property in types) {
            if (types.hasOwnProperty(property)){
                i = target.findIndex(equalsLabel, property);
                if (i == -1){
                    i = target.length;
                    target[i]={
                        label: htmlEncodeDecode.unescapeHTML(property),
                        value: htmlEncodeDecode.unescapeHTML(property),
                        $$subTypes:[]
                    };
                } 
                for (var y = 0; y<types[property].length; y++){
                    types[property][y] = htmlEncodeDecode.unescapeHTML(types[property][y]);
                    if (target[i].$$subTypes.findIndex(equalsLabel,types[property][y]) ==-1 ,types[property][y]){
                        target[i].$$subTypes.push({label: types[property][y], value: types[property][y]});
                    }
                }
                target[i].$$subTypes.sort(compareLabels);
            }
        }
        target.sort(compareLabels);
    }

    remoteActions.loadLanguages().then(function(languages) {
        $rootScope.languages = languages;
    });

    remoteActions.loadDataRaptorBundles().then(function(drBundles) {
        $rootScope.drBundles = drBundles.map(function(bundle) {
            return {
                Id: bundle.Id,
                Name: bundle.Name,
                Type__c: bundle[ns + 'Type__c']
            };
        });
    });

    var templates;
    remoteActions.loadVlocityUITemplates().then(function(uiTemplates) {
        templates = uiTemplates.map(function(uiTemplate) {
            return {
                Id: uiTemplate.Id,
                Name: uiTemplate.Name,
                Type__c: uiTemplate[ns + 'Type__c']
            };
        });
    });

    remoteActions.loadIntegrationProcedureKeys().then(function(intProcedureKeys) {
        $rootScope.intProcedureKeys = intProcedureKeys;
    });

    remoteActions.getDocuments().then(function(documents) {
        $rootScope.pdfs = documents;
    });

    remoteActions.loadDocuSignTemplates().then(function(docuSignTemplates) {
        $rootScope.docuSignTemplates = docuSignTemplates;
    });

    remoteActions.GetEmailTemplates().then(function(emailTemplates) {
        $rootScope.emailTemplates = emailTemplates;
    });

    remoteActions.GetEmailDocuments().then(function(emailDocuments) {
        $rootScope.emailDocuments = emailDocuments;
    });

    remoteActions.getMatrixNames().then(function(matrixNames) {
        console.log(matrixNames);
        $rootScope.matrixNames = matrixNames;
    });

    function optCompare(a,b){
        if (a.label =='   ')
            return -1;
        return String(a.label).localeCompare(b.label);
    }

    function mapKeyInObject(map, sourceArray) {
        if (sourceArray) {
            Array.from(sourceArray).forEach(function(key) {
                map[key] = key;
            });
            map['   '] = null;
        }
    }

    function updateArray(target, sourceObj){
        var labels = sourceObj?Object.keys(sourceObj):[];
        var j = -1;
        for (var i = 0; i<target.length; i++){
            if ((j=labels.findIndex(equalsLabel,target[i].label)) != -1){
                target[i].value = sourceObj[target[i].label];
                labels.splice(j,1);
            } else {
                target.splice(i--,1);
            }
        }
        labels.forEach(function(label){
            target.push({'label':label, 'value':sourceObj[label]});
        });
        target.sort(optCompare);
    }

    return function(property, element, asArray) {
        var obj = {};
        var customArr = false;
        if (!property || !element) {
            return obj;
        }

        if (element instanceof ScriptElement && /__c$/.test(property.label)) {
            switch (property.label) {
                case 'Type__c':
                    customArr = true;
                    obj = $rootScope.scriptElementTypes;
                    break;
                case 'SubType__c':
                    customArr = true;
                    if (element.Type__c !== null && element.Type__c !==""){
                        obj = (obj = $rootScope.scriptElementTypes.find(function(a){return a.label.trim() == element.Type__c;}))!==undefined? obj.$$subTypes :[];
                    }else {
                        obj = null;
                    }
                    break;
                case 'DataRaptorBundleId__c':  
                    $rootScope.drBundles.filter(function(bundle) {
                        return bundle.Type__c === 'Load (JSON)';
                    }).forEach(function(bundle) {
                        obj[bundle.Name] = bundle.Id;
                    });
                    obj['   '] = '';
                    break;
                case 'Language__c':mapKeyInObject(obj, $rootScope.languages);
                    break;
                default: // no-op
            }
        } else if (property.isForDataRaptor()) {
            $rootScope.drBundles.filter(function(bundle) {
                if (/transformBundle/i.test(property.label) || /DataRaptor Transform Action/.test(element.type())) {
                    return bundle.Type__c === 'Transform';
                } else if (/DataRaptor Extract Action/.test(element.type())) {
                    return bundle.Type__c === 'Extract (JSON)' || (isIntegrationProcedure && bundle.Type__c === 'Extract');
                } else if (/DataRaptor Post Action/.test(element.type())) {
                    return bundle.Type__c === 'Load (JSON)' || (isIntegrationProcedure && bundle.Type__c === 'Load' && bundle.InputType__c !== 'SObject');
                }
                return true;
            }).forEach(function(bundle) {
                obj[' ' + bundle.Name] = bundle.Name;
            });
            if (!(/docuSignTemplatesGroupSig/.test(property.type) || /docuSignTemplatesGroup/.test(property.type))) {
                obj['+ Create New DataRaptor'] = '+ Create New DataRaptor';
            }
            obj['   '] = '';
        } else if (/optionSource/.test(property.label) && /Select/.test(element.Type__c.label)){
            obj = {
                'SObject': 'SObject',
                'Custom': 'Custom',
                'Manual': ''
            };
        }  else if (/optionSource/.test(property.label)){
            obj = {
                'SObject': 'SObject',
                'Custom': 'Custom',
                'Image':'image',
                'Manual': ''
            };
        }else if (/timezone/.test(property.label)){
            obj = {
                'User Timezone': 'User',
                //'Starting Timezone': 'start',
                'Local Timezone': 'Local'
            };
        }else if (/horizontalMode/.test(property.label) && /Select/.test(element.Type__c.label)){
            obj = {
                'Horizontal': true,
                'Vertical': false
            };
        }  else if (/horizontalMode/.test(property.label)){
            obj = {
                'Horizontal': true,
                'Vertical': false,
                'Image': 'image'
            };
        } else if (/cancelType/.test(property.label)) {
            obj = {
                'SObject': 'SObject',
                'URL': 'URL',
                'Redirect': 'Redirect',
                'Dismiss': 'Dismiss'
            };
        } else if (/^controllingField/.test(property.label)) {
            obj= {
                'SObject': 'SObject',
                'Custom': 'Custom',
                'None': ''
            };
        } else if (/^validationRequired$/.test(property.label) && !element.isStep()) {
            if (element.parent() instanceof ScriptElement) {
                obj = {'Submit': 'Submit'};
                obj[$localizable('DRMapperNone', 'None')] = null;
                // OMNI-423 - fix currentValue if it is "Step" and it's in the Action usecase
                if (property.currentValue === 'Step') {
                    property.currentValue = 'None';
                    property.update();
                }
            } else {
                obj = validationRequired;
            }
        } else if (/PDF Action/.test(element.type()) && /templateName/.test(property.label)) {
            $rootScope.pdfs.forEach(function(pdf) {
                obj[pdf.DeveloperName] = pdf.DeveloperName;
            });
            obj['   '] = null;
            if (!obj[property.currentValue]) {
                property.currentValue = null;
                property.update();
            }
        } else if (/(Formula|Aggregate)/.test(element.type()) && /dataType/.test(property.label)) {
            obj = {
                '   ': null,
                'Date': 'Date',
                'Boolean': 'Boolean',
                'Number': 'Number',
                'Currency': 'Currency',
                'Text': 'Text'
            };
        } else if (/Done Action/.test(element.type()) && /type/.test(property.label)) {
            obj = {
                'SObject': 'SObject',
                'URL': 'URL',
                'Redirect': 'Redirect'
            };
        }  else if (/Rest Action/.test(element.type()) && /type/.test(property.label)) {
            obj = {
                'Web': 'Web',
                'Apex': 'Apex',
                'Named Credential': 'Named Credential',
                'SOAP/XML': 'SOAP/XML'
            };
        } else if (/integrationProcedureKey/.test(property.label)) {
            obj[' '] = null;
            $rootScope.intProcedureKeys.forEach(function(key) {
                obj[key] = key;
            });
        } else if (/^Filter$/.test(element.type()) && /type/.test(property.label)) {
            obj = {
                'Select': 'Select',
                'Multi-select': 'Multi-select'
            };
        } else if ((/^Selectable Items$/.test(element.type()) || /^Edit Block$/.test(element.type())) && /selectMode/.test(property.label)) {
            obj = {
                'Single': 'Single',
                'Multi': 'Multi'
            };
        } else if (/^Validation/.test(element.type()) && /messages/.test(property.label)) {
            obj = {
                'Comment': 'Comment',
                'Success': 'Success',
                'Warning': 'Warning'
            };
            if (property.currentValue.value === false) {
                obj.Requirement = 'Requirement';
            }
        } else if (/^conditionType$/.test(property.label)) {
            obj = {
                'Hide element if false': 'Hide if False',
                'Set element to read only if false': 'Readonly if False',
                'Set required element to optional if false': 'Optional if False'
            };
        } else if (/Template/i.test(property.label)) {
            obj = templateMgr.getTemplates(templates,property);
        } else if (/language$/.test(property.label)) {
            mapKeyInObject(obj, $rootScope.languages);
        } else if (/^dateType$/.test(property.label)) {
            obj={
                'date': 'date',
                'string': 'string'
            };
        } else if (/matrixName/.test(property.label) && /Matrix Action/.test(element.type())){
            $rootScope.matrixNames.forEach(function(matrix) {
                obj[matrix] = matrix;
            });
            obj['   '] = null;
            if (!obj[property.currentValue]) {
                property.currentValue = null;
                property.update();
            }
        }

        if (obj && Object.keys(obj).length === 0 && !customArr) {
            if (element.PropertySet__c[property.label]) {
                obj[element.PropertySet__c[property.label]] = element.PropertySet__c[property.label];
            }
            obj['   '] = null;
        }
        
        // To avoid firing the watcher on every run, the same array (scope.options) is returned on each call
        if (asArray) {
            // on first run set update behavior
            if (this.options === undefined){
                this.options = [];
                // set appropriate update function
                if (customArr){
                    // special cases like Type and SubType
                    this.updateOptions = function(newVal,oldVal,scope){
                        scope.options = newVal;
                        return null;
                    };
                } else{
                    // default behavior
                    this.updateOptions = function(newVal,oldVal,scope){
                        updateArray(scope.options,newVal);
                        return null;
                    };
                }
            }

            this.updateOptions(obj,null,this);
            return this.options;

        } 
        
        return obj;
    };
});

},{"../../../polyfills/Array.includes.js":62,"../../oui/util/HtmlEncodeDecode.js":50,"../../oui/util/ScriptElement.js":53,"../../oui/util/vlcUiTempMgr.js":57}],35:[function(require,module,exports){
angular.module("omniscriptDesigner")
.filter("placeholder", function() {
  return function(property) {
    // OMNI-1081 - Remove placeholders for now until we have more usefule text
    return '';
  };
});
},{}],36:[function(require,module,exports){
var Property = require('../../oui/util/Property.js');
var GroupedProperty = require('../../oui/util/GroupedProperty.js');
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module('omniscriptDesigner')
.filter('propertyLayout', function(propertyLayoutConfigurations) {
    'use strict';
    function removeEmptyRows(row) {
        return row && row.filter(function (entry) {
            return !!entry;
        }).length > 0;
    }

    function isActionRemote(element) {
        return element.parent() instanceof ScriptElement;
    }

    function makeLayoutFunction(layoutConfig) {
        var propertiesByKey = {};
        function mapEntryToRow(rowOrGroup, element) {
            function getAndRemoveProperty(propertyName) {
                var property = propertiesByKey[propertyName];
                delete propertiesByKey[propertyName];
                return property;
            }

            // if an array go through the entire and map each row
            if (angular.isArray(rowOrGroup)) {
                return rowOrGroup.map(function(item) {
                    if (angular.isObject(item)) {
                        var prop = getAndRemoveProperty(item.prop);
                        if (item.showIf && prop) {
                            prop.addShowIfRule(item.showIf);
                        }
                        return prop;
                    } else {
                        return getAndRemoveProperty(item);
                    }
                });
            } else if (angular.isString(rowOrGroup)) {
                if (rowOrGroup === '<<nonlisted>>') {
                    return ['<<nonlisted>>'];
                }
                return [getAndRemoveProperty(rowOrGroup)];
            } else if (angular.isObject(rowOrGroup)) {
                if (rowOrGroup.prop) {
                    var prop = getAndRemoveProperty(rowOrGroup.prop);
                    if (rowOrGroup.showIf) {
                        if (prop) {
                            prop.addShowIfRule(rowOrGroup.showIf);
                        }
                        if (!rowOrGroup.layoutrows) {
                            return [prop];
                        }
                    }
                    var count = 0, layoutrows;
                    if (rowOrGroup.repeated && element && angular.isArray(element.PropertySet__c[rowOrGroup.prop])) {
                        count = element.PropertySet__c[rowOrGroup.prop].length;
                        // map the entries to be prefixed with the prop name & index
                        // e.g. itemsKey => persistentComponent.0.itemsKey
                        layoutrows = element.PropertySet__c[rowOrGroup.prop].map(function(property, index) {
                            return rowOrGroup.layoutrows.map(function(row) {
                                function prefix(item) {
                                    if (angular.isObject(item)) {
                                        item = angular.copy(item);
                                        item.prop = prefix(item.prop);
                                        return item;
                                    }
                                    return /^\!/.test(item) ? item.substring(1) : rowOrGroup.prop + '.' + index + '.' + item;
                                }
                                return angular.isArray(row) ? row.map(prefix) : prefix(row);
                            }).map(function(config) {
                                return mapEntryToRow(config, element);
                            }).filter(removeEmptyRows);
                        });
                    } else {
                        // map the entries to be prefixed with the prop name,
                        // e.g. itemsKey => persistentComponent.itemsKey
                        layoutrows = rowOrGroup.layoutrows.map(function(row) {
                            function prefix(item) {
                                if (angular.isObject(item)) {
                                    item = angular.copy(item);
                                    item.prop = prefix(item.prop);
                                    return item;
                                }
                                return /^\!/.test(item) ? item.substring(1) : rowOrGroup.prop + '.' + item;
                            }
                            return angular.isArray(row) ? row.map(prefix) : prefix(row);
                        }).map(function(config) {
                            return mapEntryToRow(config, element);
                        }).filter(removeEmptyRows);
                    }
                    var layoutGroup = new GroupedProperty(
                      rowOrGroup.prop,
                      rowOrGroup.title,
                      layoutrows,
                      element,
                      count,
                      prop,
                      rowOrGroup.layoutrows
                    );
                    if (rowOrGroup.hasOwnProperty('collapse')) {
                        layoutGroup.collapse = rowOrGroup.collapse;
                    }
                    if (rowOrGroup.showIf) {
                        layoutGroup.addShowIfRule(rowOrGroup.showIf);
                    }
                    if (layoutGroup.layoutrows.length > 0 || /persistentComponent/.test(layoutGroup.prop)) {
                        return [layoutGroup];
                    } else {
                        return [];
                    }
                } else {
                    var group = new GroupedProperty(
                      null,
                      rowOrGroup.title,
                      rowOrGroup.layoutrows.map(function(config) {
                        return mapEntryToRow(config, element);
                      }).filter(removeEmptyRows),
                      element,
                      !!rowOrGroup.repeated
                    );
                    if (rowOrGroup.hasOwnProperty('collapse')) {
                        group.collapse = rowOrGroup.collapse;
                    }
                    if (rowOrGroup.showIf) {
                        group.addShowIfRule(rowOrGroup.showIf);
                    }
                    if (group.layoutrows.length > 0) {
                        return [group];
                    }
                    return [];
                }
            }
            return [];
        }

        function addNestedProps(property, element, propertiesByKey) {
            if (property.type === 'object') {
                Object.keys(property.defaultValue).map(function(propName) {
                    propertiesByKey[property.label + '.' + propName] =
                          new Property(property.label + '.' + propName, property.defaultValue[propName], element, true);
                });
            } else if (/persistentComponent/.test(property.label)) {
                property.defaultValue.forEach(function(defaultValue, index) {
                    Object.keys(defaultValue).map(function(propName) {
                        // add nested and indexed props
                        if (!property.currentValue || index < property.currentValue.length) {
                            propertiesByKey[property.label + '.' + index + '.' + propName] =
                                new Property(property.label + '.' + index + '.' + propName, defaultValue[propName], element, true);
                        }
                    });
                });
                if (element.PropertySet__c[property.label].length > property.defaultValue.length) {
                    /*jshint -W083 */
                    for (var index = Math.max(property.defaultValue.length - 1, 0);
                            index < element.PropertySet__c[property.label].length ; index++) {
                        Object.keys(element.PropertySet__c[property.label][index]).map(function(propName) {
                            // add nested and indexed props
                            propertiesByKey[property.label + '.' + index + '.' + propName] =
                                new Property(property.label + '.' + index + '.' + propName,
                                             element.PropertySet__c[property.label][index][propName], element, true);
                        });
                    }
                }
            }
        }

        return function(properties, element) {
            propertiesByKey = {};
            properties.forEach(function(property) {
                propertiesByKey[property.label] = property;
                // add nested props
                addNestedProps(property, element, propertiesByKey);
            });
            var layout = layoutConfig.reduce(function(array, config) {
                var output = mapEntryToRow(config, element);
                if (angular.isArray(output) && angular.isArray(output[0])) {
                    array = array.concat(output);
                } else {
                    array.push(output);
                }
                return array;
            }, []);
            // show & conditionType are configured differently
            var remainingproperties = Object.keys(propertiesByKey).filter(function(key) {
                return !/^(show|conditionType|showPersistentComponent\..*)$/.test(key);
            }).map(function(key) {
                return propertiesByKey[key];
            });
            var insertRemainingPropertiesAtIndex = -1;
            _.forEach(layout, function(row, index) {
                if (row && row.length === 1 && row[0] === '<<nonlisted>>') {
                    insertRemainingPropertiesAtIndex = index;
                    return false;
                }
            });
            if (insertRemainingPropertiesAtIndex !== -1) {
                return layout.slice(0, insertRemainingPropertiesAtIndex).concat(defaultLayoutAlgorithm(remainingproperties))
                            .concat(layout.slice(insertRemainingPropertiesAtIndex+1)).filter(removeEmptyRows);
            }
            return layout.concat(defaultLayoutAlgorithm(remainingproperties)).filter(removeEmptyRows);
        };
    }

    var actionLayoutPropertiesFiterRules = {
        'Default': {
            'Button': ['controlWidth', 'redirectPreviousLabel', 'redirectPreviousWidth'],
            'Remote': ['inProgressMessage', 'postMessage',
                  'failureNextLabel', 'failureAbortLabel', 'failureAbortMessage',
                  'redirectNextLabel', 'redirectNextWidth']
        },
        'Review Action': {
            'Button': ['controlWidth', 'previousLabel', 'previousWidth'],
            'Remote': ['nextLabel', 'nextWidth']
        }
    };

    function defaultLayoutAlgorithm(properties) {
        var layout = [],
            props = {}, row, rowKey,
            maxRows = 4, i, prop,lastRow,
            pairedProps = {};
        // iterate once and put into pairs
        for (i = 0; i < properties.length; i++) {
            switch (properties[i].label) {
                case 'conditionType':  // we don't render 'conditionType' as a regular property
                case 'show':        break; // we don't render 'show' as a regular property
                case 'min' :  // intentionally fall through to group these
                case 'max' :  // intentionally fall through to group these
                case 'minLength' :  // intentionally fall through to group these
                case 'maxLength' :  if (!pairedProps.minmax) {
                    pairedProps.minmax = [properties[i]];
                } else {
                    pairedProps.minmax.push(properties[i]);
                }
                    props[properties[i].label] = properties[i];
                    break;
                case 'preTransformBundle' : // intentionally fall through to group these
                case 'postTransformBundle' : if (!pairedProps.prePostTransform) {
                    pairedProps.prePostTransform = [properties[i]];
                } else {
                    pairedProps.prePostTransform.push(properties[i]);
                }
                    props[properties[i].label] = properties[i];
                    break;
                case 'pattern':
                case 'ptrnErrText': if (!pairedProps.patternAndErr) {
                    pairedProps.patternAndErr = [properties[i]];
                } else {
                    pairedProps.patternAndErr.push(properties[i]);
                }
                    props[properties[i].label] = properties[i];
                    break;
                case 'InternalNotes__c':
                    pairedProps.InternalNotes__c = [properties[i]];
                    pairedProps.InternalNotes__c.push('');
                    props[properties[i].label] = properties[i];
                    break;
                case 'remoteOptions' : // remote options should never be paired because it takes up too much space
                    props[properties[i].label] = properties[i];
                    break;
                default:            // find matching pairs (e.g. previousLabel, previousWidth)
                    var prefix = properties[i].label.split(/[A-Z]/)[0];
                    if (!pairedProps[prefix]) {
                        pairedProps[prefix] = [properties[i]];
                    } else {
                        pairedProps[prefix].push(properties[i]);
                    }
                    props[properties[i].label] = properties[i];
            }
        }

        for (rowKey in pairedProps) {
            row = pairedProps[rowKey];
            if (row.length > 1) {
                for (i = 0; i < row.length;) {
                    var newRow = [row[i++]];
                    props[newRow[0].label] = null;
                    if (i < row.length) {
                        newRow.push(row[i++]);
                        props[newRow[1].label] = null;
                    }
                    if(rowKey === 'InternalNotes__c')
                        lastRow = newRow;
                    else
                        layout[maxRows++] = newRow;
                }
            }
        }
        for (prop in props) {
            if (props[prop]) {
                layout[maxRows++] = [props[prop]];
            }
        }
        if (layout.length > maxRows) {
            layout.splice(maxRows, layout.length);
        }
        layout[maxRows++] = lastRow;
        return layout;
    }

    propertyLayoutConfigurations = Object.keys(propertyLayoutConfigurations).reduce(function(obj, key) {
        obj[key] = makeLayoutFunction(propertyLayoutConfigurations[key]);
        return obj;
    }, {});

    return function buildLayout(properties, element) {
        var organizerAlgo = null,
            propertiesToExclude = ['accessibleInFutureSteps', 'debounceValue', 'restOptions.responseType', 'DataRaptorBundleId__c', 'autoFocus', 'disOnTplt'];

        //label need not be displayed when the element is a line break
        if (/Line Break/.test(element.Type__c && element.Type__c.label)){
            propertiesToExclude.push('label');
        }

        // Exclude hide property for all but formula and aggregate
        if (!/(?:Formula)|(?:Aggregate)/.test(element.Type__c && element.Type__c.label)) {
            propertiesToExclude.push('hide');
        }

         // Exclude svgSprite and svgIcon property for these four actions
        if (/(?:Remote Action)|(?:Matrix Action)|(?:Rest Action)|(?:Integration Procedure Action)/.test(element.Type__c && element.Type__c.label)) {
            propertiesToExclude.push('svgSprite');
            propertiesToExclude.push('svgIcon');
        }

        if (element.isAction()) {
            var layoutRules = actionLayoutPropertiesFiterRules[element.type()];
            if (!layoutRules) {
                layoutRules = actionLayoutPropertiesFiterRules.Default;
            }
            propertiesToExclude = propertiesToExclude.concat(isActionRemote(element) ? layoutRules.Button :
                                                                        layoutRules.Remote);
        }
        if (propertiesToExclude) {
            var excludeRegexp = new RegExp('^(' + propertiesToExclude.join('|') + ')$');
            properties = properties.filter(function(property) {
                return !excludeRegexp.test(property.label);
            });
        }
        organizerAlgo = propertyLayoutConfigurations[element.type()] || propertyLayoutConfigurations.Default;
        return organizerAlgo(properties, element);
    };
});

},{"../../oui/util/GroupedProperty.js":49,"../../oui/util/Property.js":52,"../../oui/util/ScriptElement.js":53}],37:[function(require,module,exports){
var ScriptElement = require('../../oui/util/ScriptElement.js');

angular.module('omniscriptDesigner')
.filter('readablePropertyName', function() {
    var transforms = {
        'label': 'Label',
        'Name' : 'Element Name',
        'controlWidth': 'Control Width',
        'required': 'Required?',
        'help': 'Help text active?',
        'showInputWidth': 'Label outside of field',
        'inputWidth': 'Field Width',
        'helpText': 'Help Text',
        'show': 'Hide Element If False',
        'mask': 'Mask',
        'maskCurrency': 'Decimal Places',
        'pattern': 'Pattern',
        'ptrnErrText': 'Error Text',
        'Active__c': 'Active?',
        'IsReusable__c': 'Reusable?',
        'Type__c': 'Type',
        'SubType__c': 'SubType',
        'DataRaptorBundleId__c': 'DataRaptor Submit Interface',
        'Language__c': 'Language',
        'bundle': 'DataRaptor Interface',
        'preTransformBundle': 'Pre-Transform DataRaptor Interface',
        'postTransformBundle': 'Post-Transform DataRaptor Interface',
        'xmlPreTransformBundle': 'XML Pre-Transform DataRaptor Interface',
        'xmlPostTransformBundle': 'XML Post-Transform DataRaptor Interface',
        'transformBundle' : 'Transform DataRaptor Interface',
        'remoteTimeout': 'Remote Timeout (ms)',
        'instruction': 'Instruction (Horizontal Mode Only)',
        'URIEncode': 'Encode URI',
        'docuSignReturnUrl': 'DocuSign Return Url',
        'AdditionalInformation__c' : 'Description',
        'InternalNotes__c' : 'Internal Notes',
        'callFrequency' : 'Call Frequency (ms)',
        'fileAttachments' : 'File Attachments from OmniScript',
        'staticDocList' : 'Document Attachments',
        'docList' : 'Document Attachments from OmniScript',
        'wpm': 'Window Post Message?',
        'ssm': 'Session Storage Message?',
        'docuSignTemplatesGroup': 'DocuSign Templates Group',
        'docuSignTemplatesGroupSig': 'DocuSign Templates Group',
        'horizontalMode':'Display Mode',
        'type':'Option Source',
        'padding': 'Additonal Padding (px)',
        'svgSprite':'Default Svg Sprite',
        'svgIcon':'Default Svg Icon',
        'elementName':'Svg Controlling Element',
        'selectCheckBox':'Checkbox Element Name',
        'valueSvgMap':'Svg Controlling Element Map',
        'advancedMergeMap':'Advanced Merge Map',
        'columnsPropertyMap':'Columns Property Map',
        'linkToExternalObject' : 'External Objects Page',
        'labelSingular':'Singular Label',
        'labelPlural':'Plural Label',
        'nameColumn':'Column Name',
        'disOnTplt': 'Display On Template',
        'allowMergeNulls': 'NULL is a Valid Matching Value when Merging'
    };

    // creates String acronyms = '(JSON|XML|URL|...)' for use in regex patterns
    acronyms = (function (acArr){
            var pattern = "";
            acArr.forEach(function(item){
                pattern = pattern +'|'+ item;
            });
            return pattern.replace(/^\|/,"(?:")+')';
        })([
        // Array of acronyms to be handled by regex. Replace will capitalize these so don't include lower case 
        'JSON','REST','HTTP','HTML','XML','URL','URI'
    ]);

    var elementSpecificTransforms = {
        'PDF Action': {
            'templateName': 'Document'
        },
        'Script Configuration': {
            'Name': 'OmniScript name'
        },
        'Procedure Configuration': {
            'Name': 'Integration Procedure Name'
        }
    };

    return function(propertyName, element) {
        if (propertyName) {
            var parts = propertyName.split('.');
            if (/^showPersistentComponent$/.test(parts[0]) && parts.length > 1) {
                return parts[1];
            }

            //changing label name from mask to decimal places for currency
            var typeC = element['Type__c'];
            if (typeC && /Mask/i.test(propertyName) && /Currency/i.test(typeC.label)) {
                return transforms['maskCurrency'];
            }
            
            var lastPropName = parts[parts.length - 1];
            if (element && elementSpecificTransforms[element.type()]) {
                if (elementSpecificTransforms[element.type()][lastPropName]) {
                    return elementSpecificTransforms[element.type()][lastPropName];
                }
            } else if (/^\d+$/.test(lastPropName)) {
                return +lastPropName + 1;
            }
            if (transforms[propertyName]) {
                return transforms[propertyName];
            } else if (transforms[lastPropName]) {
                return transforms[lastPropName];
            }
            if (/Rest Action/i.test((element.Type__c||{label:""}).label||""))
                lastPropName = lastPropName.replace(/[Rr]est([A-Z])/, 'http$1');
            return lastPropName
                  // puts space before words, capitalized acronyms and numbers
                  .replace(new RegExp(/[A-Z][a-z]+|[A-Z]+(?=[A-Z][a-z]|$)|[0-9]+/,'g'),' $&')
                  // Capitalizes recognized acronyms and first character
                  .replace(new RegExp('\\b'+acronyms+'\\b\|^.','ig'), v => v = v.toUpperCase())
                  .trim();
        }
        return '';
    };
});

},{"../../oui/util/ScriptElement.js":53}],38:[function(require,module,exports){
var scriptElement = require('../../oui/util/ScriptElement.js');

angular.module('omniscriptDesigner')
.filter('templateForProperty', function() {
    function isReusableScriptElement(element) {
        return element.Type__c && element.Type__c.isScript && element.Type__c.isScript();
    }
    function isScriptElement(element) {
        return element instanceof scriptElement;
    }

    function isStep(element) {
        return element.isStep && element.isStep();
    }

    var selectableItemsPropToElementType = {
        'bundle':['DataRaptor Extract Action', 'DataRaptor Post Action', 'DataRaptor Transform Action' ],
        'optionSource.type':[],
        'horizontalMode':[], 
        'timezone':[],
        'controllingField.type':[],
        'type':['Done Action', 'Filter', 'Rest Action'],
        'templateName':['PDF Action'],
        'preTransformBundle': ['!Step'],
        'postTransformBundle': ['!Step'],
        'xmlPreTransformBundle': ['!Step'],
        'xmlPostTransformBundle': ['!Step'],
        'transformBundle': ['!Step'],
        'vlcPreTransformBundle': [],
        'vlcPostTransformBundle': [],
        'validationRequired': ['!Step'],
        'selectMode': ['Selectable Items', 'Edit Block'],
        'dataType': ['Formula', 'Aggregate'],
        'Type':[isReusableScriptElement],
        'Sub Type':[isReusableScriptElement],
        'Language':[isReusableScriptElement],
        'language':[],
        'matrixName':['Matrix Action'],
        'integrationProcedureKey':['Integration Procedure Action']
    };

    function matchesSelectableProp(property, element) {
        var matchingElements = selectableItemsPropToElementType[property.label];
        if (!matchingElements && /\./.test(property.label)) {
            matchingElements = selectableItemsPropToElementType[property.label.substring(property.label.lastIndexOf('.') + 1)];
        }
        if (matchingElements && element) {
            if (matchingElements.length === 0) {
                return true;
            }
            return matchingElements.some(function(expectedElement) {
                if (angular.isString(expectedElement)) {
                    if (/^\!/.test(expectedElement)) {
                        return element.type() !== expectedElement.substring(1);
                    } else {
                        return element.type() === expectedElement;
                    }
                } else if (angular.isFunction(expectedElement)) {
                    return expectedElement(element);
                }
                return false;
            });
        }
        return false;
    }

    function useSelect(property, element) {
        // special case for complex option
        if ((isScriptElement(element) && /__c$/.test(property.label) && !property.isKeyValue() && !(/^(?:IsReusable)|(?:AdditionalInformation)|(?:(?:Sub)?Type)__c$/.test(property.label)))) {
            return true;
        } else {
            return matchesSelectableProp(property, element);
        }
    }

    function useTypeAhead(property, element) {
        return /(?:HTMLTemplateId)|(?:templateurl)|(?:(?:Sub)?Type)__c$/.test(property.label);
    }

    return function (property, element) {
        if (!property) {
            return '';
        }

        if (property.group){
            return 'group-template.tpl.html';
        }
        

        if (property.label === 'cancelType'){
            return 'select-property-template.tpl.html';
        }
        
        if (property.label === 'dataSource') {
            return 'datasource-property-template.tpl.html';
        }

        if (property.label === 'inputWidth') {
            //add value for property inputWidth
            property.show = element.PropertySet__c.showInputWidth;
            return 'slider-cw-property-template.tpl.html';
        }

        if (property.label === 'showInputWidth') {
            return 'checkbox-property-template.tpl.html';
        }

        if (/^element(Error|Value)Map$/.test(property.label)) {
            return 'set-error-values-property-template.tpl.html';
        }

        if (element && element.Type__c && /Disclosure/.test(element.Type__c.label) && property.label === 'text'){
            return 'rte-property-template.tpl.html'; //new
        }

        if (/^(executionConditionalFormula|failureConditionalFormula)$/.test(property.label)) {
            return 'formula-builder-property-template.tpl.html';
        }

        switch (property.type) {
            case 'key-value': return 'key-value-property-template.tpl.html';
            case 'emailBody':
            case 'InternalNotes__c':
            case 'textarea': return 'textarea-property-template.tpl.html';
            case 'expression': return 'expression-builder-property-template.tpl.html';
            case 'validation': return 'validation-expression-property-template.tpl.html';
            case 'validationMessages': return 'validation-messages-property-template.tpl.html';
            case 'object': return 'object-property-template.tpl.html';
            case 'rte': return 'rte-property-template.tpl.html';
            case 'array': 
            if (property.$parentProperty && property.$parentProperty.type == 'key-value') {
                return 'key-value-property-template.tpl.html';
            }
            if (/^([^\.]\.)?options$/.test(property.label)) {
                return 'options-property-template.tpl.html';
            } else if (/dataRaptor Input Parameters/.test(property.label) || /matrix Input Parameters/.test(property.label)) {
                return 'input-parameters-property-template.tpl.html';
            }
                return 'array-property-template.tpl.html';
            case 'checkbox': return 'checkbox-property-template.tpl.html';
            case 'spinner': return 'spinner-property-template.tpl.html';
            case 'slider': return 'slider-property-template.tpl.html';
            case 'docuSignTemplatesGroup': return 'docusign-signerlist-table.tpl.html';
            case 'docuSignTemplatesGroupSig': return 'docusign-signerlist-table-sig.tpl.html';
            case 'docuSignTemplate': return 'docusign-select-template.tpl.html';
            case 'signerInformation.templateRole': return 'docusign-signerinfo-template-role.tpl.html';
            case 'docuSignReturnUrl': return 'docusign-embed-signature-return-page.tpl.html';
            case 'googleAddressCountry': return 'typeahead-select-country.tpl.html';
            case 'googleTransformation': return 'typeahead-google-transformation.tpl.html';
            case 'emailTemplateInformation': return 'email-action-send-via-template.tpl.html';
            case 'emailInformation': return 'email-action-send-via-address.tpl.html';
            case 'useTemplate': return 'email-action-useTemplate-checkbox.tpl.html';
            case 'staticDocList': return 'email-action-document-attachments-multiselect.tpl.html';
            case 'dateType': return 'select-property-template.tpl.html';
            case 'valueSvgMap': return 'editblock-valuesvgmap-table.tpl.html';
            case 'advancedMergeMap': return 'listmerge-advancedmergemap-table.tpl.html';
            case 'columnsPropertyMap' : return 'external-object-columns-property-table.tpl.html';
            case 'relationshipFieldsMap' : return 'external-object-relationship-fields-table.tpl.html';
            case 'linkToExternalObject' : return 'external-object-url.tpl.html';
            case 'sobjectMapping': return 'editblock-sobjectfieldmap-table.tpl.html';
            case 'selectSobject': return 'editblock-object-select-template.tpl.html';
            default:
                if (useSelect(property, element)) {
                    return 'select-property-template.tpl.html';
                } else if (useTypeAhead(property, element)) {
                    return 'typeahead-property-template.tpl.html';
                }
                return 'property-template.tpl.html';

        }
    };
});

},{"../../oui/util/ScriptElement.js":53}],39:[function(require,module,exports){
angular.module('omniscriptDesigner')
.factory('propertyLayoutConfigurations', function() {
  'use strict';

  var aggregateAndFormulaLayout = [
  ['Name', 'controlWidth'],
  ['label','dataType'],
  ['showInputWidth','inputWidth'],
  'expression',
  {
    title: 'Formatting',
    collapse: false,
    showIf: 'dataType == "Number" || dataType == "Currency" || dataType == "Date"',
    layoutrows: [
    [{
      prop: 'mask',
      showIf: 'dataType == "Number" || dataType == "Currency"'
    },{
      prop: 'currencySymbol',
      showIf: 'dataType == "Currency"'
    }],
    {
      prop: 'hideGroupSep',
      showIf: 'dataType == "Currency"'
    },
    [{
      prop: 'dateFormat',
      showIf: 'dataType == "Date"'
    }, null],
    ]
  },
  ['hide',null]
  ];

  var layoutConfigurations = {
    'Procedure Configuration':[
        ['Name', 'controlWidth'],
        ['Type__c' ,'SubType__c'],
        {
            prop: 'linkToExternalObject',
            showIf: 'this.$canvasElement.Type__c == "VlocityExternalObject"'
        },
        {
            title: 'Table Property',
            collapse: false,
            showIf: 'this.$canvasElement.Type__c == "VlocityExternalObject"',
            layoutrows: [
            ['nameColumn', 'description'],
            ['labelSingular','labelPlural']
            ]
        },
        {
            prop: 'columnsPropertyMap',
            showIf: 'this.$canvasElement.Type__c == "VlocityExternalObject"'
        },
        {
            prop: 'relationshipFieldsMap',
            showIf: 'this.$canvasElement.Type__c == "VlocityExternalObject"'
        },
        'Description__c'
    ],
    'DataRaptor Extract Action': [
        ['Name', 'controlWidth'],
        'label',
        ['bundle','remoteTimeout'],
        'dataRaptor Input Parameters',
        ['validationRequired', 'showPersistentComponent'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, 
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'Matrix Action': [
        ['Name', 'controlWidth'],
        'label',
        'matrix Input Parameters',
        ['validationRequired', 'showPersistentComponent'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'DataRaptor Post Action': [
        ['Name', 'controlWidth'],
        'label',
        ['bundle','remoteTimeout'],
        'dataRaptor Input Parameters',
        ['validationRequired', 'showPersistentComponent'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'DataRaptor Transform Action': [
        ['Name', 'controlWidth'],
        'label',
        ['bundle','remoteTimeout'],
        ['validationRequired', 'showPersistentComponent'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'Post to Object Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', 'showPersistentComponent'],
        'useRest',
        {
          title: 'Remote Options',
          collapse: true,
          showIf: '!useRest',
          layoutrows: [
           ['remoteClass', 'remoteMethod']
          ]
        },
        {
          title: 'REST Options',
          collapse: true,
          showIf: 'useRest',
          layoutrows: [
           ['restPath', 'restMethod']
          ]
        },
        'postNameTemplate',
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['postTransformBundle', null],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'Remote Action': [
        ['Name', 'controlWidth'],
        'label',
        ['remoteClass','remoteMethod'],
        ['remoteTimeout', null],
        ['validationRequired', 'showPersistentComponent'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'DocuSign Envelope Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', 'showPersistentComponent'],
        'docuSignTemplatesGroup',
        'emailSubject',
        'emailBody',
        ['dateFormat','dateTimeFormat'],
        ['timeFormat','readOnly'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Remote Properties',
          collapse: true,
          layoutrows: [
          ['remoteTimeout']
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['transformBundle', null],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'DocuSign Signature Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', 'showPersistentComponent'],
        ['docuSignTemplate', null],
        'docuSignTemplatesGroupSig',
        {
          title: 'Signer Information',
          prop: 'signerInformation',
          layoutrows: [
          ['signerName', 'signerEmail'],
          ['templateRole', null]
          ]
        },
        'emailSubject',
        'docuSignReturnUrl',
        ['dateFormat','dateTimeFormat'],
        'timeFormat',
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Remote Properties',
          collapse: true,
          layoutrows: [
          ['remoteTimeout']
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['transformBundle', null],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'Type Ahead Block': [
        ['Name', 'controlWidth'],
        ['required', 'readOnly'],
        'label',
        ['showInputWidth','inputWidth'],
        ['help', 'helpText'],
        ['minLength', 'maxLength'],
        ['typeAheadKey', 'dataProcessorFunction'],
        ['newItemLabel', 'callFrequency'],
        ['editMode', 'hideEditButton'],
        ['useDataJson', 'dataJsonPath'],
        {
          title: 'Google Maps Autocomplete',
          collapse: true,
          layoutrows: [
          ['enableGoogleMapsAutocomplete', 'hideMap'],
          ['googleMapsAPIKey','googleAddressCountry'],
          'googleTransformation'
          ]
        }
    ],
    'Email Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', 'showPersistentComponent'],
        'useTemplate',
        'emailTemplateInformation',
        'emailInformation',
        ['fileAttachments','docList'],
        'staticDocList',
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Remote Properties',
          collapse: true,
          layoutrows: [
          ['remoteTimeout']
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }
    ],
    'Rest Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', 'showPersistentComponent'],
        ['restPath','restMethod'],
        [{ 
            prop: 'type',
            showIf: 'type !== "Integration"'
          }, 
          {
          prop: 'namedCredential',
          showIf: 'type === "Named Credential" || type === "SOAP/XML" || type === "Integration"'
        }],
        {
          title: 'REST Options',
          collapse: true,
          prop: 'restOptions',
          showIf: 'type === "Web" || type === "Named Credential" || type === "SOAP/XML" || type === "Integration"',
          layoutrows: [
          'headers',
          'params',
          'URIEncode',
          ['cache','withCredentials'],
          ['sendBody', 'timeout'],
          ['isCompressed', 'clientCertificateName'],
          [{
            prop: 'responseType',
            showIf: 'false'
          }, null]
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          [{
            prop: 'preTransformBundle',
            showIf: 'type !== "SOAP/XML"'
          }, {
            prop: 'postTransformBundle',
            showIf: 'type !== "SOAP/XML"'
          }],
          [{
            prop: 'xmlPreTransformBundle',
            showIf: 'type === "SOAP/XML"'
          }, {
            prop: 'xmlPostTransformBundle',
            showIf: 'type === "SOAP/XML"'
          }],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
          title: 'Debug Logging',
          'collapse': false,
          layoutrows: [
          ['preActionLogging', 'postActionLogging']
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        },
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        },
        'executionConditionalFormula',
        'failureConditionalFormula',
        'failOnStepError'
    ],
    'PDF Action': [
        ['Name', 'controlWidth'],
        'label',
        ['templateName', 'remoteTimeout'],
        ['validationRequired', 'showPersistentComponent'],
        ['displayHeight', 'displayWidth'],
        ['dateFormat', 'dateTimeFormat'],
        ['timeFormat', null],
        ['attachmentName', 'attachmentParentId'],
        ['showPopup', null],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, 
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'Script Configuration': [
        ['Name','AdditionalInformation__c'],
        ['Type__c', 'SubType__c'],
        ['Language__c', 'currencyCode'],
        ['IsReusable__c', 'timeTracking'],
        ['showInputWidth', null],
        'includeCustomization',
        'elementTypeToHTMLTemplateMapping',
        'seedDataJSON',
        'trackingCustomData',
        'visualforcePagesAvailableInPreview',
        {
          prop: 'persistentComponent',
          title: 'Persistent Component',
          repeated: true,
          collapse: true,
          layoutrows: [
          ['id','itemsKey'],
          'label',
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode'],
          ['remoteClass', 'remoteMethod'],
          ['remoteTimeout', 'render'],
          'remoteOptions',
          'modalConfigurationSetting'
          ]
        },{
          title: 'Cancel Options',
          collapse:true,
          layoutrows:[
            ['cancelType','cancelSource'],
            ['cancelRedirectPageName', 'cancelRedirectTemplateUrl'],
            ['consoleTabLabel', null],
            ['wpm', 'ssm'],
            ['message']
          ]
        },
        {
            title: 'Save Options',
            collapse: true,
            layoutrows: [
              ['allowSaveForLater', {
                prop: 'autoSaveOnStepNext',
                showIf: 'allowSaveForLater == true'
              }],
              ['saveNameTemplate', 'saveExpireInDays'],
              ['saveForLaterRedirectPageName', 'saveForLaterRedirectTemplateUrl'],
              ['saveObjectId', 'saveContentEncoded'],
              'saveURLPatterns'
            ]
        },
        {
            title: 'Knowledge Options',
            collapse: true,
            layoutrows: [
            ['enableKnowledge', null],
            {
              prop: 'knowledgeArticleTypeQueryFieldsMap',
              showIf: 'enableKnowledge == true'
            }
            ]
        }
    ],
    'Selectable Items': [
        ['Name',null],
        'label',
        ['remoteClass', 'remoteMethod'],
        'remoteOptions',
        ['remoteTimeout', null],
        ['preTransformBundle', 'postTransformBundle'],
        ['HTMLTemplateId', 'itemsKey'],
        ['selectMode', 'dataJSON'],
        ['currencySymbol', null],
        {
          title: 'Modal Compare Setting',
          collapse: true,
          layoutrows: [
          ['modalHTMLTemplateId', 'modalController'],
          ['modalSize', 'maxCompareSize']
          ]
        },
        {
          title: 'Modal Configuration Setting',
          prop: 'modalConfigurationSetting',
          collapse: true,
          layoutrows: [
          ['modalHTMLTemplateId', 'modalController'],
          ['modalSize',null]
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'Done Action': [
        ['Name', 'controlWidth'],
        'label',
        ['validationRequired', null],
        ['type', 'source'],
        ['redirectPageName', 'redirectTemplateUrl'], ['consoleTabLabel', null], {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        }
    ],
    'Integration Procedure Action': [
        ['Name', 'controlWidth'],
        'label',
        ['remoteClass','remoteMethod'],
        ['remoteTimeout', null],
        ['validationRequired', 'showPersistentComponent'],
        ['integrationProcedureKey'],
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        }, {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        },
        'remoteOptions'
    ],
    'List Merge Action': [
        'Name',
        'mergeListsOrder',
        'advancedMerge',
        {
        	  prop: 'mergeFields',
        	  showIf: 'advancedMerge == false'
        },
        {
        	  prop: 'advancedMergeMap',
        	  showIf: 'advancedMerge == true'
        },
        'mergeFields',
        'advancedMergeMap',
        'allowMergeNulls',
        'hasPrimary',
        {
          prop: 'primaryListKey',
          showIf: 'hasPrimary == true'
        },
        'filterListFormula',
        'sortBy',
        'sortInDescendingOrder',
        {
          title: 'Send/Response Transformations',
          collapse: false,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'Intelligence Action': [
        'Name',
        'machineDeveloperName',
        'inputData',
        'itemsToRankPath',
        ['pageSize', 'offset'],
        {
          title: 'Send/Response Transformations',
          collapse: false,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        }
    ],
    'Formula': aggregateAndFormulaLayout,
    'Aggregate': aggregateAndFormulaLayout,
    'Default': [
        ['Name', 'controlWidth'],
        ['required', 'readOnly'],
        ['repeat', {
          prop: 'repeatClone',
          showIf: 'repeat == true'
        }],
        'label',
        ['showInputWidth','inputWidth'],
        'instruction',
        ['validationRequired', 'showPersistentComponent'],
        ['help', 'helpText'],
        ['mask', 'currencySymbol'],
        ['dateFormat', 'timeFormat'],
        'placeholder',
        'dataSource',
        {
          title: 'Button Properties',
          collapse: true,
          layoutrows: [
          ['previousLabel', 'previousWidth'],
          ['nextLabel', 'nextWidth'],
          ['saveLabel', 'saveMessage'],
          ['cancelLabel', 'cancelMessage'],
          ['completeLabel', 'completeMessage']
          ]
        },
        {
          title: 'Options',
          prop: 'optionSource',
          collapse: false,
          layoutrows: [
            ['!horizontalMode','type'],
            [{
              prop: '!optionWidth',
              showIf: 'horizontalMode == "image"'
            },
            {
              prop: '!optionHeight',
              showIf: 'horizontalMode == "image"'
            }],
            {
              prop: '!enableCaption',
              showIf: 'horizontalMode == "image"'
            },
            {
              prop: 'source',
              showIf: '!(optionSource.type == ""||optionSource.type == "image")'
            },
            {
              prop: '!options', // preceding ! says not to prefix this property
              showIf: '(optionSource.type == ""||optionSource.type == "image")'
            }
          ]
        },
        {
          title: 'Controlling Field',
          prop: 'controllingField',
          collapse: true,
          layoutrows: [
            ['type', null],
            [{
              prop: 'source', 
              showIf: 'controllingField.type == "SObject" || (controllingField.source != "" && controllingField.source != null)'
            },
            {
              prop: 'element', // preceding ! says not to prefix this property
              showIf: 'controllingField.type != ""'
            }]
          ]
        },
        {
          title: 'Knowledge Options',
          prop: 'knowledgeOptions',
          collapse: true,
          layoutrows: [
          ['language', 'publishStatus'],
          ['keyword', 'dataCategoryCriteria'],
          ['remoteTimeout', null]
          ]
        },
        {
          title: 'User Messages',
          collapse: true,
          layoutrows: [
          ['inProgressMessage', 'postMessage'],
          ['failureNextLabel', 'failureAbortLabel'],
          'failureAbortMessage'
          ]
        },
        {
          title: 'Remote Properties',
          collapse: true,
          layoutrows: [
          ['remoteClass', 'remoteMethod'],
          ['remoteTimeout', 'remoteOptions']
          ]
        },
        {
          title: 'Redirect Properties',
          collapse: true,
          layoutrows: [
          ['redirectPageName', 'redirectTemplateUrl'],
          ['redirectNextLabel', 'redirectNextWidth'],
          ['redirectPreviousLabel', 'redirectPreviousWidth']
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        '<<nonlisted>>',
        'HTMLTemplateId'
    ],
    'Edit Block': [
        ['Name', 'controlWidth'],
        'label',
        ['allowNew', 'allowEdit'],
        ['allowDelete', null],
        ['newLabel', 'editLabel'],
        ['deleteLabel', null],
        ['svgSprite', 'svgIcon'],
        ['elementName', 'sumElement'],
        ['selectMode', 'selectCheckBox'],
        'valueSvgMap',
        {
          title: 'sObject Mapping',
          collapse: true,
          layoutrows: [
          ['selectSobject',null],
          'sobjectMapping'
          ]
        }
    ],
    'Filter': [
        'Name',
        'label',
        ['showInputWidth','inputWidth'],
        'attributeCategoryCode',
        'type'
    ],
    'Response Action': [
        ['Name', 'controlWidth'],
        'responseFormat',
        {
            prop: 'responseDefaultData',
            showIf: 'typeof responseDefaultData === "object" && Object.keys(responseDefaultData).length !== 0'
        },
        {
          title: 'Send/Response Transformations',
          collapse: false,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        'additionalOutput',
        'returnOnlyAdditionalOutput',
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        },
        'returnFullDataJSON'
    ],
    'Calculation Action': [
        ['Name', 'controlWidth'],
        'label',
         {
          title: 'Remote Properties',
          collapse: true,
          layoutrows: [
          ['remoteClass', 'remoteMethod'],
          ['remoteOptions'],
          ]
        },
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        },
        'executionConditionalFormula',
        'failOnStepError'
    ],
    'OmniForm' : [
        ['Name', 'controlWidth'],
        'label',
        {
          title: 'Send/Response Transformations',
          collapse: true,
          layoutrows: [
          ['sendJSONPath', 'sendJSONNode'],
          ['preTransformBundle', 'postTransformBundle'],
          ['responseJSONPath', 'responseJSONNode']
          ]
        },
        {
          title: 'Additional Input/Output/Failure Response',
          collapse: false,
          layoutrows: [
            ['sendOnlyAdditionalInput'],
            ['additionalInput'],
            ['returnOnlyAdditionalOutput'],
            ['additionalOutput'],
            ['returnOnlyFailureResponse'],
            ['failureResponse'],
          ] 
        },
        {
            prop: 'extraPayload',
            showIf: '(this.$canvasElement.scriptElement().IsProcedure__c == true && typeof extraPayload === "object" && Object.keys(extraPayload).length !== 0 && additionalInput != null) || this.$canvasElement.scriptElement().IsProcedure__c == false'
        },
        {
            prop: 'useFormulas',
            showIf: 'useFormulas == false'
        },
        'failureConditionalFormula',
        'executionConditionalFormula'
    ]
  };

    return layoutConfigurations;
  });

},{}],40:[function(require,module,exports){
(function() {
    'use strict';
    /* jshint -W030 */

    //var MAX_SIZE = 5048576;
    var MAX_SIZE = 750000; /* 1 000 000 * 3/4 to account for base64 */
    //var FILE_SIZE_WARNING = 'file size exceeds the limit';
    var FILE_SIZE_WARNING = 'File exceeds the 1mb Remote Action upload limit. Please go' +
        ' to the Documents tab to upload the file (up to 5mb).';
    var FAILED_UPLOAD = 'The file could not be uploaded';

    function isSmallEnough(file) {
        return file.size < MAX_SIZE ;
    }

    window.tinymce.PluginManager.add('docInsert', function(editor, url) {
        editor.addCommand('openDocInsertWindow', function(callback) {
            var obj = callback();
            obj.getDocs = obj.getDocs || []; /* obj = {getDocs: [], callback: function(){}} */
            var selValue = ''; //value selected from listbox

            editor.windowManager.open(
                {
                    title: obj.imageInsert ? 'Image Insert' : 'Document Insert',
                    width: 400,
                    height: 300,
                    body: [
                        {
                            id: 'insertFromSF',
                            type:'checkbox',
                            text:'pick from existing ' + (obj.imageInsert ? 'images' : 'documents'),
                            onclick: function() {
                                var toggleValue = $('#insertFromSF').attr('aria-checked');
                                $('#filePicker').toggle();
                                (toggleValue === 'true') ? $('#selDocuments').show() : $('#selDocuments').hide();

                                //clears the error message if any
                                $('#errorLabel').text('');
                            }
                        },
                        {
                            type: 'textbox',
                            id: 'filePicker',
                            onPostRender: function() {
                                $('#filePicker').attr('placeholder', 'click to browse for files');
                            },
                            onclick: function() {
                                //clears the error message if any
                                $('#errorLabel').text('');

                                $('#fileSelector').click();
                            },
                            onChange: function(e) {
                                var files = ($('input:file'))[0].file;

                            }
                        },
                        {
                            type:'selectbox',
                            id:'selDocuments',
                            style: 'height:25px; padding: 2px 0;background-color: #F0F0F0; border-radius: 3px',
                            width: 200,
                            options: obj.getDocs () || []
                        },
                        {
                            type: 'textbox',
                            subtype: 'file',
                            id: 'fileSelector',
                            style: 'display:none',
                            width: 200,
                            onPostRender: function() {
                                obj.imageInsert && (function() {
                                    setTimeout(function() {
                                        $('#fileSelector').attr('accept', 'image/*');
                                    });
                                }());
                            },
                            onChange: function(e) {
                                //updates the text field
                                var files = ($('input:file'))[0].files;
                                document.getElementById('filePicker').value = files[0].name;
                            }
                        },
                        {
                            type: 'container',
                            html:'<div><p style="color:red; word-break: break-all; white-space: normal;' +
                                'font-size: 12px; font-style: italic; position:relative; top:-20px" id="errorLabel"></p></div>'
                        }
                    ],
                    onPostRender: function() {
                        setTimeout(function() {
                            $('#selDocuments').hide();
                        });
                    },
                    onsubmit: function() {
                        var win = this;

                        //gets executed when select from salesforce is checked
                        ($('#insertFromSF').attr('aria-checked') === 'true') && (function() {

                            //getting the value from the selectbox
                            var value = $('#selDocuments').val(),
                                docId = '';
                            value && (function() {
                                docId = $.parseHTML (value)[0].id;
                            }());

                            //this step is very important otherwise
                            //the selValue contains non ascii
                            //characters
                            selValue = '' + selValue.trim();

                            if (/oid=/.test(docId)){
                                document.getElementById(obj.fieldName).value = 'https://' + window.location.hostname +
                                    '/servlet/servlet.ImageServer?id=' + docId;
                            } else {
                                document.getElementById(obj.fieldName).value = 'https://' + window.location.hostname +
                                    '/servlet/servlet.FileDownload?file=' + docId;
                            }

                            obj.callback = false;
                            win.close();
                            return true;
                        }());

                        //gets executes when the select from salesforce checkbox is not checked
                        obj.callback && (function() {
                            var files = ($('input:file'))[0].files;
                            var reader = new FileReader();
                            //console.log(files[0]);
                            reader.readAsBinaryString(files[0]);

                            reader.onerror = function(e) {
                                document.getElementById('filePicker').value =  files[0].name;
                                console.log(e);
                            };

                            reader.onload = function(e) {
                                if (!isSmallEnough(files[0])) {
                                    //document.getElementById('filePicker').value =  FILE_SIZE_WARNING + ': ' +
                                    //files[0].name;

                                    $('#errorLabel').text(FILE_SIZE_WARNING);
                                    return false;
                                }

                                document.getElementById('filePicker').value =  'uploading ' + files[0].name + '...';

                                var bstring = e.target.result;
                                var result = obj.callback(bstring,files[0].name, files[0].type);

                                //dont see error from SF incase of failed uploads
                                result.then && result.then(function(result) {
                                    //this returns an array of valid
                                    //docs or erraneous doc - check
                                    //the remote action upload
                                    //document
                                    var urlLocation = '';
                                    if (obj.imageInsert) {
                                        urlLocation =   'https://' + window.location.hostname +
                                                            '/servlet/servlet.ImageServer?' + 
                                                            'id=' + result[0].Id +
                                                            '\&\&docName=' + result[0].DeveloperName + 
                                                            '\&\&oid=' + window.oid;

                                    } else {
                                        var fileId = result[0].Id + '\&\&docName=' + result[0].DeveloperName;
                                        urlLocation =  'https://' + window.location.hostname +
                                            '/servlet/servlet.FileDownload?file=' + fileId ;
                                    }

                                    window.document.getElementById (obj.fieldName).value = urlLocation;
                                    win.close();
                                }, function(fail) {
                                    $('#errorLabel').text(FAILED_UPLOAD + (fail.message ? 'Error message: ' + fail.message : '.'));
                                });
                            };
                        }());

                        //this makese the window stay up till the reader on load gets done
                        return false;
                    }
                });
        });

    });
}());

},{}],41:[function(require,module,exports){
(function() {
    /*jshint -W030 */
    'use strict';
    var htmlString = '<div id="articleList" style="overflow-y:auto; padding: 5px; border-radius: 5px; border: 1px solid #C5C5C5;' +
        ' width: 550px !important; height: 250px !important;" readonly="readonly"></div>';

    window.tinymce.PluginManager.add('smartLink', function(editor, url) {

        editor.addButton('example', {
            icon: 'anchor',
            tooltip:'Smart link',
            onclick: function() {
                editor.editorCommands.execCommand('openSmartLinkWindow');
            }
        });

        editor.addCommand('openSmartLinkWindow', function(callback, callback2) {
            var selValue = 'online';
            var langCode = '';

            editor.windowManager.open({
                title: 'Smart Link Article',
                buttons: [],
                body: [
                    {
                        type: 'listbox',
                        id: 'publishStatus',
                        values: [
                            {text: 'Publish', value: 'online'},
                            {text: 'Draft', value: 'draft'},
                            {text: 'Draft Translation', value: 'archived'},
                        ],
                        onselect: function(v) {
                            selValue = v.target.settings.value;
                        }
                    },{
                        type: 'listbox',
                        id: 'langCode',
                        values: window.tinymce.getLanguageCodeMap(),
                        onselect: function(v) {
                            langCode = v.target.settings.value;
                        },
                        onPostRender: function(v){
                            this.value('en_US');
                            langCode = 'en_US';
                        }
                    },{
                        type: 'textbox',
                        id: 'sText',
                        subtype: 'text',
                    },{
                        type: 'container',
                        style: 'padding-bottom: 10px; height: 250px ! important',
                        html:htmlString
                    }
                ],
                onsubmit: function(e) {
                    // Insert content when the window form is submitted
                    //editor.insertContent('Title: ' + e.data.title);
                    $('#articleList').empty();
                    var resultString = '';
                    var sKey = $('#sText').val() || '';
                    console.log(sKey, selValue, langCode);

                    window.tinymce.remoteCall(sKey, selValue, langCode).then(function(results) {
                        var articles = JSON.parse(results.replace(/&quot;/g,'"'));

                        (!articles.error) && (function(){
                            window.angular.forEach(articles,function(article) {
                            var display = article.urlName;
                            
                            //popup true disables the salesforce headerforarticles
                            resultString = resultString  + '<p class="mce-anchor" style="padding: 5px" ><a title="' +
                                article.title + '" href="/articles/' + article.articleType + '/' +
                                article.urlName + '?popup=true" target="_blank">' + display +  '</a></p>';
                            });
                        }());
                        
                        resultString &&
                            (function(){
                                $('#articleList').append(resultString);
                            }());
                    });

                    //query the remote actions object and see what it gives you
                    return false;
                },
                onPostRender: function() {
                    var win = this;

                    //bubbles the click on the links inside the div area
                    $('#articleList').click(function(event) {

                        //incase the user clicks on the empty div
                        if (event.target.id === 'articleList'){
                            return ;
                        }
                        
                        var aTag = '\<a class=mce-anchor' + ' href="' + event.target.getAttribute('href') +
                            '" target="_blank"\>' + (event.target.text ||  event.target.getAttribute('href'))  + '\<\/a\>&nbsp;';
                        editor.insertContent(aTag);
                        event.preventDefault();
                        win.close();
                    });

                    setTimeout(function() {
                        $('#sText').attr('placeholder', 'enter the name of the article and press enter');
                    });
                }

            });
        });
    });

}());

},{}],42:[function(require,module,exports){
(function() {
    /* jshint -W030 */
    'use strict';
    window.angular.module('omniscriptDesigner').
        service('customViewModalService', ['$modal', 'interTabMsgBus', function($modal, interTabMsgBus){

            this.getCustomViewModalWindow = function(pScope, newValue, oldValue, pageToMode, callback){
                
                var self = this;

                //gets the layout and the view name from the localStorage
                this.config = (function(){
                    return interTabMsgBus.get('config', true) ; //this can be a valid object or an empty object
                }());

                
                //if nothing was written to the localStorage
                (!this.config) && (function(){
                    self.config = {};
                    self.config.layout = self.config.layout || 'false';
                }());

                return $modal ({
                    title: 'Custom Visual Force Page Setup',
                    templateUrl: 'custom-VF-modal.tpl.html',
                    backdrop: 'static',
                    keyboard: false,
                    controller: function($scope, $http){
                        $scope.customViewModal = self.config;

                        $scope.submit = function(){

                            //newValue is custom
                            pageToMode[newValue] = $scope.customViewModal.pageName;
                            
                            var sucessCallback = function(result){
                                //this is a hack - since salesforce always the header as 200 no matter what happens
                                if (/Visualforce Error/.test(result.data)){
                                    $scope.errorMessage = $scope.customViewModal.pageName + ' is not a valid page';
                                } else {
                                    $scope.$hide();

                                    window.setTimeout(function(){
                                        //writing to the session no matter what
                                        interTabMsgBus.set('config', self.config, true);
                                    },0);
                                    
                                    callback && (function(){
                                        callback(function(){
                                            //replace this with an object
                                            return {
                                                verticalMode: '&verticalMode='+ $scope.customViewModal.layout,
                                            };
                                        });
                                    }());
                                    
                                    $scope.errorMessage = '';
                                }
                            };

                            var failureCallback = function(error){
                                //notify the user that the page is invalid
                                $scope.errorMessage = $scope.customViewModal.pageName + ' is not a valid page';
                            };

                            //check the page for 404s 
                            $http.get('/apex/' + $scope.customViewModal.pageName).then(sucessCallback,
                                                                                       failureCallback);

                        };

                        $scope.cancel = function() {
                            //flips the select to the oldervalue when we cancel the modal
                            pScope.previewMode = oldValue;
                            $scope.$hide();
                        };
                    }
                });
            };
        }]);
}());

},{}],43:[function(require,module,exports){
(function(){
    window.angular.module('omniscriptDesigner')
        .service('propertyEditorModalService', ['$timeout', '$modal', 'remoteActions',function($timeout, $modal, remoteActions){

            this.imgDocs = [];

            this.supportedFormats = ['png', 'gif', 'jpeg', 'jpg'];

            var self = this;

            this.init = function(documents) {
                this.documents = documents.map(function(document) {
                        ((document.IsPublic && document.Type && document.Type.indexOf('image') !== -1) ||  self.supportedFormats.includes(document.Type)) &&
                            (function() {
                                self.imgDocs.push(document);
                            }());

                        return document ;
                });
            };

            this.loadDocs = function(){
                remoteActions.getAllDocuments().then(function(documents) {
                    self.init(documents);
                });
            };

            this.loadDocs();

            this.prepDocInsert = function(parentObject, tgtProp, imageInsert) {
                var input = {};
                input.filePicker = false;
                input.fileUpload = null;
                input.selDocuments = null;
                input.imageInsert = imageInsert;
                input.currentValue = parentObject[tgtProp];

                input.callback = function(bstring, name) {
                    return remoteActions.uploadDocument(btoa(bstring),name, 'image'); //this returns a promise
                };

                input.getTest = function(){
                    return self.names;
                };

                input.getDocs = function(imageInsert) {
                    if (imageInsert)
                        return self.imgDocs;
                    else return self.documents;
                };

                input.loadDocs = function(){return self.loadDocs();};

                if (input.currentValue){
                    input.filePicker = true;
                    input.selDocuments = input.getDocs(imageInsert).find(function(doc){
                        if (doc.Id == input.currentValue.match(/[^=&;]+(?=(?:&(?:amp;?)?){1,2}(?:docName|oid=))/)[0])
                            return doc;
                    });
                }

                this.openDocInsert(function(){
                    return input;
                }, parentObject, tgtProp);
            };

            this.openDocInsert = function(callback, parentObject, tgtProp) {

                return $modal({
                        title: (callback().imageInsert ? 'Image' : 'Document') + ' Insert',
                        templateUrl: 'modal-doc-insert.tpl.html',
                        controller: function($scope){
                            $scope.obj = callback();

                            var MAX_SIZE = 750000;

                            var FILE_SIZE_WARNING = 'File exceeds the 1mb Remote Action upload limit. Please go' +
                                                    ' to the Documents tab to upload the file (up to 5mb).';
                            var FAILED_UPLOAD = 'The file could not be uploaded';

                            function isSmallEnough(file) {
                                return file.size < MAX_SIZE ;
                            }



                            $scope.cancel = function(){
                                $scope.$hide();
                            };

                            $scope.delete = function(){
                                parentObject[tgtProp] = null;
                                $scope.$hide();
                            };

                            $scope.submit = function(){

                                var basePath = ($scope.obj.imageInsert ? '../servlet/servlet.ImageServer?' : '../servlet/servlet.FileDownload?file=');

                                if($scope.obj.filePicker && $scope.obj.selDocuments !== null){
                                    if ($scope.obj.imageInsert) {
                                        parentObject[tgtProp] = basePath + 
                                                                'id=' + $scope.obj.selDocuments.Id +
                                                                '&&docName=' + $scope.obj.selDocuments.DeveloperName +
                                                                '&&oid=' + window.oid;
                                    } else {
                                        parentObject[tgtProp] = basePath + $scope.obj.selDocuments.Id +
                                                                '&&docName=' + $scope.obj.selDocuments.DeveloperName;
                                    }

                                    $scope.obj.callback = false;
                                    $scope.cancel();


                                }else if(!($scope.obj.filePicker || document.getElementById('filePicker').files === null)){
                                    //Submit UPLOADED docId
                                    var file = document.getElementById('filePicker').files[0];
                                    var reader = new FileReader();

                                    reader.readAsBinaryString(file);

                                    reader.onerror = function(e) {
                                        document.getElementById('docSelModalFile').value =  file.name;
                                    };

                                    reader.onload = function(e) {
                                        if (!isSmallEnough(file)) {
                                            $('#errorLabel').text(FILE_SIZE_WARNING);
                                            return false;
                                        }

                                        document.getElementById('docSelModalFile').value =  'uploading ' + file.name + '...';

                                        var bstring = e.target.result;
                                        var result = $scope.obj.callback(bstring,file.name, file.type);

                                        result.then && result.then(function(result) {
                                            if ($scope.obj.imageInsert){
                                                parentObject[tgtProp] = basePath + 
                                                                        'id=' + result[0].Id +
                                                                        '&&docName=' + result[0].DeveloperName+
                                                                        '&&oid=' + window.oid;
                                            } else{
                                                parentObject[tgtProp] = basePath + result[0].Id +
                                                                        '&&docName=' + result[0].DeveloperName;
                                            }

                                            $scope.obj.loadDocs();
                                            $scope.cancel();
                                        }, function(fail) {
                                            $('#errorLabel').text(FAILED_UPLOAD + (fail.message ? 'Error message: ' + fail.message : '.'));
                                        });
                                    };


                                }
                            };

                            $scope.clearError = function(){
                                $('#errorLabel').text('');
                            };

                        }                    
                });
            };

            this.prepExpressionEditor = function(elementNames,parentObject, tgtProp, expressionOnly){
                var input = {};
                input.currentVal = parentObject[tgtProp];
                if (typeof input.currentVal == 'undefined'){
                    input.currentVal='';
                }
                input.elementNames = elementNames;

                // delete leading '=' token
                if (!expressionOnly) {
                    input.currentVal = String(input.currentVal).replace(/(?:^\s*=)|(?:\s*$)/g,'');
                }

                this.openExpressionEditor(function(){
                    return input;
                },parentObject, tgtProp);
            };

            this.openExpressionEditor = function(callback, parentObject, tgtProp) {

                return $modal({
                    title: 'Expression Editor',
                    templateUrl: 'modal-edit-expression.tpl.html',
                    backdrop:'static',
                    controller: function($scope) {
                        $scope.obj = callback();

                        $scope.obj.newVal = $scope.obj.currentVal;

                        $scope.cancel = function(){
                            $scope.$hide();
                        };

                        $scope.submit = function(){
                            if($scope.obj.newVal || $scope.obj.newVal == 'false'){
                                parentObject[tgtProp] = '='+$scope.obj.newVal;
                                if(parentObject.hasOwnProperty('$parentProperty')){
                                    parentObject.$parentProperty.update();
                                }
                            }
                            $scope.cancel();
                        };
                    }
                });
            };
        }
    ]);
}());
},{}],44:[function(require,module,exports){
(function () {
    /* jshint -W030 */
    'use strict';
    window.angular.module('omniscriptDesigner')
        .service('tinyMCEService', ['$timeout', 'remoteActions',function($timeout, remoteActions) {
            this.plugins = (function() {
                return 'docInsert smartLink';
            }());
            this.imageDocs = [];

            this.supportedFormats = ['png', 'gif', 'jpeg', 'jpg'];



            var self = this;
            this.init = function(documents) {
                this.documents = documents.map(function(document) {
                    ((document.Type && document.Type.indexOf('image') !== -1) ||  self.supportedFormats.includes(document.Type)) &&
                        (function() {
                            if (document.IsPublic){
                                self.imageDocs.push('\<span id=' + document.Id +
                                                    '\&\&docName=' + document.DeveloperName +
                                                    '\&\&oid=' + window.oid +
                                                    '> ' +document.Name +'\</span>');
                            }
                        }());

                    return '\<span id=' + document.Id + '\&\&docName=' +
                        document.DeveloperName + '> ' +  document.Name +'\</span>' ;
                });
            };

            remoteActions.getAllDocuments().then(function(documents) {
                self.init(documents);
            });

            remoteActions.getLanguageCodeMap().then(function(langCodeMap){
                var langMap = [];

                angular.forEach(langCodeMap, function(key, value){
                    langMap.push({text: value, value: key });
                });
                
                window.tinymce.getLanguageCodeMap = function(){
                    return langMap;
                };
            });

            window.tinyMCE.remoteCall = function(searchKey, status, langCode) {
                searchKey = searchKey || '';
                status = status || '' ;
                langCode = langCode || '';
                return remoteActions.getKnowledgeArticles(searchKey, status, langCode);
            };

            this.openDocInsertWindow = function(tinyMCE,field_name, type) {
                var input = {};
                input.fieldName = field_name || '';
                input.imageInsert = (type === 'image') ? true : false;

                input.callback = function(bstring, name, type) {
                    return remoteActions.uploadDocument(btoa(bstring),name, type); //this returns a promise
                };

                input.getTest = function(){
                    return self.names;
                };

                input.getDocs = function() {
                    if (type === 'image') {
                        return self.imageDocs;
                    }else {
                        return self.documents;
                    }
                };

                tinyMCE.activeEditor.editorCommands.execCommand('openDocInsertWindow', function() {
                    return input;
                });
            };

        }]);

}());

},{}],45:[function(require,module,exports){
angular.module("omniscriptDesigner").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("adv-show-property-template.tpl.html",'<div class="row">\n    <div class="col-xs-6">\n        <select class="form-control"\n                disabled="disabled"\n                ng-change="showPropertyConditionType.update()"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-options="value as label for (label, value) in optionsForProperty(showPropertyConditionType, activeElement)"\n                ng-model="showPropertyConditionType.currentValue">\n            <option value="" ng-if="false"></option>\n        </select>\n    </div>\n</div>\n<br/>\n<div class="showGroup">\n    <div ng-include="\'show-rule-property-template.tpl.html\'"></div>\n</div>'),$templateCache.put("array-property-template.tpl.html",'<!-- array-property-template.tpl.html -->\n<label ng-class="{ \'col-lg-5\' : property.isKeyValue() }"  ng-if="property.isDefault || !property.isKeyValue()">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="col-lg-5" ng-if="!property.isDefault || property.isKeyValue()">\n    <input  type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.key" />\n</div>\n<div ng-class="{ \'col-lg-6\' : property.isKeyValue() && !property.$parentProperty.isKeyValue() }" ng-if="!property.$parentProperty.isKeyValue()">\n    <div class="arrayProperty input-group"\n         ng-repeat="prop in property.arrayAsProperties() track by $index"\n         ng-init="property = prop">\n        <span class="input-group-addon">{{$index}}</span>\n        <input type="{{property.type}}"\n                class="form-control"\n                ng-disabled="scriptElement.IsActive__c"\n                placeholder="{{property | placeholder}}"\n                ng-change="property.update()"\n                ng-model="property.currentValue"\n                ng-if="property.type !== \'object\' && property.type !== \'key-value\' && property.type !== \'array\'" />\n        \n        <input  type="text"\n            ng-if="property.type === \'object\' || property.type === \'key-value\' || property.type === \'array\'"\n            class="form-control"\n            disabled="disabled"\n            readonly="readonly"\n            placeholder="{{property | placeholder}}"\n            value="Use \'Edit JSON\' to edit this value." />\n        <div class="input-group-btn">\n            <button class="btn btn-link" ng-click="deleteArrayProperty(property.$parentProperty, $index)"\n                    ng-if="!scriptElement.IsActive__c" title="Delete entire row">\n                <span class="icon icon-v-trash"></span>\n            </button>\n        </div>\n    </div>\n</div>\n<div ng-class="{ \'col-lg-6\' : property.isKeyValue() && property.$parentProperty.isKeyValue() }" ng-if="property.$parentProperty.isKeyValue()">\n    <input  type="text"\n        class="form-control"\n        disabled="disabled"\n        readonly="readonly"\n        placeholder="{{property | placeholder}}"\n        value="use \'Edit JSON\' to edit this value." />\n</div>\n<div ng-class="{ \'col-lg-5\' : property.isKeyValue() }" ng-if="property.isKeyValue() && !property.$parentProperty.isKeyValue()"></div>\n<div ng-class="{ \'col-lg-6\' : property.isKeyValue() }" ng-if="property.arrayAsProperties()[0].type != \'object\' && property.arrayAsProperties()[0].type != \'key-value\' && property.arrayAsProperties()[0].type != \'array\'">\n    <button type="button" class="btn btn-default"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-click="addNewArrayProperty(property)">{{ ::\'OmniDesNewArrayProp\' | localize }}</button>\n</div>'),$templateCache.put("canvas-element-template.tpl.html",'<!-- canvas-element-template.tpl.html -->\n<i class="icon icon-v-right-arrow"\n        ng-if="element.allowsChildren()"\n        ng-show="element.collapse"\n        ng-click="element.collapse = !element.collapse"></i>\n<i class="icon icon-v-down-arrow"\n        ng-if="element.allowsChildren()"\n        ng-show="!element.collapse"\n        ng-click="element.collapse = !element.collapse"></i>\n <ul class="show-marker-wrapper">\n    <li ng-repeat="color in popover.controllingElementsColors[element.Name]  track by $index"\n        class="show-marker"\n        ng-style="{\'background-color\': color, \'left\': 0}"></li>\n </ul>\n<h3>\n    <span ng-class="{\'vlc-margin-left-5\': (element.parent().type() === \'Edit Block\')}">\n        {{element.Name}}\n        <span class="icon icon-v-view" ng-if="element.PropertySet__c.show.group.rules.length > 0"></span>\n        <i class="icon icon-v-claim-line" ng-if="element.hasErrors()"\n            data-container=".container"\n            data-type="info" bs-tooltip="element"\n            bs-enabled="true"\n            data-html = "true"\n            ng-attr-data-title="{{errors != null && errors.length > 0 && errors[0].message}}"></i>\n    </span>\n    <i class="icon icon-v-grip pull-right" ng-drag-handle="ng-drag-handle"></i>\n    <i ng-if="element.saving" class="pull-right spinner"></i>\n    <button ng-if="!element.saving" class="btn btn-link pull-right"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-click="delete(element)">\n        <span class="icon icon-v-trash"></span>\n    </button>\n    <button ng-if="!element.saving" class="btn btn-link pull-right"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-click="clone(element)">\n        <span class="icon icon-v-copy"></span>\n    </button>\n    <span class="pull-right element-type">{{element.Type__c | elementLabel}}</span>\n</h3>\n<input type="checkbox" ng-if="element.parent().type() === \'Edit Block\' && !notDispOnTmltObj.hasOwnProperty(element.type())" ng-init="setDisOnTpltPrp(element)" ng-model="element.PropertySet__c.disOnTplt" ng-click="onCanvasCheckboxElementClick(element, $event);" />\n\n<ul class="drop-zone"\n     ng-if="element.allowsChildren()"\n     ng-show="!element.collapse"\n     dnd-disable-if="$parent.$parent.scriptElement.IsActive__c || element.saving"\n     dnd-list="element.children"\n     dnd-allowed-types="element.allowedTypes()"\n     dnd-drop="onDNDDrop(event, index, item, external, type, \'itemType\')"\n     dnd-dragover="onDNDMove(event, index, item, external, type, \'itemType\')">\n    <li\n        class="canvasElement {{element | className}}"\n        ng-class="{\'active\': activeElement == element,\'filter\': element.filter}"\n        ng-repeat="element in element.children track by $index"\n        dnd-type="element.Type__c.type"\n        dnd-disable-if="$parent.$parent.scriptElement.IsActive__c || element.saving"\n        dnd-draggable="element.Id"\n        dnd-effect-allowed="move"\n        dnd-selected="models.selected = item"\n        ng-attr-data-dnd-height="{{element.allowsChildren() ? undefined : 36}}"\n        ng-click="onCanvasElementClick(element, $event)"\n        ng-include="\'canvas-element-template.tpl.html\'"></li>\n </ul>'),$templateCache.put("checkbox-property-template.tpl.html",'<!-- checkbox-property-template.tpl.html -->\n<div class="col-md-5" ng-if="!property.isDefault && property.isKeyValue()">\n    <input  type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.key" />\n</div>\n<div ng-class="{ \'col-md-5\' : property.isKeyValue() }">\n    <label>\n        <input  type="checkbox"\n                ng-change="property.update()"\n                ng-disabled="scriptElement.IsActive__c || ( property.label === \'readOnly\' && activeElement.parent().type() === \'Type Ahead Block\')"\n                ng-model="property.currentValue" />\n        <span ng-model="property.label"\n              ng-if="property.isDefault">{{property.label | readablePropertyName: activeElement}}</span>\n        \n        <i class=\'icon icon-v-information-line\' bs-tooltip="tooltips[\'lightningDesignOnly\']" data-container=".container" data-type="info" ng-if="(tooltipElements[property.$canvasElement.CanvasType] && tooltipElements[property.label])"></i>\n        \n        <div class="info icon icon-v-information-line" vlc-tooltip></div>\n    </label>\n</div>\n<div class="col-md-1" ng-if="property.isKeyValue()">\n    <button type="button" class="btn btn-link trash"\n            ng-if="!scriptElement.IsActive__c && !property.isDefault"\n            ng-click="property.delete()">\n        <span class="icon icon-v-trash"></span>\n    </button> \n</div>\n'),$templateCache.put("confirmation.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body" ng-bind="content"></div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="ok();$hide()">{{ ::\'OmniDesOk\' | localize }}</button>\n        <button type="button" class="btn btn-default" ng-click="$hide()">{{ ::\'OmniDesCancel\' | localize }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("confirmationModal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body">\n        <div class="content" ng-bind="content">\n        </div>\n      </div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="ok();$hide()">{{ ::\'OmniDesOk\' | localize }}</button>\n        <button type="button" class="btn btn-default" ng-click="$hide()">{{ ::\'OmniDesCancel\' | localize }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("custom-VF-modal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n    <div class="modal-dialog" style="display:inline-block;width:auto;position:fixed;top:40%;left:50%">\n        <div class="modal-content" style="display:inline-block">\n            <div class="modal-header">\n                <h4 class="modal-title">{{::title}}</h4>\n            </div>\n            <div class="modal-body">\n                <form>\n                    <div class="form-group form-inline text-center">\n                        <label>Visual Force Page Name\n                            <input ng-model="customViewModal.pageName" type="text" class="form-control"/>\n                        </label>\n                    </div>\n                    <div class="form-group form-inline text-center">\n                        <p class="pull-left">Mode</p>\n                        <div class="input-group pull-right">\n                          <span style="position:relative;left:-20px"><input ng-model="customViewModal.layout" type="radio" value="false"/> Horizontal&nbsp;</span>\n                          <input ng-model="customViewModal.layout" type="radio" value="true" /> Vertical\n                        </div>\n                    </div>\n                    <!-- mugatu clearfix did not work for me in this case -->\n                    <div class="form-group text-center" style="clear:both">\n                        <div class="row">\n                            <button ng-click="submit()" class="btn btn-primary">Launch</button>\n                            <button ng-click="cancel()" class="btn btn-default">Cancel</button>\n                        </div>\n                    </div>\n                    <div class="form-group text-center">\n                        <p style="color:red">{{errorMessage}}</p>\n                    </div>\n                </form>\n            </div>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("datasource-property-template.tpl.html",'<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<select class="form-control datasource-select"\n        ng-options="value.value as value.label for value in dataSourceTypes"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-model="activeElement.PropertySet__c[property.label].type"></select>\n<div ng-if="activeElement.PropertySet__c[property.label].type === \'Custom\'">\n    <input type="text"\n       class="form-control"\n       ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n       placeholder="{{ ::\'OmniDesEnterSource\' | localize }}"\n       ng-disabled="scriptElement.IsActive__c"\n       ng-model="activeElement.PropertySet__c[property.label].source" />\n</div>\n<div class="panel panel-default" ng-if="activeElement.PropertySet__c[property.label].type === \'SObject\'">\n    <div class="panel-heading">\n        {{ ::\'OmniDesInputParam\' | localize }}\n        <i class="icon icon-v-information-line"\n            bs-tooltip="tooltips.inputParameters"\n            data-container=".container"\n                data-type="info"></i>\n        <button class="btn btn-default" type="button"\n                ng-if="!scriptElement.IsActive__c"\n                ng-click="addNewInputParameter(activeElement.PropertySet__c[property.label].mapItems.inputParameters)">\n            <i class="icon icon-v-plus-line"></i>\n            {{ ::\'OmniDesAddInputParam\' | localize }}\n        </button>\n    </div>\n    <table class="table">\n        <thead>\n            <th>{{ ::\'OmniDesDataSource\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.dataSource"\n                    data-container=".container"\n                    data-type="info"></i>\n            </th>\n            <th>{{ ::\'OmniDesFilterValue\' | localize }}</th>\n            <th width="50px">&nbsp;</th>\n        </thead>\n        <tbody>\n            <tr ng-repeat="inputParam in activeElement.PropertySet__c[property.label].mapItems.inputParameters">\n                <td>\n                     <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="inputParam.element"\n                            bs-options="name for name in elementNames()"\n                            bs-typeahead="bs-typeahead"\n                            data-min-length="0" />\n                </td>\n                <td>\n                     <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="inputParam.inputParam"\n                </td>\n                <td>\n                    <button type="button"\n                            class="btn btn-link"\n                            ng-if="!scriptElement.IsActive__c"\n                            ng-click="deleteInputParameter(inputParam, activeElement.PropertySet__c[property.label].mapItems.inputParameters)">\n                        <i class="icon icon-v-trash"></i>\n                    </button>\n                </td>\n            </tr>\n        </tbody>\n    </table>\n</div>\n<div class="panel panel-default" ng-if="activeElement.PropertySet__c[property.label].type === \'SObject\'">\n    <div class="panel-heading">\n        {{ ::\'OmniDesLookupQueryCfg\' | localize }}\n        <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.lookupQueryConfiguration"\n                    data-container=".container"\n                    data-type="info"></i>\n        <button class="btn btn-default" type="button"\n                ng-if="!scriptElement.IsActive__c"\n                ng-click="addNewMapping(activeElement.PropertySet__c[property.label].mapItems.phase1MapItems)">\n            <i class="icon icon-v-plus-line"></i>\n            {{ ::\'OmniDesAddMapping\' | localize }}\n        </button>\n    </div>\n    <table class="table">\n        <thead>\n            <th width="85px">{{ ::\'OmniDesLookupOrder\' | localize }}</th>\n            <th>{{ ::\'OmniDesLookupObjAndFld\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.lookupObjectName"\n                    data-container=".container"\n                    data-type="info"></i></th>\n            <th>{{ ::\'OmniDesFilterValue\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.filterValue"\n                    data-container=".container"\n                    data-type="info"></i>\n                </th>\n            <th>{{ ::\'OmniDesJSONPath\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.jsonPath"\n                    data-container=".container"\n                    data-type="info"></i></th>\n            <th width="50px">&nbsp;</th>\n        </thead>\n        <tbody>\n            <tr ng-repeat="mapItem in activeElement.PropertySet__c[property.label].mapItems.phase1MapItems">\n                <td>\n                    <input type="number"\n                            class="form-control"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-disabled="scriptElement.IsActive__c"\n                            ng-model="mapItem.InterfaceObjectLookupOrder__c"\n                            min="1" ng-min="1"\n                </td>\n                <td>\n                    <select ng-options="object.name as object.name for object in sobjectTypes"\n                            ng-disabled="scriptElement.IsActive__c"\n                            ng-change="loadFieldsFor(mapItem.InterfaceObjectName__c)"\n                            class="form-control input-sm"\n                            ng-model="mapItem.InterfaceObjectName__c"></select>\n                    .\n                    <select ng-options="name as name for (name, field) in allFieldsForObjects[mapItem.InterfaceObjectName__c] | orderBy:\'toString()\'"\n                        ng-disabled="scriptElement.IsActive__c"\n                        class="form-control input-sm"\n                        ng-model="mapItem.InterfaceFieldAPIName__c"></select>\n                </td>\n                <td>\n                    <select ng-options="name for name in viewModel.filterOptions"\n                        ng-disabled="scriptElement.IsActive__c"\n                        class="form-control input-sm"\n                        ng-model="mapItem.FilterOperator__c"></select>\n                    <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="mapItem.FilterValue__c"\n                </td>\n                <td>\n                    <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="mapItem.DomainObjectFieldAPIName__c"\n                </td>\n                <td>\n                    <button type="button"\n                            ng-if="!scriptElement.IsActive__c"\n                            class="btn btn-link"\n                            ng-click="deleteMapping(mapItem, activeElement.PropertySet__c[property.label].mapItems.phase1MapItems)">\n                        <i class="icon icon-v-trash"></i>\n                    </button>\n                </td>\n            </tr>\n        </tbody>\n    </table>\n</div>\n<div class="panel panel-default" ng-if="activeElement.PropertySet__c[property.label].type === \'SObject\'">\n    <div class="panel-heading">\n        {{ ::\'OmniDesPopLookupEl\' | localize }}\n        <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.populateLookupElementWithQueryResult"\n                    data-container=".container"\n                    data-type="info"></i>\n    </div>\n    <table class="table">\n        <thead>\n            <th>{{ ::\'OmniDesJSONPathFldName\' | localize }}</th>\n            <th>{{ ::\'OmniDesInto\' | localize }}</th>\n        </thead>\n        <tbody>\n            <tr>\n                <td>\n                    <input  type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="activeElement.PropertySet__c[property.label].mapItems.phase2MapItems[0].InterfaceFieldAPIName__c"\n                </td>\n                <td>{{ ::\'OmniDesName\' | localize }}<i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.jsonPathFieldNameName"\n                    data-container=".container"\n                    data-type="info"></i></td>\n            </tr>\n            <tr>\n                <td>\n                    <input  type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-model-options="{ debounce: {\'default\': 500, \'blur\': 0} }"\n                            ng-model="activeElement.PropertySet__c[property.label].mapItems.phase2MapItems[1].InterfaceFieldAPIName__c"\n                </td>\n                <td>{{ ::\'OmniDesValue\' | localize }}<i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.jsonPathFieldNameValue"\n                    data-container=".container"\n                    data-type="info"></i></td>\n            </tr>\n        </tbody>\n    </table>\n</div>'),$templateCache.put("docusign-embed-signature-return-page.tpl.html",'<!-- docusign-embed-signature-return-page.tpl.html -->\n\n<label ng-class="{ \'col-lg-5\' : property.isKeyValue() }"  ng-if="property.isDefault || !property.isKeyValue()">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    <i class=\'icon icon-v-information-line\' bs-tooltip="tooltips.docuSignReturnUrl" data-container=".container" data-type="info"></i>\n</label>\n<input  type="text"\n    class="form-control"\n    ng-change="property.update()"\n    ng-disabled="scriptElement.IsActive__c"\n    placeholder="{{property | placeholder}}"\n    ng-model="property.currentValue"\n/>\n'),$templateCache.put("docusign-select-template.tpl.html","<!-- docusign-select-template.tpl.html -->\n\n<label name='loopname' class=\"select-label vlc-docusign-select\">{{ ::'OmniDesDocuTemplate' | localize }}</label>\n    <select \n        class='form-control'\n        name='loopname'\n        ng-disabled='scriptElement.IsActive__c'\n        ng-model='activeElement.PropertySet__c.docuSignTemplate'\n        ng-change='onChangeDocusignTemplate(activeElement)'\n        ng-options=\"option[nsPrefix + 'TemplateIdentifier__c'] as option.Name for option in docuSignTemplates\"\n        ng-required='true'\n    /> \n </label>"),$templateCache.put("docusign-signerinfo-template-role.tpl.html","<!-- docusign-signerinfo-template-role.tpl.html -->\n\n<label name='loopname' class=\"select-label vlc-docusign-select\">{{ ::'OmniDesDocuTemplateRole' | localize }}</label>\n    <select ng-init='initTemplateRoles(activeElement, nsPrefix)'\n        class='form-control'\n        name='loopname'\n        ng-disabled='scriptElement.IsActive__c'\n        ng-model='activeElement.PropertySet__c.signerInformation.templateRole'\n        ng-options='option.name as option.name for option in activeElement.templateRoleName.roles'\n        ng-required='true'\n    /> \n </label>"),$templateCache.put("docusign-signerlist-table-sig.tpl.html",'<!-- docusign-signerlist-table-sig.tpl.html -->\n\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class="panel panel-default vlc-docusign-list" ng-init=\'onInitDocuSignTemplates(activeElement)\'>\n        <div class="panel-heading">\n            {{ ::\'OmniDesDocuTemplates\' | localize }}\n            <button class="btn btn-default" type="button"\n                ng-disabled="form.propertiesForm.docusignTemplate.$invalid || form.propertiesForm.docusignSignerRole.$invalid || scriptElement.IsActive__c"\n                ng-click=\'addDocuSignTemplate(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>{{ ::\'OmniDesDocuAddTemplate\' | localize }}\n            </button>\n        </div>\n        <div ng-repeat=\'template in activeElement.PropertySet__c.docuSignTemplatesGroupSig\'>\n            <div class="panel-heading">\n                {{ ::\'OmniDesDocuEachTemplate\' | localize }}\n            </div>\n            <table class="table" ng-init=\'initTemplateRoles(activeElement, nsPrefix, $index)\' style=\'margin-bottom: 12px;\'>\n                <div class="panel panel-default vlc-docusign-list" style=\'margin-bottom:0px;\'>\n                    <thead class=\'vlc-docusign-list-head\'>\n                        <th width="60px">{{ ::\'OmniDesDocuIncludeToSend\' | localize }}\n                            <i class=\'icon icon-v-information-line\'\n                                bs-tooltip="tooltips.docuSignIncludeToSend"\n                                data-container=".container"\n                                data-type="info">\n                            </i>\n                        </th>\n                        <th>{{ ::\'OmniDesDocuTemplatePick\' | localize }}</th>\n                        <th>{{ ::\'OmniDesDocuTemplateRole\' | localize }}</th>\n                        <th>{{ ::\'OmniDesDocuDRTransformPick\' | localize }}</th>\n                        <th>{{ ::\'OmniDesDocuSendJSONPath\' | localize }}</th>\n                        <th>{{ ::\'OmniDesDocuSendJSONNode\' | localize }}</th>\n                        <th width="30px">&nbsp;</th>\n                    </thead>\n                </div>\n                <tbody class="vlc-docusign-tbody-omni">\n                    <tr>\n                        <td>\n                            <input type="checkbox"\n                                class=\'form-control vlc-docusign-checkbox-cell\'\n                                ng-disabled=\'scriptElement.IsActive__c\'\n                                ng-model="template.includeToSend" />\n                        </td>\n                        <td>\n                            <label class="select-label vlc-docusign-select">\n                                <select name=\'docusignTemplate\'\n                                    class=\'form-control vlc-docusign-sig-cell\'\n                                    ng-disabled="scriptElement.IsActive__c || activeElement.Type__c.type == \'OmniScript\' || property.loading"\n                                    ng-change="onChangeDocusignTemplate(activeElement, $index)"\n                                    ng-model="template.docuSignTemplate"\n                                    ng-options="option[nsPrefix + \'TemplateIdentifier__c\'] as option.Name for option in docuSignTemplates"\n                                    ng-required=\'true\'/>\n                            </label>\n                        </td>\n                        <td>\n                            <label class="select-label vlc-docusign-select">\n                                <select name=\'docusignSignerRole\' style=\'width: 105%; top: 6px; position: relative;\'\n                                    class=\'form-control\'\n                                    ng-disabled=\'scriptElement.IsActive__c\'\n                                    ng-model=\'template.templateRole\'\n                                    ng-options=\'option.name as option.name for option in template.templateRoleName.roles\'\n                                    ng-required=\'true\'/>\n                            </label>\n                         </td>\n                        <td>\n                            <label class="select-label vlc-docusign-select">\n                                <select class="form-control vlc-docusign-sig-cell"\n                                     disabled="disabled"\n                                     ng-change="property.update()"\n                                     ng-disabled="scriptElement.IsActive__c || activeElement.Type__c.type == \'OmniScript\' || property.loading"\n                                     ng-options="value as label for (label, value) in optionsDocuSignTransform(property, activeElement)"\n                                     ng-model="template.transformBundle">\n                                     <option value="" ng-if="false"></option>\n                                </select>\n                           </label>\n                        </td>\n                        <td>\n                             <input type=\'text\' class="form-control vlc-docusign-sig-cell"\n                                 disabled="disabled"\n                                 ng-disabled="scriptElement.IsActive__c"\n                                 ng-model="template.sendJSONPath">\n                        </td>\n                        <td>\n                             <input type=\'text\' class="form-control vlc-docusign-sig-cell"\n                                 disabled="disabled"\n                                 ng-disabled="scriptElement.IsActive__c"\n                                 ng-model="template.sendJSONNode">\n                             </input>\n                        </td>\n                        <td class=\'vlc-delete-cell\'>\n'+"                            <span class='trash-icon icon-v-trash vlc-docusign-delete-cell' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteDocuSignTemplate($index, activeElement)'>\n                        </td>\n                    </tr>\n                </tbody>\n            </table>\n        </div>\n   </div>"),$templateCache.put("docusign-signerlist-table.tpl.html","<!-- docusign-signerlist-table.tpl.html -->\n\n    <label>\n        <span ng-model=\"property.label\">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class=\"panel panel-default vlc-docusign-list\" ng-init='onInitDocuSignTemplates(activeElement)'>\n        <div class=\"panel-heading\">\n            {{ ::'OmniDesDocuTemplates' | localize }}\n            <button class=\"btn btn-default\" type=\"button\"\n                ng-disabled=\"form.propertiesForm.docusignSignerName.$invalid || form.propertiesForm.docusignSignerEmail.$invalid || form.propertiesForm.docusignSignerRole.$invalid || scriptElement.IsActive__c\"\n                ng-click='addDocuSignTemplate(activeElement)' >\n                <i class=\"icon icon-v-plus-line\"></i>{{ ::'OmniDesDocuAddTemplate' | localize }}\n            </button>\n        </div>\n        <div ng-repeat='template in activeElement.PropertySet__c.docuSignTemplatesGroup'>\n            <div class=\"panel-heading\">\n                {{ ::'OmniDesDocuEachTemplate' | localize }}\n            </div>\n            <table class=\"table\" ng-init='initTemplateRoles(activeElement, nsPrefix, $index)' style='margin-bottom: 12px;'>\n                <div class=\"panel panel-default vlc-docusign-list\" style='margin-bottom:0px;'>\n                    <thead class='vlc-docusign-list-head'>\n                        <th width=\"60px\">{{ ::'OmniDesDocuIncludeToSend' | localize }}\n                            <i class='icon icon-v-information-line'\n                                bs-tooltip=\"tooltips.docuSignIncludeToSend\"\n                                data-container=\".container\"\n                                data-type=\"info\">\n                            </i>\n                        </th>\n                        <th>{{ ::'OmniDesDocuTemplatePick' | localize }}</th>\n                        <th>{{ ::'OmniDesDocuDRTransformPick' | localize }}</th>\n                        <th>{{ ::'OmniDesDocuSendJSONPath' | localize }}</th>\n                        <th>{{ ::'OmniDesDocuSendJSONNode' | localize }}</th>\n                        <th width=\"30px\">&nbsp;</th>\n                    </thead>\n                </div>\n                <tbody class=\"vlc-docusign-tbody-omni\">\n                    <tr>\n                        <td>\n                            <input type=\"checkbox\"\n                                class='form-control vlc-docusign-checkbox-cell'\n                                ng-disabled='scriptElement.IsActive__c'\n                                ng-model=\"template.includeToSend\" />\n                        </td>\n                        <td>\n                            <label class=\"select-label vlc-docusign-select\">\n                                <select name='docusignSignerRole'\n                                    class='form-control vlc-docusign-select-cell'\n                                    ng-disabled=\"scriptElement.IsActive__c || activeElement.Type__c.type == 'OmniScript' || property.loading\"\n                                    ng-change=\"onChangeDocusignTemplate(activeElement, $index)\"\n                                    ng-model=\"template.docuSignTemplate\"\n                                    ng-options=\"option[nsPrefix + 'TemplateIdentifier__c'] as option.Name for option in docuSignTemplates\"/>\n                           </label>\n                        </td>\n                        <td>\n                            <label class=\"select-label vlc-docusign-select\">\n                                <select class=\"form-control vlc-docusign-select-cell\"\n                                     disabled=\"disabled\"\n                                     ng-change=\"property.update()\"\n                                     ng-disabled=\"scriptElement.IsActive__c || activeElement.Type__c.type == 'OmniScript' || property.loading\"\n                                     ng-options=\"value as label for (label, value) in optionsDocuSignTransform(property, activeElement)\"\n                                     ng-model=\"template.transformBundle\">\n                                     <option value=\"\" ng-if=\"false\"></option>\n                                </select>\n                           </label>\n                        </td>\n                        <td>\n                             <input type='text' class=\"form-control vlc-docusign-input-cell\"\n                                 disabled=\"disabled\"\n                                 ng-disabled=\"scriptElement.IsActive__c\"\n                                 ng-model=\"template.sendJSONPath\">\n                        </td>\n                        <td>\n                             <input type='text' class=\"form-control vlc-docusign-input-cell\"\n                                 disabled=\"disabled\"\n                                 ng-disabled=\"scriptElement.IsActive__c\"\n                                 ng-model=\"template.sendJSONNode\">\n                             </input>\n                        </td>\n                        <td class='vlc-delete-cell'>\n                            <span class='trash-icon icon-v-trash vlc-docusign-delete-cell' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteDocuSignTemplate($index, activeElement)'>\n                        </td>\n                    </tr>\n                </tbody>\n            </table>\n            <table class=\"table\" style='margin-bottom: 12px;'>\n                <div class=\"panel panel-default vlc-docusign-list\" style='margin-bottom:0px; border: none;'>\n                    <div class=\"panel-heading\"> {{ ::'OmniDesDocuRecipients' | localize }}\n                        <button class=\"btn btn-default\" type=\"button\" \n                            ng-disabled=\"form.propertiesForm.docusignSignerName.$invalid || form.propertiesForm.docusignSignerEmail.$invalid || form.propertiesForm.docusignSignerRole.$invalid || scriptElement.IsActive__c\" \n                            ng-click='addDocuSignSigner(activeElement, $index)' >\n                            <i class=\"icon icon-v-plus-line\"></i>{{ ::'OmniDesDocuAddRecipient' | localize }}\n                        </button>\n                    </div>\n                    <thead class='vlc-docusign-list-head'>\n                        <th>{{ ::'OmniDesDocuRoutingOrder' | localize }}\n                            <i class='icon icon-v-information-line'\n                                bs-tooltip=\"tooltips.docuSignRoutingOrder\"\n                                data-container=\".container\"\n                                data-type=\"info\">\n                            </i>\n                        </th>\n                        <th>{{ ::'OmniDesDocuSignerName' | localize }}<span class=\"required\">*</span></th>\n                        <th>{{ ::'OmniDesDocuSignerEmail' | localize }}<span class=\"required\">*</span></th>\n                        <th>{{ ::'OmniDesDocuTemplateRole' | localize }}<span class=\"required\">*</span></th>\n                        <th width=\"50px\">&nbsp;</th>\n                    </thead>\n                    <tbody class=\"vlc-docusign-tbody-omni\" ng-init='initTemplateRoles(activeElement, nsPrefix, $index)'>\n                           <tr ng-repeat='signer in template.signerList'>\n                               <td>\n                                   <input type='text'\n                                       class='form-control vlc-docusign-input-cell'\n                                       ng-disabled='scriptElement.IsActive__c'\n                                       ng-model='signer.routingOrder'/>\n                               </td>\n                               <td>\n                                   <input type='text' \n                                       class='form-control vlc-docusign-input-cell'\n                                       ng-disabled='scriptElement.IsActive__c'\n                                       name='docusignSignerName'\n                                       ng-model='signer.signerName'\n                                       ng-required='true'/>\n                               </td>\n                               <td>\n                                   <input type='text' \n                                       class='form-control vlc-docusign-input-cell'\n                                       ng-disabled='scriptElement.IsActive__c'\n                                       name='docusignSignerEmail'\n                                       ng-model='signer.signerEmail'\n                                       ng-required='true'/>\n                               </td>\n                               <td>\n                                   <label class=\"select-label vlc-docusign-select\">\n                                       <select name='docusignSignerRole vlc-docusign-select-cell' style='top: 6px; position: relative; width: 105%;'\n                                           class='form-control'\n                                           ng-disabled='scriptElement.IsActive__c'\n                                           ng-model='signer.templateRole'\n                                           ng-options='option.name as option.name for option in template.templateRoleName.roles' ng-required='true'/>\n                                   </label>\n                               </td>\n                               <td class='vlc-delete-cell'>\n                                   <span class='trash-icon icon-v-trash vlc-docusign-delete-cell' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteDocuSignSigner($index, activeElement)' style='top: 8px; left: 17px;'>\n                               </td>\n                           </tr>\n                       </tbody>\n                </div>\n            </table>\n        </div>\n   </div>"),
$templateCache.put("editblock-object-select-template.tpl.html","<!-- editblock-object-select-template.tpl.html -->\n\n<label name='loopname' class=\"select-label vlc-docusign-select\">Select sObject</label>\n    <select \n        class='form-control'\n        id='selectsObject_ctrl'\n        ng-disabled='scriptElement.IsActive__c'\n        ng-model='activeElement.PropertySet__c.selectSobject'\n        ng-init=\"loadFieldsFor(activeElement.PropertySet__c.selectSobject)\"\n        ng-change=\"loadFieldsFor(activeElement.PropertySet__c.selectSobject)\"\n        ng-options=\"object.name as object.name for object in sobjectTypes\"\n    /> \n </label>"),$templateCache.put("editblock-sobjectfieldmap-table.tpl.html",'<!-- editblock-sobjectfieldmap-table.tpl.html -->\n\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class=\'panel panel-default vlc-docusign-list\'>\n        <div class="panel-heading">\n            sObject Field Mapping\n            <button class="btn btn-default" type="button"\n                ng-disabled="form.propertiesForm.osControl.$invalid || form.propertiesForm.sObjectField.$invalid || scriptElement.IsActive__c"\n                ng-click=\'addsObjectMap(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>Add Mapping\n            </button>\n        </div>\n        <table class=\'table\'>\n            <thead class=\'vlc-docusign-list-head\'>\n                <th>Edit Block Element</th>\n                <th>sObject Field</th>\n                <th width="100px">Duplicate Key</th>\n                <th width="30px">&nbsp;</th>\n            </thead>\n            <tbody class="vlc-docusign-tbody-omni">\n               <tr ng-repeat=\'map in activeElement.PropertySet__c.sobjectMapping\'>\n                    <td>\n                        <input type="text"\n                            name="osElement"\n                            class="form-control"\n                            id="osElement_{{$index}}"\n                            ng-disabled="scriptElement.IsActive__c"\n                            ng-model=\'map.osElement\'\n                            ng-required="true"\n                            bs-options="option for option in getTypeAheadEleOptions(activeElement,\'osElement_{{$index}}\')"\n                            bs-typeahead="bs-typeahead"\n                            data-min-length="0"/>\n                    </td>\n                    <td>\n                        <select class=\'form-control\'\n                            name="sObjectField"\n                            id="sObjectField_{{$index}}"\n                            ng-disabled=\'scriptElement.IsActive__c\'\n                            ng-model=\'map.sObjectField\'\n                            ng-required="true"\n                            ng-options="name as name for (name, field) in getAllFieldsForObjects(activeElement.PropertySet__c.selectSobject, \'sObjectField_{{$index}}\') | orderBy:\'toString()\'"/>\n                    </td>\n                    <td class=\'vlc-editblock-upsertkey\'>\n                        <input type="checkbox"\n                            class=\'form-control vlc-docusign-checkbox-cell\'\n                            ng-disabled=\'scriptElement.IsActive__c\'\n                            ng-model="map.duplicateKey" />\n                    </td>\n                    <td class=\'vlc-delete-cell\'>\n'+"                        <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deletesObjectMap($index, activeElement)'>\n                    </td>\n               </tr>\n            </tbody>\n       </table>\n    </div>\n"),$templateCache.put("editblock-valuesvgmap-table.tpl.html",'<!-- editblock-valueSvgMap-table.tpl.html -->\n\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class="panel panel-default vlc-docusign-list">\n        <div class="panel-heading">\n            SVG ICON\n            <button class="btn btn-default" type="button"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-click=\'addValueSvgMap(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>Add Svg Icon\n            </button>\n        </div>\n        <table class="table">\n            <div class="panel panel-default vlc-docusign-list" style=\'margin-bottom:0px;\'>\n                <thead class=\'vlc-docusign-list-head\'>\n                    <th>value</th>\n                    <th>Svg Sprite</th>\n                    <th>Svg Icon</th>\n                    <th width="30px">&nbsp;</th>\n                </thead>\n            </div>\n            <tbody class="vlc-docusign-tbody-omni">\n                <tr ng-repeat=\'map in activeElement.PropertySet__c.valueSvgMap\'>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.value">\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.svgSprite">\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.svgIcon">\n                         </input>\n                    </td>\n                    <td class=\'vlc-delete-cell\'>\n'+"                        <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteValueSvgMap($index, activeElement)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n   </div>"),$templateCache.put("email-action-document-attachments-multiselect.tpl.html","<!-- email-action-document-attachments-multiselect.tpl.html -->\n\n<div class='form-group'>\n    <label name='loopname' class=\"select-label vlc-docusign-select\">Select Document Attachments</label>\n        <select  multiple='multiple'\n            style='height: 100px; overflow-y: scroll;'\n            class='form-control'\n            name='loopname'\n            ng-disabled='scriptElement.IsActive__c'\n            ng-model='activeElement.PropertySet__c.staticDocList'\n            ng-options=\"option.DeveloperName as option.DeveloperName for option in emailDocuments\"\n        /> \n    </label>\n</div>"),$templateCache.put("email-action-send-via-address.tpl.html","<!-- email-action-send-via-address.tpl.html -->\n    <div class='panel panel-default vlc-docusign-list' ng-if='!activeElement.PropertySet__c.useTemplate'>\n        <div class='panel-heading'>\n            To:\n            <button class='btn btn-default' type='button'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-click='addAddress(property, \"toAddressList\")' >\n                <i class='icon icon-v-plus-line'></i>{{ ::'OmniDesDocuAddRecipient' | localize }}\n            </button>\n        </div>\n        <table class='table'>\n            <thead class='vlc-docusign-list-head'>\n                <th style='width: 96%;'>To Address List</th>\n            </thead>\n            <tbody class='vlc-docusign-tbody-omni'>\n                <tr ng-repeat='toAddr in activeElement.PropertySet__c.emailInformation.toAddressList track by $index'>\n                    <td style='padding-right: 0px;'>\n                        <input type='text'\n                            class='form-control'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.emailInformation.toAddressList[$index]'/>\n                    </td>\n                    <td class='vlc-delete-cell'>\n                         <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteAddress($index, activeElement.PropertySet__c.emailInformation.toAddressList)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n    <div class='panel panel-default vlc-docusign-list' ng-if='!activeElement.PropertySet__c.useTemplate'>\n        <div class='panel-heading'>\n            Cc:\n            <button class='btn btn-default' type='button'\n                ng-disabled=\"scriptElement.IsActive__c\" \n                ng-click='addAddress(property, \"ccAddressList\")' >\n                <i class=\"icon icon-v-plus-line\"></i>{{ ::'OmniDesDocuAddRecipient' | localize }}\n            </button>\n        </div>\n        <table class='table'>\n            <thead class='vlc-docusign-list-head'>\n                <th style='width: 96%;'>Cc Address List</th>\n            </thead>\n            <tbody class='vlc-docusign-tbody-omni'>\n                <tr ng-repeat='toAddr in activeElement.PropertySet__c.emailInformation.ccAddressList track by $index'>\n                    <td style='padding-right: 0px;'>\n                        <input type='text'\n                            class='form-control'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.emailInformation.ccAddressList[$index]'/>\n                    </td>\n                    <td class='vlc-delete-cell'>\n                         <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteAddress($index, activeElement.PropertySet__c.emailInformation.ccAddressList)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n    <div class='panel panel-default vlc-docusign-list' ng-if='!activeElement.PropertySet__c.useTemplate'>\n        <div class='panel-heading'>\n            Bcc:\n            <button class='btn btn-default' type='button'\n                ng-disabled='scriptElement.IsActive__c' \n                ng-click='addAddress(property, \"bccAddressList\")' >\n                <i class='icon icon-v-plus-line'></i>{{ ::'OmniDesDocuAddRecipient' | localize }}\n            </button>\n        </div>\n        <table class='table'>\n            <thead class='vlc-docusign-list-head'>\n                <th style='width: 96%;'>Bcc Address List</th>\n            </thead>\n            <tbody class='vlc-docusign-tbody-omni'>\n                <tr ng-repeat='toAddr in activeElement.PropertySet__c.emailInformation.bccAddressList track by $index'>\n                    <td style='padding-right: 0px;'>\n                        <input type='text'\n                            class='form-control'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.emailInformation.bccAddressList[$index]'/>\n                    </td>\n                    <td class='vlc-delete-cell'>\n                         <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteAddress($index, activeElement.PropertySet__c.emailInformation.bccAddressList)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n    </div>\n    <div class='form-group' ng-if='!activeElement.PropertySet__c.useTemplate'>\n            <label><span>Email Subject</span></label>\n            <input  type='text'\n                class='form-control'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-model='activeElement.PropertySet__c.emailInformation.emailSubject' />\n        </div>\n        <div class='form-group' ng-if='!activeElement.PropertySet__c.useTemplate'>\n            <label><span>Email Body</span></label>\n            <textarea\n                class='form-control'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-model='activeElement.PropertySet__c.emailInformation.emailBody' />\n        </div>\n        <div class='form-group' ng-if='!activeElement.PropertySet__c.useTemplate'>\n            <label>\n                <input type='checkbox'\n                    ng-disabled='scriptElement.IsActive__c'\n                    ng-model='activeElement.PropertySet__c.emailInformation.setHtmlBody' />\n                <span style='margin-left: 5px;'>Set Html Body</span>\n            </label>\n        </div>\n"),$templateCache.put("email-action-send-via-template.tpl.html","<!-- email-action-send-via-template.tpl.html -->\n<div ng-if='activeElement.PropertySet__c.useTemplate'>\n    <div class='form-group col-lg-5'>\n        <label name='loopname' class=\"select-label vlc-docusign-select\">Select Email Template</label>\n            <select \n                class='form-control'\n                name='loopname'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-model='activeElement.PropertySet__c.emailTemplateInformation.emailTemplateName'\n                ng-options=\"option.DeveloperName as option.DeveloperName for option in emailTemplates\"\n            /> \n        </label>\n    </div>\n    <div class='form-group col-lg-5'>\n        <label><span>Email Target Object Id</span></label>\n            <input  type='text'\n            class='form-control'\n            ng-disabled='scriptElement.IsActive__c'\n            ng-model='activeElement.PropertySet__c.emailTemplateInformation.emailTargetObjectId' />\n    </div>\n    <div class='form-group col-lg-5'>\n        <label><span>What Id</span></label>\n            <input  type='text'\n                class='form-control'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-model='activeElement.PropertySet__c.emailTemplateInformation.whatId' />\n    </div>\n    <div class='form-group col-lg-5' style='margin-top: 25px'>\n        <label>\n            <input type='checkbox'\n                ng-disabled='scriptElement.IsActive__c'\n                ng-model='activeElement.PropertySet__c.emailTemplateInformation.saveAsActivity' />\n            <span style='margin-left: 5px;'>Save As Activity</span>\n        </label>\n    </div>\n</div>"),$templateCache.put("email-action-useTemplate-checkbox.tpl.html","<!-- email-action-useTemplate-checkbox.tpl.html -->\n<div class='form-group'>\n    <label>\n        <input type='checkbox'\n            ng-disabled='scriptElement.IsActive__c'\n            ng-change='onChangeEmailUseTemplate(activeElement)'\n            ng-model='activeElement.PropertySet__c.useTemplate' />\n        <span style='margin-left: 5px;'>Use Template</span>\n    </label>\n</div>"),$templateCache.put("expression-builder-property-template.tpl.html",'<div class="form-group">\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <simple-expression-builder\n            expression="property.currentValue"\n            aggregatemode="activeElement.type() == \'Aggregate\'"\n            disabled="scriptElement.IsActive__c"\n            element-names="elementNames(true)"\n            change="property.update()" />\n</div>'),$templateCache.put("external-object-columns-property-table.tpl.html",'<!-- external-object-columns-property-table.tpl.html -->\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class="panel panel-default vlc-docusign-list">\n        <div class="panel-heading">\n            Columns Property\n            <button class="btn btn-default" type="button"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-click=\'addColumnsPropertyMap(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>Add Column Property\n            </button>\n        </div>\n        <table class="table">\n            <div class="panel panel-default vlc-docusign-list" style=\'margin-bottom:0px;\'>\n                <thead class=\'vlc-docusign-list-head\'>\n                    <th>Name<span class="required">*</span></th>\n                    <th>Label</th>\n                    <th>Description</th>\n                    <th>Type<span class="required">*</span></th>\n                    <th>Length<span class="required">*</span></th>\n                    <th>Decimal Places</th>\n                    <th width="30px">&nbsp;</th>\n                </thead>\n            </div>\n            <tbody class="vlc-docusign-tbody-omni">\n                <tr ng-repeat=\'map in activeElement.PropertySet__c.columnsPropertyMap\'>\n                    <td>\n                         <input type=\'text\' class="form-control" required\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.name">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.label">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.description">\n                         </input>\n                    </td>\n                    <td>    \n                         <select class="form-control" required\n                            ng-disabled="scriptElement.IsActive__c" \n                            ng-options=\'option for option in columnPropertyTypes\'\n                            ng-model=\'map.type\'>\n                         </select>\n                    </td>\n                    <td>\n                        <input type=\'number\' class="form-control"\n                             min="1"\n                             max="131072"\n                             step=1\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-if="map.type == \'Long text area\'"\n                             ng-model="map.length">\n                         </input>\n                         <input type=\'number\' class="form-control"\n                             min="1"\n                             max="255"\n                             step=1\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-if="map.type == \'Text\'"\n                             ng-model="map.length">\n                         </input>\n                         <input type=\'number\' class="form-control"\n                             min="1"\n                             max="18"\n                             step=1\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-if="map.type == \'Number\'"\n                             ng-model="map.length">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'number\' class="form-control"\n                             ng-if="map.type === \'Number\'"\n                             ng-disabled="map.type != \'Number\' || scriptElement.IsActive__c"                             \n                             ng-model="map.decimalPlaces">\n                         </input>\n                    </td>\n                    <td class=\'vlc-delete-cell\'>\n'+"                        <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteColumnsPropertyMap($index, activeElement)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n   </div>"),$templateCache.put("external-object-relationship-fields-table.tpl.html",'<!-- external-object-relationship-fields-table.tpl.html -->\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class="panel panel-default vlc-docusign-list">\n        <div class="panel-heading">\n            Relationship Fields\n            <button class="btn btn-default" type="button"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-click=\'addRelationshipFieldsMap(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>Add Field\n            </button>\n        </div>\n        <table class="table">\n            <div class="panel panel-default vlc-docusign-list" style=\'margin-bottom:0px;\'>\n                <thead class=\'vlc-docusign-list-head\'>\n                    <th>Name<span class="required">*</span></th>\n                    <th>Label</th>\n                    <th>Description</th>\n                    <th>Length<span class="required">*</span></th>\n                    <th>Type<span class="required">*</span></th>\n                    <th>Reference To<span class="required">*</span></th>\n                    <th>Reference Target Field</th>\n                    <th width="30px">&nbsp;</th>\n                </thead>\n            </div>\n            <tbody class="vlc-docusign-tbody-omni">\n                <tr ng-repeat=\'map in activeElement.PropertySet__c.relationshipFieldsMap\'>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.name"\n                             ng-required="true">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.label">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.description">\n                         </input>\n                    </td>\n                    <td>\n                         <input type=\'number\' class="form-control"\n                             min="1"\n                             max="255"\n                             step=1\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.length">                             \n                         </input>\n                    </td>\n                    <td>    \n                         <select class="form-control"\n                            ng-disabled="scriptElement.IsActive__c" \n                            ng-options=\'option for option in relationshipTypes\'\n                            ng-required="true"\n                            ng-model=\'map.type\'>\n                            <option value="" ng-if="true"></option>\n                         </select>\n                    </td>\n                    <td>    \n                        <select class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-if="map.type == \'Lookup relationship\'"\n                             ng-options="object.name as object.name for object in sobjectTypes"\n                             ng-required="true"\n                             ng-model=\'map.referenceTo\'>\n                             <option value="" ng-if="true"></option>\n                         </select>\n                         <select class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-if="map.type == \'External lookup relationship\'"\n                             ng-options="object.name as object.name for object in externalObjectTypes | orderBy: \'\'"\n                             ng-required="true"\n                             ng-model=\'map.referenceTo\'>\n                             <option value="" ng-if="true"></option>\n                         </select>\n                          <select class="form-control"\n                            ng-disabled="scriptElement.IsActive__c"\n                            ng-if="map.type == \'Indirect lookup relationship\'"\n                            ng-options="option as option for option in objectsWithExternalFieldsName | orderBy: \'\'"\n                            ng-required="true"\n                            ng-model=\'map.referenceTo\'>\n                            <option value="" ng-if="true"></option>\n                        </select>\n                    </td>\n                    <td>    \n                          <select class="form-control"\n                            ng-disabled="scriptElement.IsActive__c"\n                            ng-if="map.type == \'Indirect lookup relationship\' && map.referenceTo != \'\'"\n                            ng-options="object.name as object.name for object in objectWithExternalFields(map.referenceTo) | orderBy: \'toString()\'"\n                            ng-required="true"\n                            ng-model=\'map.referenceTargetField\'>\n                            <option value="" ng-if="true" selected hidden></option>\n                          </select>\n                    </td>\n                    <td class=\'vlc-delete-cell\'>\n'+"                        <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteRelationshipFieldsMap($index, activeElement)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n   </div>"),$templateCache.put("external-object-url.tpl.html",'<!-- external-object-url.tpl.html -->\n<label>\n        \n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n        <!-- <i class="icon icon-v-link" ng-if="!property.loading"></i> -->\n        <button type="button" class="btn btn-link pull-right" target="_blank" ng-click="openLink(\'ExternalObjectsPage\')">\n                     <!--<span>{{ activeElement.SubType__c }}</span>-->\n                     <i class="icon icon-v-link" ng-if="!property.loading"></i>\n        </button>\n</label>'),$templateCache.put("formula-builder-property-template.tpl.html",'<div class="form-group">\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <monaco-editor ng-model="property.currentValue"\n                   ng-attr-readonly="{{scriptElement.IsActive__c ? \'readonly\' : undefined}}"\n                   ng-attr-disabled="{{scriptElement.IsActive__c ? \'disabled\' : undefined}}" \n                   language="vlocity-formula"\n                   style="max-width: 100%; min-height: 7rem; max-height: 7rem; padding: 0; overflow: visible; display: block; border: 1px solid #ccc; border-radius: 4px;"\n                   ng-change="property.update()"></monaco-editor>\n</div>'),$templateCache.put("group-template.tpl.html",'<!-- group-template.tpl.html -->\n<div class="group" ng-if="!property.tabs">\n    <h4 ng-click="property.collapse = !property.collapse">\n    <i class="icon icon-v-right-arrow"\n            ng-show="property.collapse"></i>\n    <i class="icon icon-v-down-arrow"\n            ng-show="!property.collapse"></i>\n      {{ property.title }}\n    </h4>\n    <div ng-show="!property.collapse"\n         class="group-rows">\n      <div ng-repeat="row in property.layoutrows track by $index"\n           ng-include="\'row-template.tpl.html\'">\n      </div>\n    </div>\n</div>\n<div class="group" ng-if="property.tabs">\n    <h4 ng-click="property.collapse = !property.collapse">\n    <i class="icon icon-v-right-arrow"\n            ng-show="property.collapse"></i>\n    <i class="icon icon-v-down-arrow"\n            ng-show="!property.collapse"></i>\n      {{ property.title }}\n    </h4>\n    <ul class="nav nav-alt" role="tablist" ng-show="!property.collapse" >\n      <li role="presentation" ng-repeat="$pane in property.tabs track by $index" ng-class="[ property.activeTab ===  $index ? \'active\' : \'\' ]">\n        <i class="icon icon-v-close" ng-click="deleteTab(property, $index)" ng-if="!$last && !scriptElement.IsActive__c"></i>\n        <a role="tab" data-toggle="tab" ng-click="addTab(property, $index)" data-index="{{ $index }}">\n          {{$last && !scriptElement.IsActive__c ? \'+\' : property.$canvasElement.PropertySet__c[property.prop][$index].id}}\n        </a>\n      </li>\n    </ul>\n    <div ng-show="!property.collapse" class="group-rows">\n      <div ng-repeat="row in property.layoutrows[property.activeTab] track by $index"\n           ng-init="propertySet = propertySet[property.prop][property.activeTab]"\n           ng-include="\'row-template.tpl.html\'">\n      </div>\n    </div>\n</div>\n'),$templateCache.put("input-parameters-property-template.tpl.html",'<!-- input-parameters-property-template.tpl.html -->\n<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="panel panel-default">\n    <div class="panel-heading">\n        {{ ::\'OmniDesInputParam\' | localize }}\n        <i class="icon icon-v-information-line"\n            bs-tooltip="tooltips.inputParameters"\n            data-container=".container"\n                data-type="info"></i>\n        <button class="btn btn-default" type="button"\n                ng-if="!scriptElement.IsActive__c"\n                ng-click="addNewKeyValueWrapper(propertySet, property)">\n            <i class="icon icon-v-plus-line"></i>\n            {{ ::\'OmniDesAddInputParam\' | localize }}\n        </button>\n    </div>\n    <table class="table">\n        <thead>\n            <th>{{ ::\'OmniDesDataSource\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.dataSource"\n                    data-container=".container"\n                    data-type="info"></i></th>\n            <th>{{ ::\'OmniDesFilterValue\' | localize }}</th>\n            <th width="50px">&nbsp;</th>\n        </thead>\n        <tbody ng-init="propWrapper = makeKeyValuePropWrapper(propertySet, property)">\n            <tr ng-repeat="prop in propWrapper">\n                <td>\n                     <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-change="prop.update()"\n                            ng-model="prop.name"\n                            bs-options="name for name in elementNames()"\n                            bs-typeahead="bs-typeahead"\n                            data-min-length="0"/>\n                </td>\n                <td>\n                     <input type="text"\n                            ng-disabled="scriptElement.IsActive__c"\n                            class="form-control input-sm"\n                            ng-change="prop.update()"\n                            ng-model="prop.value" />\n                </td>\n                <td>\n                    <button type="button"\n                            class="btn btn-link"\n                            ng-if="!scriptElement.IsActive__c"\n                            ng-click="prop.delete()">\n                        <i class="icon icon-v-trash"></i>\n                    </button>\n                </td>\n            </tr>\n        </tbody>\n    </table>\n</div>'),$templateCache.put("key-value-property-template.tpl.html",'<!-- key-value-property-template.tpl.html -->\n<!-- using ng-hide to esure element exists in dom at all times so it can be a target for compilation -->\n<label ng-hide="property.$parentProperty.type == \'key-value\'">\n  <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n  <div class="info icon icon-v-information-line" vlc-tooltip="getMiscForProperty(property).tooltip"></div>\n</label>\n<div class="key-value" ng-if="property.$parentProperty.type != \'key-value\'">\n\n    <div class="optionProperty row" ng-if="getMiscForProperty(property)!==undefined && property.currentValue.length">\n         <div class="col-lg-5 text-center">\n            {{property.misc.keyLabel}}\n         </div>\n         <div class="col-lg-5 text-center">\n            {{property.misc.valLabel}}\n         </div>\n    </div>\n\n    <div class="optionProperty row"\n         ng-repeat="property in property.currentValue track by $index"\n         ng-class="getClassForProperty(property)"\n         ng-include="getTemplateForProperty(property, activeElement)">\n    </div>\n</div>\n<button type="button" class="btn btn-default"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-if="property.$parentProperty.type != \'key-value\'"\n        ng-click="property.addNewKeyValueWrapper()">{{ ::\'OmniDesNewKeyValuePair\' | localize }}</button>\n<div class="col-lg-5" ng-if="property.$parentProperty.type == \'key-value\'">\n    <input  type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.key" />\n</div>\n<div class="col-lg-5" ng-if="property.$parentProperty.type == \'key-value\'">\n  <div class="input-group">\n    <input  type="text"\n            class="form-control"\n            disabled="disabled"\n            readonly="readonly"\n            placeholder="{{property | placeholder}}"\n            value="Use \'Edit JSON\' to edit this value."\n             />\n    <span class="input-group-addon" data-container=".container" data-type="info" data-html="true" bs-tooltip="property" data-title="{{property.getValueAsString()}}">\n      <span class="icon icon-v-view" ></span>\n    </span>\n  </div>\n</div>\n<div class="col-lg-1" ng-if="property.$parentProperty.type == \'key-value\'">\n    <button type="button" class="btn btn-link trash"\n            ng-if="!scriptElement.IsActive__c && !property.isDefault"\n            ng-click="property.delete()" title="Delete property">\n        <span class="icon icon-v-trash"></span>\n    </button>\n</div>\n'),
$templateCache.put("listmerge-advancedmergemap-table.tpl.html",'<!-- listmerge-advancedmergemap-table.tpl.html -->\n\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class="panel panel-default vlc-docusign-list">\n        <div class="panel-heading">\n            Advanced Merge\n            <button class="btn btn-default" type="button"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-click=\'addAdvancedMergeMap(activeElement)\' >\n                <i class="icon icon-v-plus-line"></i>Add Merge Map\n            </button>\n        </div>\n        <table class="table">\n            <div class="panel panel-default vlc-docusign-list" style=\'margin-bottom:0px;\'>\n                <thead class=\'vlc-docusign-list-head\'>\n                    <th>List Key</th>\n                    <th>Matching Path</th>\n                    <th>Normalize Key</th>\n                    <th width="30px">&nbsp;</th>\n                </thead>\n            </div>\n            <tbody class="vlc-docusign-tbody-omni">\n                <tr ng-repeat=\'map in activeElement.PropertySet__c.advancedMergeMap\'>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.listKey">\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.matchingPath">\n                    </td>\n                    <td>\n                         <input type=\'text\' class="form-control"\n                             ng-disabled="scriptElement.IsActive__c"\n                             ng-model="map.normalizeKey">\n                         </input>\n                    </td>\n                    <td class=\'vlc-delete-cell\'>\n'+"                        <span class='trash-icon icon-v-trash' ng-class='{ \"is-disabled\": scriptElement.IsActive__c }'  ng-click='deleteAdvancedMergeMap($index, activeElement)'>\n                    </td>\n                </tr>\n            </tbody>\n        </table>\n   </div>"),$templateCache.put("modal-doc-insert.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n    <div class="modal-dialog" style="width:400px;height:200px;margin-top:15%;">\n        <div class="modal-content">\n            <div class="modal-header">\n                <h4 class="modal-title vlc-debug-console-header">{{::title}}</h4>\n            </div>\n\n            <div class="modal-body">\n                <label style="display:block;">\n                    <input type = checkbox ng-model="obj.filePicker" ng-click ="clearError()">\n                    <span>Pick from existing Documents</span>\n                </label>\n                <label ng-if="!obj.filePicker" style="display:block;">\n                    <input id          = "docSelModalFile"\n                           class       = "form-control" \n                           type        = "text" \n                           placeholder = "click to browse for files" \n                           onclick     = "document.getElementById(\'filePicker\').click();" \n                           ng-model    = "obj.fileUpload">\n                    <input id        = "filePicker"\n                           type      = "file"\n                           style     = "visibility:hidden;position:absolute;"\n                           ng-click  = "clearError();obj.fileUpload=null;"\n                           onchange  = "if(this.files[0]){document.getElementById(\'docSelModalFile\').value = this.files[0].name;}else{document.getElementById(\'docSelModalFile\').value = null}"\n                           ng-model  = "obj.fileUpload"\n                           accept    = "image/*">\n                </label>\n                <label ng-if="obj.filePicker" style="display:block;">\n                    <select id="selDocuments" class="form-control" role="selectbox" ng-model="obj.selDocuments"\n                        ng-options="document as document.Name for document in obj.getDocs(true)" ng-change="clearError();">\n                    </select>\n                </label>\n                <div class="has-error"><p class="help-block" id="errorLabel"></p></div>\n            </div>\n\n            <div class="modal-footer">\n                <button ng-click="submit()" class="btn btn-default">Ok</button>\n                <button ng-click="cancel()" class="btn btn-default">Cancel</button>\n                <div class="expand" vlc-expand-collapse="" classes="vlc-debug-panel, modal-body" prop="min-height">\n                </div>\n            </div>\n\n        </div>\n    </div>\n</div>'),$templateCache.put("modal-edit-expression.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n    <div class="modal-dialog" style="width:800px;height:300px;margin-top:15%;">\n        <div class="modal-content">\n            <div class="modal-header">\n                <h4 class="modal-title vlc-debug-console-header">{{::title}}</h4>\n            </div>\n\n            <div class="modal-body">\n                <simple-expression-builder\n                        expression="obj.newVal"\n                        aggregatemode="parentObject.$canvasElement.type() == \'Aggregate\'"\n                        disabled="parentObject.$parentProperty.$canvasElement.scriptElement().IsActive__c"\n                        element-names="obj.elementNames(true)"\n                        ng-if="!$root.scriptElement.IsProcedure__c"\n                         />\n                <monaco-editor\n                        ng-model="obj.newVal"\n                        ng-attr-readonly="{{scriptElement.IsActive__c ? \'readonly\' : undefined}}"\n                        ng-attr-disabled="{{scriptElement.IsActive__c ? \'disabled\' : undefined}}" \n                        language="vlocity-formula"\n                        style="max-width: 100%; min-height: 7rem; max-height: 7rem; padding: 0; overflow: visible; display: block; border: 1px solid #ccc; border-radius: 4px;"\n                        ng-if="$root.scriptElement.IsProcedure__c"\n                         ></monaco-editor>\n            </div>\n\n            <div class="modal-footer">\n                <button ng-click="submit()" class="btn btn-default">Ok</button>\n                <button ng-click="cancel()" class="btn btn-default">Cancel</button>\n                <div class="expand" vlc-expand-collapse="" classes="vlc-debug-panel, modal-body" prop="min-height">\n                </div>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("modal-how-to-use-this.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body">\n        <p>This OmniScript can be used in one of two ways: standalone or embedded</p>\n        <h4>Standalone</h4>\n        <p>Once "Activated", the OmniScript can be accessed using one of Vlocity\'s prebuilt pages: </p>\n        <form class="form-inline" style="margin-bottom: 25px;">\n          <div class="form-group">\n            <select class="form-control" ng-options="mode for mode in modes" ng-model="currentMode" style="max-width:250px"></select>\n          </div>&nbsp;&nbsp;\n          <div class="radio">\n            <label class="radio-inline">\n              <input type="radio" value="vertical" ng-model="vertOrHoriz"/> Vertical\n            </label>\n            <label class="radio-inline" style="margin-top: 6px;">\n              <input type="radio" value="horizontal" ng-model="vertOrHoriz"/> Horizontal\n            </label>\n            <label class="radio-inline" style="margin-top: 6px;" ng-hide ="currentMode == \'Mobile\' || currentMode == \'Communities\'">\n              <input type="radio" value="lightning" ng-model="vertOrHoriz"/> Lightning\n            </label>\n          </div>&nbsp;&nbsp;\n        </form>\n        <p></p>\n        <div class="input-group">\n          <input type="text" class="form-control" ng-model="url" id="url" />\n          <span class="input-group-btn">\n            <button class="btn btn-default copy-btn" type="button" data-clipboard-target="#url">Copy to clipboard</button>\n          </span>\n        </div><!-- /input-group -->\n        <h5>Alternative URL</h5>\n        <div class="input-group">\n          <input type="text" class="form-control" ng-model="urlWithParam" id="urlWithParam" />\n          <span class="input-group-btn">\n            <button class="btn btn-default copy-btn" type="button" data-clipboard-target="#urlWithParam">Copy to clipboard</button>\n          </span>\n        </div>\n        <hr>\n        <h4>Embedded</h4>\n        <p>If you have your own Visualforce page that you want to embed the script in then copy and paste the below code into it:</p>\n        <button class="btn btn-default copy-btn pull-right" type="button" data-clipboard-target="#vf">Copy to clipboard</button>\n        <label>\n            <input  type="checkbox" ng-model="isLightning" ng-change = \'onChangeisLightning(this)\'/>\n            <span>Lightning</span>\n        </label>\n        <textarea id="vf" class="form-control modal-textarea" rows="17" ng-model="textarea">\n        </textarea>\n        <p></p>\n      </div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="ok();$hide()">{{ ::\'OmniDesOk\' | localize }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("modal-view-full-data-json.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true" ng-init=\'initFullDataJson()\'>\n  <div class=\'spinner\' ng-show=\'loading\' style=\'position: relative; top: 280px; left: 49%; z-index: 9999;\'></div>\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body">\n        <button class="btn btn-default copy-btn pull-right" type="button" data-clipboard-target="#vf">Copy to clipboard</button>\n        <textarea id="vf" class="form-control modal-textarea" rows="17" ng-model="dataJson">\n        </textarea>\n        <p></p>\n      </div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="ok();$hide()">{{ ::\'OmniDesOk\' | localize }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("object-property-template.tpl.html",'<!-- object-property-template.tpl.html -->\n<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="objectProperty" ng-repeat="property in property.objectAsProperties()">\n    <div ng-class="getClassForProperty(property)"\n         ng-init="propertySet = propertySet[$parent.property.label]"\n         ng-include="getTemplateForProperty(property, activeElement)"></div>\n</div>'),$templateCache.put("options-property-template.tpl.html",'<!-- options-property-template.tpl.html -->\n<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<ul style="min-height: 0px">\n    <li class="row">\n        <div class="col-md-1"></div>\n        <div    class="col-md-4 text-center" \n                ng-class=\'{"col-md-5": property.$canvasElement.Type__c.label=="Multi-select"&&propertySet.optionSource.type!="image"}\' >\n                {{ ::\'OmniDesName\' | localize }}\n                <i  class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.fieldNameName"\n                    data-container=".container"\n                    data-type="info"></i>\n        </div>\n        <div    class="col-md-4 text-center" \n                ng-class=\'{"col-md-5": property.$canvasElement.Type__c.label=="Multi-select"&&propertySet.optionSource.type!="image"}\' >\n                {{ ::\'OmniDesValue\' | localize }}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.fieldNameValue"\n                    data-container=".container"\n                    data-type="info"></i>\n        </div>\n        <div class="col-md-1 text-center" ng-class=\'{"col-md-2":property.$canvasElement.Type__c.label=="Multi-select"}\' ng-if="propertySet.optionSource.type == \'image\'">{{ ::\'OmniDesImage\' | localize}}</div>\n        <div    class="col-md-1 text-center" \n                ng-class="{\'col-md-2\': propertySet.optionSource.type != \'image\'}" \n                ng-if=\'property.$canvasElement.Type__c.label!="Multi-select"\' >\n                {{ ::\'OmniDesAutoAdvance\' | localize}}\n                <i class="icon icon-v-information-line"\n                    bs-tooltip="tooltips.autoAdvance"\n                    data-container=".container"\n                    data-type="info"></i>\n        </div>\n        <div class="col-md-1"></div>\n    </li>\n</ul>\n<ul dnd-list="propertySet[property.label]"\n    dnd-drop="onDrop(event, index, item, propertySet[property.label])">\n    <li class="optionProperty row"\n            ng-repeat="value in propertySet[property.label] track by $index"\n            dnd-dragstart="onDragStart(value, $index, event)"\n            dnd-draggable="value"\n            dnd-effect-allowed="move">\n        <div class="col-md-1"><i class="icon icon-v-grip"></i></div>\n        <div class="col-md-4" ng-class=\'{"col-md-5": property.$canvasElement.Type__c.label=="Multi-select"&&propertySet.optionSource.type!="image"}\' dnd-nodrag="true">\n            <input  type="text"\n                    ng-disabled="scriptElement.IsActive__c"\n                    class="form-control"\n                    ng-model="value.name" />\n        </div>\n        <div class="col-md-4" ng-class=\'{"col-md-5": property.$canvasElement.Type__c.label=="Multi-select"&&propertySet.optionSource.type!="image"}\' dnd-nodrag="true">\n            <input type="text"\n                class="form-control"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-model="value.value" />\n        </div>\n        <div class="col-md-1" ng-class=\'{"col-md-2":property.$canvasElement.Type__c.label=="Multi-select"}\' dnd-nodrag="true" ng-if=\'propertySet.optionSource.type=="image"\' style="min-height:28px">\n            <button type="button" class="btn btn-default add-new des-thumb" ng-disabled="scriptElement.IsActive__c" ng-click=\'propDocSel(value,"imgId",true)\'>\n                <span ng-if="value.imgId === null || !value.imgId" >+ {{::\'OmniAdd\' | localize}}</span>\n                <img ng-if="value.imgId !== null && value.imgId" class="des-thumb image-thumb" src="{{value.imgId}}" alt="External Reference">\n            </button>\n            <button type="button" class="btn btn-link btn-clear" ng-disabled="scriptElement.IsActive__c" ng-click="value.imgId = null; console.log(value.imgId)" ng-if="value.imgId && value.imgId!=null"><span>x</span></button>\n        </div>\n        <div class="col-md-1" dnd-nodrag="true" ng-if=\'property.$canvasElement.Type__c.label!="Multi-select"\' ng-class="{\'col-md-2\':propertySet.optionSource.type!=\'image\'}">\n            <label style="left:50%;position:relative;">\n                <input  type="checkbox"\n                        ng-model="value.autoAdv"\n                        ng-true-value="\'next\'"\n                        ng-false-value="null"\n                        ng-disabled="scriptElement.IsActive__c"\n                />\n            </label>\n        </div>\n        <div class="col-md-1" dnd-nodrag="true">\n            <button type="button" class="btn btn-link"\n                    ng-if="!scriptElement.IsActive__c"\n                    ng-click="propertySet[property.label].splice(propertySet[property.label].indexOf(value), 1)">\n                <span class="icon icon-v-trash"></span>\n            </button>\n        </div>\n    </li>\n</ul>\n<button type="button" class="btn btn-default add-new"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-click="addNewOption(property)">{{ ::\'OmniDesNewOption\' | localize }}</button>'),$templateCache.put("paleteElementGroup.tpl.html",'<div class="paletteElementGroup" >\n    <h5 ng-click="model.expand = !model.expand">\n        <span class="pull-left">{{grouptitle}}</span>\n        <i class="icon icon-v-right-arrow pull-right"\n            ng-show="!model.expand"></i>\n        <i class="icon icon-v-down-arrow pull-right"\n            ng-show="model.expand"></i>\n    </h5>\n    <ul class="collapse" ng-class="{in: model.expand}">\n        <li ng-show="group.length == 0">\n            <h6>{{ ::\'OmniDesPaletteEmpty\' | localize:\'There are no available {1}\':grouptitle }}</h6>\n        </li>\n        <li class="paletteElementType"\n            ng-show="group.length > 0"\n            ng-repeat="element in group"\n            dnd-disable-if="$parent.$parent.scriptElement.IsActive__c"\n            dnd-type="element.type"\n            dnd-effect-allowed="move"\n            dnd-draggable="element">\n            {{element | elementLabel}}\n            <i class="icon icon-v-grip"></i>\n        </li>\n    </ul>\n</div>'),$templateCache.put("previewIntProcedure.tpl.html",'<div class="slds-col slds-grid slds-grid_vertical-stretch slds-nowrap slds-is-relative"\n      style="max-width: calc(100vw - 29px);">\n\n  <!-- Input column -->\n  <div class="slds-panel dr-preview--input slds-border_right slds-size_1-of-4 slds-grid slds-grid_vertical slds-nowrap" style="max-width: 25%">\n    <div class="slds-filters__header slds-p-top_small slds-grid slds-has-divider_bottom"\n         style="flex-shrink: 0">\n      <h3 class="slds-align-middle slds-text-heading_small">{{::$root.vlocity.getCustomLabel(\'InputParameters\', \'Input Parameters\')}}</h3>\n      <button class="slds-button slds-col_bump-left" style="line-height: 1rem;" ng-click="vm.toggleJsonMode()" ng-if="!vm.jsonMode">{{::$root.vlocity.getCustomLabel(\'EditAsJSON\' , \'Edit as JSON\')}}</button>\n      <button class="slds-button slds-col_bump-left" style="line-height: 1rem;" ng-click="vm.toggleJsonMode()" ng-if="vm.jsonMode"\n        ng-disabled="vm.invalidJSON">{{::$root.vlocity.getCustomLabel(\'EditAsParams\', \'Edit as Params\')}}</button>\n    </div>\n    <div class="slds-grow slds-col slds-grid_vertical slds-grid_vertical-stretch slds-grid"\n         ng-class="{\'slds-scrollable_y\': !vm.jsonMode}"\n         ng-style="vm.jsonMode ? {\'min-height\': \'80%\'} : {}">\n      <div class="slds-panel__section slds-col slds-grid_vertical slds-grid_vertical-stretch slds-grid"\n           ng-if="!vm.jsonMode">   \n        <div class="slds-form--compound" >\n          <div class="slds-form-element__group">\n            <div class="slds-form-element__row">\n              <div class="slds-form-element slds-size_1-of-2">\n                <label class="slds-form-element__label">{{::$root.vlocity.getCustomLabel(\'Key\', \'Key\')}}</label>\n              </div>\n              <div class="slds-form-element slds-size_1-of-2">\n                <label class="slds-form-element__label">{{::$root.vlocity.getCustomLabel(\'Value\', \'Value\')}}</label>\n              </div>\n            </div>\n          </div>\n        </div>\n        <fieldset class="slds-form--compound" ng-repeat="param in vm.params">\n          <div class="slds-form-element__group">\n            <div class="slds-form-element__row">\n              <div class="slds-form-element slds-size_3-of-7">\n                <input class="slds-input" type="text" ng-model="param.key" />\n              </div>\n              <div class="slds-form-element slds-size_3-of-7">\n                <input id="input-02" class="slds-input" type="text" ng-model="param.value" />\n              </div>\n              <div class="slds-size_1-of-7">\n                <button class="slds-button slds-button_icon slds-m-left_x-small" ng-click="vm.deleteParam(param)">\n                  <slds-button-svg-icon sprite="\'utility\'" icon="\'delete\'"></slds-button-svg-icon>\n                </button>\n              </div>\n            </div>\n          </div>\n        </fieldset>\n        <div class="slds-text-align_center slds-m-bottom_small">\n          <button class="slds-button" ng-click="vm.addParam()">\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'add\'"></slds-button-svg-icon>\n            {{::$root.vlocity.getCustomLabel(\'AddNewKeyValuePair\', \'Add New Key/Value Pair\')}}\n          </button>\n        </div>\n      </div>\n      <div class="slds-panel__section slds-col slds-grid_vertical slds-grid_vertical-stretch slds-grid"\n           style="overflow: hidden"\n           ng-if="vm.jsonMode">\n        <monaco-editor class="slds-col slds-grid slds-grid_vertical-stretch slds-p-bottom_small" \n                       ng-if="vm.jsonMode"\n                       ng-model="vm.jsonParams"\n                       style="border: 1px solid #ccc; border-radius: 4px; overflow: hidden; max-height: 100%;"\n                       monaco-options=\'{"wordWrap":true}\'></monaco-editor>\n      </div>\n    </div>\n    <div class="slds-panel__actions slds-has-divider--top">\n      <div class="slds-grid">\n        <div>\n          <a ng-click="vm.reset()" class="slds-button">{{::$root.vlocity.getCustomLabel(\'ClearData\', \'Clear Data\')}}</a>\n        </div>\n        <button class="slds-button slds-button--brand slds-col_bump-left" ng-click="vm.submitRequest()">{{::$root.vlocity.getCustomLabel(\'Execute\', \'Execute\')}}</button>\n      </div>\n    </div>\n  </div>\n\n  <div class="slds-grid slds-grid_vertical slds-grid_vertical-stretch"\n       ng-class="{\'slds-col\': !vm.sidebarOpen, \'slds-size_2-of-4\': vm.sidebarOpen}">\n    <div class="slds-col slds-size_1-of-1 slds-grid slds-grid_vertical slds-grid_vertical-stretch">\n      <div class="slds-grid slds-p-top_small slds-p-bottom_x-small slds-p-left_small slds-p-right_xx-large slds-has-divider_bottom">\n        <div class="slds-text-heading_small">{{::$root.vlocity.getCustomLabel(\'Response\', \'Response\')}}\n          <span class="slds-text-body--regular slds-m-left_small" ng-if="vm.requestTime"> {{vm.requestTime}}ms</span>\n        </div>\n      </div>\n      <monaco-editor class="slds-col slds-grid slds-grid_vertical-stretch slds-m-around_small" readonly="readonly"\n      style="border: 1px solid #ccc; border-radius: 4px; overflow: hidden; max-height: 100%"       \n        language="{{vm.getDebugType(vm.response.returnResultsData)}}"\n        format-on-render="true"\n        monaco-options=\'{"wordWrap":true}\'\n        disabled="disabled" ng-model="vm.response.returnResultsData"></monaco-editor>\n    </div>\n  </div>\n\n  <!-- DEBUG/ERROR Sidebar -->\n  <div class="slds-panel slds-grid slds-grid_vertical slds-nowrap slds-panel_filters via-slds-sidebar" style="right: 0; top: 0; bottom: 0; margin-left: 0"\n  ng-class="{\'via-slds-sidebar--closed\': !vm.sidebarOpen, \'slds-size_1-of-4\': vm.sidebarOpen}">\n    <div class="slds-form_stacked slds-grow slds-col slds-grid slds-grid_vertical"\n         style="overflow:hidden">\n      <div class="slds-filters slds-col slds-grid slds-grid_vertical slds-grid_vertical-stretch">\n        <div class="slds-filters__header slds-grid slds-has-divider_bottom">\n          <h3 class="slds-align-middle slds-text-heading_small" ng-show="vm.sidebarOpen">{{::$root.vlocity.getCustomLabel(\'ErrorsDebugOutput\', \'Errors/Debug Output\')}}</h3>\n          <button class="slds-button slds-col_bump-left slds-button_icon slds-button_icon-small" ng-attr-title="{{::$root.vlocity.getCustomLabel(\'CloseFilterPanel\', \'Close Filter Panel\')}}"\n            ng-click="vm.sidebarOpen = !vm.sidebarOpen">\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'forward\'" ng-if="vm.sidebarOpen"></slds-button-svg-icon>\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'back\'" ng-if="!vm.sidebarOpen"></slds-button-svg-icon>\n            <span class="slds-assistive-text">{{::$root.vlocity.getCustomLabel(\'CloseFilterPanel\', \'Close Filter Panel\')}}</span>\n          </button>\n        </div>\n        <div class="slds-filters__body slds-col slds-grid slds-grid_vertical slds-grid_vertical-stretch via-slds-filters__no-padding"\n          ng-show="vm.sidebarOpen" style="padding: 0">\n          <div class="slds-col slds-grid slds-grid_vertical slds-grid_vertical-stretch">\n            <!-- Debug Log -->\n            <div class="slds-grid slds-grid_vertical slds-grid_vertical-stretch slds-section slds-border_bottom" ng-class="{\'slds-col slds-is-open\': vm.currentSection === \'debug\'}">\n              <div class="slds-section__title">\n                <button class="slds-button slds-section__title-action" ng-click="vm.toggleAccordian(\'errors\', \'debug\')">\n                  <slds-button-svg-icon sprite="\'utility\'" icon="\'switch\'" extra-classes="\'slds-section__title-action-icon slds-button__icon--left\'"></slds-button-svg-icon>\n                  {{::$root.vlocity.getCustomLabel(\'DebugLog\', \'Debug Log\')}}\n                </button>\n              </div>\n              <div class="slds-section__content slds-p-horizontal_small slds-col slds-grid slds-grid_vertical slds-grid_vertical-stretch">\n                <div class="slds-grid slds-grid_align-end">\n                    <slds-picklist slds-options="option as option.name for option in vm.outputDropdown"\n                                    class="slds-m-bottom_small slds-size_small"\n                                    ng-model="vm.selectedOption"></slds-picklist>\n                </div>\n                <monaco-editor class="slds-col slds-grid slds-grid_vertical-stretch slds-m-bottom_small" \n                style="border: 1px solid #ccc; border-radius: 4px; overflow: hidden;" \n                  language="{{vm.selectedOption.language}}" \n                  readonly="readonly"\n                  disabled="disabled" \n                  format-on-render="true"\n                  monaco-options=\'{"wordWrap":true}\'\n                  ng-model="vm.selectedOption.response"></monaco-editor>\n              </div>\n            </div>\n\n            <!-- Expected JSON/XML Output -->\n            <div class="slds-grid slds-grid_vertical slds-grid_vertical-stretch slds-m-top_small slds-section slds-border_bottom" ng-class="{\'slds-col slds-is-open\': vm.currentSection === \'errors\'}">\n              <div class="slds-section__title">\n                <button class="slds-button slds-section__title-action" ng-click="vm.toggleAccordian(\'debug\', \'errors\')">\n                  <slds-button-svg-icon sprite="\'utility\'" icon="\'switch\'" extra-classes="\'slds-section__title-action-icon slds-button__icon--left\'"></slds-button-svg-icon>\n                  {{::$root.vlocity.getCustomLabel(\'Errors\', \'Errors\')}}\n                </button>\n              </div>\n              <div class="slds-section__content slds-p-horizontal_small slds-col slds-grid slds-grid_vertical slds-grid_vertical-stretch">\n                <monaco-editor class="slds-col slds-grid slds-grid_vertical-stretch slds-m-bottom_small" \n                  style="border: 1px solid #ccc; border-radius: 4px; overflow: hidden;" \n                  language="javascript"     \n                  readonly="readonly"\n                  format-on-render="true"\n                  disabled="disabled" \n                  monaco-options=\'{"wordWrap":true}\'\n                  ng-model="vm.response.errors"></monaco-editor>\n              </div>\n            </div>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n\n\n  <div class="slds-spinner_container" ng-if="vm.requesting">\n    <div class="slds-spinner--brand slds-spinner slds-spinner--medium" role="alert">\n      <span class="slds-assistive-text">{{::$root.vlocity.getCustomLabel(\'LoadingUC\', \'Loading\')}}</span>\n      <div class="slds-spinner__dot-a"></div>\n      <div class="slds-spinner__dot-b"></div>\n    </div>\n  </div>\n</div>'),$templateCache.put("property-template.tpl.html",'<!-- property-template.tpl.html -->\n<label ng-class="{ \'col-lg-5\' : property.isKeyValue() }"\n       ng-if="property.isDefault || !property.isKeyValue()">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    <i class=\'icon icon-v-information-line\' bs-tooltip="tooltips[property.label]" data-container=".container" data-type="info" ng-if="tooltipElements[property.label]"></i>\n</label>\n<div class="col-lg-5" ng-if="(!property.isDefault && property.isKeyValue()) || property.$parentProperty.isKeyValue()">\n    <input  type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.key" />\n</div>\n<div ng-class="{ \'col-lg-5\' : property.isKeyValue() }" ng-if="!property.$parentProperty.isKeyValue()">\n    <input  type="{{property.type}}"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.currentValue" />\n</div>\n<div ng-class="{ \'col-lg-5\' : property.isKeyValue() }" ng-if="property.$parentProperty.isKeyValue()">\n    <input  type="text"\n            class="form-control"\n            disabled="disabled"\n            readonly="readonly"\n            placeholder="{{property | placeholder}}"\n            value="Use \'Edit JSON\' to edit this value." />\n</div>\n\n<div class="col-lg-1" ng-if="(!property.isDefault && property.isKeyValue()) || property.$parentProperty.isKeyValue()">\n    <button type="button" class="btn btn-link trash"\n            ng-if="!scriptElement.IsActive__c && (!property.isDefault || property.isKeyValue())"\n            ng-click="property.delete()" title="Delete property">\n        <span class="icon icon-v-trash"></span>\n    </button>\n</div>'),$templateCache.put("row-template.tpl.html",'<!-- row-template.tpl.html -->\n<div class="row propertyRow">\n    <div ng-attr-class="col-md-{{row.length > 1 && !(property.currentValue.reverse) ? (10/row.length) : 12}}"\n         ng-repeat="property in row track by $index"\n         ng-if="property && !(property.shouldShow() == false)">\n         <div ng-class="getClassForProperty(property)"\n              ng-include="getTemplateForProperty(property, activeElement)"></div>\n    </div>\n</div>\n'),$templateCache.put("rte-property-template.tpl.html",'<!-- rte-property-template.tpl.html -->\n<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div>\n    <textarea ui-tinymce="tinymceOptions"\n              ng-change="property.update()"\n              ng-disabled="scriptElement.IsActive__c"\n              ng-model="property.currentValue"></textarea>\n</div>'),$templateCache.put("select-property-template.tpl.html",'<label ng-class="{ \'col-md-5\' : property.isKeyValue() }" ng-if="property.isDefault">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="col-md-5" ng-if="!property.isDefault && property.isKeyValue()">\n    <input  type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-model="property.key" />\n</div>\n<div class="row" ng-class="{ \'col-md-5\' : property.isKeyValue() }">\n    <div ng-class="{\'col-xs-12\': !property.hasLink(), \'col-xs-10\': property.hasLink()}">\n        <select class="form-control"\n                disabled="disabled"\n                ng-change="property.update()"\n                ng-disabled="scriptElement.IsActive__c || activeElement.Type__c.type == \'OmniScript\' || property.loading"\n                ng-options="option.value as option.label for option in optionsForProperty(property, activeElement, true)"\n                ng-model="property.currentValue">\n            <option value="" ng-if="false"></option>\n        </select>\n    </div>\n    <div class="col-xs-1"\n         ng-if="property.hasLink()">\n        <a class="btn btn-link pull-right"\n            target="_blank"\n            ng-click="performAction(property, \'link\')"\n            ng-disabled="property.loading || !property.currentValue">\n            <i class="icon icon-v-link" ng-if="!property.loading"></i>\n            <span class="small spinner" ng-if="property.loading"></span>\n        </a>\n    </div>\n</div>\n<div class="col-md-1" ng-if="property.isKeyValue()">\n    <button type="button" class="btn btn-link trash"\n            ng-if="!scriptElement.IsActive__c && !property.isDefault"\n            ng-click="property.delete()">\n        <span class="icon icon-v-trash"></span>\n    </button>\n</div>'),
$templateCache.put("set-error-values-property-template.tpl.html",'<label>\n  <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n  <div class="info icon icon-v-information-line" vlc-tooltip="getMiscForProperty(property).tooltip"></div>\n</label>\n<div class="row set-error-value">\n    <div class="col-md-4">\n        <label>{{::\'OmniDesElementName\' | localize:\'Element Name\'}}</label>\n    </div>\n    <div class="col-md-3 type-col">\n        <label>{{::\'OmniScriptType\' | localize:\'Type\'}}</label>\n    </div>\n    <div class="col-md-4">\n        <label change-label="OmniDesMapValue" style="display: block;">{{::\'OmniDesValue\' | localize:\'Value\'}}</label>\n    </div>\n    <div class="col-md-1">\n        <label>&nbsp;</label>\n    </div>\n</div>\n<div class="row set-error-value" ng-repeat="property in property.currentValue track by $index">\n    <div class="col-md-4">\n        <input type="text" class="form-control"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-model="property.key"\n            ng-change="property.update()"\n            bs-options="name for name in elementNames()"\n            bs-typeahead="bs-typeahead"\n            data-min-length="0"/>\n    </div>\n    <div class="col-md-3 type-col">\n        <span>{{ property.key | getTypeForElement }}</span>\n    </div>\n    <div class="col-md-4 faux-field" ng-class="{divDisabled:(property.type == \'object\' || property.type == \'key-value\' || property.type == \'array\') || scriptElement.IsActive__c}">\n        <button type="button"\n                class="btn btn-default faux-field"\n                ng-if="$parent.property.label == \'elementValueMap\' || $parent.property.label == \'elementErrorMap\'"\n                ng-disabled="(property.type == \'object\' || property.type == \'key-value\' || property.type == \'array\') || scriptElement.IsActive__c"\n                ng-click=\'editAsExpression(property,"currentValue",false)\'><i>fx</i></button>\n        <input type="text"\n            class="form-control faux-field"\n            ng-disabled="scriptElement.IsActive__c"\n            placeholder="{{property | placeholder}}"\n            ng-change="property.update()"\n            ng-model="property.currentValue"\n            ng-if="property.type !== \'object\' && property.type !== \'key-value\' && property.type !== \'array\'"\n            data-min-length="0" />\n        <input type="text"\n            class="form-control faux-field"\n            value="{{(property.type == \'object\' || property.type == \'key-value\') ? \'Object\' : \'Array\'}} (click \'Edit as JSON\' to modify)" \n            ng-if="property.type == \'object\' || property.type == \'key-value\' || property.type == \'array\'"\n            disabled="disabled"\n            readonly="readonly"/>\n    </div>\n    <div class="col-md-1">\n        <button type="button" class="btn btn-link trash"\n                ng-if="!scriptElement.IsActive__c"\n                ng-click="property.delete()" title="Delete entire element, type and value">\n            <span class="icon icon-v-trash"></span>\n        </button>\n    </div>\n</div>\n<button type="button" class="btn btn-default"\n        ng-disabled="scriptElement.IsActive__c"\n        ng-click="property.addNewKeyValueWrapper()">{{ ::\'OmniDesSetErrorValuePair\' | localize:\'+ Add New Value\' }}</button>\n'),$templateCache.put("show-property-template.tpl.html",'<label>{{showProperty.label | readablePropertyName: activeElement}}</label>\n<div class="showGroup">\n    <div ng-include="\'show-rule-property-template.tpl.html\'" ng-init="parent.rule = activeElement.PropertySet__c.show;"></div>\n</div>'),$templateCache.put("show-rule-property-template.tpl.html",'<div class="showRule input-group" ng-if="!rule.group">\n    <input type="text" class="form-control"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-model="rule.field"\n            placeholder="{{ ::\'OmniDesShowEnterFldName\' | localize }}"\n            bs-options="name for name in elementNames()"\n            bs-typeahead="bs-typeahead"\n            data-min-length="0"/>\n    <div class="input-group-btn">\n        <button type="button" class="btn btn-default"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-model="rule.condition"\n                data-html="1"\n                bs-options="condition.value as condition.label for condition in conditions" bs-select>\n                {{ ::\'OmniDesShowCond\' | localize }} <span class="caret"></span>\n        </button>\n    </div>\n    <input  type="text" class="form-control"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-model="rule.data"\n            placeholder="{{ ::\'OmniDesShowEnterValue\' | localize }}" />\n    <div class="input-group-btn">\n        <button type="button" class="btn btn-link"\n                ng-if="!scriptElement.IsActive__c"\n                ng-click="deleteRule(rule, parent.rule.group.rules)">\n            <span class="icon icon-v-trash"></span>\n        </button>\n    </div>\n</div>\n<div class="showRuleGroup" ng-if="rule.group">\n    <button type="button" class="btn btn-default"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-model="rule.group.operator"\n            data-html="1"\n            bs-options="operator.value as operator.label for operator in operators" bs-select>\n            {{ ::\'OmniDesCanvasCondition\' | localize }} <span class="caret"></span>\n    </button>\n    <div ng-repeat="rule in rule.group.rules track by $index"\n            ng-include="\'show-rule-property-template.tpl.html\'"></div>\n    <button type="button" class="btn btn-link"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-click="addCondition(rule.group)">{{ ::\'OmniDesShowAddCond\' | localize }}</button>\n    <button type="button" class="btn btn-link"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-click="addGroup(rule.group)">{{ ::\'OmniDesShowAddGroup\' | localize }}</button>\n    <button type="button" class="btn btn-link"\n            ng-if="!scriptElement.IsActive__c && (rule != activeElement.PropertySet__c[showProperty.label] && rule != rootRule)"\n            ng-click="deleteGroup(rule, parent.rule.group.rules)">\n        <span class="icon icon-v-trash"></span>\n    </button>\n</div>'),$templateCache.put("slider-cw-property-template.tpl.html",'<style>\n .col-md-12.vlc-slider--input-width{\n     padding-left:0;\n     padding:0;\n     width:100%;\n }\n</style>\n<div class="col-md-12 vlc-slider--input-width" ng-show="property.show">\n\n    <label ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</label>\n    <div range-slider min="0" max="12"\n         disabled="scriptElement.IsActive__c"\n         on-handle-up="property.update()"\n         model-max="property.currentValue" pin-handle="min"\n         show-values show-labels attach-handle-values></div>\n\n</div>\n'),$templateCache.put("slider-property-template.tpl.html",'<label ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</label>\n<div range-slider min="0" max="12"\n    disabled="scriptElement.IsActive__c"\n    on-handle-up="property.update()"\n    model-max="property.currentValue" pin-handle="min"\n    show-values show-labels attach-handle-values></div>'),$templateCache.put("spinner-property-template.tpl.html",'<label>\n    <span class="spinner"></span>\n</label>'),$templateCache.put("tabs.tpl.html",'<ul class="nav" ng-class="$navClass" role="tablist">\n  <li role="presentation" ng-repeat="$pane in $panes track by $index" ng-class="[ $isActive($pane, $index) ? $activeClass : \'\', $pane.disabled ? \'disabled\' : \'\' ]">\n    <a role="tab" data-toggle="tab" ng-click="!$pane.disabled && $setActive($pane.name || $index)" data-index="{{ $index }}" ng-bind-html="$pane.title" aria-controls="$pane.title">\n    </a>\n    <i class="icon icon-v-close"></i>\n  </li>\n</ul>\n<div ng-transclude class="tab-content">\n</div>'),$templateCache.put("textarea-property-template.tpl.html",'<div class="form-group">\n    <label>\n        <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <textarea class="form-control"\n               ng-disabled="scriptElement.IsActive__c"\n               ng-change="property.update()"\n               rows="5"\n               ng-model="property.currentValue"></textarea>\n</div>'),$templateCache.put("typeahead-google-transformation.tpl.html","<!-- typeahead-google-transformation.tpl.html -->\n\n    <label>\n        <span ng-model=\"property.label\">{{property.label | readablePropertyName: activeElement}}</span>\n    </label>\n    <div class='panel panel-default vlc-docusign-list'>\n        <table class='table'>\n            <thead class='vlc-docusign-list-head'>\n                <th>Input JSON</th>\n                <th>Output JSON</th>\n            </thead>\n            <tbody>\n               </tr>\n                    <td>\n                        <lable>street</lable>\n                    </td>\n                    <td>\n                        <select class='form-control'\n                            id='google_street'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.googleTransformation.street'\n                            ng-options='option for option in getGoogleTransOptions(activeElement, \"google_street\")' />\n                    </td>\n               </tr>\n               <tr>\n                    <td>\n                        <label>locality</label>\n                    </td>\n                    <td>\n                        <select class='form-control'\n                            id='google_locality'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.googleTransformation.locality'\n                            ng-options='option for option in getGoogleTransOptions(activeElement, \"google_locality\")'/>\n                    </td>\n               </tr>\n               <tr>\n                    <td>\n                        <label>administrative_area_level_1</label>\n                    </td>\n                    <td>\n                        <select class='form-control'\n                            id='google_administrative_area_level_1'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.googleTransformation.administrative_area_level_1'\n                            ng-options='option for option in getGoogleTransOptions(activeElement, \"google_administrative_area_level_1\")'/>\n                    </td>\n               </tr>\n               <tr>\n                    <td>\n                        <label'>country</label>\n                    </td>\n                    <td>\n                        <select class='form-control'\n                            id='google_country'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.googleTransformation.country'\n                            ng-options='option for option in getGoogleTransOptions(activeElement, \"google_country\")'/>\n                    </td>\n               </tr>\n                <tr>\n                    <td>\n                        <label>postal_code</label>\n                    </td>\n                    <td>\n                        <select class='form-control'\n                            id='google_postal_code'\n                            ng-disabled='scriptElement.IsActive__c'\n                            ng-model='activeElement.PropertySet__c.googleTransformation.postal_code'\n                            ng-options='option for option in getGoogleTransOptions(activeElement, \"google_postal_code\")'/>\n                    </td>\n                </tr>\n            </tbody>\n       </table>\n    </div>\n"),$templateCache.put("typeahead-property-template.tpl.html",'<label>\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div>\n  <input  type="text" class="form-control"\n          typeahead-options="optionsForProperty"\n          ng-model="property.currentValue"\n          bs-options="option.value as option.label for option in options"\n          bs-typeahead="bs-typeahead" \n          data-min-length="0"\n          ng-change="property.update();"\n          data-watch-options="true"\n          placeholder="{{property | placeholder}}"\n          ng-disabled="scriptElement.IsActive__c||options==null" />\n</div>\n'),$templateCache.put("typeahead-select-country.tpl.html","<!-- typeahead-select-country.tpl.html -->\n\n    <label name='loopname' class=\"select-label vlc-docusign-select\">Select Country</label>\n    <select  class='form-control' name='loopname' ng-disabled='scriptElement.IsActive__c' ng-model='activeElement.PropertySet__c.googleAddressCountry'\n            ng-options='option.value as option.name for option in googleCountryOptions' ng-init='initGoogleDefaultCountry(activeElement)'>\n    </select>"),$templateCache.put("validation-expression-property-template.tpl.html",'<label ng-class="{ \'col-md-5\' : property.isKeyValue() }" ng-if="property.isDefault">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="showGroup">\n    <div ng-include="\'show-rule-property-template.tpl.html\'"\n         ng-init="rule = property.getResolvedObject(); parent.rule = activeElement.PropertySet__c.validateExpression; rootRule = property.getResolvedObject()"></div>\n</div>'),$templateCache.put("validation-messages-property-template.tpl.html",'<label ng-class="{ \'col-md-5\' : property.isKeyValue() }" ng-if="property.isDefault">\n    <span ng-model="property.label">{{property.label | readablePropertyName: activeElement}}</span>\n</label>\n<div class="row validation-messages" ng-repeat="prop in propertySet[property.label] track  by $index"\n     ng-init="property = asProperty(property.label + \'.\' + $index, prop, activeElement)">\n    <div class="col-md-1">\n        <label>{{property.currentValue.value}}</label>\n    </div>\n    <div class="col-md-4">\n        <select class="form-control"\n                ng-change="property.update()"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-options="value as label for (label, value) in optionsForProperty(property, activeElement)"\n                ng-model="property.currentValue.type">\n            <option value="" ng-if="false"></option>\n        </select>\n    </div>\n    <div class="col-md-5">\n      <input type="text"\n            class="form-control"\n            ng-change="property.update()"\n            ng-disabled="scriptElement.IsActive__c"\n            ng-model="property.currentValue.text" />\n    </div>\n    <div class="col-md-2">\n      <label>\n        <input  type="checkbox"\n                ng-change="property.update()"\n                ng-disabled="scriptElement.IsActive__c"\n                ng-model="property.currentValue.active" />\n        <span ng-model="property.currentValue.active">Active</span>\n      </label>\n    </div>\n</div>\n\n')}]);
},{}],46:[function(require,module,exports){
angular.module("oui", ["vlocity"]);

require('./factory/Save.js');

},{"./factory/Save.js":47}],47:[function(require,module,exports){
var ScriptElement = require('../util/ScriptElement.js');
var unescapeHTML = require('../util/HtmlEncodeDecode.js').unescapeHTML;

angular.module("oui")
.factory('save', function($q, remoteActions, $rootScope, $timeout, $localizable) {
  var promisesInProgress = {};

  function saveVisitor(element) {
    var isScriptElement = (element === $rootScope.scriptElement);
    var isNewElement = !element.Id;
    var elementId = element.Id ? element.Id : (isNewElement && isScriptElement ? 'scriptElement' : element.Name);

    var promise = doSave(element);
    if (promise && elementId) {
      var chain = promisesInProgress[elementId];
      if (!chain) {
        promisesInProgress[elementId] = [];
      }
      promisesInProgress[elementId].push(promise);
    }
    return promise;
  }

  function doSave(element) {
    var isScriptElement = (element === $rootScope.scriptElement);
    var isNewElement = !element.Id;
    var elementId = element.Id;
    if ($rootScope.scriptElement.IsActive__c || element.deleted || element.deleting) {
      return $q.when(element);
    }

    if ($rootScope.scriptElement.activating) {
      return;
    }

    if (element.saving) {
      if (isNewElement) {
        if (isScriptElement) {
          elementId = "scriptElement";
        } else {
          elementId = element.Name;
        }
      }
      // queue this save
      var currentChain = promisesInProgress[elementId];
      if (currentChain) {
        return currentChain[currentChain.length - 1].then(function() {
          var previousJson = element.originalJson,
                  json = element.asJson();
          var isEqualToOldJson = angular.equals(json, previousJson);
          if (!isEqualToOldJson) {
            saveVisitor(element);
          }
        });
      } else {
        promisesInProgress[elementId] = [];
      }
    } else if (elementId) {
      promisesInProgress[elementId] = [];
    }
    var previousJson = element.originalJson,
        json = element.asJson();
    var isEqualToOldJson = angular.equals(json, previousJson);
    if (isEqualToOldJson && !isNewElement && !element.errors) {
      return $q.when(element);
    } else if(!element.Name || element.Name==='') {
      element.setErrors([{
        message: $localizable('OmniDesMustSetName', 'You must set a name')
      }]);
      return $q.when(element);
    } else if(element.type()==='DocuSign Envelope Action') {
        var list = element.PropertySet__c.docuSignTemplatesGroup,
            flag = false;
        if(list){
            for(var i=0; i<list.length; i++){
                var signerList = list[i].signerList;
                for(var j=0; j<signerList.length; j++) {
                    flag = ((signerList[j].signerName == undefined || signerList[j].signerName == '') || (signerList[j].signerEmail == undefined|| signerList[j].signerEmail == '') || (signerList[j].templateRole == undefined || signerList[j].templateRole == ''));
                    if(flag)
                        break;
                }
                if(flag)
                    break;
            }
            if(flag){
                element.setErrors([{
                    message: $localizable('OmniDesDocuRecipientErr', 'Please complete recipient information')
                }]);
                return $q.when(element);
            }
         }
    } else if(element.type()==='DocuSign Signature Action') {
        var listSig = element.PropertySet__c.docuSignTemplatesGroupSig,
            flag = false;
        if(listSig){
            for(var k=0; k<listSig.length; k++){
                flag = ((listSig[k].docuSignTemplate == undefined || listSig[k].docuSignTemplate == '') || (listSig[k].templateRole == undefined|| listSig[k].templateRole == ''));
                if(flag)
                    break;
            }
            if(flag){
                element.setErrors([{
                    message: $localizable('OmniDesDocuTemplateErr', 'Please complete template information')
                }]);
                return $q.when(element);
            }
         }
    } else if(element.type()==='Edit Block') {
        var listsObMap = element.PropertySet__c.sobjectMapping,
            flag = false;
        if(listsObMap){
            for(var l=0; l<listsObMap.length; l++){
                flag = ((listsObMap[l].osElement == undefined || listsObMap[l].osElement == '') || (listsObMap[l].sObjectField == undefined|| listsObMap[l].sObjectField == ''));
                if(flag)
                    break;
            }
            if(flag){
                element.setErrors([{
                    message: $localizable('OmniEditBlockMappingErr', 'Please complete sObject Maping')
                }]);
                return $q.when(element);
            }
         }
    }
      if (element.originalJson && (element.originalJson[ns + "Version__c"] === json[ns + "Version__c"])) {
      delete json[ns + "Version__c"];
    }
    element.originalJson = json;
    element.setSaving();
    var saveFn = (element instanceof ScriptElement) ? remoteActions.saveOmniScript : remoteActions.saveElement;
    $rootScope.$broadcast("save", element);
    return saveFn.call(remoteActions, json)
            .then(function(result){
              var promises = [];
              element.saving = false;
              if (result.success) {
                $rootScope.$broadcast("saved", element);
                if (isNewElement) {
                  element.setId(result.id);
                  // if update the Id and have children then we need to save them all too
                  if (element.children.length > 0) {
                    for (var i = 0; i < element.children.length; i++) {
                      promises.push(saveVisitor(element.children[i]));
                    }
                  }
                  if (isScriptElement && !/id/.test(window.location.search)) {
                    $timeout(function() {
                      History.pushState("","",window.location.pathname +
                          (window.location.search.length === 0 ?"?" :  window.location.search +"&")+ "id=" + result.id);
                    });
                  }
                }
                if (isScriptElement) {
                  // also need to update the language in case it was default to the users language
                  promises.push(remoteActions.getOmniScript($rootScope.scriptElement.Id)
                               .then(function(omniScriptResult){
                                  $rootScope.scriptElement.Language__c = omniScriptResult[ns + "Language__c"];
                                  $rootScope.scriptElement.LastModifiedDate = omniScriptResult.LastModifiedDate;
                                  $rootScope.scriptElement.LastModifiedById = omniScriptResult.LastModifiedById;
                                  $rootScope.scriptElement.LastModifiedBy = omniScriptResult.LastModifiedBy ? unescapeHTML(omniScriptResult.LastModifiedBy.Name) : null;
                                  $rootScope.scriptElement.Version__c = omniScriptResult[ns + "Version__c"];
                                  if (isNewElement) {
                                    // also update the Version, Owner & Created fields
                                    $rootScope.scriptElement.CreatedById = omniScriptResult.CreatedById;
                                    $rootScope.scriptElement.CreatedDate = omniScriptResult.CreatedDate;
                                    $rootScope.scriptElement.CreatedBy = omniScriptResult.CreatedBy ? unescapeHTML(omniScriptResult.CreatedBy.Name) : null;
                                    $rootScope.scriptElement.Owner = omniScriptResult.Owner ? unescapeHTML(omniScriptResult.Owner.Name) : null;
                                  }
                               }));
                }
              } else {
                element.setErrors(result.errors);
              }
              if (promises) {
                return $q.all(promises).then(function(){
                  return element;
                });
              }
              return element;
            });

  }

  return saveVisitor;
});

},{"../util/HtmlEncodeDecode.js":50,"../util/ScriptElement.js":53}],48:[function(require,module,exports){
/* globals ns */
'use strict';
var idFunction = require('../util/generateId.js');
var unescapeHTML = require('../util/HtmlEncodeDecode.js').unescapeHTML;
var PaletteElement = require('../util/PaletteElement.js');
var ScriptElement = require('../util/ScriptElement.js');
var requiredProperties = require('../util/requiredProperties.js');
var nameSpacePropsRegex = /^(Active__c|Level__c|OmniScriptId__c|OmniScriptVersion__c|Order__c|ParentElementId__c|ReusableOmniScript__c|SearchKey__c|Type__c|InternalNotes__c)$/i;

/*
 * Represents an element in the middle canvas
 * which may have one or more children
 */
function CanvasElement(paletteElement) {
    if (!paletteElement) {
        throw 'You must set a PaletteElement';
    }
    this.Type__c = paletteElement;
    this.ParentElementId__c = null;
    if (paletteElement.scriptElement) {
        this.PropertySet__c = {
            'Type': paletteElement.scriptElement.Type__c,
            'Sub Type': paletteElement.scriptElement.SubType__c,
            'Language': paletteElement.scriptElement.Language__c
        };
    } else {
        this.PropertySet__c = {};
    }
    this.PropertySet__c.show = {
        group: {
            operator: 'AND',
            rules: []
        }
    };
    this.OmniScriptId__c = null;
    this.SearchKey__c = null;
    this.Order__c = null;
    this.Active__c = true;
    this.Name = idFunction(this.Type__c.prettyName(true));
    this.Id = null;
    this.InternalNotes__c = null;
    this.children = [];
    var me = this;
    this.children.splice = function() {
        if (arguments.length === 3) {
            arguments[2].ParentElementId__c = me.Id;
            arguments[2].OmniScriptId__c = me.OmniScriptId__c;
        }
        var result = Array.prototype.splice.apply(this, arguments);
        // update Order__c
        for (var i = 0; i < this.length; i++) {
            this[i].Order__c = i + 1;
        }
        return result;
    };
}

CanvasElement.prototype.type = function() {
    return this.Type__c.label;
};

CanvasElement.prototype.setDefaultPropertySet = function(json) {
    if (this.originalJson && this.originalJson[ns + 'PropertySet__c']) {
        var escapedJson = unescapeHTML(this.originalJson[ns + 'PropertySet__c']);
        if (Object.keys(JSON.parse(escapedJson)).length <= 2) {
            this.originalJson[ns + 'PropertySet__c'] = json;
        }
    }
};

CanvasElement.fromJson = function(json) {
    json[ns + 'PropertySet__c'] = unescapeHTML(json[ns + 'PropertySet__c']);
    var propSet = JSON.parse(json[ns + 'PropertySet__c']);
    var paletteElement = PaletteElement.getPaletteElement(json[ns + 'Type__c'], propSet);
    if (!paletteElement) {
        console.log('Warning: Couldn\'t find existing palatte element for ' + json[ns + 'Type__c']);
        paletteElement = PaletteElement.factory(angular.extend({Name: json[ns + 'Type__c']}, propSet));
    }
    var canvasElement = new CanvasElement(paletteElement);
    canvasElement.Id = json.Id;
    canvasElement.Name = unescapeHTML(json.Name);
    idFunction.registerExistingPrefix(json.Name);
    canvasElement.ParentElementId__c = json[ns + 'ParentElementId__c'];
    canvasElement.PropertySet__c = propSet;
    canvasElement.OmniScriptId__c = json[ns + 'OmniScriptId__c'];
    canvasElement.SearchKey__c = json[ns + 'SearchKey__c'];
    canvasElement.Order__c = json[ns + 'Order__c'];
    canvasElement.Level__c = json[ns + 'Level__c'];
    canvasElement.Active__c = json[ns + 'Active__c'];
    canvasElement.InternalNotes__c = json[ns + 'InternalNotes__c'] ? unescapeHTML(json[ns + 'InternalNotes__c']) : null;
    if (!canvasElement.PropertySet__c.show) {
        canvasElement.PropertySet__c.show = {
            group: {
                operator: 'AND',
                rules: []
            }
        };
    }
    if (propSet.hasOwnProperty('showPersistentComponent')) {
        propSet.showPersistentComponent = CanvasElement.convertShowPersistentComponentToMap(canvasElement, propSet);
    }
    allElementsById[json.Id] = canvasElement;
    canvasElement.originalJson = json;
    return canvasElement;
};

CanvasElement.convertShowPersistentComponentToMap = function(canvasElement, propSet) {
    // convert from array of true/false into map of persistentComponentId to bool
    var scriptElement = canvasElement.scriptElement();
    if (!scriptElement) {
        return [];
    }
    var newShowPersistentComponent = {};
    if (angular.isArray(scriptElement.PropertySet__c.persistentComponent)) {
        if (!angular.isArray(propSet.showPersistentComponent)) {
            propSet.showPersistentComponent = [propSet.showPersistentComponent];
        }
        scriptElement.PropertySet__c.persistentComponent.forEach(function(persistentComponent, index) {
            newShowPersistentComponent[persistentComponent.id] = propSet.showPersistentComponent.length > index ? propSet.showPersistentComponent[index] || false : false;
        });
    }
    return newShowPersistentComponent;
};

CanvasElement.prototype.allowsChild = function(childPaletteElement) {
    var childLabel = childPaletteElement.label,
        isAllowedAsChild = false;
    switch (this.type()) {
        case 'OmniScript':
            isAllowedAsChild = /^(OmniScript|Step)$/.test(childLabel);
            break;
        case 'Step':
            isAllowedAsChild = !childPaletteElement.isNavigation();
            break;
        case 'Block':
            isAllowedAsChild = !childPaletteElement.isNavigation() && !childPaletteElement.isGroupedControl();
            break;
        default:
            break;
    }
    return isAllowedAsChild;
};

CanvasElement.prototype.allowedTypes = function() {
    return this.Type__c.allowedTypes();
};

CanvasElement.prototype.allowsChildren = function() {
    return this.allowedTypes().length > 0;
};

CanvasElement.prototype.isBlock = function() {
    return /^Block$/.test(this.type());
};

CanvasElement.prototype.isStep = function() {
    return /^Step/.test(this.type());
};

CanvasElement.prototype.isAction = function() {
    return /Action$/.test(this.type());
};

CanvasElement.prototype.isInput = function() {
    return this.Type__c.isInput();
};

CanvasElement.prototype.parent = function() {
    if (this.ParentElementId__c) {
        return CanvasElement.getById(this.ParentElementId__c);
    } else if (this.OmniScriptId__c) {
        return ScriptElement.getById(this.OmniScriptId__c);
    }
};

CanvasElement.prototype.scriptElement = function() {
    if (this.OmniScriptId__c) {
        return ScriptElement.getById(this.OmniScriptId__c);
    }
};

CanvasElement.prototype.delete = function() {
    this.deleted = true;
    var parent = this.parent();
    if (parent) {
        var existingIndex = parent.children.indexOf(this);
        parent.children.splice(existingIndex, 1);
        if (this.ParentElementId__c) {
            this.ParentElementId__c = null;
        } else if (this.OmniScriptId__c) {
            this.OmniScriptId__c = null;
        }
    }
};

CanvasElement.prototype.clone = function() {
    var newElement = new CanvasElement(this.Type__c);
    for (var i = 0; i < this.children.length; i++) {
        var childClone = this.children[i].clone();
        newElement.children.push(childClone);
    }
    for (var property in this) {
        if (this.hasOwnProperty(property) &&
             !angular.isObject(this[property]) &&
             !angular.isFunction(this[property]) &&
             !/^(\$\$hashKey|Id|Name)$/gi.test(property)) {
            newElement[property] = this[property];
        } else if (/^PropertySet__c$/.test(property)) {
            newElement[property] = angular.copy(this[property]);
        }
    }
    return newElement;
};

CanvasElement.prototype.setId = function(id) {
    this.Id = id;
    for (var i = 0; i < this.children.length; i++) {
        this.children[i].ParentElementId__c = id;
    }
    allElementsById[id] = this;
};

CanvasElement.prototype.asJson = function() {
    var json = {
        Name: this.Name,
        Id: this.Id
    };
    for (var property in this) {
        if (this.hasOwnProperty(property)) {
            if (nameSpacePropsRegex.test(property) && (this[property] != null ||
                    // if null and the property didn't exist in originalJson
                    (this.originalJson && this[property] == null && this.originalJson[ns + property] != null))) {
                json[ns + property] = this[property];
            }
        }
    }
    var propSet = angular.copy(this.PropertySet__c);
    if (propSet.show) {
        propSet.show = resetExpressionIfEmpty(propSet.show);
    }
    if (propSet.validateExpression) {
        propSet.validateExpression = resetExpressionIfEmpty(propSet.validateExpression);
    }
    // OMNI-271 - only set label to name if this is the first time the Element
    //            is being saved
    if (this.Type__c.type !== 'OmniScript') {
        if (!propSet.label && !this.Id) {
            propSet.label = this.PropertySet__c.label = this.Name;
        } else if (propSet.label === '') {
            propSet.label = null;
        }
    }
    if (propSet.hasOwnProperty('showPersistentComponent')) {
        // turn this into an array based on order of persistentComponents in ScriptElement
        var scriptElement = this.scriptElement();
        if (scriptElement) {
            var arrayOfShowPersistentComponent = [];
            if (scriptElement.PropertySet__c.persistentComponent) {
                scriptElement.PropertySet__c.persistentComponent.forEach(function(persistentComponent, index) {
                    arrayOfShowPersistentComponent[index] = propSet.showPersistentComponent[persistentComponent.id];
                });
            }
            propSet.showPersistentComponent = arrayOfShowPersistentComponent;
        }
    }
    if (this.originalJson && this.originalJson[ns + 'PropertySet__c']) {
        propSet = cleanUnnecessaryEmptyPropsOnPropertySet(propSet,
                                                            JSON.parse(this.originalJson[ns + 'PropertySet__c']),
                                                            requiredProperties[this.type()]);
    }
    json[ns + 'PropertySet__c'] = JSON.stringify(propSet);
    if (this.Type__c.type === 'OmniScript') {
        json[ns + 'Type__c'] = 'OmniScript';
    } else {
        json[ns + 'Type__c'] = json[ns + 'Type__c'].label;
    }
    return json;
};

function cleanUnnecessaryEmptyPropsOnPropertySet(propSet, originalPropSet, skipProperties) {
    Object.keys(propSet).forEach(function(key) {
        if (skipProperties && skipProperties.indexOf(key) !== -1) {
            return;
        }
        if (propSet[key] === '' || propSet[key] == null) {
            if (originalPropSet[key] === undefined) {
                delete propSet[key];
            }
        }
    });
    return propSet;
}

function resetExpressionIfEmpty(object) {
    if (object && object.group.rules.length === 0) {
        return null;
    }
    return object;
}

CanvasElement.prototype.setSaving = function() {
    if (this.OmniScriptId__c) {
        this.errors = null;
        this.saving = true;
    }
};

CanvasElement.prototype.setOmniScriptId = function(omniScriptId) {
    this.OmniScriptId__c = omniScriptId;
    for (var i = 0; i < this.children.length; i++) {
        this.children[i].setOmniScriptId(omniScriptId);
    }
};

CanvasElement.prototype.toString = function() {
    return 'Element: ' + this.Name;
};

CanvasElement.prototype.setErrors = function(errors) {
    this.errors = errors;
};

CanvasElement.prototype.hasErrors = function(errors) {
    return this.errors && this.errors.length > 0;
};

CanvasElement.prototype.each = function(expFunction) {
    expFunction(this);
    for (var i = 0; i < this.children.length; i++) {
        this.children[i].each(expFunction);
    }
};

var allElementsById = {};

CanvasElement.getById = function(id) {
    return allElementsById[id];
};

module.exports = CanvasElement;

},{"../util/HtmlEncodeDecode.js":50,"../util/PaletteElement.js":51,"../util/ScriptElement.js":53,"../util/generateId.js":54,"../util/requiredProperties.js":56}],49:[function(require,module,exports){
var Property = require('../util/Property.js');
var idFunction = require('../util/generateId.js');

function GroupedProperty(property, title, layoutrows, canvasElement, count, originalProp, originalLayout) {
  this.group = true;
  this.prop = property;
  this.title = title;
  this.count = count;
  this.layoutrows = layoutrows || [];
  this.$canvasElement = canvasElement;
  this.showIfRules = [];
  this.originalProp = originalProp;
  this.originalLayout = originalLayout;
  if (this.originalProp && this.originalProp.defaultValue.length > 0) {
    this.tabs = [];
    for (var i = 0; i < this.count; i++) {
      this.tabs.push({
        title: i+1
      });
    }
    if (!canvasElement.scriptElement().IsActive__c) {
      this.tabs.push({title: '+'});
    }
    this.activeTab = 0;
  }
  this.initializeCurrentValue();
}

GroupedProperty.prototype.initializeCurrentValue = function() {
 this.layoutrows.forEach(function(row) {
    row.forEach(function(prop) {
      if (prop) {
        if (angular.isArray(prop)) {
          prop.forEach(function(prop){
            prop.initializeCurrentValue();
            if (/\.?id$/.test(prop.label)) {
              idFunction.registerExistingPrefix(prop.currentValue);
            }
          });
        } else {
          prop.initializeCurrentValue();
          if (/\.?id$/.test(prop.label)) {
            idFunction.registerExistingPrefix(prop.currentValue);
          }
        }
      }
    });
 });
};

GroupedProperty.prototype.update = function() {
 this.layoutrows.forEach(function(row) {
    row.forEach(function(prop) {
      if (prop) {
        if (angular.isArray(prop)) {
          prop.forEach(function(prop){
            prop.update();
          });
        } else {
          prop.update();
        }
      }
    });
 });
};


GroupedProperty.prototype.addShowIfRule = function(showIfRuleText) {
  this.showIfRules.push(showIfRuleText);
};

GroupedProperty.prototype.shouldShow = function() {
  return this.showIfRules.every(function(ruleAsText){
    /*jshint -W085 */
    with(this.$canvasElement.PropertySet__c) {
      /* jshint evil: true */
      return eval(ruleAsText);
    }
  }, this);
};

GroupedProperty.prototype.deleteTab = function(index) {
  this.activeTab = index - 1 < 0 ?  0 : index-1;
  this.tabs.splice(index, 1);
  var oldProp = this.$canvasElement.PropertySet__c[this.prop].splice(index, 1);
  this.layoutrows.splice(index, 1);
  // if this is persistentComponent we also need to delay the matching property on every child element
  if (this.prop === 'persistentComponent') {
    this.$canvasElement.each(function(element){
      if (element.PropertySet__c.showPersistentComponent) {
        delete element.PropertySet__c.showPersistentComponent[oldProp.id];
      }
    });
  }
  // also need to update index of all existing properties :/
  var me = this;
  this.layoutrows = this.layoutrows.map(function(layoutrows, index) {
    return layoutrows.map(function(row) {
      if (!angular.isArray(row)) {
        row = [row];
      }
      return row.map(function(layoutRow){
        layoutRow.label = layoutRow.label.replace(/\.\d+\./, "." + index + ".");
        if (layoutRow.cachedArray) {
          layoutRow.cachedArray.forEach(function(prop) {
            prop.label = prop.label.replace(/\.\d+\./, "." + index + ".");
          });
        }
        return layoutRow;
      });
    });
  });
};

function newPersistentProperty(obj) {
  obj = angular.copy(obj);
  Object.keys(obj).forEach(function(key){
    if (angular.isString(obj[key])) {
      obj[key] = '';
      if (key === 'id') {
        obj[key] = idFunction('New');
      }
    } else if (/modalConfigurationSetting|remoteOptions/.test(key)) {
      Object.keys(obj[key]).forEach(function(childKey) {
        if (!/modalSize/.test(childKey)) {
          obj[key][childKey] = '';
        }
      });
    }
  });
  return obj;
}

GroupedProperty.prototype.handleTabClick = function(index) {
  this.activeTab = index;
  if (this.activeTab === this.tabs.length - 1 && !this.$canvasElement.scriptElement().IsActive__c) {
    var outerProp = this;
    this.tabs.splice(this.tabs.length - 1, 0, {
      title: this.tabs.length
    });
    this.activeTab = index;
    if (index < this.originalProp.defaultValue.length || index === 0) {
      this.$canvasElement.PropertySet__c[this.prop].push(newPersistentProperty(this.originalProp.defaultValue[index]));
    } else {
      this.$canvasElement.PropertySet__c[this.prop].push(newPersistentProperty(this.$canvasElement.PropertySet__c[this.prop][0],{}));
    }
    if (this.prop === 'persistentComponent') {
      this.$canvasElement.each(function(element){
        if (element.PropertySet__c.showPersistentComponent) {
          element.PropertySet__c.showPersistentComponent.New = false;
        }
      });
    }
    var me = this;
    this.layoutrows.push(this.originalLayout.map(function(row){
      if (!angular.isArray(row)) {
        row = [row];
      }
      return row.map(function(layoutRow){
        return new Property(
            me.prop + "." + index + "." + layoutRow,
            me.originalProp.defaultValue[0][layoutRow],
            me.$canvasElement,
            true
          );
      });
    }));
  }
};

GroupedProperty.prototype.isForDataRaptor = function() {
  return false;
};

module.exports = GroupedProperty;
},{"../util/Property.js":52,"../util/generateId.js":54}],50:[function(require,module,exports){
var escape = document.createElement('textarea');
function escapeHTML(html) {
    escape.innerHTML = html;
    return escape.innerHTML;
}

function unescapeHTML(html) {
    escape.innerHTML = html;
    return escape.value;
}

exports.escapeHTML = escapeHTML;
exports.unescapeHTML = unescapeHTML;

},{}],51:[function(require,module,exports){
var ScriptElement = require('../util/ScriptElement.js');

/*
 * Represents an Element in the palatte
 * of drag/droppable canvas elements
 */
function PaletteElement(label, type, scriptElement)  {
    'use strict';
    this.label = label;
    this.type = type;
    this.scriptElement = scriptElement;
}

PaletteElement.prototype.prettyName = function (isDropped) {
    'use strict';
    if (/Rest/i.test(this.label)) {
        if (/^rest action$/i.test(this.label))
            return this.label.replace(/\brest\b/i, 'HTTP');
        else 
            return this.label.replace(/\brest\b/i, 'REST');
    } else if (/^Validation$/.test(this.label)) {
        return 'Messaging';
    } else if (isDropped && /^Type Ahead Block$/.test(this.label)) {
        return this.label.substring(0, this.label.lastIndexOf('Block')-1);
    //OMNI-2769
    } else if (/^Date\/Time \(Local\)$/.test(this.label)) {
        return "Date\/Time";
    } else {
        return this.label;
    }
};

PaletteElement.prototype.isNavigation = function() {
    'use strict';
    return this.type == 'navigation';
};

PaletteElement.prototype.isScript = function() {
    'use strict';
    return this.type == 'OmniScript';
};

PaletteElement.prototype.isGroupedControl = function() {
    'use strict';
    return this.type == 'groupedControl';
};

PaletteElement.prototype.isInput = function() {
    'use strict';
    return (this.type == 'input' || this.type == 'typeahead-excluded-input' || this.type == 'editblock-excluded-input');
};

PaletteElement.prototype.isAction = function() {
    'use strict';
    return (this.type == 'action' || this.type == 'typeahead-action' || this.type == 'common-action' || this.type == 'editblock-action');
};

PaletteElement.prototype.toString = function() {
    'use strict';
    return 'Palette: ' + this.label;
};

PaletteElement.prototype.allowedTypes = function() {
    'use strict';
    if (this.label === 'OmniScript' || /^Input Block$/i.test(this.label)) {
        return [];
    }
    if (this.label === 'Step') {
        return ['action', 'typeahead-action', 'common-action', 'editblock-action', 'input', 'typeahead-excluded-input', 'editblock-excluded-input', 'groupedControl', 'selectable-items', 'inputblock', 'filterblock', 'docuSign-signature-action', 'typeahead-block','edit-block'];
    } else if (this.isNavigation()) {
        return ['action', 'typeahead-action', 'common-action', 'editblock-action', 'input', 'typeahead-excluded-input', 'editblock-excluded-input', 'groupedControl', 'filterblock','edit-block'];
    }  else if (this.isGroupedControl()) {
        return ['action', 'typeahead-action', 'common-action', 'editblock-action', 'input', 'typeahead-excluded-input', 'editblock-excluded-input', 'selectable-items', 'groupedControl', 'docuSign-signature-action'];
    } else if (this.type == 'filterblock') {
        return ['filter'];
    } else if (this.type == 'typeahead-block') {
        return ['typeahead-action', 'common-action', 'input'];
    } else if(this.type == 'edit-block') {
        return ['editblock-action', 'common-action', 'input', 'typeahead-excluded-input', 'groupedControl'];
    } else {
        return [];
    }
};

PaletteElement.factory = function(label) {
    'use strict';
    var paletteElement = null;
    if (angular.isString(label)) {
        if (/^(Step|OmniScript)$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'navigation');
        } else if (/^OmniForm$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'action');
        } else if (/^Block$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'groupedControl');
        } else if (/^DocuSign Signature Action/i.test(label)) {
            paletteElement = new PaletteElement(label, 'docuSign-signature-action');
        } else if (/(Action$|^Set)/i.test(label)) {
            if (/^DataRaptor Extract Action$/i.test(label) || /^Calculation Action$/i.test(label)) {
                paletteElement = new PaletteElement(label, 'typeahead-action');
            } else if(/^Integration Procedure Action$/i.test(label) || /^Matrix Action$/i.test(label)) {
                paletteElement = new PaletteElement(label, 'editblock-action');
            } else if(/^Remote Action$/i.test(label) || /^Rest Action$/i.test(label) ) {
                paletteElement = new PaletteElement(label, 'common-action');
            } else {
                paletteElement = new PaletteElement(label, 'action');
            }
        } else if (/^Filter Block$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'filterblock');
        } else if (/^Filter$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'filter');
        } else if (/^Input Block$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'inputblock');
        } else if (/^Selectable Items/i.test(label)) {
            paletteElement = new PaletteElement(label, 'selectable-items');
        }  else if (/^Type Ahead Block$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'typeahead-block');
        } else if (/^Edit Block$/i.test(label)) {
            paletteElement = new PaletteElement(label, 'edit-block');
        } else {
            if(editBlockExcludedElements[label]) {
                paletteElement = new PaletteElement(label, 'editblock-excluded-input');
            } else if (!typeaheadExcludedElements[label]) {
                paletteElement = new PaletteElement(label, 'input');
            } else {
                paletteElement = new PaletteElement(label, 'typeahead-excluded-input');
            }
        }
        allElements[label] = paletteElement;
    } else if (angular.isObject(label)) {
        var scriptElement = label;
        paletteElement = new PaletteElement(scriptElement.Name, 'OmniScript', scriptElement);
        var typeMap = allElements.scripts[scriptElement.Type__c];
        if (!typeMap) {
            typeMap = allElements.scripts[scriptElement.Type__c] = {};
        }
        if (!typeMap[scriptElement.SubType__c]) {
            typeMap[scriptElement.SubType__c] = {};
        }
        typeMap[scriptElement.SubType__c][scriptElement.Language__c] = paletteElement;
    }
    return paletteElement;
};

PaletteElement.getPaletteElement = function(label, configuration) {
    'use strict';
    if (!configuration.hasOwnProperty('Type') &&
        !configuration.hasOwnProperty('Sub Type') &&
        !configuration.hasOwnProperty('Language')) {
        if (allElements[label]) {
            return allElements[label];
        } else {
            return new PaletteElement(label, configuration);
        }
    } else {
        // need to look up for a re-usable script with the matching
        // Type__c, SubType__c and Language__c
        try {
            return allElements.scripts[configuration.Type][configuration['Sub Type']][configuration.Language];
        } catch (e) {
            return new PaletteElement(label, configuration);
        }
    }
};

var allElements = {
    'scripts': {}
};

var typeaheadExcludedElements = {
    'Disclosure':'Disclosure',
    'File':'File',
    'Filter':'Filter',
    'Image':'Image',
    'Lookup':'Lookup',
    'Password':'Password',
    'Signature':'Signature',
    'Headline':'Headline',
    'Text Block':'Text Block',
    'Geolocation':'Geolocation',
    'Validation':'Validation'
};

var editBlockExcludedElements = {
    'Submit':'Submit',
    'Geolocation':'Geolocation'
}

module.exports = PaletteElement;

},{"../util/ScriptElement.js":53}],52:[function(require,module,exports){
var idFunction = require('../util/generateId.js');
var CanvasElement = require('../util/CanvasElement.js');
var ScriptElement = require('../util/ScriptElement.js');
var inherit = require('../util/inherit.js');

/*
 * Used to work around prompt bug - https://bugs.webkit.org/show_bug.cgi?id=74961
 * No easy way to feature detect unfortunately
 */
var isSafari = function() {
    return /^((?!chrome).)*safari/i.test(navigator.userAgent) && (navigator.userAgent.indexOf('Mac') > 1);
}

/*
 * Represents a Property in the property set of an object
 */
function Property(key, defaultValue, canvasElement, isDefault, parentProperty) {
    'use strict';
    this.$previousValues = [];
    this.$parentProperty = parentProperty;
    this.label = key;
    this.defaultValue = key === 'options' ? [{'name':'', 'value':''}] : defaultValue;
    if (key === 'showPersistentComponent' && canvasElement) {
        // special case to adapt this to a map :(
        var scriptElement = canvasElement.parent();
        while (!(scriptElement instanceof ScriptElement)) {
            scriptElement = scriptElement.parent();
        }
        var newShowPersistentComponent = {};
        if (angular.isArray(scriptElement.PropertySet__c.persistentComponent)) {
            if (!canvasElement.PropertySet__c.showPersistentComponent) {
                canvasElement.PropertySet__c.showPersistentComponent =
                  new Array(scriptElement.PropertySet__c.persistentComponent.length);
            }
            scriptElement.PropertySet__c.persistentComponent.forEach(function(persistentComponent, index) {
                newShowPersistentComponent[persistentComponent.id] =
             defaultValue.length > index ? canvasElement.PropertySet__c.showPersistentComponent[index] || false : false;
            });
            Object.keys(canvasElement.PropertySet__c.showPersistentComponent).forEach(function(key) {
                if (!newShowPersistentComponent.hasOwnProperty(key)) {
                    delete canvasElement.PropertySet__c.showPersistentComponent[key];
                }
            });
            this.defaultValue = newShowPersistentComponent;
        }
    }
    this.type = this.getType(key, this.defaultValue, canvasElement ? canvasElement.type() : '');
    this.isDefault = isDefault;
    this.id = idFunction();
    this.showIfRules = [];
    this.$canvasElement = canvasElement;
    if (!this.defaultValue) {
        if (/^minLength$/.test(this.label)) {
            this.defaultValue = 0;
        } else if (/^maxLength$/.test(this.label)) {
            this.defaultValue = 255;
        }
    }
    this.initializeCurrentValue();
}

Property.prototype.initializeCurrentValue = function() {
    'use strict';
    if (this.type === 'validation') {
        this.defaultValue = {
            group: {
                operator: 'AND',
                rules: []
            }
        };
    }
    if (this.$canvasElement) {
        var resolvedObject = this.getResolvedObject();
        if (this.type === 'key-value') {
            // if we're key-value pairs then currentValue is an array
            this.currentValue = [];
            var me = this;
            if (!resolvedObject) {
                resolvedObject = this.$canvasElement.PropertySet__c[this.label] = angular.copy(this.defaultValue);
            }
            if (resolvedObject) {
                var defaultValue = this.defaultValue;
                var defaultKeys = Object.keys(defaultValue);
                var parentProperty = this;
                Object.keys(resolvedObject).forEach(function(key) {
                    me.currentValue.push(new KeyValueWrapper(function() {
                        return me.getResolvedObject();
                    }, key, me.currentValue, defaultValue[key], parentProperty,
                  defaultValue.hasOwnProperty(key) && !(parentProperty instanceof KeyValueWrapper)));
                    defaultKeys = defaultKeys.filter(function(defKey) {
                        return defKey !== key;
                    });
                });
                // if an option has default value we should explicitily add them
                // again if they'be been removed.
                defaultKeys.forEach(function(key) {
                    me.currentValue.push(new KeyValueWrapper(function() {
                        return me.getResolvedObject();
                    }, key, me.currentValue, defaultValue[key], me, true));
                });
                // put defaults first
                me.currentValue.sort(function(a, b) {
                    return a.isDefault ? -1 : (b.isDefault ? 1 : (a.label > b.label ? 1 : -1));
                });
            }
        } else if (angular.isUndefined(resolvedObject) ||
                  /* jshint eqnull: true */
                  (this.type === 'validation' && resolvedObject == null)) {
            this.currentValue = angular.copy(this.defaultValue);
        } else {
            this.currentValue = resolvedObject;
            // handle special case for where default is object, by currentValue is array
            if (angular.isArray(this.currentValue) && !angular.isArray(this.defaultValue)) {
                this.currentValue = angular.copy(this.defaultValue);
            }
            // if we're 'showPersistentComponent' add the missing elements
            if (this.label === 'showPersistentComponent' && this.defaultValue.length > this.currentValue.length) {
                this.currentValue = resolvedObject.concat(this.defaultValue.slice(this.currentValue.length));
            }
        }
        this.update();
    }
};

Property.prototype.addShowIfRule = function(showIfRuleText) {
    'use strict';
    this.showIfRules.push(showIfRuleText);
};

Property.prototype.shouldShow = function() {
    return this.showIfRules.every(function(ruleAsText) {
        /*jshint -W085 */
        with(this.$canvasElement.PropertySet__c) {
            /* jshint evil: true */
            return eval(ruleAsText);
        }
    }, this);
};

Property.prototype.adaptValueToBeSet = function(value, currentPath, object) {
    'use strict';
    if (this.type === 'key-value') {
        value.forEach(function(keyValuePair) {
            keyValuePair.update();
        });
    } else {
        object[currentPath] = value;
    }
};

Property.prototype.isOnPropertySet = function() {
    'use strict';
    return !(this.label === 'Name' || /__c$/.test(this.label));
};

Property.prototype.getResolvedObject = function() {
    'use strict';
    if (!this.isOnPropertySet()) {
        return this.$canvasElement[this.label];
    }
    var thisProp = this,
         object = this.$canvasElement.PropertySet__c;
    this.label.split('.').forEach(function(currentPath, index, array) {
        if (index === array.length - 1) {
            object = object[currentPath];
        } else {
            var parentObj = object;
            object = parentObj[currentPath];
            if (!object) {
                object = parentObj[currentPath] = {};
            }
        }
    });
    // Remove prop ''.
    if (object && object.hasOwnProperty('')){
        delete object[''];
    }
    return object;
};

function createNewDataRaptor(property, originalValue) {
    var type;
    var newName = prompt('Please enter a new name for the DataRaptor interface', '');
    if (newName === '' && !isSafari()) {
        alert('Please enter a Name');
        createNewDataRaptor(property, originalValue);
    } else if (!/^[a-zA-Z0-9\s-_]+$/.test(newName) && newName && newName.length > 0) {
        alert('This interface name can only contain letters, numbers and spaces. Please choose a different name.');
        createNewDataRaptor(property, originalValue);
        return;
    } else if (newName !== null && !(newName === '' && isSafari())) {
        if (/transformBundle/i.test(property.label) || /DataRaptor Transform Action/.test(property.$canvasElement.type())) {
            type = 'Transform';
        } else if (/DataRaptor Extract Action/.test(property.$canvasElement.type())) {
            type = 'Extract (JSON)';
        } else if (/DataRaptor Post Action/.test(property.$canvasElement.type())) {
            type = 'Load (JSON)';
        }
        var scriptElement = property.$canvasElement;
        while (!(scriptElement instanceof ScriptElement)) {
            scriptElement = scriptElement.parent();
        }
        property.loading = true;
        angular.element($('[ng-app="omniscriptDesigner"]')[0]).injector().invoke(function($rootScope, remoteActions, $dataraptor, save) {
            // ensure drbundle doesn't exist
            var found = false;
            $rootScope.drBundles.forEach(function(bundle) {
                found = (found || bundle.Name == newName);
                if (found) {
                    return false;
                }
            });
            if (found) {
                alert('This name is already in use. Please enter a different name');
                createNewDataRaptor(property, originalValue);
                return;
            }

            remoteActions.viewFullDataJson(scriptElement.Id)
              .then(function(omniScriptResult) {
                  return omniScriptResult.replace(/&quot;/g, '"');
              }).then(function(json) {
                return $dataraptor.createNewBundle({
                    'Name': newName,
                    'DRMapName__c': newName,
                    'Type__c': type,
                    'InterfaceObject__c': 'json',
                    'InputJson__c': type !== 'Extract (JSON)' && property.label !== 'xmlPostTransformBundle' ? json : '',
                    'InputType__c': property.label === 'xmlPostTransformBundle' ? 'XML' : 'JSON',
                    'OutputType__c': property.$canvasElement.Type__c.label === 'PDF Action' ? 'PDF' : (property.label === 'xmlPreTransformBundle' ? 'XML' : 'JSON')
                });
            }).then(function(bundle) {
                $rootScope.drBundles.push({
                    Id: bundle.id,
                    Name: newName,
                    Type__c: type
                });
                property.currentValue = newName;
                property.update();
                return save(property.$canvasElement)
                  .then(function(canvasElement) {
                      return bundle;
                  });
            }).then(function(value) {
                property.loading = false;
                window.open('/apex/' + window.ns + 'DRMapper' + (value.id ? '?bundleId=' + value.id : ''));
            });
        });
    } else {
        property.currentValue = originalValue;
        property.update();
    }
}

Property.prototype.getValueAsString = function() {
    return JSON.stringify(_.get(this.$canvasElement.PropertySet__c, this.label), null, 4);
}

Property.prototype.update = function() {
    'use strict';
    this.$previousValues.push(this.currentValue);
    if (this.isForDataRaptor() && this.currentValue === '+ Create New DataRaptor') {
        createNewDataRaptor(this,
            (this.$previousValues.length > 0 ? this.$previousValues[this.$previousValues.length - 2] : this.defaultValue));
    } else {
        if (this.type === 'number') {
            if (this.currentValue !== undefined) {
                this.currentValue = (this.currentValue === null || this.currentValue === '') ?
                                null : Number(this.currentValue);
            } else {
                // OMNI-521 - if this.currentValue === undefined then someone could be
                //            typing in '-10' so ignore setting it for now
                return;
            }
        }
        if (!this.isOnPropertySet()) {
            this.adaptValueToBeSet(this.currentValue, this.label, this.$canvasElement);
        } else {
            var currentValue = this.currentValue,
                thisProp = this,
                object = this.$canvasElement.PropertySet__c;
            this.label.split('.').forEach(function(currentPath, index, array) {
                if (index === array.length - 1) {
                    thisProp.adaptValueToBeSet(currentValue, currentPath, object);
                } else {
                    object = object[currentPath];
                    if (!object) {
                        object = object[currentPath] = {};
                    }
                }
            });
        }
    }
};

Property.prototype.addNewKeyValueWrapper = function() {
    'use strict';
    var me = this;
    this.currentValue.push(
      new KeyValueWrapper(function() {
          return me.getResolvedObject();
      }, '', this.currentValue, '', this, false)
  );
};

Property.prototype.isForDataRaptor = function() {
    'use strict';
    return (this.$canvasElement instanceof ScriptElement && /DataRaptorBundleId__c/.test(this.label)) ||
            /(pre|post|xmlPre|xmlPost)TransformBundle$/.test(this.label) || /transformBundle$/.test(this.label) ||
            (this.$canvasElement && /^DataRaptor (Extract|Post|Transform) Action$/.test(this.$canvasElement.type()) &&
                /^bundle$/.test(this.label));
};

Property.prototype.hasLink = function() {
    'use strict';
    return this.isForDataRaptor() || 
        (this.$canvasElement && this.$canvasElement.type() === 'PDF Action' && /templateName/.test(this.label))||
        (this.$canvasElement&&this.$canvasElement.Type__c&&this.$canvasElement.Type__c.type=='OmniScript'&&this.label=="Sub Type");
};

Property.prototype.getType = function(propertyName, value, label) {
    'use strict';
    var isChildOfKeyValue = (this.$parentProperty && this.$parentProperty.type === 'key-value');
    if (!isChildOfKeyValue && /^show$/.test(propertyName)) {
        return 'show';
    }
    else if (label === 'Procedure Configuration' && propertyName == 'AdditionalInformation__c') {
        return 'textarea';
    }
    else if ( /^inputWidth$/i.test(propertyName) ) {
        return 'slider';
    } else if (!isChildOfKeyValue && /width$/i.test(propertyName) &&
               !/^showInputWidth$/.test(propertyName) &&
               !/^displayWidth$/.test(propertyName) &&
               !/^optionWidth$/.test(propertyName)) {
        return 'slider';
    } else if (!isChildOfKeyValue && (/length$/i.test(propertyName) ||
                                        /^(min|max|saveExpireInDays)$/i.test(propertyName))) {
        return 'number';
    } else if ((!isChildOfKeyValue && /Options$/.test(propertyName) &&
                                        !/^(restOptions|knowledgeOptions)$/.test(propertyName) ||
                                                /^element(Error|Value)Map$/.test(propertyName)) ||
                                                (angular.isObject(value) && !angular.isArray(value) &&
                                                    this.isKeyValue())) {
        return 'key-value';
    } else if (!isChildOfKeyValue && /^validateExpression$/.test(propertyName)) {
        return 'validation';
    } else if (!isChildOfKeyValue && /^expression$/.test(propertyName)) {
        return 'expression';
    } else if (value === 'spinner') {
        return 'spinner';
    } else if (!isChildOfKeyValue && propertyName == 'docuSignTemplatesGroup') {
        return 'docuSignTemplatesGroup';
    } else if (!isChildOfKeyValue && propertyName == 'docuSignTemplatesGroupSig') {
        return 'docuSignTemplatesGroupSig';
    } else if (!isChildOfKeyValue && propertyName == 'valueSvgMap') {
        return 'valueSvgMap';
    } else if (!isChildOfKeyValue && propertyName == 'advancedMergeMap') {
        return 'advancedMergeMap';
    } else if (!isChildOfKeyValue && propertyName == 'columnsPropertyMap') {
        return 'columnsPropertyMap';
    } else if (!isChildOfKeyValue && propertyName == 'relationshipFieldsMap') {
        return 'relationshipFieldsMap';
    } else if (!isChildOfKeyValue && propertyName == 'linkToExternalObject') {
        return 'linkToExternalObject';
    } else if (!isChildOfKeyValue && propertyName == 'sobjectMapping') {
        return 'sobjectMapping';
    } else if (!isChildOfKeyValue && propertyName == 'selectSobject') {
        return 'selectSobject';
    } else if (!isChildOfKeyValue && propertyName == 'dateType') {
           return 'dateType';
    } else if (!isChildOfKeyValue && propertyName == 'signerInformation.templateRole') {
        return 'signerInformation.templateRole';
    } else if (!isChildOfKeyValue && propertyName == 'docuSignTemplate') {
        return 'docuSignTemplate';
    } else if (!isChildOfKeyValue && propertyName == 'emailBody') {
        return 'emailBody';
    } else if (!isChildOfKeyValue && propertyName == 'docuSignReturnUrl') {
        return 'docuSignReturnUrl';
    } else if (!isChildOfKeyValue && propertyName == 'InternalNotes__c') {
        return 'InternalNotes__c';
    } else if (!isChildOfKeyValue && propertyName == 'googleAddressCountry') {
        return 'googleAddressCountry';
    } else if (!isChildOfKeyValue && propertyName == 'googleTransformation') {
        return 'googleTransformation';
    } else if (!isChildOfKeyValue && propertyName == 'emailTemplateInformation') {
        return 'emailTemplateInformation';
    } else if (!isChildOfKeyValue && propertyName == 'emailInformation') {
        return 'emailInformation';
    } else if (!isChildOfKeyValue && propertyName == 'useTemplate') {
        return 'useTemplate';
    } else if (!isChildOfKeyValue && propertyName == 'staticDocList') {
        return 'staticDocList';
    } else if (
        !isChildOfKeyValue && ((/^Text$/.test(label) && /^text$/.test(propertyName)) ||
        (/^Headline/.test(label) && /^label/.test(propertyName)) ||
        (/^Text Block/.test(label) && /^text$/.test(propertyName)) ||
        (/^instruction$/.test(propertyName)))
      ) {
        return 'rte';
    } else if (angular.isString(value)) {
        return 'text';
    } else if (angular.isNumber(value)) {
        return 'number';
    } else if (angular.isDate(value)) {
        return 'date';
    } else if (typeof value === 'boolean' && propertyName != 'horizontalMode') {
        return 'checkbox';
    } else if (angular.isArray(value)) {
        if (!isChildOfKeyValue && /messages/.test(propertyName)) {
            return 'validationMessages';
        }
        return 'array';
    } else if (angular.isObject(value)) {
        if (angular.equals(value, {})) {
            return 'key-value';
        }
        return 'object';
    } else {
        return 'text';
    }
};

Property.prototype.isKeyValue = function() {
    'use strict';
    return this.$parentProperty && this.$parentProperty.isKeyValue();
};

Property.prototype.arrayAsProperties = function() {
    'use strict';
    var parent = this;
    if (!this.cachedArray || this.cachedArray.length !== this.currentValue.length) {
        this.cachedArray = this.currentValue.map(function(value, index) {
            return new Property(parent.label + '.' + index, value, parent.$canvasElement, false, parent);
        });
    }
    return this.cachedArray;
};

Property.prototype.objectAsProperties = function(parentProperty) {
    'use strict';
    var parent = this;
    if (!this.cachedArray || this.cachedArray.length !== Object.keys(this.currentValue).length) {
        this.cachedArray = Object.keys(this.currentValue).map(function(key) {
            return new Property(parent.label + '.' + key, parent.currentValue[key], parent.$canvasElement, true, parent);
        });
    }
    return this.cachedArray;
};

function KeyValueWrapper(originalObjectResolutionFn, prop, parentArray, defaultValue, parentProperty, isDefault) {
    'use strict';
    // key, defaultValue, canvasElement, isDefault
    this.originalKey = prop;
    this.key = prop;
    this.originalObjectResolutionFn = originalObjectResolutionFn;
    try {
        this.currentValue = originalObjectResolutionFn()[prop];
    } catch (e) {
        // handle case where object could be null
        this.currentValue = null;
    }
    Property.call(this, prop, defaultValue || this.currentValue,
                        parentProperty.$canvasElement, isDefault, parentProperty);
    this.$parentArray = parentArray;
    try {
        if (this.type !== 'key-value') {
            this.currentValue = this.originalObjectResolutionFn()[this.key];
        }
    } catch (e) {}
}

KeyValueWrapper.prototype = inherit(Property.prototype);

KeyValueWrapper.prototype.update = function(skipCheck) {
    'use strict';
    if (this.originalKey !== this.key) {
        // also check the key isn't used by another property in the parent
        var updateConflictingProperty = false;
        if (this.$parentArray && !skipCheck) {
            var me = this;
            this.$parentArray.forEach(function(property) {
                if (property !== me &&
                    me.originalKey === property.key) {
                    updateConflictingProperty = property;
                }
            });
        }
        this.originalObjectResolutionFn()[this.key] = angular.copy(this.originalObjectResolutionFn()[this.originalKey]);
        delete this.originalObjectResolutionFn()[this.originalKey];
        if (updateConflictingProperty) {
            updateConflictingProperty.update(true);
        }
    }
    try {
        if (this.type === 'key-value') {
            if (this.type === 'key-value') {
                this.currentValue.forEach(function(keyValuePair) {
                    keyValuePair.update();
                });
            }
        } else if (this.isForDataRaptor() && this.currentValue === '+ Create New DataRaptor') {
            createNewDataRaptor(this,
                    (this.$previousValues.length > 0 ? this.$previousValues[this.$previousValues.length - 2] : this.defaultValue));
        } else {
            this.originalObjectResolutionFn()[this.key] = getStringToActualType(this.currentValue, this.originalObjectResolutionFn()[this.key]);
        }
    } catch (e) {}
    this.originalKey = this.key;
};

KeyValueWrapper.prototype.getResolvedObject = function() {
    'use strict';
    try {
        return this.originalObjectResolutionFn()[this.key];
    } catch (e) {
        return null;
    }
};

KeyValueWrapper.prototype.isKeyValue = function() {
    'use strict';
    return true;
};

KeyValueWrapper.prototype.arrayAsProperties = function() {
    'use strict';
    var parent = this;
    if (!this.cachedArray || this.cachedArray.length !== this.currentValue.length) {
        this.cachedArray = this.currentValue.map(function(value, index) {
            return new Property(parent.$parentProperty.label + '.' + parent.label + '.' + index,
                          value, parent.$canvasElement, false, parent);
        });
    }
    return this.cachedArray;
};

KeyValueWrapper.prototype.objectAsProperties = function(parentProperty) {
    'use strict';
    var parent = this;
    if (!this.cachedArray || this.cachedArray.length !== Object.keys(this.currentValue).length) {
        this.cachedArray = Object.keys(this.currentValue).map(function(key) {
            return new Property(parent.$parentProperty.label + '.' + parent.label + '.' + key,
                          parent.currentValue[key], parent.$canvasElement, false, parent);
        });
    }
    return this.cachedArray;
};

function getStringToActualType(value, existingValue) {
    'use strict';
    /* jshint eqnull:true */
    if (typeof value !== 'string') {
        return value;
    } if (value == null || value === '') {
        return value;
    } else if (/^(true|false)$/i.test(value)) {
        return (/true/i.test(value)).valueOf();
    } else {
        var asNum = Number(value);
        if (isNaN(asNum) || typeof existingValue === 'string') {
            return value;
        } else {
            return asNum.valueOf();
        }
    }
}


KeyValueWrapper.prototype.getValueAsString = function() {
    return JSON.stringify(_.get(this.originalObjectResolutionFn(), this.label), null, 4);
}

KeyValueWrapper.prototype.delete = function () {
    'use strict';
    delete this.originalObjectResolutionFn()[this.key];
    this.$parentArray.splice(this.$parentArray.indexOf(this), 1);
};

module.exports = Property;

},{"../util/CanvasElement.js":48,"../util/ScriptElement.js":53,"../util/generateId.js":54,"../util/inherit.js":55}],53:[function(require,module,exports){
var unescapeHTML = require('../util/HtmlEncodeDecode.js').unescapeHTML;
var nameSpacePropsRegex = /(IsActive__c|AdditionalInformation__c|DataRaptorBundleId__c|DataRaptorBundleName__c|IsReusable__c|IsProcedure__c|JSON_Output__c|Language__c|SubType__c|Type__c|Version__c|TestHTMLTemplates__c|CustomJavaScript__c)$/i;
var allScriptsById = {};

/*
 * ScriptElement represents the OmniScript root object all
 * forms are designed for
 */
function ScriptElement(json) {
  this.Id = json.Id;
  if (this.Id) {
    // OMNI-559 - do not clobber the existing instance
    //            instead return it
    if (allScriptsById[this.Id]) {
      return allScriptsById[this.Id];
    }
    allScriptsById[this.Id] = this;
  }
  this.Type__c = json[ns + "Type__c"] ? unescapeHTML(json[ns + "Type__c"]) : null;
  this.SubType__c = json[ns + "SubType__c"] ? unescapeHTML(json[ns + "SubType__c"]) : null;
  if (json[ns + "PropertySet__c"]) {
    this.PropertySet__c = JSON.parse(unescapeHTML(json[ns + "PropertySet__c"]));
  } else {
    this.PropertySet__c = {};
  }
  this.TestHTMLTemplates__c = json[ns + "TestHTMLTemplates__c"] ? unescapeHTML(json[ns + "TestHTMLTemplates__c"]) : "";
  this.CustomJavaScript__c = json[ns + "CustomJavaScript__c"] ? unescapeHTML(json[ns + "CustomJavaScript__c"]) : "";
  this.IsActive__c = json[ns + "IsActive__c"];
  this.IsReusable__c = !!json[ns + "IsReusable__c"];
  this.Version__c = json[ns + "Version__c"];
  this.Language__c = json[ns + "Language__c"] ? unescapeHTML(json[ns + "Language__c"]) : null;
  this.DataRaptorBundleId__c = json[ns + "DataRaptorBundleId__c"] ? json[ns + "DataRaptorBundleId__c"] : null;
  this.Version__c = json[ns + "Version__c"];
  this.IsProcedure__c = !!json[ns + "IsProcedure__c"];
  this.CanvasType = this.IsProcedure__c ? "Procedure Configuration" : "Script Configuration";
  this.Name = unescapeHTML(json.Name);
  this.OwnerId = json.OwnerId;
  this.Owner = json.Owner ? unescapeHTML(json.Owner.Name): null;
  this.CreatedById = json.CreatedById;
  this.CreatedBy = json.CreatedBy ? unescapeHTML(json.CreatedBy.Name) : null;
  this.CreatedDate = json.CreatedDate;
  this.LastModifiedDate = json.LastModifiedDate;
  this.LastModifiedById = json.LastModifiedById;
  this.LastModifiedBy = json.LastModifiedBy ? unescapeHTML(json.LastModifiedBy.Name) : null;
  this.children = [];
  this.AdditionalInformation__c = json[ns + "AdditionalInformation__c"] ? unescapeHTML(json[ns + "AdditionalInformation__c"]) : null;
  // fix up persistentComponent to be an array
  if (this.PropertySet__c.persistentComponent && !angular.isArray(this.PropertySet__c.persistentComponent)) {
    this.PropertySet__c.persistentComponent = [this.PropertySet__c.persistentComponent];
  }
  var me = this;
  this.children.splice = function() {
    if (arguments.length === 3) {
      arguments[2].OmniScriptId__c = me.Id;
    }
    var result = Array.prototype.splice.apply(this, arguments);
    // update Order__c
    for (var i = 0; i < this.length; i++) {
      this[i].Order__c = i+1;
    }
    return result;
  };
  this.originalJson = this.asJson();
}

ScriptElement.prototype.isAction = function() {
  return false;
};

ScriptElement.prototype.allowedTypes = function() {
  return ["navigation", "action", "typeahead-action", "editblock-action", "common-action", "OmniScript"];
};

ScriptElement.prototype.type = function() {
  return this.CanvasType;
};

ScriptElement.prototype.setId = function(id) {
  this.Id = id;
  if (this.children) {
    for (var i = 0; i < this.children.length; i++) {
      this.children[i].setOmniScriptId(id);
    }
  }
  allScriptsById[this.Id] = this;
};

ScriptElement.prototype.asJson = function() {
  var json = {
    Name: this.Name,
    Id: this.Id
  };
  for (var property in this) {
    if (nameSpacePropsRegex.test(property)) {
      json[ns + property] = this[property];
    }
  }
  var propSet = angular.copy(this.PropertySet__c);
  json[ns + "PropertySet__c"] = JSON.stringify(propSet);
  return json;
};

ScriptElement.prototype.setSaving = function() {
  this.errors = null;
  this.saving = true;
};

ScriptElement.prototype.setErrors = function(errors) {
  this.errors = errors;
};

ScriptElement.prototype.hasErrors = function(errors) {
  return this.errors && this.errors.length > 0;
};

ScriptElement.getById = function(id){
  return allScriptsById[id];
};

ScriptElement.prototype.each = function(expFunction) {
  expFunction(this);
  if (this.children) {
    for (var i = 0; i < this.children.length; i++) {
      this.children[i].each(expFunction);
    }
  }
};

ScriptElement.prototype.scriptElement = function() {
  return this;
};


ScriptElement.prototype.setDefaultPropertySet = function(json) {
    /* do nothing */
};


ScriptElement.reset = function() {
  allScriptsById = {};
};

module.exports = ScriptElement;
},{"../util/HtmlEncodeDecode.js":50}],54:[function(require,module,exports){
var idFunction = (function idFunction() {
  var prefixCounts = {"OmniScript Component": 1};
  var fn = function(prefix) {
    prefix = prefix ? prefix : "OmniScript Component";
    prefix = prefix.replace(/\brest\b/i, "REST");
    if (!prefixCounts[prefix]) {
      prefixCounts[prefix] = 1;
    }
    // string is never null
    return (prefix + " " + (prefixCounts[prefix]++)).replace(/\s/g,'');
  };
  fn.registerExistingPrefix = function(name) {
    var nameParts = name.split(/(?=[A-Z0-9 ])/);
    if (!isNaN(nameParts[nameParts.length - 1])) {
      var count = parseInt(nameParts[nameParts.length - 1], 10),
          key = nameParts.splice(0, nameParts.length - 1).join(' ');
      if (!prefixCounts[key] || prefixCounts[key] <= count) {
        prefixCounts[key] = count + 1;
      }
    }
  };
  return fn;
})();
module.exports = idFunction;
},{}],55:[function(require,module,exports){
module.exports = function inherit(proto) {
  function F() {}
  F.prototype = proto;
  return new F();
};
},{}],56:[function(require,module,exports){
var requiredProperties = {
    'Selectable Items': [
        'modalHTMLTemplateId','modalController','modalSize',
        'maxCompareSize','modalConfigurationSetting', 'accessibleInFutureSteps'
    ],
    'Block':['conditionType', 'accessibleInFutureSteps', 'repeatClone'],
    'Checkbox':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly', 
      'optionSource', 'controllingField'],
    'Currency':['conditionType','debounceValue', 'repeatClone','readOnly'],
    'Date':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Date/Time (Local)':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Disclosure':['conditionType', 'accessibleInFutureSteps','readOnly'],
    'Email':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Lookup':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Multi-select':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly', 'horizontalMode',
       'optionSource', 'controllingField'],
    'Number':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Password':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Radio':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly', 
      'horizontalMode', 'optionSource', 'controllingField'],
    'Range':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Select':['conditionType', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Signature':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Step':['conditionType', 'knowledgeOptions', 'remoteOptions', 'remoteClass', 'remoteMethod', 'remoteTimeout'],
    'Telephone':['conditionType', 'accessibleInFutureSteps', 'debounceValue', 'repeatClone','readOnly'],
    'Text':['conditionType', 'accessibleInFutureSteps', 'debounceValue', 'repeatClone','readOnly'],
    'Text Area':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Time':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'URL':['conditionType', 'debounceValue', 'accessibleInFutureSteps', 'repeatClone','readOnly'],
    'Filter Block':['accessibleInFutureSteps'],
    'Filter':['accessibleInFutureSteps'],
    'Input Block':['accessibleInFutureSteps']
};

module.exports = requiredProperties;
},{}],57:[function(require,module,exports){
(function () {
    'use strict';
    /*jshint -W030*/

    var tempMgr  = {
        ootb :{
            ' ': null,
            'vlcSelectableItem.html': 'vlcSelectableItem.html',
            'vlcSmallItems.html': 'vlcSmallItems.html',
            'vlcCardList.html': 'vlcCardList.html',
            'vlcPaymentList.html': 'vlcPaymentList.html',
            'vlcAssetList.html': 'vlcAssetList.html',
            'vlcSelectableItemV2.html':'vlcSelectableItemV2.html',
            'vlcSmallItemsV2.html':'vlcSmallItemsV2.html',
            'vlcSelectableItemHyb.html':'vlcSelectableItemHyb.html',
            'vlcSmallItemsHyb.html':'vlcSmallItemsHyb.html'
        },

        getModalTemplates: function(uiTemplates) {
            var obj = {};
            uiTemplates.map(function(template) {
                if (/^OmniScript Modal$/.test(template['Type__c'])) {
                    obj[template.Name] = template.Name;
                }
            });

            return obj;

        },

        getRedirectTemplates: function(uiTemplates) {
            var obj = {};
            uiTemplates.map(function(template) {
                if (/^OmniScript Redirect$/.test(template['Type__c'])) {
                    obj[template.Name] = template.Name;
                }
            });
            return obj;
        },

        getSelectableTemplates: function(uiTemplates) {
            var obj = {};
            uiTemplates.map(function(template) {
                if (/^OmniScript Selectable Items$/.test(template['Type__c'])) {
                    obj[template.Name] = template.Name;
                }
            });

            for (var prop in this.ootb) {
                if (this.ootb.hasOwnProperty(prop)) {
                    obj[prop] = this.ootb[prop];
                }
            }
            return obj;
        },

        getGenTemplates: function(uiTemplates) {
            var obj = {};
            console.log('inside gen templates');
            uiTemplates.map(function(template) {
                if (/^OmniScript$/.test(template['Type__c'])) {
                    obj[template.Name] = template.Name;
                }
            });

            return obj;
        },

        getInputBlockTemplates: function(uiTemplates) {
            var obj = {};
            uiTemplates.map(function(template) {
                obj[template.Name] = template.Name;
            });

            return obj;

        },

        getDefaultValues: function(label, obj) {
            var map = {
                'modalHTMLTemplateId': 'vlcModalContent.html',
                'modalConfigurationSetting.modalHTMLTemplateId': 'vlcProductConfig.html',
                'inputBlock': 'vlcTableSample.html',
                'Submit.redirectTemplateUrl': 'vlcApplicationAcknowledge.html',
                'Submit.confirmRedirectTemplateUrl': 'vlcApplicationConfirmation.html',
                'DataRaptor Extract Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'Remote Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'Rest Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'Done Action.redirectTemplateUrl': 'vlcMobileConfirmation.html',
                'Calculation Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'DocuSign Envelope Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'PDF Action.redirectTemplateUrl': 'vlcPDF.html',
                'DataRaptor Post Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'DataRaptor Transform Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'Matrix Action.redirectTemplateUrl': 'vlcAcknowledge.html',
                'Post to Object Action.redirectTemplateUrl': 'vlcApplicationAcknowledgeV2.html',
                'Review Action.redirectTemplateUrl': 'vlcApplicationConfirmationV2.html',
                'vlcProductConfig.html': 'vlcProductConfig.html'
            };

            if (map[label]) {
                obj[map[label]] = map[label];
            }
            return obj;
        },

        getTemplates: function(uiTemplates, property) {
            if (!(angular.isArray(uiTemplates))) {
                return {};
            }

            if (/modal/i.test(property.label)) {
                if (/persistentComponent\.\d+\.modalConfigurationSetting\.modalHTMLTemplateId/.test(property.label)) {
                    if (property.$canvasElement && property.$canvasElement.PropertySet__c &&
                            property.$canvasElement.PropertySet__c.persistentComponent) {
                        var persistentComponentConf = property.$canvasElement.PropertySet__c.persistentComponent;
                        var index = +property.label.split('.')[1];
                        if (persistentComponentConf.length > index) {
                            if (persistentComponentConf[index].id === 'vlcCart') {
                                return this.getDefaultValues('vlcProductConfig.html',this.getModalTemplates(uiTemplates));
                            }
                            else {
                                return this.getModalTemplates(uiTemplates);
                            }
                        }
                    }
                    return {};
                } else {
                    return this.getDefaultValues(property.label,this.getModalTemplates(uiTemplates));
                }
            }

            if (/redirect/i.test(property.label) && property.$canvasElement.CanvasType === 'Script Configuration') {
                return {
                    'vlcSaveForLaterAcknowledge.html':'vlcSaveForLaterAcknowledge.html'
                };
            } else if (/redirect/i.test(property.label) && property.$canvasElement['Type__c']) {
                return this.getDefaultValues(property.$canvasElement['Type__c'].label + '.' + property.label,
                                                this.getRedirectTemplates(uiTemplates));
            }

            if (property.$canvasElement['Type__c'] && /input block/i.test(property.$canvasElement['Type__c'].label)) {
                return this.getDefaultValues('inputBlock',this.getGenTemplates(uiTemplates));
            }

            if (property.$canvasElement['Type__c'] && /selectable/i.test(property.$canvasElement['Type__c'].label)) {
                return this.getDefaultValues(property.label,this.getSelectableTemplates(uiTemplates));
            }

            //this is the default case
            return this.getGenTemplates(uiTemplates);
        }
    };

    module.exports = tempMgr ;
}());

},{}],58:[function(require,module,exports){
angular.module('ouihome')
       .factory('backcompatExport', function(remoteActions, $localizable) {
           var $scope = {};

           return function backcompatExport(script, dontRetryCompile, useJSONV2)  {
                var exportResult,
                    initialPromise;
                if (useJSONV2) {
                    initialPromise = remoteActions.BuildJSONV2(script.Id)
                } else {
                    initialPromise = remoteActions.exportOmniScript(script.Id);
                }
                initialPromise
                    .then(function(result) {
                        var pom = document.createElement('a');
                        if (!angular.isString(result)) {
                            // OMNI-421 - always make into array for backcompat
                            if (!angular.isArray(result) && useJSONV2 !== true) {
                                result = [result];
                            }
                            result = JSON.stringify(result);
                            result = result.replace('&quot;', '&amp;quot;');
                        }
                        try {
                            pom.setAttribute('href', 'data:application/zip;charset=utf-8,' + encodeURIComponent(result));
                            var name = (script[fileNsPrefix() + 'Type__c'] || '') + '_' + (script[fileNsPrefix() + 'SubType__c'] || '') + '_' + (script[fileNsPrefix() + 'Language__c'] || '');
                            name = name.replace(/ /g, '');
                            pom.setAttribute('download', name + '.json');
                            pom.style.display = 'none';
                            document.body.appendChild(pom);
                            pom.click();
                        } catch (e) {
                            window.alert($localizable('OmniHomeFailExport', 'Unable to export {1}', script.Name));
                        }
                        document.body.removeChild(pom);
                    }, function(error) {
                        if (dontRetryCompile) {
                            window.alert($localizable('OmniHomeFailExport', 'Unable to export {1}', script.Name));
                        } else {
                            // if false then try compile it
                            var iframe = document.createElement('iframe');
                            iframe.src = window.previewUrl + '?id=' + script.Id;
                            iframe.style.display = 'none';
                            $(iframe).load(function() {
                                setTimeout(function() {
                                    document.body.removeChild(iframe);
                                    backcompatExport(script, true, useJSONV2);
                                }, 5000);
                            });
                            document.body.appendChild(iframe);
                        }
                    });
           };
       });

},{}],59:[function(require,module,exports){
//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/find
if (!Array.prototype.find) {
  Array.prototype.find = function(predicate) {
    /* jshint eqnull:true */
    if (this == null) {
      throw new TypeError('Array.prototype.find called on null or undefined');
    }
    if (typeof predicate !== 'function') {
      throw new TypeError('predicate must be a function');
    }
    var list = Object(this);
    var length = list.length >>> 0;
    var thisArg = arguments[1];
    var value;

    for (var i = 0; i < length; i++) {
      value = list[i];
      if (predicate.call(thisArg, value, i, list)) {
        return value;
      }
    }
    return undefined;
  };
}
},{}],60:[function(require,module,exports){
//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/findIndex
if (!Array.prototype.findIndex) {
  Array.prototype.findIndex = function(predicate) {
    /* jshint eqnull:true */
    if (this == null) {
      throw new TypeError('Array.prototype.findIndex called on null or undefined');
    }
    if (typeof predicate !== 'function') {
      throw new TypeError('predicate must be a function');
    }
    var list = Object(this);
    var length = list.length >>> 0;
    var thisArg = arguments[1];
    var value;

    for (var i = 0; i < length; i++) {
      value = list[i];
      if (predicate.call(thisArg, value, i, list)) {
        return i;
      }
    }
    return -1;
  };
}
},{}],61:[function(require,module,exports){
// Production steps of ECMA-262, Edition 6, 22.1.2.1
// https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/from?v=example
if (!Array.from) {
  Array.from = (function () {
    var toStr = Object.prototype.toString;
    var isCallable = function (fn) {
      return typeof fn === 'function' || toStr.call(fn) === '[object Function]';
    };
    var toInteger = function (value) {
      var number = Number(value);
      if (isNaN(number)) { return 0; }
      if (number === 0 || !isFinite(number)) { return number; }
      return (number > 0 ? 1 : -1) * Math.floor(Math.abs(number));
    };
    var maxSafeInteger = Math.pow(2, 53) - 1;
    var toLength = function (value) {
      var len = toInteger(value);
      return Math.min(Math.max(len, 0), maxSafeInteger);
    };

    // The length property of the from method is 1.
    return function from(arrayLike/*, mapFn, thisArg */) {
      // 1. Let C be the this value.
      var C = this;

      // 2. Let items be ToObject(arrayLike).
      var items = Object(arrayLike);

      // 3. ReturnIfAbrupt(items).
      if (arrayLike == null) {
        throw new TypeError('Array.from requires an array-like object - not null or undefined');
      }

      // 4. If mapfn is undefined, then let mapping be false.
      var mapFn = arguments.length > 1 ? arguments[1] : void undefined;
      var T;
      if (typeof mapFn !== 'undefined') {
        // 5. else
        // 5. a If IsCallable(mapfn) is false, throw a TypeError exception.
        if (!isCallable(mapFn)) {
          throw new TypeError('Array.from: when provided, the second argument must be a function');
        }

        // 5. b. If thisArg was supplied, let T be thisArg; else let T be undefined.
        if (arguments.length > 2) {
          T = arguments[2];
        }
      }

      // 10. Let lenValue be Get(items, "length").
      // 11. Let len be ToLength(lenValue).
      var len = toLength(items.length);

      // 13. If IsConstructor(C) is true, then
      // 13. a. Let A be the result of calling the [[Construct]] internal method 
      // of C with an argument list containing the single item len.
      // 14. a. Else, Let A be ArrayCreate(len).
      var A = isCallable(C) ? Object(new C(len)) : new Array(len);

      // 16. Let k be 0.
      var k = 0;
      // 17. Repeat, while k < len… (also steps a - h)
      var kValue;
      while (k < len) {
        kValue = items[k];
        if (mapFn) {
          A[k] = typeof T === 'undefined' ? mapFn(kValue, k) : mapFn.call(T, kValue, k);
        } else {
          A[k] = kValue;
        }
        k += 1;
      }
      // 18. Let putStatus be Put(A, "length", len, true).
      A.length = len;
      // 20. Return A.
      return A;
    };
  }());
}
},{}],62:[function(require,module,exports){
//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
if (![].includes) {
  Array.prototype.includes = function(searchElement /*, fromIndex*/ ) {
    'use strict';
    var O = Object(this);
    var len = parseInt(O.length) || 0;
    if (len === 0) {
      return false;
    }
    var n = parseInt(arguments[1]) || 0;
    var k;
    if (n >= 0) {
      k = n;
    } else {
      k = len + n;
      if (k < 0) {k = 0;}
    }
    var currentElement;
    while (k < len) {
      currentElement = O[k];
      if (searchElement === currentElement ||
         (searchElement !== searchElement && currentElement !== currentElement)) {
        return true;
      }
      k++;
    }
    return false;
  };
}
},{}],63:[function(require,module,exports){
/**
 * Module: sharedObjectService[For using common data/Object for using in different controller]
 */
angular.module('sharedObjectService', [])

    /**
     * Factory NotSupportedElmService[For getting non supported element for base template]
     * @param  {[function]} 
     * @return {[Service]}
     */
    .factory('NotSupportedElmService', function() {
        var NotSupportedElmService;

        NotSupportedElmService = (function() {
            function NotSupportedElmService() {}

            /**
             * [getList return list of not supported element in Base template]
             * @return {[type]} [object]
             */
            NotSupportedElmService.prototype.getList = function() {
                return {
                    "Image": "Image",
                    "Block": "Block",
                    "File": "File",
                    "Disclosure": "Disclosure",
                    "Headline": "Headline",
                    "Validation": "Validation",
                    "Line Break": "Line Break",
                    "Text Block": "Text Block"
                }
            };
            return NotSupportedElmService;
    })();

    if (typeof(window.angularSharedService) === 'undefined' || window.angularSharedService === null) {
        window.angularSharedService = new NotSupportedElmService();
    }

    return window.angularSharedService;
});
},{}]},{},[1]);

})();