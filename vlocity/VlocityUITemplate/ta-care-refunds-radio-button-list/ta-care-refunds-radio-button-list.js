vlocity.cardframework.registerModule.filter("format", function() {
    return function (input, items, option) {
		var args = items;
		return input.replace(/\{(\d+)\}/g, function (match, capture) {
			return option[args[parseInt(capture, 10)]];
		});
	};
});