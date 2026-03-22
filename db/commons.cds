namespace anubhav.common;

using {Currency} from '@sap/cds/common';

// similar to data element in ABAP
type guid    : String(32);

// domain fix values M- Male , F - Female , U - Unknown
type gender  : String(1) enum {
    male = 'M';
    Female = 'F';
    undiclosed = 'U';

};

// referance field for quanity and currency .
//@ annotations that have special significance in CAPM .
type AmountT : Decimal(10, 2) @(Semantic.amount.currencyCode: 'CURRENCY_code'
                //sap.unit : 'CURRENCY_code'          
                                                              );

//custom structure aspect
// when we refer a field type that refer to another entity . that entity have a key
// in this example Currency has a key name code
// the cloumn name of the strcuture will be COLUMN_KEY = CURRENCY_code.
aspect Amount {
    CURRENCY     : Currency @title : '{i18n>CURRENCY}';
    GROSS_AMOUNT : AmountT @title : '{i18n>GROSS_AMOUNT}';
    NET_AMOUNT   : AmountT @title : '{i18n>NET_AMOUNT}';
    TAX_AMOUNT   : AmountT @title : '{i18n>TAX_AMOUNT}';
}

// types o validate phone number and email.
type PhoneNumber : String(30) @assert.format : '^[6-9]\d{9}$';
type Email : String(250) @assert.format : '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
