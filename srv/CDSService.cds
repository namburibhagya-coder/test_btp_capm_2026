//consume reference of my db tables
using {anubhav.cds} from '../db/CDSviews';

service CDSService @(path:'CDSService'){

    entity ProductSet as projection on cds.CDSviews.ProductView{
        *,
        // never be persisted in db 
        virtual soldCount : Int16

    };
    entity ItemSet as projection on cds.CDSviews.ItemView;
        
    
}