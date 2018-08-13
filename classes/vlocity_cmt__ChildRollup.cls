/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ChildRollup {
    global ChildRollup() {

    }
    global static List<SObject> rollUp(vlocity_cmt.ChildRollup.Context ctx, List<SObject> detailRecordsFromTrigger) {
        return null;
    }
    global static List<SObject> rollUp(vlocity_cmt.ChildRollup.Context ctx, Set<Id> masterIds) {
        return null;
    }
global class BadRollUpSummaryStateException extends Exception {
}
global class Context {
    global Context(Schema.SObjectType m, Schema.SObjectType d, Schema.DescribeFieldResult lf) {

    }
    global Context(Schema.SObjectType m, Schema.SObjectType d, Schema.DescribeFieldResult lf, String detailWhereClause) {

    }
    global void add(vlocity_cmt.ChildRollup.RollupSummaryField fld) {

    }
}
global enum RollupOperation {Avg, Count, Max, Min, Sum}
global class RollupSummaryField {
    global RollupSummaryField(Schema.DescribeFieldResult m, Schema.DescribeFieldResult d, vlocity_cmt.ChildRollup.RollupOperation op) {

    }
}
}
