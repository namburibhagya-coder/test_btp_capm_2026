//Implimentation file - js with the same name 
//DPC_EXT class you write in ABAP for service implimentation
const cds = require('@sap/cds')

module.exports = class Myservice extends cds.ApplicationService { init() {

  this.on ('anubhav', async (req) => {
    console.log('On anubhav', req.data)
    let Myname = req.data.name;
    return `welcome to CAP server , Hello ${Myname}!! How are you today`
  })
// calling parent class constructor here . this willcall basic code to boost your service
  return super.init()
}}
