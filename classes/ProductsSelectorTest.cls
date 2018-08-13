@IsTest
private class ProductsSelectorTest {
    @IsTest
    private static void WhenQueryProductsByIdCorrectQuantityMustBeReturned() {
        //Given
        Integer expectedProductsQuantity = 2;
        Integer actualProductsQuantity = 0;
        List<Product2> expectedProducts = TestDataFactory.CreateProduct(expectedProductsQuantity);
        Set<Id> productIds = (new Map<Id, Product2>(expectedProducts)).KeySet();
        
        //When
        List<Product2> actualProducts = new ProductsSelector().SelectById(productIds);
        actualProductsQuantity = actualProducts.Size();

        //Then
        System.AssertEquals(expectedProductsQuantity, actualProductsQuantity);
    }
}