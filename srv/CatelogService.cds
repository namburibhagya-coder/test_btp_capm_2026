// consume reference of my db tables.
using {
     anubhav.db.master,
     anubhav.db.transaction
} from '../db/datamodel';

service CatalogService @(path: 'CatalogService', requires : 'authenticated-user') {

     //entity representation of an end point of data to perform CRUDQ tasks
     entity Employeeset @(restrict : [
                                   { grant : ['READ'], to: 'Viewer',
                                     // Row level security 
                                     where : 'bankName = $user.spiderman'  },
                                   { grant : ['WRITE','DELETE'] , to : 'Editor'}
                                ])                                  as projection on master.employee;
     entity ProductSet                                    as projection on master.product;
     entity BusinessPartnerSet                            as projection on master.businesspartner;
     entity AddressSet                                    as projection on master.address;
     @readonly
     entity StatusCode as projection on master.StatusCode;      
     
     //@readonly
     //@Capabilities: {Deletable: false}
     entity purchaseOrderSet @( 
                                restrict : [
                                   { grant : ['READ'], to: 'Viewer' },
                                   { grant : ['WRITE','DELETE'] , to : 'Editor'}
                                ],
                                odata.draft.enabled: true ,
                                Common.DefaultValuesFunction: 'getDeafultValue') as
          projection on transaction.purchaseorder {
               *,
               //CDS Expression language
               case
                    OVERALL_STATUS
                    when 'P'
                         then 'Pending'
                    when 'A'
                         then 'Approved'
                    when 'X'
                         then 'Rejected'
                    when 'D'
                         then 'Delivered'
                    else 'Unknown'
               end as OverallStatus : String(10),
               case
                    OVERALL_STATUS
                    when 'P'
                         then 2
                    when 'A'
                         then 3
                    when 'X'
                         then 1
                    when 'D'
                         then 3
                    else 0
               end as Spiderman     : Integer
          }
          actions {
               ///Side effect - a trigger to my action leads to a change of a field value in data
               //this force framework to make a GET call after action is triggred to load data
               //_anubhav is  variable that will contain the updated data coming from BE
               @cds.odata.bindingparameter.name: '_anubhav'
               @Common.SideEffects : {TargetProperties: ['_anubhav/GROSS_AMOUNT', '_anubhav/OVERALL_STATUS']}
               // System will pass PO primary key - NODE_KEY automatically as input
               action boost() returns purchaseOrderSet
          };

     entity purchaseItemsSet as projection on transaction.poitems;

     //Functions are non instance bound beacuse they are not connected to any entity
     function getLargestOrder() returns array of purchaseOrderSet;

     // Define funcion to get default values .
     function getDeafultValue() returns purchaseOrderSet;

}
