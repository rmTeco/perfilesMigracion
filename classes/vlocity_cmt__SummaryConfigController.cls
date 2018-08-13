/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SummaryConfigController {
    global String currencyLocaleSymbol {
        get;
    }
    global String decimalSep {
        get;
    }
    global String nsPrefix {
        get;
    }
    global String thousandSep {
        get;
    }
    global SummaryConfigController() {

    }
    @RemoteAction
    global static Map<String,Object> getOrderSummaryConfig(Id oId, String features) {
        return null;
    }
    @RemoteAction
    global static List<Object> getOrderSummaryDetails(String columnMapString, Id oId) {
        return null;
    }
global class SummaryConfigException extends Exception {
}
}
