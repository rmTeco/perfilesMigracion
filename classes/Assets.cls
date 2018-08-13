public class Assets extends ApplicationDomain {
    public Assets(List<Asset> assets) {
        Super(assets);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain Construct(List<SObject> sObjectList) {
            return new Assets(sObjectList);
        } 
    }
}