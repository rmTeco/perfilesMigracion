/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface OrderItemDomainService extends vlocity_cmt.DomainService {
    void addFulfilmentRequestLines(List<vlocity_cmt.XOMOrderDomainObject> param0);
    void addInvToAssetDecompRelation(List<vlocity_cmt.XOMOrderDomainObject> param0);
    void addObject(vlocity_cmt.XOMOrderItemDomainObject param0, Boolean param1);
    void deleteObject(vlocity_cmt.XOMOrderItemDomainObject param0, Boolean param1);
    List<vlocity_cmt.XOMOrderItemDomainObject> getByOrderId(Id param0, Boolean param1);
    vlocity_cmt.XOMOrderItemDomainObject getObject(Id param0, Boolean param1);
    List<vlocity_cmt.XOMOrderItemDomainObject> getObjects(Set<Id> param0, Boolean param1);
    void updateFulfilmentRequestLineLinenumbers(List<vlocity_cmt.XOMOrderDomainObject> param0);
    void updateInventoryIdInFulfilmentRequestLines(List<vlocity_cmt.XOMOrderDomainObject> param0);
    void updateObject(vlocity_cmt.XOMOrderItemDomainObject param0, Boolean param1);
}
