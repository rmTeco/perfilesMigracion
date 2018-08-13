host: 
info:
    title: VLocity CPQ API
    version: 1.0.0
basePath: /services/apexrest
schemes:
- https
swagger: '2.0'

paths:
    /vlocity_cmt/V1/CPQServices/{id1}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id1
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/addCartItem'
            summary: This instance is for removing item from cart
            tags:
            - CPQ
    /vlocity_cmt/V1/CPQServices/{id2}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id2
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/cartChangeQuantity'
            summary: This instance is for changing qty in the cart
            tags:
            - CPQ
    /vlocity_cmt/V1/CPQServices/{id3}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id3
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/cartGetOrderItems'
            summary: This instance is for getting the items in the order
            tags:
            - CPQ
    /vlocity_cmt/V1/CPQServices/{id4}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id4
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/cartProcessOrder'
            summary: This instance is processing the order ie submit
            tags:
            - CPQ
    /vlocity_cmt/V1/CPQServices/{id5}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id5
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/cartGetPriceSets'
            summary: This instance is obtaining the price books available.
            tags:
            - CPQ
    /vlocity_cmt/V1/CPQServices/{id}:
        post:
            description: multi-request service for cpq functionality
            parameters:
            -   default: ''
                description: Id of the cart to perform the operation.
                in: path
                name: id
                required: true
                type: string
            -   description: The command and data to be sent.
                in: body
                name: body
                required: true
                schema:
                    $ref: '#/definitions/addCartItem'
            summary: This instance is for adding item to cart
            tags:
            - CPQ

definitions:
    AccountInfo:
        properties:
            city:
                default: Paddington, Sydney
                description: Town
                type: string
            customerEmail:
                default: john.doe@telstra.com
                description: email for lookup on the account
                type: string
            email:
                default: john.doe@telstra.com
                description: email for lookup on the account
                type: string
            identification:
                default: '2021'
                description: A JSON blob of the indentification information of the
                    customer
                type: string
            name:
                default: John Doe
                description: Name of the account
                type: string
            postal:
                default: '2021'
                description: Post code
                type: string
            state:
                default: NSW
                description: Territory
                type: string
            street:
                default: 363 Oxford St
                description: Street Address
                type: string
        type: object
    Offer:
        properties:
            feesTaxes:
                items:
                    $ref: '#/definitions/taxServiceFee'
                type: array
            name:
                description: The name of the offer.
                type: string
            offerId:
                description: The Id of the offer.
                type: string
            offerType:
                description: The offer type. ie Bundle Or Standalone
                type: string
            oneTimePrice:
                $ref: '#/definitions/Price'
            recurringPrice:
                $ref: '#/definitions/Price'
        type: object
    PaymentMethod:
        properties:
            CardHolderName:
                default: John Doe
                description: Name of the card holder
                type: string
            CardNumber:
                default: '4111111111111111'
                description: Credit card number
                type: string
            CardType:
                default: Visa
                description: Type of Card, not needed for most gateways
                type: string
            ExpirationMonth:
                default: '01'
                description: Expiration Month
                type: string
            ExpirationYear:
                default: '2020'
                description: Expiration Year
                type: string
            Last4Numbers:
                default: '111'
                description: CVV Number on back of the card
                type: string
            type:
                default: CreditCard
                description: Name of the card holder
                type: string
        type: object
    Price:
        properties:
            amount:
                description: The price for the offer.
                type: number
            description:
                description: A description of the price.
                type: string
            priceRecurringPeriod:
                description: |
                    The count of the UOM for each recurring payment. ie if priceUOM is monthis and this is 1.5 then interpert the combined pair as 1.5 months.
                type: number
            priceUOM:
                description: The unit of measurement for the price.
                type: string
        type: object
    Product:
        properties:
            name:
                description: The name of the Product
                type: string
            productId:
                description: The product ID
                type: string
            productType:
                description: The type of the Product
                type: string
            resourceId:
                default: '123456'
                description: The unique ID of this resource
                type: string
        type: object
    Products:
        items:
            $ref: '#/definitions/Product'
        type: array
    account:
        properties:
            accountId:
                type: string
        type: object
    addCartItem:
        items:
            properties:
                command:
                    default: addItemToOrder
                    description: Command to process on the order  THis will dictate
                        the data sent.
                    type: string
                priceBookEntryId:
                    default: ''
                    description: Id of the pricebook entry to add
                    type: string
            type: object
        type: array
    attributeDetail:
        properties:
            attributeUniqueCode:
                description: The specific attribute to set.
                type: string
            value:
                description: The itemId.
                type: string
        required:
        - attributeUniqueCode
        - value
    cart:
        properties:
            account:
                $ref: '#/definitions/account'
            cartId:
                description: The unique cart ID.
                type: string
            customer:
                $ref: '#/definitions/customer'
            id:
                description: The unique ID.
                type: string
            userId:
                description: The userId that this cart belongs to.
                type: string
        type: object
    cartChangeQuantity:
        items:
            properties:
                command:
                    default: changeQty
                    description: Command to process on the order  This will dictate
                        the data sent.
                    type: string
                lineItem:
                    default: ''
                    description: Id of the line to change the quantity
                    type: string
                qty:
                    default: '2'
                    description: the new quantity
                    type: string
            type: object
        type: array
    cartGetOrderItems:
        items:
            properties:
                command:
                    default: getOrderItems
                    description: Command to process on the order  THis will dictate
                        the data sent.
                    type: string
            type: object
        type: array
    cartGetOrders:
        items:
            properties:
                command:
                    default: getOrders
                    description: Command to process on the order  THis will dictate
                        the data sent.
                    type: string
            type: object
        type: array
    cartGetPriceSets:
        items:
            properties:
                command:
                    default: getPriceSets
                    description: Command to process on the order  THis will dictate
                        the data sent.
                    type: string
            type: object
        type: array
    cartOffer:
        properties:
            offer:
                $ref: '#/definitions/Offer'
            quantity:
                format: int32
                type: integer
        required:
        - quantity
        - offer
        type: object
    cartProcessOrder:
        items:
            properties:
                command:
                    default: processOrder
                    description: Command to process on the order  THis will dictate
                        the data sent.
                    type: string
            type: object
        type: array
    customer:
        properties:
            customerId:
                type: string
            customerType:
                type: string
            datOfBirth:
                format: date
                type: string
            externalCustomerId:
                type: string
            firstName:
                type: string
            lastName:
                type: string
            oranisationName:
                type: string
            title:
                type: string
        type: object
    removeCartItem:
        items:
            properties:
                command:
                    default: removeItemFromOrder
                    description: Command to process on the order  This will dictate
                        the data sent.
                    type: string
                lineItemToRemove:
                    default: '0001'
                    description: Line Number of the item to remove
                    type: string
            type: object
        type: array
    taxServiceFee:
        properties:
            description:
                description: The description of the fee.
                type: string
            flatFee:
                description: The flat fee.
                type: number
            name:
                description: The name of the fee.
                type: string
            percentageFee:
                description: The percentage attached.
                type: number
        type: object
    updateItem:
        properties:
            JSONAttribute:
                default: {}
                description: THe Json Attributes to update
                type: object
            id:
                default: ''
                description: id of the line item to update
                type: string
            quantity:
                default: '1'
                description: The new quantity, this can be the same qty
                type: integer
        type: object
