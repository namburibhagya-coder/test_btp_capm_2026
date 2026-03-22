using CatalogService as service from '../../srv/CatelogService';

// Add Selection fields
annotate service.purchaseOrderSet with @(
    UI.SelectionFields      : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS,
    ],

    // Add a column to table data
    UI.LineItem             : [
        {
            $Type         : 'UI.DataField',
            Value         : PO_ID,
            @UI.Importance: #High,
        },

        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.boost',
            Label : 'Boost',
            Inline: true,
        },
        {
            $Type      : 'UI.DataField',
            Value      : OVERALL_STATUS,
            Criticality: Spiderman
        },
    ],
    UI.HeaderInfo           : {
        //Title of the table - first screen
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Pucrchase Orders',
        //Second Screen title section
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://media.licdn.com/dms/image/v2/C4D0BAQEADNH5e7u7AA/company-logo_200_200/company-logo_200_200/0/1630495746155?e=1773878400&v=beta&t=BUmhAnpB1wUq1P7B9mEs-esvKMNMpOsm2lnMTbxLQoQ'
    },
    // Add tabstrip in the second page( Facets) - object Page
    UI.Facets               : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    Label : 'Basic Details',
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.Identification'
                },
                {
                    Label : 'Pricing Details',
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Spiderman'
                },
                {
                    Label : 'Additional Details',
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#superman'
                }

            ],
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Items Data',
            Target: 'Items/@UI.LineItem',


        }
    ],
    //default block which is always one Identification block
    // Contains Group of fields
    UI.Identification       : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: NOTE
        },
    ],
    // field group block that can be many blocks and can have multiple fields inside
    UI.FieldGroup #Spiderman: {
        Label: 'Pricing Details',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT
            },
        ],
    },
    // field group for status
    // to avaiod duplication field group annatations we use identifier
    UI.FieldGroup #superman : {

    Data: [
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type: 'UI.DataField',
            Value: OVERALL_STATUS
        },
        {
            $Type: 'UI.DataField',
            Value: LIFECYCLE_STATUS,
        }

    ], },

);

annotate service.purchaseItemsSet with @(

    UI.HeaderInfo    : {
        TypeName      : 'PO Item',
        TypeNamePlural: 'Purchase Order Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.DESCRIPTION}

    },
    // Add Line item Data
    UI.LineItem      : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        }
    ],
    UI.Facets        : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Item Details',
        Target: '@UI.Identification'
    }],

    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        }
    ]

);


//annotate a field to get its meaningful text
annotate service.PurchaseOrderSet with {
    @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'StatusCode',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: OVERALL_STATUS,
                ValueListProperty: 'code',
            }, ],
            Label         : 'Status',
        },
        Common.ValueListWithFixedValues: true,
    )
    OVERALL_STATUS;
    @Common.Text: NOTE
    PO_ID;
    @Common.Text     : PARTNER_GUID.COMPANY_NAME
    @ValueList.entity: service.BusinessPartnerSet
    //@UI.Hidden: true
    //@Common : { TextArrangement : #TextOnly }
    PARTNER_GUID;
};

//annotate a field to get its meaningful text
annotate service.PurchaseItemsSet with {
    @Common.Text     : PRODUCT_GUID.DESCRIPTION
    //@UI.Hidden: true
    //@Common : { TextArrangement : #TextOnly }
    @ValueList.entity: service.ProductSet
    PRODUCT_GUID;
};

//Design Value help in CAPM for Partner Guid and Product Guid
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: COMPANY_NAME,
}, ]);

@cds.odata.valuelist
annotate service.ProductSet with @(UI.Identification: [{
    $Type: 'UI.DataField',
    Value: DESCRIPTION,
}, ]);

annotate service.StatusCode with {
    code @Common.Text: value
};
