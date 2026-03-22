const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSService extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet } = cds.entities('CDSService')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
   // Step1 : get all unique product Ids
   let ids = productSet.map(p=>p.ProductId);

   //CDS query language to go to the items data and aggregate the count 
   const orderCount = await SELECT.from(ItemSet)
                                   .columns('ProductId' , {func : 'count', as: 'Anubhav'}) 
                                   .where({'ProductId': {in : ids}})
                                   .groupBy('ProductId')
   
    //console.log('After READ ProductSet', productSet)
    for( const wa of productSet){
      const foundRecord = orderCount.find(pc=>pc.ProductId===wa.ProductId);
      wa.soldCount = foundRecord? foundRecord.Anubhav : 0;
    }
    return productSet;
  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })


  return super.init()
}}
