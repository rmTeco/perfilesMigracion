/**
 * DataPanel class
 * 
 * UI component that displays and edits Attached Data (aka Business Attributes).
 * 
 * 2013 Genesys Professional Services
 *
 * 
 **/

/*
 * UI component that displays and edits Attached Data (aka Business Attributes).
 * Depends on JInplace and Datepicker components; JInplace is modified to support validation and invalid status indication.
 * 
 * Data array is sorted inside.
 *
 * Parameters:
 * parentEl - Parent <div> for the component. This component adjusts to fit parent width but may have unlimited height.
 *     Parent <div> should take care of vertical overflow, either hide or scroll overflowing parts.
 *     Parent component will be emptied before filling it with data fields. Please avoid putting any 
 *     decorating elements inside it.
 * datepickerLocale - locale to be used for jQuery Ui Datepicker component. Optional, "" by default.
 * readonly - If set to "true", disables all editing actions. Optional, "false" by default.
 * 
 * Fields:
 * parentEl - parent <div> to be filled with attributes table
 * attData - array of data to display and edit
 * datepickerLocale - locale to use for JQuery UI Datepicker component. Optional, "" by default.
 * readonly - controls whether data is editable as "true" or "false"
 * labelWidth - width for label column, number, in percents. Allowed values 10...90. Default value is 20.
 * dataWidth - width for data column, calculated based on labelWidth.
 *
 * Following fields keep track of own DOM elements to avoid depending on element IDs (they are global in DOM and may interfere 
 * with other components):
 * inputs - array of all input elements
 * activators - array of all edit activator elements
 * datepickers  - array of datepicker components
 * editables - array of all in-place editors
 */
function DataPanel(parentEl, datepickerLocale, readonly) {
	this.parentEl = parentEl;
	this.datepickerLocale = (typeof datepickerLocale === "undefined") ? "" : datepickerLocale;
	this.readonly = (typeof readonly === "undefined") ? "false" : readonly;
	this.setLabelWidth(20);

	this.inputs = [];
	this.activators = [];
	this.datepickers = [];
	this.editables = [];

	// Used to guarantee activator ID uniqueness between components
	DataPanel.prototype.INSTANCE_ID++;

	this.createFunctionMaps();
}

/*
 * Makes DOM element IDs unique between component instances.
 */
DataPanel.prototype.INSTANCE_ID = 0;

DataPanel.prototype.setData = function(data) {
	this.attData = data;
	
	// fill and display the data
	this.fillData();
}

DataPanel.prototype.setLabelWidth = function(value) {
	if (typeof value !== "number" || value < 10 || value > 90) {
		throw "Invalid value (" + value + "). Allowed range is 10...90";
	}
	this.labelWidth = value;
	// 93% - reserve space for activator elements.
	// If 20px constitute 7%, then at less than 285px width table would have horizontal scroll
	this.dataWidth = 93 - value; 
}

/*
 * Validator functions accept a new value as an argument and return undefined if the value is not valid or return 
 * the same value if it is valid. Returned value will be stored in data array. Validators can also return value 
 * tranformed into different format.
 */
DataPanel.prototype.validateDefault = function(value) {
	return value; // Yes, no validation
}

DataPanel.prototype.validateInteger = function(value) {
	/*
	Examples:
	99...9
	+99...9
	-99...9
	*/
	var intRegex = /^[-+]?\d+$/;
	return intRegex.test(value) ? value : undefined;
}

DataPanel.prototype.validateFloat = function(value) {
	/* 
	Examples:
	0
	.1
	0.1
	-0.1
	,1
	0,1
	-0,1

	Note that both point and comma can be used as fractional part separator.
	It is supposed that there are no thousand separators used. Otherwise, we have to use locale-specific regexps.
	*/
	var floatRegex = /^[-+]?\d*([\.\,]\d+)?$/;
	return floatRegex.test(value) ? value : undefined;
}

/*
 * Called by JInPlace editor component when a value is changed. Should validate and store the new value (or submit it to server).
 * Parameters:
 * opts - list of "data-XXX" attributes of the editable HTML element
 * value - string from editor field
 */
DataPanel.prototype.submitValue = function(opts, value) {
	var el = this.getDataElement(opts.attribute);

	var newVal = this.validators[el.type].call(this, value);
	if (newVal === undefined) {
		return newVal;
	}

	// Store only valid values
	el.value = newVal;
	console.log("setting value: " + opts.attribute + " = " + newVal);

	// todo Update actual data here

	/* Special handling for Link type */
	if ("Link" == el.type) {
		this.fixLinkControl(el, value);
	}
	
	return value;
}

/*
 * Called by JInPlace editor field to read value from store or load it from server.
 */
DataPanel.prototype.loadValue = function(opts) {
	var el = this.getDataElement(opts.attribute);
	return el ? el.value : undefined;
}

/*
 * Returns a data record that has corresponding "key" field value.
 */
DataPanel.prototype.getDataElement = function(key) {
	if (null == this.attData) {
		return null;
	}
	for (var i = 0; i < this.attData.length; i++) {
		var el = this.attData[i];
		if ((null != el) && (el.key == key)) {
			return el;
		}
	}
	return null;
}

/*
 * Stores value in a data record that has corresponding "key" field value.
 */
DataPanel.prototype.setDataValue = function(key, value) {
	var el = this.getDataElement(key);
	if (null != el) {
		el.value = value;
	}
}

/*
 * Parses record "key" out of UI element ID value.
 */
DataPanel.prototype.getKeyFromId = function(id) {
	var actPrefix = "gplus-ad-activator-";
	var pos = id.indexOf(actPrefix);
	if (pos >= 0) {
		return id.substring(pos + actPrefix.length);
	}
}

/*
 * Creates ID for the editing activator HTML element.
 */
DataPanel.prototype.makeActivatorId = function(key) {
	return DataPanel.prototype.INSTANCE_ID + "-gplus-ad-activator-" + key;
}

DataPanel.prototype.getInput = function(key) {
	return this.inputs[key];
}

DataPanel.prototype.getActivator = function(key) {
	return this.activators[key];
}

/*
 * makeXxxControl functions create display/editor UI components for given data records.
 */

DataPanel.prototype.makeDefaultControl = function(el) {
	if (this.isEditable(el)) {
		var triggerEdit = curry(function() {
			this.getActivator(el.key).click();
		}, this);

		var input = $("<span>")
			.attr("class", "gplus-ad-data-field gplus-ad-wordwrap")
			.attr("data-activator", "#" + this.makeActivatorId(el.key))
			.attr("style", el.style)
			.text(el.value)
			.click(triggerEdit);

		this.editables.push(input);
		return input;
	}
	return $("<span>")
		.attr("class", "gplus-ad-data-field gplus-ad-wordwrap")
		.attr("style", el.style)
		.text(el.value);
}

DataPanel.prototype.makeBooleanControl = function(el) {
	var inp = $("<input>")
		.attr("type", "checkbox")
		.attr("checked", el.value)
		.attr("disabled", this.readonly || el.readonly);
	inp.click(curry(function(inp, ev) {
		var opts = {"attribute": el.key };
		this.submitValue(opts, inp.prop("checked"));
	}, this, inp));
	return inp;
}

/*
 * Date conversion functions
 * JS provides the following useful functions:
 * date.toISOString();
 * date.toLocaleString();
 * date.parse(isoDateStr);
 * JS does not provide any means to parse dates in localized format, jQuery UI Datepicker functions are used.
 */

DataPanel.prototype.isoDateToLocal = function(isoDateStr) {
	var millis = Date.parse(isoDateStr);
	if (millis) {
		var format = $.datepicker.regional[this.datepickerLocale].dateFormat;
		return $.datepicker.formatDate(format, new Date(millis));
	}
	else {
		return undefined;
	}
}

DataPanel.prototype.localDateToIso = function(localDateStr) {
	var format = $.datepicker.regional[this.datepickerLocale].dateFormat;
	try {
		return $.datepicker.parseDate(format, localDateStr).toISOString();
	}
	catch (err) {
		return undefined;
	}
}

DataPanel.prototype.makeDateControl = function(el) {
	var key = el.key;
	var dateStr = this.isoDateToLocal(el.value);

	if (this.readonly == "true" || el.readonly == "true") {
		return $("<span>")
			.attr("class", "gplus-ad-data-field")
			.attr("style", el.style)
			.text(dateStr);
	}

	/* Handles validation and "invalid value" border effect */
	var onBlur = function(input, ev) {
		console.log("blur");
		var localDate = input.val();
		var isoDate = this.localDateToIso(localDate);
		if (isoDate === undefined) {
			ev.preventDefault();
			
			input.removeClass("gplus-ad-noborder").addClass("gplus-ad-invalid-input");
			// focus() would not work if called immediately since element has not lost focus yet at the moment
			window.setTimeout(function() { input.focus(); }, 10);
		}
		else {
			input.addClass("gplus-ad-noborder").removeClass("gplus-ad-invalid-input");

			var opts = {"attribute": key};
			this.submitValue(opts, isoDate);
		}
	};

	/* Handles edit undo when Escape is pressed */
	var onKeyUp = function(input, ev) {
		if (ev.keyCode == 27) {
			var opts = {"attribute": key};
			var oldValue = this.loadValue(opts);

			input.datepicker("hide");
			input.val(this.isoDateToLocal(oldValue));
			$(function() { input.blur(); });
		}
		else if (ev.keyCode == 13) {
			$(function() { input.blur(); });
		}
	};

	var input = $("<input>")
		.attr("type", "text")
		.attr("value", dateStr)
		.attr("class", "gplus-ad-data-field gplus-ad-noborder")
		.attr("style", el.style);
	input.blur(curry(onBlur, this, input))
		.keyup(curry(onKeyUp, this, input));

	this.datepickers.push(input);

	return input;
}

DataPanel.prototype.isEditable = function(el) {
	return (null != el) && (null != el.type) && this.controlMakers[el.type] && (this.readonly == "false" || el.readonly == "false");
}

/*
 * Functions makeXxxActivator create HTML elements that work as editing activator controls.
 */

DataPanel.prototype.makeEmptyActivator = function(el) {
	return $("<div>").attr("class", "gplus-ad-act-box");
}

DataPanel.prototype.makeDefaultActivator = function(el) {
	return $("<img>")
		.attr("src", gImageURL + "pencil-icon-16x16.png")
		.attr("class", "gplus-ad-activator");
}

DataPanel.prototype.makeBooleanActivator = function(el) {
	var triggerEdit = curry(function() {
		var checkbox = this.getInput(el.key);
		checkbox.focus();
	}, this);

	return this.makeDefaultActivator(el).click(triggerEdit);
}

DataPanel.prototype.makeDateActivator = function(el) {
	var triggerEdit = curry(function() {
		var input = this.getInput(el.key);
		input.focus();
	}, this);

	return this.makeDefaultActivator(el).click(triggerEdit);
}

DataPanel.prototype.makeLink = function(el) {
	return $("<a>")
		.attr("class", "gplus-ad-wordwrap")
		.attr("style", el.style)
		.attr("href", el.value)
		.attr("target", "_blank")
		.text(el.value);
}

DataPanel.prototype.makeLinkControl = function(el) {
	// "Link" control requires special handling in submitAttribute()
	var wrapper = $("<span>")
		.attr("data-activator", "#" + this.makeActivatorId(el.key))
		.attr("class", "gplus-ad-wordwrap")
		.attr("style", el.style);

	var field = this.makeLink(el);

	wrapper.append(field);

	this.editables.push(wrapper);

	return wrapper;
}

/*
 * In-place editor replaces content of editor component with text after edit.
 * This function changes text back to active link.
 */
DataPanel.prototype.fixLinkControl = function(el, value) {
	var wrapper = this.getInput(el.key);
	var field = this.makeLink(el);
	var action = function() {
		wrapper.html(field);
	};
	window.setTimeout(action, 50);
}

DataPanel.prototype.makeUndefinedControl = function(el) {
	return $("<span>")
		.attr("class", "gplus-ad-data-field gplus-ad-wordwrap")
		.attr("style", el.style)
		.text("Unknown-" +  "\"" + el.type + "\"");
}

DataPanel.prototype.createControl = function(el) {
	var maker = (null == el.type) ? null : this.controlMakers[el.type];
	if (null == maker) {
		maker = this.makeUndefinedControl;
	}
	var control = maker.call(this, el);

	control.attr("data-attribute", el.key);
	this.inputs[el.key] = control;

	return control;
}

DataPanel.prototype.createActivator = function(el) {
	var maker = this.isEditable(el) ? this.activatorMakers[el.type] : null;
	if (null == maker) {
		maker = this.makeEmptyActivator;
	}
	var act = maker.call(this, el);
	act.attr("id", this.makeActivatorId(el.key));
	this.activators[el.key] = act;
	return act;
}

/*
 * Empties parent element and fills it with div-based table containing labels, activators and display/editor components.
 */
DataPanel.prototype.fillData = function() {
	var s = "";
	var rowId = 0;
	var container = $("<div>").attr("class", "gplus-ad-data-panel");

	if (null == this.attData) {
		return;
	}

	container.empty();

	// Sort data by "order" field
	this.attData.sort(function(a, b) {return a.order - b.order});

	// apply a thick boundary
	container.append($("<div>").attr("class", "gplus-ad-row-divider-thick"));
	
	var that = this;
	var lastIndex = Object.keys(that.attData).length - 1;
	$.each(that.attData, function(key, el) {
		var actDiv = $("<div>").attr("class", "gplus-ad-act-box");
		var label = $("<label>").attr("style", el.style).text(el.label + ":");
		var labelDiv = $("<div>").attr("class", "gplus-ad-label-box gplus-ad-wordwrap"); //.attr("style", "width: " + this.labelWidth + "%;");
		var dataDiv = $("<div>").attr("class", "gplus-ad-data-box gplus-ad-wordwrap").attr("style", "width: " + this.dataWidth - 1 + "%;");
		var rowDiv = $("<div>").attr("class", "gplus-ad-row-box");

		labelDiv.append(label);
		actDiv.append(that.createActivator(el));
		dataDiv.append(that.createControl(el));
		rowDiv.append(labelDiv).append(actDiv).append(dataDiv);
		
		container.append(rowDiv);

		// only add a divider if not the last element in the list
		if (rowId < lastIndex) {
			container.append($("<div>").attr("class", "gplus-ad-row-divider-thin"));
		}

		rowId++;
	});
	container.append($("<div>").attr("class", "gplus-ad-row-divider-thick"));

	this.parentEl.append(container);

	this.setupInplaceEdit(this.attData);
};

/*
 * Bind/initialize JInPlace and Datepicker editors.
 */
DataPanel.prototype.setupInplaceEdit = function(attData) {
	if ((null == this.attData) || this.readonly) {
		return;
	}

	var attDataInstance = this;
	// Executed in the context of AttData
	var onCloseFn = function(datepicker, dateText, inst) {
		console.log("close");
		if ("" == dateText) {
			return;
		}
		var key = datepicker.attr("data-attribute");
		var opts = {"attribute": key};
		var newVal = this.submitValue(opts, this.localDateToIso(dateText));
	};

	// Executed in the context of datepicker
	var onSelectFn = function(dateText, inst) {
		if ("" == dateText) {
			return;
		}
		// Remove "invalid value" border from edit control
		$(this).addClass("gplus-ad-noborder").removeClass("gplus-ad-invalid-input");
	};

	var datepickers = this.datepickers;
	$(function() {
		$.each(datepickers, function(index, value) {
			// Here, "value" points to jQuery-wrapped datepicker DOM element
			// onCloseFn will have "datepicker" argument fixed to the datepicker component

			value.datepicker({
				showOn: "button",
				buttonImage: gImageURL + "pencil-icon-16x16.png",
				buttonImageOnly: true,
				onClose: curry(onCloseFn, attDataInstance, value),
				onSelect: onSelectFn
			});
		});
	});

	// Set JInPlace options
	$.fn.jinplace.defaults.url = "/"; // fake, just to facilitate jinplace editor
	$.fn.jinplace.defaults.loadurl = "/"; // fake, just to facilitate jinplace editor
	$.fn.jinplace.defaults.inputClass = "gplus-ad-editor-field";
	$.fn.jinplace.defaults.inputInvalidClass = "gplus-ad-invalid-input";
	$.fn.jinplace.defaults.placeholder = "";
	$.fn.jinplace.defaults.submitFunction = curry(this.submitValue, this);
	$.fn.jinplace.defaults.loadFunction = curry(this.loadValue, this);

	$.each(this.editables, function(index, value) {	value.jinplace(); });
}

DataPanel.prototype.createFunctionMaps = function() {
	/* Functions validateXXX perform validation of entered values before edits are committed */
	this.validators = {
		"boolean": this.validateDefault,
		"string": this.validateDefault,
		"integer": this.validateInteger,
		"float": this.validateFloat,
		"date": this.validateDefault, /* Date validation is performed by date picker/editor control */
		"link": this.validateDefault
	};

	/* Functions makeXXXControl create editor components or viewer components, depending on read-only attribute flag */
	this.controlMakers = {
		"boolean": this.makeBooleanControl,
		"string": this.makeDefaultControl,
		"integer": this.makeDefaultControl,
		"float": this.makeDefaultControl,
		"date": this.makeDateControl,
		"link": this.makeLinkControl
	};

	/* Functions makeXXXActivator create activator controls. 
	 * Activators serve two purposes: they indicate that field is editable and 
	 * start in-place editing in related editors upon click.
	 */
	this.activatorMakers = {
		"boolean": this.makeBooleanActivator,
		"string": this.makeDefaultActivator,
		"integer": this.makeDefaultActivator,
		"float": this.makeDefaultActivator,
		"date": this.makeDateActivator,
		"link": this.makeDefaultActivator
	};
}
