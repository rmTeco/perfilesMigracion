public abstract class ApplicationSelector extends fflib_SObjectSelector {
    public ApplicationSelector() {
        this(false);
    }

    public ApplicationSelector(Boolean includeFieldSetFields) {
        this(includeFieldSetFields, true, true);
    }

    public ApplicationSelector(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS) {
        Super(includeFieldSetFields, enforceCRUD, enforceFLS, false);
    }
}