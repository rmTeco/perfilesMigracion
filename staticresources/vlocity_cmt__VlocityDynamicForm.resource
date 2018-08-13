(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/**
 * Vlocity Dynamic form
 */

angular.module('VlocityDynamicForm',['vlocity', 'ngMessages', 'ui.mask', 'sldsangular']);

// Add this to vlocity.js
require('./modules/vlocitydynamicform/lib/angular-messages.js');
require('./modules/vlocitydynamicform/lib/mask.min.js');

require('./modules/vlocitydynamicform/directives/VlocityDynamicForm.js');
require('./modules/vlocitydynamicform/templates/templates.js');


},{"./modules/vlocitydynamicform/directives/VlocityDynamicForm.js":2,"./modules/vlocitydynamicform/lib/angular-messages.js":3,"./modules/vlocitydynamicform/lib/mask.min.js":4,"./modules/vlocitydynamicform/templates/templates.js":5}],2:[function(require,module,exports){
/**
* Vlocity Dynamic Form
* Dynamically build an HTML form using a JSON array/object and templates.
* @version v1.0.0
* Authors: jraju@vlocity.com;
*
* Credits: http://github.com/danhunsaker/angular-dynamic-forms
*/

/**
 * USAGE
 * @param {Object} ngModel - An object in the current scope where the form data should be read/stored.
 * @example <vlocity-dynamic-form template-url="form-template.js" ng-model="formData"></vlocity-dynamic-form>
 * @example <vlocity-dynamic-form template-url="form-template.js" ng-model="formData"><input type="submit" click="submitform()" /></vlocity-dynamic-form>
 *
*/

/* JSHINT globals */
/* globals _ */

angular.module('VlocityDynamicForm')
    .directive('vlocityDynamicForm', ['$templateCache', '$parse', '$http', '$compile', '$interpolate', '$document', '$timeout', '$locale', '$sldsPopover','$rootScope','ISO_CURRENCY_INFO',
                                      function ($templateCache, $parse, $http, $compile, $interpolate, $document, $timeout, $locale, $sldsPopover,$rootScope,ISO_CURRENCY_INFO) {
    'use strict';
    var supported = {
        //  Text-based elements
        'text': {element: 'input', type: 'text', editable: true, textBased: true},
        'email': {element: 'input', type: 'email', editable: true, textBased: true},
        'number': {element: 'input', type: 'number', editable: true, textBased: true},
        'password': {element: 'input', type: 'password', editable: true, textBased: true},
        'tel': {element: 'input', type: 'tel', editable: true, textBased: true},
        'textarea': {element: 'textarea', editable: true, textBased: true},
        'date': {element: 'date', editable: true, textBased: true},
        'datetime': {element: 'datetime', editable: true, textBased: true},

        //ranges
        'number-range': {element: 'range', type: 'number', editable: true, textBased: true},
        'date-range': {element: 'date-range', type: 'text', editable: true, textBased: true},
        'datetime-range': {element: 'date-range', type: 'text', editable: true, textBased: true},

        //  Specialized editables
        'range': {element: 'input', type: 'range', editable: true, textBased: false},
        //Element is set as checkbox although it's an input so that it uses the checkbox template
        'checkbox': {element: 'checkbox', type: 'checkbox', editable: true, textBased: false},
        'select': {element: 'select', editable: true, textBased: false},

        //  Pseudo-non-editables (containers)
        'checklist': {element: 'checklist', editable: false, textBased: false},
        'radiolist': {element: 'radiolist', editable: false, textBased: false},
        'fieldset': {element: 'fieldset', editable: false, textBased: false},

        //  Non-editables (mostly buttons)
        'button': {element: 'button', type: 'button', editable: false, textBased: false},
        'hidden': {element: 'input', type: 'hidden', editable: false, textBased: false},
        'image': {element: 'input', type: 'image', editable: false, textBased: false},
        'submit': {element: 'button', type: 'submit', editable: false, textBased: false}
    };

    var defaultFieldMapping = {
        'type' : 'type',
        'value' : 'value',
        'valuesArray' : { //multiple values. Eg: select, fieldset, radio
            'field': 'values',  //Points to an array
            'value': 'value',   //Points to an value field in an object of an array
            'selected': 'selected',
            'required': 'required',
            'disabled': 'disabled',
            'readonly': 'readonly',
            'defaultSelected': 'defaultSelected',
            'label': 'label'
            },
        'label' : 'label',
        'description': 'description',
        'readonly':'readonly',
        'required': 'required',
        'hidden': 'ishidden',
        'min': 'min',
        'max': 'max',
        'step': 'step',
        'minLength': 'minlength',
        'maxLength': 'maxlength',
        'placeholder': 'placeholder',
        'multiple': 'multiple',
        'disabled': 'disabled',
        'dataType': 'dataType',
        'formatMask': 'formatMask',
        'customTemplate' : 'customTemplate',
        'model': 'model' //temporary
    };

    var defaultTemplateMapping = {
        'input': 'InputTemplate.tpl.html',
        'range': 'RangeInputTemplate.tpl.html',
        'textarea': 'TextareaTemplate.tpl.html',
        'date': 'DateTemplate.tpl.html',
        'date-range':'DateRangeTemplate.tpl.html',
        'datetime': 'DateTimeTemplate.tpl.html',
        'checkbox': 'CheckboxTemplate.tpl.html',
        'checklist': 'CheckboxFieldsetTemplate.tpl.html',
        'radiolist': 'RadioFieldsetTemplate.tpl.html',
        'sectionlegend': 'SectionLegendTemplate.tpl.html',
        'sectionlegendToggle': 'SectionLegendToggleTemplate.tpl.html',
        'select': 'SelectTemplate.tpl.html'
    };

    var isIE = !!navigator.userAgent.match(/Trident/g) || !!navigator.userAgent.match(/MSIE/g);

    return {
        restrict: 'E', // supports using directive as element only
        transclude: true,
        link: function ($scope, element, attrs, ctrl, transcludeFn) {
            var newElement = null,
                HTMLFragment = null,
                newChild = null,
                optGroups = {},
                cbAtt = '',
                foundOne = false,
                iterElem = element,
                model = null,
                mapObject = null,
                fieldMapping = null,
                fieldSetMapping = null,
                pathMapping = null,
                templateMapping = null,
                newCheckboxFragment = null,
                newRadioFragment = null,
                transcludeElement,
                changeCallback;

            /* with multi currency enabled userCurrency will be USD and not $
             * https://success.salesforce.com/answers?id=90630000000h1ovAAA
            */
            var isoCurrencyCode = $rootScope.vlocity.userCurrency || 'USD';
            // some org returns userLanguage as en-us and some returns en_US causes issue we have to discuss on that and resolve
            //var userLocale = 'en_US';
            var isoCurrencySymbol = ISO_CURRENCY_INFO[isoCurrencyCode].text;
            $scope.localeCurencySym = isoCurrencySymbol || '$';

            /*
             * For form elements that the user does not interact with directly,
             * but whose underlying model has changed, we need to manually trigger
             * the form-on-change event
            */
            $scope.watchModel = function(modelObj, debounce) {
                var debounceTime = debounce ? 800 : 0;
                var saveDebounce = null;
                $scope.$watch(modelObj, function(newValue, oldValue) {
                    if (saveDebounce) {
                        $timeout.cancel(saveDebounce);
                    }
                    if (newValue !== oldValue && isFormAutoSave() && newValue) {
                        saveDebounce = $timeout(function () {
                            var wrappedResult = angular.element(document.getElementsByName(getFormName()));
                            var formChangeFn = $parse(wrappedResult.attr('form-on-change'));
                            formChangeFn($scope, {e:false});
                        }, debounceTime);
                    }
                }, true);
            };

            var extendContent = function(field) {
                var obj = {}; obj[field.label]= false;
                $scope.expand = $scope.expand || {};
                $scope.showMore = $scope.showMore || obj;
                var extendElement = newElement.find('[vdf-fieldset-wrapper] .extend-content');

                if (fieldSetMapping && fieldSetMapping.showMoreFlag && field.valuesArray.length > fieldSetMapping.showCount) {
                    $scope.showMore[field.label] = true;
                    $scope.expand[field.label] = true;
                }
                return extendElement;
            };

            //   @TODO
            //   Work in progress code. optimizations pending

            //  Check that the required attributes are in place
            if (angular.isDefined(attrs.ngModel)) {
                //TODO: check why $scope.$parent, it fails in some cases
                model = $parse(attrs.ngModel)($scope) || $parse(attrs.ngModel)($scope.$parent);
                //@TODO handle both $scope.parent and $scope
                mapObject = attrs.mapObject ? $parse(attrs.mapObject)($scope.$parent): {};
                fieldMapping = _.merge({}, defaultFieldMapping, mapObject.fieldMapping);
                fieldSetMapping = mapObject.fieldSetMapping || null;
                pathMapping = mapObject.pathMapping || null;
                templateMapping = mapObject.templateMapping || null;

                var setProperty = function (obj, props, value, lastProp, buildParent) {
                    props = props.split('.');
                    lastProp = lastProp || props.pop();

                    for (var i = 0; i < props.length; i++) {
                        obj = obj[props[i]] = obj[props[i]] || {};
                    }
                    if (!buildParent) {
                        obj[lastProp] = value;
                    }
                },
                bracket = function (model, base) {
                    var props = model.split('.');
                    return (base || props.shift()) + (props.length ? '["' + props.join('"]["') + '"]' : '');
                },

                /**
                 * getFieldType: get field type in lowercase
                 * @param  {object} field Object to query
                 * @return {string} input fieldType eg: email, number in lowercase
                 */
                getFieldType = function(field) {
                    var type = field.type;
                    var multiple = field.multiple ? field.multiple: '';

                    type = type ? type.toLowerCase() : '';

                    //Temporary fix
                    // @TODO needs proper fix
                    type = (type === 'dropdown') ? 'select' : type;
                    type = (type === 'checkbox' && multiple === true) ? 'checklist' : type;
                    type = (type === 'radio') ? 'radiolist' : type;

                    return type;   
                },

                /**
                 * getObjField returns the value based on the object path
                 * @param  {object} field    Object to query
                 * @param  {string} typePath query path
                 * @return {Object or String}
                 */
                getObjField = function(field, typePath) {
                    var type = _.get(field, typePath);
                    return type;
                },

                /**
                 * getTemplateMap Provides the template map based on the merge of default map and provided custom map.
                 * @param  {object} customTemplateMapping  Provide the object to override the default templates for inputs
                 * @return {object} New template map
                 */
                getTemplateMap = function (customTemplateMapping) {
                   return _.merge({}, defaultTemplateMapping, customTemplateMapping);
                },

                /**
                 * getTemplate returns the value based on the object path
                 * @param  {string} inputType  input type
                 * @return {html fragment}  returns the template based on input type
                 */
                getTemplate = function (inputType) {
                    var template = '',
                        templateMap = getTemplateMap(templateMapping);

                    template = templateMap[inputType];
                    return $templateCache.get(template);
                },

                /**
                 * getModel : function to get the model xpath
                 * @param  {Number} pid   parentIndex
                 * @param  {Number} id    index
                 * @param  {Object} field object
                 * @return {string} model xpath eg: importedScope.attributesObj[0].productAttributes.records[0].values
                 */
                getModel = function (pid, field, id) {
                    var path,
                        modelPath = '';

                    //Append the path when the json depth for model is 2 levels or more
                    //refer mapObject.pathMapping
                    path = pathMapping && pathMapping.path ? pathMapping.path : '';

                    if (path) {
                        //pid is the parent loop index
                        modelPath = attrs.ngModel + '['+ pid + '].'+ path + '['+ id +'].' + bracket(field);
                    }else {
                        modelPath = attrs.ngModel + '['+ pid +'].' + bracket(field);
                    }

                    return modelPath;
                },

                /**
                 * getFormInputName
                 * @param  {Number} pid [optional] parent index number. Exists when field category is avilable, two levels
                 * @param  {Number} id  mandatory param. 'id' is an index number
                 * @return {[String]}  unique input field name string Eg: myform_field_1_0
                 */
                getFormInputName = function (pid, id) {
                    var uniqueFormName = getFormName();

                    uniqueFormName = uniqueFormName + '_field';
                    // check if pid/id is a number. should allow zero
                    uniqueFormName = !isNaN(pid) ? uniqueFormName + '_' + pid : uniqueFormName;
                    uniqueFormName = !isNaN(id) ? uniqueFormName + '_' + id : uniqueFormName;

                    return uniqueFormName;
                },

                /**
                 * getFormName
                 * @return {string} returns the form name. Defaults when no name attribute is passed.
                 */
                getFormName = function () {
                    //If form name is not passed in directive it defaults to vdf. Always pass the unique form name in vdf directive.
                    //When multiple instances of vdf is used, it's a must to pass the unique form name
                    var DEFAULT_FORM_NAME = 'vdf'; //default name
                    return attrs.name? attrs.name : DEFAULT_FORM_NAME;
                },

                /**
                 * isFormAutoSave
                 * @return {boolean} returns whether the form elements should be auto-saved or not
                 */
                isFormAutoSave = function () {
                    return (angular.isDefined(attrs.formAutoSave) && (attrs.formAutoSave === 'true'));
                },

                buildSectionLegend = function (field, id, label) {
                    var isReplaceable = false;
                    HTMLFragment = getTemplate('sectionlegend');  //@TODO map it
                    newElement = angular.element(HTMLFragment);
                    var sectionLegend = newElement.find('[vdf-section-legend]');

                    isReplaceable  = !!sectionLegend.attr('vdf-replace');

                    if(isReplaceable) {
                        sectionLegend.replaceWith(label);
                    }else {
                        sectionLegend.text(label);
                    }

                    // Add the element to the page
                    this.append(newElement);
                    newElement = null;
                },

                /**
                 * getFieldMapTransform: Deep object merge for mapping fields
                 * @param  {object} defaultFieldMapping [Contains all the default set of key/value pairs]
                 * @param  {object} customFieldMapping  [Custom key/value pairs which overrides default]
                 * @return {object}                     [Transformed standard field mapping]
                 *
                 * Eg: defaultFieldMapping: {a:1, b:2, c:{c1:1, c2:2}}
                 *     customFieldMapping: {a:11, c:{c1:11}}
                 *     output: {a:11, b:2, c:{c1:11, c2:2}}
                 */
                getFieldMapTransform = function (defaultFieldMapping, customFieldMapping) {
                   return _.merge({}, defaultFieldMapping, customFieldMapping);
                },

                /**
                 * getFieldTransform: Tranforms the custom field to standard field with default attributes.
                 * Usually contains the HTML5 standard input attributes eg: min, max, required, placeholder
                 * @param  {object} rawField [description]
                 * @return {object} Transformed standard field object
                 */
                getFieldTransform = function (rawField) {
                    var transformedField = {};
                    var fieldMap = getFieldMapTransform(defaultFieldMapping, mapObject.fieldMapping);
                    _.forEach(fieldMap, function(mapValue, key) {
                        var fieldValue = [];

                        //If the value is object, loop through the nested keys
                        if(key === 'valuesArray' && rawField[mapValue.field] && rawField[mapValue.field].length > 0) {
                            _.forEach(rawField[mapValue.field], function(valuesArrayObj, valuesArrayIndex) {
                                var resultObj;
                                _.forEach(mapValue, function(childMapValue, childKey) {
                                    var childFieldValue = _.get(rawField[mapValue.field][valuesArrayIndex], childMapValue);
                                    if (typeof childFieldValue !== 'undefined') {
                                        resultObj = resultObj || {};
                                        resultObj[childKey] = childFieldValue;
                                    }
                                });
                                fieldValue[valuesArrayIndex] = resultObj;
                            });
                        } else {
                            fieldValue = _.get(rawField, mapValue);
                        }

                        if (typeof fieldValue !== 'undefined') {
                            transformedField[key] = fieldValue;
                        }
                    });

                    return transformedField;
                },

                buildFields = function (rawField, pid, id) {
                    var templateScope = $scope.$new();
                    var checkListArray = [];
                    var field = {};
                    var customTemplateFieldPath;
                    var vdfInput;
                    var vdfSelect;
                    var extendElement;
                    var vdfOnly, vdfMin, vdfMax, vdfTimeMin, vdfTimeMax, vdfDateMin, vdfDateMax;
                    // get the raw field object as a standard field object
                    // Templates read the values based on standard field object
                    field = getFieldTransform(rawField);

                    if (String(id).charAt(0) === '$') {
                        // Don't process keys added by Angular
                        return;
                    }

                    //Handle the custom vlocity templates for inputs
                    //If customTemplate exists, it wil override the default templates.
                    if(field.customTemplate) {
                        //Handle non category fields - fields at root level
                        customTemplateFieldPath = attrs.ngModel + '[' +pid+ ']';

                        // Handle nested level of fields inside categories
                        // customTemplateFieldPath eg: importedScope.attributesObj[0].productAttributes.records[0]
                        if (pathMapping && pathMapping.path) {
                            customTemplateFieldPath = customTemplateFieldPath + '.' + pathMapping.path + '['+ id + ']';
                        }

                        newElement = '<vloc-cmp customtemplate="' + field.customTemplate + '" loaded="true" records="' + customTemplateFieldPath + '" form-name="' + getFormName() + '" form-auto-save="' + isFormAutoSave() + '"></vloc-cmp>';
                        this.append(newElement);
                        newElement = null;
                        return;
                    }

                    if (!angular.isDefined(supported[getFieldType(field)]) || supported[getFieldType(field)] === false) {
                        //  Unsupported.  Create SPAN with field.label as contents
                        newElement = angular.element('<span></span>');
                        if (angular.isDefined(field.label)) {
                            angular.element(newElement).html(field.label);
                        }
                        angular.forEach(field, function (val, attr) {
                            if (['label', 'type'].indexOf(attr) > -1) {
                                return;
                            }
                            newElement.attr(attr, val);
                        });
                        this.append(newElement);
                        newElement = null;
                    } else {
                        // newElement = angular.element($document[0].createElement(supported[getFieldType(field)].element));
                        HTMLFragment = getTemplate(supported[getFieldType(field)].element);

                        //Add the form field name for input fields, labels and error handlers by
                        // replacing [[vdf-form-field-name]] with "myFormName.myFieldName"
                        HTMLFragment = HTMLFragment.replace(/\[\[vdf-form-field-name\]\]/gi, getFormName() + '.' + getFormInputName(pid, id));

                        //Replace the template scope values. eg: label name, required field
                        templateScope.field = field;
                        templateScope.attrs = attrs;
                        HTMLFragment = $compile(HTMLFragment)(templateScope);
                        // HTMLFragment = $interpolate(HTMLFragment)(templateScope);
                        newElement = angular.element(HTMLFragment);
                        vdfInput = newElement.find('[vdf-input]');

                        if (angular.isDefined(supported[getFieldType(field)].type)) {
                            vdfInput.attr('type', supported[getFieldType(field)].type);
                        }

                        //  Editable fields (those that can feed models)
                        if (angular.isDefined(supported[getFieldType(field)].editable) && supported[getFieldType(field)].editable) {
                            vdfInput.attr('name', getFormInputName(pid, id));
                            //vdfInput.attr('ng-model', bracket(fieldMapping.model, attrs.ngModel));
                            vdfInput.attr('ng-model', getModel(pid, fieldMapping.value, id));

                            // Build parent in case of a nested model
                            //setProperty(model, fieldMapping.model, {}, null, true);

                            if (angular.isDefined(field.readonly)) {vdfInput.attr('ng-readonly', field.readonly);}
                            if (angular.isDefined(field.required)) {vdfInput.attr('ng-required', field.required);}
                            if (angular.isDefined(field.disabled)) {vdfInput.attr('ng-disabled', field.disabled);}
                            if (angular.isDefined(field.value)) {
                                //setProperty(model, fieldMapping.model, angular.copy(fieldMapping.value));

                                vdfInput.attr('value', field.value);
                            }
                        }

                        //  Fields based on input type=text
                        if (angular.isDefined(supported[getFieldType(field)].textBased) && supported[getFieldType(field)].textBased) {
                            if (angular.isDefined(field.minLength)) {vdfInput.attr('ng-minlength', field.minLength);}
                            if (angular.isDefined(field.maxLength)) {vdfInput.attr('ng-maxlength', field.maxLength);}
                            if (angular.isDefined(field.validate)) {vdfInput.attr('ng-pattern', field.validate);}
                            if (angular.isDefined(field.placeholder)) {vdfInput.attr('placeholder', field.placeholder);}

                            //slds readonly input style override
                            if (angular.isDefined(field.readonly) && field.readonly) {vdfInput.css('background-color', '#e0e5ee');}
                        }

                        //Add format mask support for input type text
                        if (getFieldType(field) === 'text' && field.formatMask) {
                            vdfInput.attr('ui-mask', field.formatMask);
                            vdfInput.attr('ui-mask-placeholder', '');
                            if (isIE) {
                                $scope.watchModel('' + getModel(pid, fieldMapping.value, id),true);
                            }
                        }

                        if (getFieldType(field) === 'date') {
                            vdfInput.attr('slds-date-picker', 'true');
                            vdfInput.attr('data-date-format', 'shortDate');
                            vdfInput.keypress(function(event) {event.preventDefault();});
                            // watch the underlying model and manually trigger the form-on-change event
                            $scope.watchModel('' + getModel(pid, fieldMapping.value, id));
                        }

                        if (getFieldType(field) === 'datetime') {
                            vdfInput = newElement.find('[vdf-data]');
                            vdfInput.attr('slds-date-picker', 'true');
                            vdfInput.attr('data-date-format', 'shortDate');
                            vdfInput.keypress(function(event) {event.preventDefault();});

                            vdfInput  = newElement.find('[vdf-time]');
                            vdfInput.attr('slds-time-picker', 'true');
                            vdfInput.attr('data-time-format', 'mediumTime');
                            vdfInput.attr('name', getFormInputName(pid));

                            vdfInput.keypress(function(event) {event.preventDefault();});

                            // watch the underlying model and manually trigger the form-on-change event
                            $scope.watchModel('' + getModel(pid, fieldMapping.value, id));
                        }

                        if (getFieldType(field) === 'date-range' || getFieldType(field) === 'datetime-range') {
                            vdfOnly =   newElement.find('[data-vdf-only]');
                            vdfMin  =   newElement.find('[data-vdf-min]');
                            vdfMax  =   newElement.find('[data-vdf-max]');
                            vdfTimeMin  =   newElement.find('[time-vdf-min]');
                            vdfTimeMax  =   newElement.find('[time-vdf-max]');

                            if (field.min === field.max) {
                                vdfOnly.attr('ng-true-value', field.min);
                                vdfOnly.attr('ng-false-value', 'null');
                                vdfOnly.attr('type', 'checkbox');
                                vdfOnly.attr('ng-model', getModel(pid, fieldMapping.value, id));
                                
                                moment.locale(window.navigator.language);

                                if (getFieldType(field) === 'datetime-range') {
                                    field.value = moment(field.min).format('LLL');
                                } else {
                                    field.value = moment(field.min).format('LL');
                                }
                            } else {
                                //Display correct range on datapicker
                                vdfDateMin = new Date(field.min).setHours(0,0,0);
                                vdfDateMax = new Date(field.max).setHours(0,0,0);

                                vdfMin.attr('slds-date-picker', 'true');
                                vdfMin.attr('data-date-format', 'shortDate');
                                vdfMin.attr('data-min-date', vdfDateMin);
                                vdfMin.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.min');

                                vdfMax.attr('slds-date-picker', 'true');
                                vdfMax.attr('data-date-format', 'shortDate');
                                vdfMax.attr('data-max-date', vdfDateMax);
                                vdfMax.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.max');

                                if (getFieldType(field) === 'datetime-range') {
                                    vdfInput  = newElement.find('[vdf-time]');
                                    vdfInput.attr('slds-time-picker', 'true');
                                    vdfInput.attr('data-time-format', 'mediumTime');
                                    vdfTimeMin.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.min');
                                    vdfTimeMax.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.max');
                                }
                            }
                        }
                        
                        //  Special cases
                        if (getFieldType(field) === 'number' || getFieldType(field) === 'range') {
                            if (angular.isDefined(field.min)) {vdfInput.attr('min', field.min);}
                            if (angular.isDefined(field.max)) {vdfInput.attr('max', field.max);}
                            if (angular.isDefined(field.step)) {
                                vdfInput.attr('step', field.step);
                            } else {
                                vdfInput.attr('step', 'any');
                            }
                        } else if (['text', 'textarea'].indexOf(getFieldType(field)) > -1) {
                            if (angular.isDefined(field.splitBy)) {newElement.attr('ng-list', field.splitBy);}
                        } else if (getFieldType(field) === 'checkbox') {
                            if (angular.isDefined(field.isOn)) {newElement.attr('ng-true-value', field.isOn);}
                            if (angular.isDefined(field.isOff)) {newElement.attr('ng-false-value', field.isOff);}
                            if (angular.isDefined(field.slaveTo)) {newElement.attr('ng-checked', field.slaveTo);}
                        } else if (getFieldType(field) === 'checklist') {
                            if (angular.isDefined(field.valuesArray)) {
                                angular.forEach(field.valuesArray, function(option, index) {
                                    var checklistObj = {};
                                    // @Todo check label or name field
                                    checklistObj[option.value] = false;
                                    checkListArray.push(checklistObj);
                                });

                                field[fieldMapping.value] = _.merge(checkListArray, field.value);
                            }

                            if (angular.isDefined(field.valuesArray)) {
                                if (! (angular.isDefined(model[field.model]) && angular.isObject(model[field.model]))) {
                                    //setProperty(model, getObjField(field, fieldMapping.model), {});
                                }

                                // Show More link
                                extendElement = extendContent(field);

                                newCheckboxFragment = newElement.find('[vdf-fieldset-element]').replaceWith('');
                                angular.forEach(field.valuesArray, function (option, childId) {
                                    newChild = newCheckboxFragment.clone();
                                    vdfInput = newChild.find('[vdf-input]');

                                    vdfInput.attr('name', getFormInputName(pid, id) + '_' + childId);
                                    vdfInput.attr('ng-model', getModel(pid, fieldMapping.value, id) + '[' + childId + ']' + '["' + option.value + '"]');
                                    if (angular.isDefined(option['class'])) {vdfInput.attr('ng-class', option['class']);}
                                    if (angular.isDefined(option.disabled)) {vdfInput.attr('ng-disabled', option.disabled);}
                                    if (angular.isDefined(option.readonly)) {vdfInput.attr('ng-readonly', option.readonly);}
                                    if (angular.isDefined(option.required)) {vdfInput.attr('ng-required', option.required);}
                                    if (angular.isDefined(option.callback)) {vdfInput.attr('ng-change', option.callback);}
                                    if (angular.isDefined(option.isOn)) {vdfInput.attr('ng-true-value', option.isOn);}
                                    if (angular.isDefined(option.isOff)) {vdfInput.attr('ng-false-value', option.isOff);}
                                    //default checkbox selection happens in angular based on userValues
                                    if (angular.isDefined(option.value)) {
                                        //setProperty(model, fieldMapping.model, angular.copy(option.value), childId);
                                        newChild.attr('value', option.value);
                                    }

                                    if (angular.isDefined(option.label)) {
                                        newChild.find('[vdf-checkbox-label]').html(option.label);
                                    }
                                    if (!$scope.showMore[field.label] || fieldSetMapping.showCount > childId) {
                                        newElement.find('[vdf-fieldset-wrapper] .visible-content').append(newChild);
                                    } else {
                                        extendElement.append(newChild);
                                    }
                                });
                                newCheckboxFragment = null;
                            }
                        } else if (getFieldType(field) === 'radio' || getFieldType(field) === 'radiolist') {
                            if (angular.isDefined(field.valuesArray)) {
                               // setProperty(model, getObjField(field, fieldMapping.model), angular.copy(field.value));

                                // Show More link
                                extendElement = extendContent(field);

                                newRadioFragment = newElement.find('[vdf-fieldset-element]').replaceWith('');
                                angular.forEach(field.valuesArray, function(option, childId) {
                                    // newChild = angular.element('<input type="radio" />');
                                    newChild = newRadioFragment.clone();
                                    vdfInput = newChild.find('[vdf-input]');

                                    vdfInput.attr('name', getFormInputName(pid, id));
                                    vdfInput.attr('ng-model', getModel(pid, fieldMapping.value, id));
                                    if (angular.isDefined(option['class'])) {vdfInput.attr('ng-class', option['class']);}
                                    if (angular.isDefined(option.disabled)) {vdfInput.attr('ng-disabled', option.disabled);}
                                    if (angular.isDefined(option.callback)) {vdfInput.attr('ng-change', option.callback);}
                                    if (angular.isDefined(option.readonly)) {vdfInput.attr('ng-readonly', option.readonly);}
                                    if (angular.isDefined(option.required)) {vdfInput.attr('ng-required', option.required);}
                                    vdfInput.attr('value', option.value);

                                    //TBD: handle the check to enable the default
                                    if (angular.isDefined(field.value) && field.value === option.value) {
                                        vdfInput.attr('checked', 'checked');
                                    }

                                    if (angular.isDefined(option.label)) {
                                        newChild.find('[vdf-radio-label]').html(option.label);
                                    }

                                    if (!$scope.showMore[field.label] || fieldSetMapping.showCount > childId) {
                                        newElement.find('[vdf-fieldset-wrapper] .visible-content').append(newChild);
                                    } else {
                                        extendElement.append(newChild);
                                    }
                                });

                                newRadioFragment = null;
                            }
                        }
                        else if (getFieldType(field) === 'select') {
                            if (angular.isDefined(field.multiple) && field.multiple !== false) {newElement.find('[vdf-select]').attr('multiple', 'multiple');}
                            if (angular.isDefined(field.empty) && field.empty !== false) {newElement.append(angular.element($document[0].createElement('option')).attr('value', '').html(field.empty));}
                            vdfSelect = newElement.find('[vdf-select]');

                            //Add a name attribute for select. Used for error handling in angular
                            vdfSelect.attr('name', getFormInputName(pid, id));

                            vdfSelect.attr('ng-model', getModel(pid, fieldMapping.value, id));
                            if (angular.isDefined(field.required)) {
                                vdfSelect.attr('ng-required', field.required);
                            }

                            if (angular.isDefined(field.disabled)) {
                                vdfSelect.attr('ng-disabled', field.disabled);
                            }

                            if (angular.isDefined(field.autoOptions)) {
                                newElement.attr('ng-options', field.autoOptions);
                            }
                            else if (angular.isDefined(field.valuesArray)) {
                                angular.forEach(field.valuesArray, function (option, childId) {
                                    newChild = angular.element($document[0].createElement('option'));
                                    newChild.attr('value', childId);
                                    if (angular.isDefined(option.disabled)) {newChild.attr('ng-disabled', option.disabled);}
                                    if (angular.isDefined(option.label)) {newChild.html(option.label);}
                                    if (angular.isDefined(option.value)) {newChild.attr('value', option.value);}

                                    // End of temporary fix
                                    if (angular.isDefined(option.group)) {
                                        if (!angular.isDefined(optGroups[option.group])) {
                                            optGroups[option.group] = angular.element($document[0].createElement('optgroup'));
                                            optGroups[option.group].attr('label', option.group);
                                        }
                                        optGroups[option.group].append(newChild);
                                    }
                                    else {
                                        vdfSelect.append(newChild);
                                    }
                                });

                                if (!angular.equals(optGroups, {})) {
                                    angular.forEach(optGroups, function (optGroup) {
                                        vdfSelect.append(optGroup);
                                    });
                                    optGroups = {};
                                }
                            }
                        }
                        else if (getFieldType(field) === 'image') {
                            if (angular.isDefined(field.label)) {newElement.attr('alt', field.label);}
                            if (angular.isDefined(field.source)) {newElement.attr('src', field.source);}
                        }
                        else if (getFieldType(field) === 'hidden') {
                            newElement.attr('name', getFormInputName(pid, id));
                            newElement.attr('ng-model', bracket(getObjField(field, fieldMapping.model), attrs.ngModel));
                            if (angular.isDefined(field.value)) {
                                setProperty(model, getObjField(field, fieldMapping.model), angular.copy(field.value));
                                newElement.attr('value', field.value);
                            }
                        }
                        else if (getFieldType(field) === 'number-range') {
                            vdfOnly =   newElement.find('[data-vdf-only]');
                            vdfMin  =   newElement.find('[data-vdf-min]');
                            vdfMax  =   newElement.find('[data-vdf-max]');

                            if(field.min === field.max) {
                                vdfOnly.attr('ng-true-value', field.min);
                                vdfOnly.attr('ng-false-value', 'null');
                                vdfOnly.attr('type', 'checkbox');
                                vdfOnly.attr('ng-model', getModel(pid, fieldMapping.value, id));

                            } else {
                                vdfMin.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.min');
                                vdfMax.attr('ng-model', getModel(pid, fieldMapping.value, id)+'.max');

                                if (angular.isDefined(field.min)) {
                                    vdfMin.attr('min', field.min);
                                    vdfMax.attr('min', field.min);
                                }
                                if (angular.isDefined(field.max)) {
                                    vdfMin.attr('max', field.max);
                                    vdfMax.attr('max', field.max);
                                }
                                if (angular.isDefined(field.step)) {
                                    vdfMin.attr('step', field.step);
                                    vdfMax.attr('step', field.step);
                                }
                            }
                        }

                        //  Common attributes; radio already applied these...
                        if (getFieldType(field) !== 'radio') {
                            if (angular.isDefined(field['class'])) { newElement.attr('ng-class', field['class']); }
                            //  ...and checklist has already applied these.
                            if (getFieldType(field) !== 'checklist') {
                                if (angular.isDefined(field.disabled)) { newElement.attr('ng-disabled', field.disabled); }
                                if (angular.isDefined(field.callback)) {
                                    //  Some input types need listeners on click...
                                    if (['button', 'fieldset', 'image', 'submit'].indexOf(getFieldType(field)) > -1) {
                                        cbAtt = 'ng-click';
                                    }
                                    //  ...the rest on change.
                                    else {
                                        cbAtt = 'ng-change';
                                    }
                                    newElement.attr(cbAtt, field.callback);
                                }
                            }
                        }

                        // Arbitrary attributes
                        if (angular.isDefined(field.attributes)) {
                            angular.forEach(field.attributes, function (val, attr) {
                                newElement.attr(attr, val);
                            });
                        }

                        // Add the element to the page
                        this.append(newElement);
                        newElement = null;
                    }
                };

                // angular.forEach(template, buildFields, element);
                // two level loop

                if (pathMapping) {
                    //Loop through Category or Grouping
                    angular.forEach(model, function(value, key){
                        var fieldList = _.get(value, pathMapping.path);
                        if (angular.isDefined(fieldList) && fieldList.length > 0) {
                            buildSectionLegend.call(this, value, key, value.Name);
                        }
                        //Loop through field set
                        angular.forEach(fieldList, function(field, index){
                            buildFields.call(this, field, key, index);
                        }, element);
                    }, element);
                } else {
                    angular.forEach(model, function(field, index) {
                        buildFields.call(this, field, index);
                    }, element);
                }

                // Determine what tag name to use (ng-form if nested; form if outermost)
                // Recurively loops through the parent untill HTMl tag

                while (!(iterElem.parent().length <= 0 || iterElem.parent().prop('tagName') === 'HTML')) {
                    // Provide a rootEl(form or ng-form) attribute support on VDF, so users can customize. Improves performance
                    try {
                        if (['form','ngForm'].indexOf(attrs.$normalize(angular.lowercase(iterElem.parent()[0].nodeName))) > -1) {
                            foundOne = true;
                            break;
                        }
                        iterElem = iterElem.parent();
                    }catch(e){
                        break;
                    }
                }
                if (foundOne) {
                    newElement = angular.element($document[0].createElement('ng-form'));
                }
                else {
                    newElement = angular.element('<form></form>');
                }

                // Psuedo-transclusion
                angular.forEach(attrs.$attr, function(attName, attIndex) {
                    newElement.attr(attName, attrs[attIndex]);
                });
                newElement.attr('name', getFormName());
                newElement.attr('model', attrs.ngModel);
                newElement.removeAttr('ng-model');

                angular.forEach(element[0].classList, function(clsName) {
                    newElement[0].classList.add(clsName);
                });
                newElement.addClass('vlocity-dynamic-form');
                //Disable the HTML5 form input validation
                newElement.attr('novalidate', true);

                // Update attribute on change event
                if(newElement.attr('form-on-change')){
                    changeCallback = $parse(newElement.attr('form-on-change'));
                    newElement.on('change', function(e) {
                        changeCallback($scope, {e:e, formValidation: $scope[getFormName()]});
                    });
                }

                // Transclude header and footer
                transcludeFn($scope, function(clone, scope) {
                    transcludeElement = angular.element('<div></div>').append(clone);
                });
                newElement.append(transcludeElement.find('header').html());
                newElement.append(element.contents());
                newElement.append(transcludeElement.find('footer').html());

                // Compile and update DOM
                $compile(newElement)($scope);
                element.replaceWith(newElement);
            }
        }
    };
}]);

},{}],3:[function(require,module,exports){
/**
 * @license AngularJS v1.5.5
 * (c) 2010-2016 Google, Inc. http://angularjs.org
 * License: MIT
 */
(function(window, angular) {'use strict';

/* jshint ignore:start */
// this code is in the core, but not in angular-messages.js
var isArray = angular.isArray;
var forEach = angular.forEach;
var isString = angular.isString;
var jqLite = angular.element;
/* jshint ignore:end */

/**
 * @ngdoc module
 * @name ngMessages
 * @description
 *
 * The `ngMessages` module provides enhanced support for displaying messages within templates
 * (typically within forms or when rendering message objects that return key/value data).
 * Instead of relying on JavaScript code and/or complex ng-if statements within your form template to
 * show and hide error messages specific to the state of an input field, the `ngMessages` and
 * `ngMessage` directives are designed to handle the complexity, inheritance and priority
 * sequencing based on the order of how the messages are defined in the template.
 *
 * Currently, the ngMessages module only contains the code for the `ngMessages`, `ngMessagesInclude`
 * `ngMessage` and `ngMessageExp` directives.
 *
 * # Usage
 * The `ngMessages` directive allows keys in a key/value collection to be associated with a child element
 * (or 'message') that will show or hide based on the truthiness of that key's value in the collection. A common use
 * case for `ngMessages` is to display error messages for inputs using the `$error` object exposed by the
 * {@link ngModel ngModel} directive.
 *
 * The child elements of the `ngMessages` directive are matched to the collection keys by a `ngMessage` or
 * `ngMessageExp` directive. The value of these attributes must match a key in the collection that is provided by
 * the `ngMessages` directive.
 *
 * Consider the following example, which illustrates a typical use case of `ngMessages`. Within the form `myForm` we
 * have a text input named `myField` which is bound to the scope variable `field` using the {@link ngModel ngModel}
 * directive.
 *
 * The `myField` field is a required input of type `email` with a maximum length of 15 characters.
 *
 * ```html
 * <form name="myForm">
 *   <label>
 *     Enter text:
 *     <input type="email" ng-model="field" name="myField" required maxlength="15" />
 *   </label>
 *   <div ng-messages="myForm.myField.$error" role="alert">
 *     <div ng-message="required">Please enter a value for this field.</div>
 *     <div ng-message="email">This field must be a valid email address.</div>
 *     <div ng-message="maxlength">This field can be at most 15 characters long.</div>
 *   </div>
 * </form>
 * ```
 *
 * In order to show error messages corresponding to `myField` we first create an element with an `ngMessages` attribute
 * set to the `$error` object owned by the `myField` input in our `myForm` form.
 *
 * Within this element we then create separate elements for each of the possible errors that `myField` could have.
 * The `ngMessage` attribute is used to declare which element(s) will appear for which error - for example,
 * setting `ng-message="required"` specifies that this particular element should be displayed when there
 * is no value present for the required field `myField` (because the key `required` will be `true` in the object
 * `myForm.myField.$error`).
 *
 * ### Message order
 *
 * By default, `ngMessages` will only display one message for a particular key/value collection at any time. If more
 * than one message (or error) key is currently true, then which message is shown is determined by the order of messages
 * in the HTML template code (messages declared first are prioritised). This mechanism means the developer does not have
 * to prioritise messages using custom JavaScript code.
 *
 * Given the following error object for our example (which informs us that the field `myField` currently has both the
 * `required` and `email` errors):
 *
 * ```javascript
 * <!-- keep in mind that ngModel automatically sets these error flags -->
 * myField.$error = { required : true, email: true, maxlength: false };
 * ```
 * The `required` message will be displayed to the user since it appears before the `email` message in the DOM.
 * Once the user types a single character, the `required` message will disappear (since the field now has a value)
 * but the `email` message will be visible because it is still applicable.
 *
 * ### Displaying multiple messages at the same time
 *
 * While `ngMessages` will by default only display one error element at a time, the `ng-messages-multiple` attribute can
 * be applied to the `ngMessages` container element to cause it to display all applicable error messages at once:
 *
 * ```html
 * <!-- attribute-style usage -->
 * <div ng-messages="myForm.myField.$error" ng-messages-multiple>...</div>
 *
 * <!-- element-style usage -->
 * <ng-messages for="myForm.myField.$error" multiple>...</ng-messages>
 * ```
 *
 * ## Reusing and Overriding Messages
 * In addition to prioritization, ngMessages also allows for including messages from a remote or an inline
 * template. This allows for generic collection of messages to be reused across multiple parts of an
 * application.
 *
 * ```html
 * <script type="text/ng-template" id="error-messages">
 *   <div ng-message="required">This field is required</div>
 *   <div ng-message="minlength">This field is too short</div>
 * </script>
 *
 * <div ng-messages="myForm.myField.$error" role="alert">
 *   <div ng-messages-include="error-messages"></div>
 * </div>
 * ```
 *
 * However, including generic messages may not be useful enough to match all input fields, therefore,
 * `ngMessages` provides the ability to override messages defined in the remote template by redefining
 * them within the directive container.
 *
 * ```html
 * <!-- a generic template of error messages known as "my-custom-messages" -->
 * <script type="text/ng-template" id="my-custom-messages">
 *   <div ng-message="required">This field is required</div>
 *   <div ng-message="minlength">This field is too short</div>
 * </script>
 *
 * <form name="myForm">
 *   <label>
 *     Email address
 *     <input type="email"
 *            id="email"
 *            name="myEmail"
 *            ng-model="email"
 *            minlength="5"
 *            required />
 *   </label>
 *   <!-- any ng-message elements that appear BEFORE the ng-messages-include will
 *        override the messages present in the ng-messages-include template -->
 *   <div ng-messages="myForm.myEmail.$error" role="alert">
 *     <!-- this required message has overridden the template message -->
 *     <div ng-message="required">You did not enter your email address</div>
 *
 *     <!-- this is a brand new message and will appear last in the prioritization -->
 *     <div ng-message="email">Your email address is invalid</div>
 *
 *     <!-- and here are the generic error messages -->
 *     <div ng-messages-include="my-custom-messages"></div>
 *   </div>
 * </form>
 * ```
 *
 * In the example HTML code above the message that is set on required will override the corresponding
 * required message defined within the remote template. Therefore, with particular input fields (such
 * email addresses, date fields, autocomplete inputs, etc...), specialized error messages can be applied
 * while more generic messages can be used to handle other, more general input errors.
 *
 * ## Dynamic Messaging
 * ngMessages also supports using expressions to dynamically change key values. Using arrays and
 * repeaters to list messages is also supported. This means that the code below will be able to
 * fully adapt itself and display the appropriate message when any of the expression data changes:
 *
 * ```html
 * <form name="myForm">
 *   <label>
 *     Email address
 *     <input type="email"
 *            name="myEmail"
 *            ng-model="email"
 *            minlength="5"
 *            required />
 *   </label>
 *   <div ng-messages="myForm.myEmail.$error" role="alert">
 *     <div ng-message="required">You did not enter your email address</div>
 *     <div ng-repeat="errorMessage in errorMessages">
 *       <!-- use ng-message-exp for a message whose key is given by an expression -->
 *       <div ng-message-exp="errorMessage.type">{{ errorMessage.text }}</div>
 *     </div>
 *   </div>
 * </form>
 * ```
 *
 * The `errorMessage.type` expression can be a string value or it can be an array so
 * that multiple errors can be associated with a single error message:
 *
 * ```html
 *   <label>
 *     Email address
 *     <input type="email"
 *            ng-model="data.email"
 *            name="myEmail"
 *            ng-minlength="5"
 *            ng-maxlength="100"
 *            required />
 *   </label>
 *   <div ng-messages="myForm.myEmail.$error" role="alert">
 *     <div ng-message-exp="'required'">You did not enter your email address</div>
 *     <div ng-message-exp="['minlength', 'maxlength']">
 *       Your email must be between 5 and 100 characters long
 *     </div>
 *   </div>
 * ```
 *
 * Feel free to use other structural directives such as ng-if and ng-switch to further control
 * what messages are active and when. Be careful, if you place ng-message on the same element
 * as these structural directives, Angular may not be able to determine if a message is active
 * or not. Therefore it is best to place the ng-message on a child element of the structural
 * directive.
 *
 * ```html
 * <div ng-messages="myForm.myEmail.$error" role="alert">
 *   <div ng-if="showRequiredError">
 *     <div ng-message="required">Please enter something</div>
 *   </div>
 * </div>
 * ```
 *
 * ## Animations
 * If the `ngAnimate` module is active within the application then the `ngMessages`, `ngMessage` and
 * `ngMessageExp` directives will trigger animations whenever any messages are added and removed from
 * the DOM by the `ngMessages` directive.
 *
 * Whenever the `ngMessages` directive contains one or more visible messages then the `.ng-active` CSS
 * class will be added to the element. The `.ng-inactive` CSS class will be applied when there are no
 * messages present. Therefore, CSS transitions and keyframes as well as JavaScript animations can
 * hook into the animations whenever these classes are added/removed.
 *
 * Let's say that our HTML code for our messages container looks like so:
 *
 * ```html
 * <div ng-messages="myMessages" class="my-messages" role="alert">
 *   <div ng-message="alert" class="some-message">...</div>
 *   <div ng-message="fail" class="some-message">...</div>
 * </div>
 * ```
 *
 * Then the CSS animation code for the message container looks like so:
 *
 * ```css
 * .my-messages {
 *   transition:1s linear all;
 * }
 * .my-messages.ng-active {
 *   // messages are visible
 * }
 * .my-messages.ng-inactive {
 *   // messages are hidden
 * }
 * ```
 *
 * Whenever an inner message is attached (becomes visible) or removed (becomes hidden) then the enter
 * and leave animation is triggered for each particular element bound to the `ngMessage` directive.
 *
 * Therefore, the CSS code for the inner messages looks like so:
 *
 * ```css
 * .some-message {
 *   transition:1s linear all;
 * }
 *
 * .some-message.ng-enter {}
 * .some-message.ng-enter.ng-enter-active {}
 *
 * .some-message.ng-leave {}
 * .some-message.ng-leave.ng-leave-active {}
 * ```
 *
 * {@link ngAnimate Click here} to learn how to use JavaScript animations or to learn more about ngAnimate.
 */
angular.module('ngMessages', [])

   /**
    * @ngdoc directive
    * @module ngMessages
    * @name ngMessages
    * @restrict AE
    *
    * @description
    * `ngMessages` is a directive that is designed to show and hide messages based on the state
    * of a key/value object that it listens on. The directive itself complements error message
    * reporting with the `ngModel` $error object (which stores a key/value state of validation errors).
    *
    * `ngMessages` manages the state of internal messages within its container element. The internal
    * messages use the `ngMessage` directive and will be inserted/removed from the page depending
    * on if they're present within the key/value object. By default, only one message will be displayed
    * at a time and this depends on the prioritization of the messages within the template. (This can
    * be changed by using the `ng-messages-multiple` or `multiple` attribute on the directive container.)
    *
    * A remote template can also be used to promote message reusability and messages can also be
    * overridden.
    *
    * {@link module:ngMessages Click here} to learn more about `ngMessages` and `ngMessage`.
    *
    * @usage
    * ```html
    * <!-- using attribute directives -->
    * <ANY ng-messages="expression" role="alert">
    *   <ANY ng-message="stringValue">...</ANY>
    *   <ANY ng-message="stringValue1, stringValue2, ...">...</ANY>
    *   <ANY ng-message-exp="expressionValue">...</ANY>
    * </ANY>
    *
    * <!-- or by using element directives -->
    * <ng-messages for="expression" role="alert">
    *   <ng-message when="stringValue">...</ng-message>
    *   <ng-message when="stringValue1, stringValue2, ...">...</ng-message>
    *   <ng-message when-exp="expressionValue">...</ng-message>
    * </ng-messages>
    * ```
    *
    * @param {string} ngMessages an angular expression evaluating to a key/value object
    *                 (this is typically the $error object on an ngModel instance).
    * @param {string=} ngMessagesMultiple|multiple when set, all messages will be displayed with true
    *
    * @example
    * <example name="ngMessages-directive" module="ngMessagesExample"
    *          deps="angular-messages.js"
    *          animations="true" fixBase="true">
    *   <file name="index.html">
    *     <form name="myForm">
    *       <label>
    *         Enter your name:
    *         <input type="text"
    *                name="myName"
    *                ng-model="name"
    *                ng-minlength="5"
    *                ng-maxlength="20"
    *                required />
    *       </label>
    *       <pre>myForm.myName.$error = {{ myForm.myName.$error | json }}</pre>
    *
    *       <div ng-messages="myForm.myName.$error" style="color:maroon" role="alert">
    *         <div ng-message="required">You did not enter a field</div>
    *         <div ng-message="minlength">Your field is too short</div>
    *         <div ng-message="maxlength">Your field is too long</div>
    *       </div>
    *     </form>
    *   </file>
    *   <file name="script.js">
    *     angular.module('ngMessagesExample', ['ngMessages']);
    *   </file>
    * </example>
    */
   .directive('ngMessages', ['$animate', function($animate) {
     var ACTIVE_CLASS = 'ng-active';
     var INACTIVE_CLASS = 'ng-inactive';

     return {
       require: 'ngMessages',
       restrict: 'AE',
       controller: ['$element', '$scope', '$attrs', function($element, $scope, $attrs) {
         var ctrl = this;
         var latestKey = 0;
         var nextAttachId = 0;

         this.getAttachId = function getAttachId() { return nextAttachId++; };

         var messages = this.messages = {};
         var renderLater, cachedCollection;

         this.render = function(collection) {
           collection = collection || {};

           renderLater = false;
           cachedCollection = collection;

           // this is true if the attribute is empty or if the attribute value is truthy
           var multiple = isAttrTruthy($scope, $attrs.ngMessagesMultiple) ||
                          isAttrTruthy($scope, $attrs.multiple);

           var unmatchedMessages = [];
           var matchedKeys = {};
           var messageItem = ctrl.head;
           var messageFound = false;
           var totalMessages = 0;

           // we use != instead of !== to allow for both undefined and null values
           while (messageItem != null) {
             totalMessages++;
             var messageCtrl = messageItem.message;

             var messageUsed = false;
             if (!messageFound) {
               forEach(collection, function(value, key) {
                 if (!messageUsed && truthy(value) && messageCtrl.test(key)) {
                   // this is to prevent the same error name from showing up twice
                   if (matchedKeys[key]) return;
                   matchedKeys[key] = true;

                   messageUsed = true;
                   messageCtrl.attach();
                 }
               });
             }

             if (messageUsed) {
               // unless we want to display multiple messages then we should
               // set a flag here to avoid displaying the next message in the list
               messageFound = !multiple;
             } else {
               unmatchedMessages.push(messageCtrl);
             }

             messageItem = messageItem.next;
           }

           forEach(unmatchedMessages, function(messageCtrl) {
             messageCtrl.detach();
           });

           unmatchedMessages.length !== totalMessages
              ? $animate.setClass($element, ACTIVE_CLASS, INACTIVE_CLASS)
              : $animate.setClass($element, INACTIVE_CLASS, ACTIVE_CLASS);
         };

         $scope.$watchCollection($attrs.ngMessages || $attrs['for'], ctrl.render);

         // If the element is destroyed, proactively destroy all the currently visible messages
         $element.on('$destroy', function() {
           forEach(messages, function(item) {
             item.message.detach();
           });
         });

         this.reRender = function() {
           if (!renderLater) {
             renderLater = true;
             $scope.$evalAsync(function() {
               if (renderLater) {
                 cachedCollection && ctrl.render(cachedCollection);
               }
             });
           }
         };

         this.register = function(comment, messageCtrl) {
           var nextKey = latestKey.toString();
           messages[nextKey] = {
             message: messageCtrl
           };
           insertMessageNode($element[0], comment, nextKey);
           comment.$$ngMessageNode = nextKey;
           latestKey++;

           ctrl.reRender();
         };

         this.deregister = function(comment) {
           var key = comment.$$ngMessageNode;
           delete comment.$$ngMessageNode;
           removeMessageNode($element[0], comment, key);
           delete messages[key];
           ctrl.reRender();
         };

         function findPreviousMessage(parent, comment) {
           var prevNode = comment;
           var parentLookup = [];

           while (prevNode && prevNode !== parent) {
             var prevKey = prevNode.$$ngMessageNode;
             if (prevKey && prevKey.length) {
               return messages[prevKey];
             }

             // dive deeper into the DOM and examine its children for any ngMessage
             // comments that may be in an element that appears deeper in the list
             if (prevNode.childNodes.length && parentLookup.indexOf(prevNode) == -1) {
               parentLookup.push(prevNode);
               prevNode = prevNode.childNodes[prevNode.childNodes.length - 1];
             } else if (prevNode.previousSibling) {
               prevNode = prevNode.previousSibling;
             } else {
               prevNode = prevNode.parentNode;
               parentLookup.push(prevNode);
             }
           }
         }

         function insertMessageNode(parent, comment, key) {
           var messageNode = messages[key];
           if (!ctrl.head) {
             ctrl.head = messageNode;
           } else {
             var match = findPreviousMessage(parent, comment);
             if (match) {
               messageNode.next = match.next;
               match.next = messageNode;
             } else {
               messageNode.next = ctrl.head;
               ctrl.head = messageNode;
             }
           }
         }

         function removeMessageNode(parent, comment, key) {
           var messageNode = messages[key];

           var match = findPreviousMessage(parent, comment);
           if (match) {
             match.next = messageNode.next;
           } else {
             ctrl.head = messageNode.next;
           }
         }
       }]
     };

     function isAttrTruthy(scope, attr) {
      return (isString(attr) && attr.length === 0) || //empty attribute
             truthy(scope.$eval(attr));
     }

     function truthy(val) {
       return isString(val) ? val.length : !!val;
     }
   }])

   /**
    * @ngdoc directive
    * @name ngMessagesInclude
    * @restrict AE
    * @scope
    *
    * @description
    * `ngMessagesInclude` is a directive with the purpose to import existing ngMessage template
    * code from a remote template and place the downloaded template code into the exact spot
    * that the ngMessagesInclude directive is placed within the ngMessages container. This allows
    * for a series of pre-defined messages to be reused and also allows for the developer to
    * determine what messages are overridden due to the placement of the ngMessagesInclude directive.
    *
    * @usage
    * ```html
    * <!-- using attribute directives -->
    * <ANY ng-messages="expression" role="alert">
    *   <ANY ng-messages-include="remoteTplString">...</ANY>
    * </ANY>
    *
    * <!-- or by using element directives -->
    * <ng-messages for="expression" role="alert">
    *   <ng-messages-include src="expressionValue1">...</ng-messages-include>
    * </ng-messages>
    * ```
    *
    * {@link module:ngMessages Click here} to learn more about `ngMessages` and `ngMessage`.
    *
    * @param {string} ngMessagesInclude|src a string value corresponding to the remote template.
    */
   .directive('ngMessagesInclude',
     ['$templateRequest', '$document', '$compile', function($templateRequest, $document, $compile) {

     return {
       restrict: 'AE',
       require: '^^ngMessages', // we only require this for validation sake
       link: function($scope, element, attrs) {
         var src = attrs.ngMessagesInclude || attrs.src;
         $templateRequest(src).then(function(html) {
           $compile(html)($scope, function(contents) {
             element.after(contents);

             // the anchor is placed for debugging purposes
             var comment = $compile.$$createComment ?
                 $compile.$$createComment('ngMessagesInclude', src) :
                 $document[0].createComment(' ngMessagesInclude: ' + src + ' ');
             var anchor = jqLite(comment);
             element.after(anchor);

             // we don't want to pollute the DOM anymore by keeping an empty directive element
             element.remove();
           });
         });
       }
     };
   }])

   /**
    * @ngdoc directive
    * @name ngMessage
    * @restrict AE
    * @scope
    *
    * @description
    * `ngMessage` is a directive with the purpose to show and hide a particular message.
    * For `ngMessage` to operate, a parent `ngMessages` directive on a parent DOM element
    * must be situated since it determines which messages are visible based on the state
    * of the provided key/value map that `ngMessages` listens on.
    *
    * More information about using `ngMessage` can be found in the
    * {@link module:ngMessages `ngMessages` module documentation}.
    *
    * @usage
    * ```html
    * <!-- using attribute directives -->
    * <ANY ng-messages="expression" role="alert">
    *   <ANY ng-message="stringValue">...</ANY>
    *   <ANY ng-message="stringValue1, stringValue2, ...">...</ANY>
    * </ANY>
    *
    * <!-- or by using element directives -->
    * <ng-messages for="expression" role="alert">
    *   <ng-message when="stringValue">...</ng-message>
    *   <ng-message when="stringValue1, stringValue2, ...">...</ng-message>
    * </ng-messages>
    * ```
    *
    * @param {expression} ngMessage|when a string value corresponding to the message key.
    */
  .directive('ngMessage', ngMessageDirectiveFactory())


   /**
    * @ngdoc directive
    * @name ngMessageExp
    * @restrict AE
    * @priority 1
    * @scope
    *
    * @description
    * `ngMessageExp` is a directive with the purpose to show and hide a particular message.
    * For `ngMessageExp` to operate, a parent `ngMessages` directive on a parent DOM element
    * must be situated since it determines which messages are visible based on the state
    * of the provided key/value map that `ngMessages` listens on.
    *
    * @usage
    * ```html
    * <!-- using attribute directives -->
    * <ANY ng-messages="expression">
    *   <ANY ng-message-exp="expressionValue">...</ANY>
    * </ANY>
    *
    * <!-- or by using element directives -->
    * <ng-messages for="expression">
    *   <ng-message when-exp="expressionValue">...</ng-message>
    * </ng-messages>
    * ```
    *
    * {@link module:ngMessages Click here} to learn more about `ngMessages` and `ngMessage`.
    *
    * @param {expression} ngMessageExp|whenExp an expression value corresponding to the message key.
    */
  .directive('ngMessageExp', ngMessageDirectiveFactory());

function ngMessageDirectiveFactory() {
  return ['$animate', function($animate) {
    return {
      restrict: 'AE',
      transclude: 'element',
      priority: 1, // must run before ngBind, otherwise the text is set on the comment
      terminal: true,
      require: '^^ngMessages',
      link: function(scope, element, attrs, ngMessagesCtrl, $transclude) {
        var commentNode = element[0];

        var records;
        var staticExp = attrs.ngMessage || attrs.when;
        var dynamicExp = attrs.ngMessageExp || attrs.whenExp;
        var assignRecords = function(items) {
          records = items
              ? (isArray(items)
                    ? items
                    : items.split(/[\s,]+/))
              : null;
          ngMessagesCtrl.reRender();
        };

        if (dynamicExp) {
          assignRecords(scope.$eval(dynamicExp));
          scope.$watchCollection(dynamicExp, assignRecords);
        } else {
          assignRecords(staticExp);
        }

        var currentElement, messageCtrl;
        ngMessagesCtrl.register(commentNode, messageCtrl = {
          test: function(name) {
            return contains(records, name);
          },
          attach: function() {
            if (!currentElement) {
              $transclude(scope, function(elm) {
                $animate.enter(elm, null, element);
                currentElement = elm;

                // Each time we attach this node to a message we get a new id that we can match
                // when we are destroying the node later.
                var $$attachId = currentElement.$$attachId = ngMessagesCtrl.getAttachId();

                // in the event that the element or a parent element is destroyed
                // by another structural directive then it's time
                // to deregister the message from the controller
                currentElement.on('$destroy', function() {
                  if (currentElement && currentElement.$$attachId === $$attachId) {
                    ngMessagesCtrl.deregister(commentNode);
                    messageCtrl.detach();
                  }
                });
              });
            }
          },
          detach: function() {
            if (currentElement) {
              var elm = currentElement;
              currentElement = null;
              $animate.leave(elm);
            }
          }
        });
      }
    };
  }];

  function contains(collection, key) {
    if (collection) {
      return isArray(collection)
          ? collection.indexOf(key) >= 0
          : collection.hasOwnProperty(key);
    }
  }
}


})(window, window.angular);

},{}],4:[function(require,module,exports){
/*!
 * angular-ui-mask
 * https://github.com/angular-ui/ui-mask
 * Version: 1.8.7 - 2016-07-26T15:59:07.992Z
 * License: MIT
 */
!function(){"use strict";angular.module("ui.mask",[]).value("uiMaskConfig",{maskDefinitions:{9:/\d/,A:/[a-zA-Z]/,"*":/[a-zA-Z0-9]/},clearOnBlur:!0,clearOnBlurPlaceholder:!1,escChar:"\\",eventsToHandle:["input","keyup","click","focus"],addDefaultPlaceholder:!0,allowInvalidValue:!1}).provider("uiMask.Config",function(){var e={};this.maskDefinitions=function(n){return e.maskDefinitions=n},this.clearOnBlur=function(n){return e.clearOnBlur=n},this.clearOnBlurPlaceholder=function(n){return e.clearOnBlurPlaceholder=n},this.eventsToHandle=function(n){return e.eventsToHandle=n},this.addDefaultPlaceholder=function(n){return e.addDefaultPlaceholder=n},this.allowInvalidValue=function(n){return e.allowInvalidValue=n},this.$get=["uiMaskConfig",function(n){var t=n;for(var a in e)angular.isObject(e[a])&&!angular.isArray(e[a])?angular.extend(t[a],e[a]):t[a]=e[a];return t}]}).directive("uiMask",["uiMask.Config",function(e){function n(e){return e===document.activeElement&&(!document.hasFocus||document.hasFocus())&&!!(e.type||e.href||~e.tabIndex)}return{priority:100,require:"ngModel",restrict:"A",compile:function(){var t=angular.copy(e);return function(e,a,i,r){function l(e){return angular.isDefined(e)?(w(e),K?(h(),d(),!0):f()):f()}function u(e){e&&(T=e,!K||0===a.val().length&&angular.isDefined(i.placeholder)||a.val(m(p(a.val()))))}function o(){return l(i.uiMask)}function c(e){return K?(j=p(e||""),R=g(j),r.$setValidity("mask",R),j.length&&(R||Q.allowInvalidValue)?m(j):void 0):e}function s(e){return K?(j=p(e||""),R=g(j),r.$viewValue=j.length?m(j):"",r.$setValidity("mask",R),R||Q.allowInvalidValue?J?r.$viewValue:j:void 0):e}function f(){return K=!1,v(),angular.isDefined(q)?a.attr("placeholder",q):a.removeAttr("placeholder"),angular.isDefined(W)?a.attr("maxlength",W):a.removeAttr("maxlength"),a.val(r.$modelValue),r.$viewValue=r.$modelValue,!1}function h(){j=F=p(r.$modelValue||""),H=_=m(j),R=g(j),i.maxlength&&a.attr("maxlength",2*S[S.length-1]),!q&&Q.addDefaultPlaceholder&&a.attr("placeholder",T);for(var e=r.$modelValue,n=r.$formatters.length;n--;)e=r.$formatters[n](e);r.$viewValue=e||"",r.$render()}function d(){Z||(a.bind("blur",y),a.bind("mousedown mouseup",V),a.bind("keydown",M),a.bind(Q.eventsToHandle.join(" "),O),Z=!0)}function v(){Z&&(a.unbind("blur",y),a.unbind("mousedown",V),a.unbind("mouseup",V),a.unbind("keydown",M),a.unbind("input",O),a.unbind("keyup",O),a.unbind("click",O),a.unbind("focus",O),Z=!1)}function g(e){return e.length?e.length>=I:!0}function p(e){var n,t,i="",r=a[0],l=A.slice(),u=L,o=u+C(r),c="";return e=e.toString(),n=0,t=e.length-T.length,angular.forEach(B,function(a){var i=a.position;i>=u&&o>i||(i>=u&&(i+=t),e.substring(i,i+a.value.length)===a.value&&(c+=e.slice(n,i),n=i+a.value.length))}),e=c+e.slice(n),angular.forEach(e.split(""),function(e){l.length&&l[0].test(e)&&(i+=e,l.shift())}),i}function m(e){var n="",t=S.slice();return angular.forEach(T.split(""),function(a,i){e.length&&i===t[0]?(n+=e.charAt(0)||"_",e=e.substr(1),t.shift()):n+=a}),n}function b(e){var n,t=angular.isDefined(i.uiMaskPlaceholder)?i.uiMaskPlaceholder:i.placeholder;return angular.isDefined(t)&&t[e]?t[e]:(n=angular.isDefined(i.uiMaskPlaceholderChar)&&i.uiMaskPlaceholderChar?i.uiMaskPlaceholderChar:"_","space"===n.toLowerCase()?" ":n[0])}function k(){var e,n,t=T.split("");S&&!isNaN(S[0])&&angular.forEach(S,function(e){t[e]="_"}),e=t.join(""),n=e.replace(/[_]+/g,"_").split("_"),n=n.filter(function(e){return""!==e});var a=0;return n.map(function(n){var t=e.indexOf(n,a);return a=t+1,{value:n,position:t}})}function w(e){var n=0;if(S=[],A=[],T="",angular.isString(e)){I=0;var t=!1,a=0,i=e.split(""),r=!1;angular.forEach(i,function(e,i){r?(r=!1,T+=e,n++):Q.escChar===e?r=!0:Q.maskDefinitions[e]?(S.push(n),T+=b(i-a),A.push(Q.maskDefinitions[e]),n++,t||I++,t=!1):"?"===e?(t=!0,a++):(T+=e,n++)})}S.push(S.slice().pop()+1),B=k(),K=S.length>1?!0:!1}function y(){if((Q.clearOnBlur||Q.clearOnBlurPlaceholder&&0===j.length&&i.placeholder)&&(L=0,N=0,R&&0!==j.length||(H="",a.val(""),e.$apply(function(){r.$pristine||r.$setViewValue("")}))),j!==U){var n=a.val(),t=""===j&&n&&angular.isDefined(i.uiMaskPlaceholderChar)&&"space"===i.uiMaskPlaceholderChar;t&&a.val(""),$(a[0]),t&&a.val(n)}U=j}function $(e){var n;if(angular.isFunction(window.Event)&&!e.fireEvent)try{n=new Event("change",{view:window,bubbles:!0,cancelable:!1})}catch(t){n=document.createEvent("HTMLEvents"),n.initEvent("change",!1,!0)}finally{e.dispatchEvent(n)}else"createEvent"in document?(n=document.createEvent("HTMLEvents"),n.initEvent("change",!1,!0),e.dispatchEvent(n)):e.fireEvent&&e.fireEvent("onchange")}function V(e){"mousedown"===e.type?a.bind("mouseout",E):a.unbind("mouseout",E)}function E(){N=C(this),a.unbind("mouseout",E)}function M(e){var n=8===e.which,t=P(this)-1||0,i=90===e.which&&e.ctrlKey;if(n){for(;t>=0;){if(D(t)){x(this,t+1);break}t--}z=-1===t}i&&(a.val(""),e.preventDefault())}function O(n){n=n||{};var t=n.which,i=n.type;if(16!==t&&91!==t){var l,u=a.val(),o=_,c=!1,s=p(u),f=F,h=P(this)||0,d=L||0,v=h-d,g=S[0],b=S[s.length]||S.slice().shift(),k=N||0,w=C(this)>0,y=k>0,$=u.length>o.length||k&&u.length>o.length-k,V=u.length<o.length||k&&u.length===o.length-k,E=t>=37&&40>=t&&n.shiftKey,M=37===t,O=8===t||"keyup"!==i&&V&&-1===v,A=46===t||"keyup"!==i&&V&&0===v&&!y,B=(M||O||"click"===i)&&h>g;if(N=C(this),!E&&(!w||"click"!==i&&"keyup"!==i&&"focus"!==i)){if(O&&z)return a.val(T),e.$apply(function(){r.$setViewValue("")}),void x(this,d);if("input"===i&&V&&!y&&s===f){for(;O&&h>g&&!D(h);)h--;for(;A&&b>h&&-1===S.indexOf(h);)h++;var I=S.indexOf(h);s=s.substring(0,I)+s.substring(I+1),s!==f&&(c=!0)}for(l=m(s),_=l,F=s,!c&&u.length>l.length&&(c=!0),a.val(l),c&&e.$apply(function(){r.$setViewValue(l)}),$&&g>=h&&(h=g+1),B&&h--,h=h>b?b:g>h?g:h;!D(h)&&h>g&&b>h;)h+=B?-1:1;(B&&b>h||$&&!D(d))&&h++,L=h,x(this,h)}}}function D(e){return S.indexOf(e)>-1}function P(e){if(!e)return 0;if(void 0!==e.selectionStart)return e.selectionStart;if(document.selection&&n(a[0])){e.focus();var t=document.selection.createRange();return t.moveStart("character",e.value?-e.value.length:0),t.text.length}return 0}function x(e,t){if(!e)return 0;if(0!==e.offsetWidth&&0!==e.offsetHeight)if(e.setSelectionRange)n(a[0])&&(e.focus(),e.setSelectionRange(t,t));else if(e.createTextRange){var i=e.createTextRange();i.collapse(!0),i.moveEnd("character",t),i.moveStart("character",t),i.select()}}function C(e){return e?void 0!==e.selectionStart?e.selectionEnd-e.selectionStart:window.getSelection?window.getSelection().toString().length:document.selection?document.selection.createRange().text.length:0:0}var S,A,T,B,I,j,H,R,_,F,L,N,z,K=!1,Z=!1,q=i.placeholder,W=i.maxlength,G=r.$isEmpty;r.$isEmpty=function(e){return G(K?p(e||""):e)};var J=!1;i.$observe("modelViewValue",function(e){"true"===e&&(J=!0)}),i.$observe("allowInvalidValue",function(e){Q.allowInvalidValue=""===e?!0:!!e,c(r.$modelValue)});var Q={};i.uiOptions?(Q=e.$eval("["+i.uiOptions+"]"),Q=angular.isObject(Q[0])?function(e,n){for(var t in e)Object.prototype.hasOwnProperty.call(e,t)&&(void 0===n[t]?n[t]=angular.copy(e[t]):angular.isObject(n[t])&&!angular.isArray(n[t])&&(n[t]=angular.extend({},e[t],n[t])));return n}(t,Q[0]):t):Q=t,i.$observe("uiMask",l),angular.isDefined(i.uiMaskPlaceholder)?i.$observe("uiMaskPlaceholder",u):i.$observe("placeholder",u),angular.isDefined(i.uiMaskPlaceholderChar)&&i.$observe("uiMaskPlaceholderChar",o),r.$formatters.unshift(c),r.$parsers.unshift(s);var U=a.val();a.bind("mousedown mouseup",V),Array.prototype.indexOf||(Array.prototype.indexOf=function(e){if(null===this)throw new TypeError;var n=Object(this),t=n.length>>>0;if(0===t)return-1;var a=0;if(arguments.length>1&&(a=Number(arguments[1]),a!==a?a=0:0!==a&&a!==1/0&&a!==-(1/0)&&(a=(a>0||-1)*Math.floor(Math.abs(a)))),a>=t)return-1;for(var i=a>=0?a:Math.max(t-Math.abs(a),0);t>i;i++)if(i in n&&n[i]===e)return i;return-1})}}}}])}();
},{}],5:[function(require,module,exports){
angular.module("VlocityDynamicForm").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("CheckboxFieldsetTemplate.tpl.html",'<fieldset class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true" vdf-element-container="true">\n    <legend class="slds-form-element__legend slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        <label class="slds-form-element__label">\n            {{::field.label}}\n        </label>\n        <div class="slds-form-element__icon" ng-if="::field.description">\n            <a href="javascript:void(0);" \n                    slds-popover \n                    data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"  \n                    nubbin-direction="bottom-left" \n                    tooltip="true" \n                    data-title="{{::field.description}}">\n                <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                <span class="slds-assistive-text">Help</span>\n            </a>\n        </div>\n    </legend>\n    <div class="slds-form-element__control" vdf-fieldset-wrapper="true">\n        <label class="slds-checkbox" vdf-fieldset-element="true">\n            <input type="checkbox" name="options" vdf-input="true">\n            <span class="slds-checkbox--faux"></span>\n            <span class="slds-form-element__label" vdf-checkbox-label="true">Checkbox Label</span>\n        </label>\n        \n        <div class="visible-content"></div>\n        <div class="extend-content" ng-show="!expand[field.label]"></div>\n\n        <a ng-if="showMore[field.label]" ng-click="expand[field.label] = !expand[field.label]">\n            <small ng-show="expand[field.label]">\n                <slds-button-svg-icon sprite="\'utility\'" icon="\'jump_to_bottom\'"></slds-button-svg-icon> Show More\n            </small>\n            <small ng-show="!expand[field.label]">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'jump_to_top\'"></slds-button-svg-icon> Show Less\n            </small>\n        </a>\n    </div>\n\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">This field is required.</div>\n    </div>\n</fieldset>\n'),$templateCache.put("CheckboxTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true" vdf-element-container="true">\n    <div class="slds-form-element__control">\n        <label class="slds-checkbox">\n            <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n            <input type="checkbox" name="options" vdf-input="true"/>\n            <span class="slds-checkbox--faux"></span>\n            <span class="slds-form-element__label">{{::field.label}}</span>\n        </label>\n        <div class="slds-form-element__icon" ng-if="::field.description">\n            <a href="javascript:void(0);" \n                    slds-popover \n                    data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"  \n                    nubbin-direction="bottom-left" \n                    tooltip="true" \n                    data-title="{{::field.description}}">\n                <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                <span class="slds-assistive-text">Help</span>\n            </a>\n        </div>\n    </div>\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">This field is required.</div>\n    </div>\n</div>'),$templateCache.put("DateRangeTemplate.tpl.html",'<div class="slds-form-element"  vdf-element-container="true">\n    <label class="slds-text-heading--label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        {{::field.label}}\n    </label>\n\n    <div class="slds-form-element__control" ng-show="field.min === field.max">\n        <label class="slds-checkbox">\n            <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n            <input vdf-input="true" data-vdf-only type="checkbox" name="options"/>\n            <span class="slds-checkbox--faux"></span>\n            <span class="slds-form-element__label">{{field.value}}</span>\n        </label>\n    </div>\n\n    <div class="slds-form-element__control slds-grid slds-wrap slds-grid--pull-padded" ng-show="field.min !== field.max">\n        <div class="slds-form-element__control slds-col--padded slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--6-of-12" >\n            <label>From</label>\n            <div class="slds-grid">\n                <input data-vdf-min vdf-input="true" vdf-input-name="true" placeholder="Date"\n                    class="slds-input" ng-class="{\'slds-size--1-of-2 slds-m-around--x-small\': field.type==\'datetime-range\'}" />\n                <input ng-show="field.type==\'datetime-range\'" time-vdf-min vdf-time="true" vdf-input="true" placeholder="Time"\n                    class="slds-input slds-size--1-of-2 slds-m-around--x-small"/>\n            </div>\n        </div>\n        <div class="slds-form-element__control slds-col--padded slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--6-of-12">\n            <label>To</label>\n            <div class="slds-grid">\n                <input data-vdf-max vdf-input="true" vdf-input-name="true" placeholder="Date"\n                    class="slds-input" ng-class="{\'slds-size--1-of-2 slds-m-around--x-small\': field.type==\'datetime-range\'}" />\n                <input ng-show="field.type==\'datetime-range\'" time-vdf-max vdf-time="true" vdf-input="true" placeholder="Time"\n                    class="slds-input slds-size--1-of-2 slds-m-around--x-small"/>\n            </div>\n        </div>\n    </div>\n</div>'),$templateCache.put("DateTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true">\n    <label class="slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>&#160;\n        {{::field.label}}\n    </label>\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);"\n                slds-popover\n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"\n                nubbin-direction="bottom-left"\n                tooltip="true"\n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n    \n    <div class="slds-form-element__control">\n    <!-- data-container attribute enables the datepicker modal to get the priority. Without data-container, datepicker modal will be hidden(partially) in a container when overflow-y:scroll -->\n        <input type="text" class="slds-input" vdf-input="true" autocomplete="off" data-container="{{attrs.dateContainer}}"/> \n    </div>\n\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">Please enter a value for this field.</div>\n        <div class="slds-form-element__help" ng-message="date">Please enter a valid date.</div>\n    </div>\n</div>'),$templateCache.put("DateTimeTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true">\n    <label class="slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>&#160;\n        {{::field.label}}\n    </label>\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);"\n                slds-popover\n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"\n                nubbin-direction="bottom-left"\n                tooltip="true"\n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n\n    <div class="slds-form-element__control slds-grid slds-wrap slds-grid--pull-padded-x-small">\n        <div class="slds-size--1-of-1 slds-medium-size--1-of-2 slds-p-around--x-small">\n            <input type="text" vdf-input="true" vdf-data="true" class="slds-input" autocomplete="off" data-container="{{attrs.dateContainer}}"/>\n        </div>\n        <div class="slds-size--1-of-1 slds-medium-size--1-of-2 slds-p-around--x-small">\n            <input type="text" vdf-input="true" vdf-time="true"  class="slds-input" autocomplete="off" data-container="{{attrs.dateContainer}}"/>\n        </div>\n    </div>\n\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">Please enter a value for this field.</div>\n        <div class="slds-form-element__help" ng-message="date">Please enter a valid date.</div>\n    </div>\n</div>'),$templateCache.put("InputTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true">\n    <label class="slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        {{::field.label}}\n    </label>\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);" \n                slds-popover \n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}" \n                nubbin-direction="bottom-left" \n                tooltip="true" \n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n    <div class="slds-form-element__control slds-input-has-fixed-addon">\n        <span class="slds-form-element__addon" ng-if="::field.dataType == \'currency\'" ng-bind-html="::localeCurencySym"></span>\n        <input vdf-input="true" vdf-input-name="true" class="slds-input" type="text"/>\n        <span class="slds-form-element__addon" ng-if="::field.dataType == \'percentage\'">%</span>\n    </div>\n\n    <!-- Error status: {{[[vdf-form-field-name]] | json}} -->\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">Please enter a value for this field</div>\n        <div class="slds-form-element__help" ng-message="invalid">Please enter a value for this invalid field</div>\n        <div class="slds-form-element__help" ng-message="email">Please enter a valid email address</div>\n        <div class="slds-form-element__help" ng-message="number">Please enter a valid number</div>\n        <div class="slds-form-element__help" ng-message="min">\n            This field value is too small <span ng-if="::field.min">(minimum is {{::field.min}})</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="max">\n            This field value is too high <span ng-if="::field.max">(maximum is {{::field.max}})</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="minlength">\n            This field is too short <span ng-if="field.minLength">(minimum is {{field.minLength}} characters)</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="maxlength">\n            This field is too long <span ng-if="field.maxLength">(maximum is {{field.maxLength}} characters)</span>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("RadioFieldsetTemplate.tpl.html",'<fieldset class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true" vdf-element-container="true">\n    <legend class="slds-form-element__legend slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        <label class="slds-form-element__label">\n            {{::field.label}}\n        </label>\n        <div class="slds-form-element__icon" ng-if="::field.description">\n            <a href="javascript:void(0);" \n                    slds-popover \n                    data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"  \n                    nubbin-direction="bottom-left" \n                    tooltip="true" \n                    data-title="{{::field.description}}">\n                <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n                <span class="slds-assistive-text">Help</span>\n            </a>\n        </div>\n    </legend>\n    <div class="slds-form-element__control" vdf-fieldset-wrapper="true">\n        <label class="slds-radio" vdf-fieldset-element="true">\n            <input type="radio" name="options" vdf-input="true"/>\n            <span class="slds-radio--faux"></span>\n            <span class="slds-form-element__label" vdf-radio-label="true">Radio Label One</span>\n        </label>\n        <div class="visible-content"></div>\n        <div class="extend-content" ng-show="!expand[field.label]"></div>\n\n        <a ng-if="showMore[field.label]" ng-click="expand[field.label] = !expand[field.label]">\n            <small ng-show="expand[field.label]">\n                <slds-button-svg-icon sprite="\'utility\'" icon="\'jump_to_bottom\'"></slds-button-svg-icon> Show More\n            </small>\n            <small ng-show="!expand[field.label]">\n                <slds-button-svg-icon sprite="\'utility\'" size="\'small\'" icon="\'jump_to_top\'"></slds-button-svg-icon> Show Less\n            </small>\n        </a>\n    </div>\n\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">This field is required.</div>\n    </div>\n</fieldset>\n'),$templateCache.put("RangeInputTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true">\n    <label class="slds-text-heading--label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        {{::field.label}}\n    </label>\n\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);" \n                slds-popover \n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"  \n                nubbin-direction="bottom-left" \n                tooltip="true" \n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n\n    <!-- Work in progress code -->\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);">\n          <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n          <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n\n    <div class="slds-form-element__control" ng-show="field.min === field.max">\n        <label class="slds-checkbox">\n            <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n            <input vdf-input="true" data-vdf-only type="checkbox" name="options"/>\n            <span class="slds-checkbox--faux"></span>\n            <span ng-if="::field.dataType == \'currency\'">{{::localeCurencySym}}</span>\n            <span class="slds-form-element__label">{{field.min}}</span>\n            <span ng-if="::field.dataType == \'percentage\'">%</span>\n        </label>\n    </div>\n    <div class="slds-form-element__control slds-grid slds-wrap slds-grid--pull-padded" ng-show="field.min !== field.max">\n        <div class="slds-form-element__control slds-col--padded slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--6-of-12" >\n            <label>From</label>\n            <div class="slds-input-has-fixed-addon">\n                <span class="slds-form-element__addon" ng-if="::field.dataType == \'currency\'">{{::localeCurencySym}}</span>\n                <input data-vdf-min vdf-input="true" vdf-input-name="true" class="slds-input" type="number" placeholder="{{::field.min}}" />\n                <span class="slds-form-element__addon" ng-if="::field.dataType == \'percentage\'">%</span>\n            </div>\n            <!-- <input data-vdf-min vdf-input="true" vdf-input-name="true" class="slds-input" type="number" placeholder="{{field.min}}" /> -->\n        </div>\n        <div class="slds-form-element__control slds-col--padded slds-size--1-of-1 slds-medium-size--3-of-6 slds-large-size--6-of-12">\n            <label>To</label>\n            <div class="slds-input-has-fixed-addon">\n                <span class="slds-form-element__addon" ng-if="::field.dataType == \'currency\'">{{::localeCurencySym}}</span>\n                <input data-vdf-max vdf-input="true" vdf-input-name="true" class="slds-input" type="number" placeholder="{{::field.max}}" />\n                <span class="slds-form-element__addon" ng-if="::field.dataType == \'percentage\'">%</span>\n            </div>\n        </div>\n    </div>\n    <!-- test -->\n\n    <!-- Error status: {{[[vdf-form-field-name]] | json}} -->\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">Please enter a value for this field</div>\n        <div class="slds-form-element__help" ng-message="invalid">Please enter a value for this invalid field</div>\n        <div class="slds-form-element__help" ng-message="email">Please enter a valid email address</div>\n        <div class="slds-form-element__help" ng-message="number">Please enter a valid number</div>\n        <div class="slds-form-element__help" ng-message="min">\n            This field value is too small <span ng-if="::field.min">(minimum is {{::field.min}})</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="max">\n            This field value is too high <span ng-if="::field.max">(maximum is {{::field.max}})</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="minlength">\n            This field is too short <span ng-if="field.minLength">(minimum is {{field.minLength}} characters)</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="maxlength">\n            This field is too long <span ng-if="field.maxLength">(maximum is {{field.maxLength}} characters)</span>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("SectionLegendTemplate.tpl.html",'<div class="slds-section" vdf-element-container>\n    <div class="slds-section__title slds-m-top--medium">\n        <h3 vdf-section-legend></h3>\n    </div>\n</div>\n'),$templateCache.put("SectionLegendToggleTemplate.tpl.html",'<div class="slds-section slds-m-top--small slds-is-open" vdf-element-container>\n    <div class="slds-section__title">\n        <h3 href="#void" class="slds-section__title-action">\n            <button class="slds-button slds-button--icon-container">\n                <svg aria-hidden="true" class="slds-button__icon">\n                    <use xmlns:xlink="{{\'/assets/icons/utility-sprite/svg/symbols.svg#switch\' | sldsStaticResourceURL}}"></use>\n                </svg>\n            </button>\n            <span vdf-section-legend vdf-replace>Section Title<span>\n        </h3>\n    </div>\n</div>'),$templateCache.put("SelectTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true" vdf-element-container="true">\n    <label class="slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>\n        {{::field.label}}\n    </label>\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);" \n                slds-popover \n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}"  \n                nubbin-direction="bottom-left" \n                tooltip="true" \n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n    <div class="slds-form-element__control">\n        <div class="slds-select_container">\n            <select class="slds-select" vdf-select="true">\n                <!-- <option vdf-select-option="true">Sample option</option> -->\n            </select>\n        </div>\n    </div>\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">This field is required.</div>\n    </div>\n</div>\n'),$templateCache.put("TextareaTemplate.tpl.html",'<div class="slds-form-element" ng-class="{\'slds-has-error\': [[vdf-form-field-name]].$invalid && [[vdf-form-field-name]].$touched, \'is-required\': required}" vdf-element-container="true">\n    <label class="slds-form-element__label">\n        <abbr class="slds-required" title="required" ng-if="::field.required">*</abbr>&#160;\n        {{::field.label}}\n    </label>\n    <div class="slds-form-element__icon" ng-if="::field.description">\n        <a href="javascript:void(0);" \n                slds-popover \n                data-container="{{attrs.tooltipContainer ? attrs.tooltipContainer : \'.via-slds\'}}" \n                nubbin-direction="bottom-left" \n                tooltip="true" \n                data-title="{{::field.description}}">\n            <slds-svg-icon sprite="\'utility\'" size="\'x-small\'" icon="\'info\'" extra-classes="\'slds-icon-text-default\'"></slds-svg-icon>\n            <span class="slds-assistive-text">Help</span>\n        </a>\n    </div>\n    <div class="slds-form-element__control">\n        <textarea class="slds-textarea" placeholder="" vdf-input="true"></textarea>\n    </div>\n    <!-- Standard Error Messages -->\n    <div ng-messages="[[vdf-form-field-name]].$error" ng-if="[[vdf-form-field-name]].$touched" role="alert">\n        <div class="slds-form-element__help" ng-message="required">\n            Please enter a value for this field.\n        </div>\n        <div class="slds-form-element__help" ng-message="minlength">\n            This field is too short <span ng-if="field.minLength">(minimum is {{field.minLength}} characters)</span>\n        </div>\n        <div class="slds-form-element__help" ng-message="maxlength">\n            This field is too long <span ng-if="field.maxLength">(maximum is {{field.maxLength}} characters)</span>\n        </div>\n    </div>\n</div>')}]);
},{}]},{},[1]);

})();