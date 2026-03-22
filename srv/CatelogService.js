const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService {
  init() {

    const { Employeeset, ProductSet, BusinessPartnerSet, AddressSet, purchaseOrderSet, purchaseItemsSet } = cds.entities('CatalogService')

    this.before(['CREATE', 'UPDATE'], Employeeset, async (req) => {
      console.log('Before CREATE/UPDATE Employeeset', req.data)
      // get the employee salary 
      let salaryAmount = parseFloat(req.data.salaryAmount);
      if (salaryAmount > 10000000) {
        //contaminate the incoming request , So CAPM will know something gone wrong .
        req.error(500, "Hey Amigo check the salary , non of employee get a million");

      }

    })
    this.after('READ', Employeeset, async (employeeset, req) => {
      console.log('After READ Employeeset', employeeset)
    })
    this.before(['CREATE', 'UPDATE'], ProductSet, async (req) => {
      console.log('Before CREATE/UPDATE ProductSet', req.data)
    })
    this.after('READ', ProductSet, async (productSet, req) => {
      console.log('After READ ProductSet', productSet)
    })
    this.before(['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
      console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
    })
    this.after('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
      console.log('After READ BusinessPartnerSet', businessPartnerSet)
    })
    this.before(['CREATE', 'UPDATE'], AddressSet, async (req) => {
      console.log('Before CREATE/UPDATE AddressSet', req.data)
    })
    this.after('READ', AddressSet, async (addressSet, req) => {
      console.log('After READ AddressSet', addressSet)
    })
    this.before(['CREATE', 'UPDATE'], purchaseOrderSet, async (req) => {
      console.log('Before CREATE/UPDATE purchaseOrderSet', req.data)
    })
    this.after('READ', purchaseOrderSet, async (purchaseOrderSet, req) => {
      console.log('After READ purchaseOrderSet', purchaseOrderSet)
      for (let index = 0; index < purchaseOrderSet.length; index++) {
        const element = purchaseOrderSet[index];
        if (!element.NOTE) {
          element.NOTE = 'Not Found'
        }
      }

    })
    this.before(['CREATE', 'UPDATE'], purchaseItemsSet, async (req) => {
      console.log('Before CREATE/UPDATE purchaseItemsSet', req.data)
    })
    this.after('READ', purchaseItemsSet, async (purchaseItemsSet, req) => {
      console.log('After READ purchaseItemsSet', purchaseItemsSet)

    })
    ///Implementation for order defaults
    this.on('getDeafultValue', async (req, res) => {
      return {
        OVERALL_STATUS: 'N',
        LIFECYCLE_STATUS: 'N'
      }
    });
    // generic handler to support myfunction implimentation - always returns data
    this.on('getLargestOrder', async (req, res) => {
      try {

        const tx = cds.tx(req);
        //use CDS QL to make a call to DB - select * upto 3 rows from pos order by GROSS_AMOUNT descending
        const reply = await tx.read(purchaseOrderSet).orderBy({
          'GROSS_AMOUNT': 'desc'
        }).limit(3);

        return reply;

      } catch (error) {
        req.error(500, "Some error occured" + error.toString())

      }

    })

    // Implimentation of action - create , update data in server 
    this.on('boost', async (req) => {
      try {

        // debugger;
        //Exctract primary key JSON - { NODE_KEY : 'key value' }
        const PRIMARYKEY = req.params[0];
        // start transaction to db
        const tx = cds.tx(req);
        //CDS query language to update your gross amount by 20000
        await tx.update(purchaseOrderSet).with({
          GROSS_AMOUNT: { '+=': 20000 },
          NOTE: 'Boosted!!'
        }).where(PRIMARYKEY)

        // read the data and send it out 
        return await tx.read(purchaseOrderSet).where(PRIMARYKEY);

      } catch (error) {

      }

    })

    return super.init()
  }
}
