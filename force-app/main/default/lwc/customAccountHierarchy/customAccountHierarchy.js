import { api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecords from '@salesforce/apex/CustomHierarchy.getRecords'
import { cols } from './utils';

export default class CustomAccountHierarchy extends LightningElement {
     @api recordId

     expandedRows = []
     accounts = []
     
     loading = false

     async connectedCallback() {
          await this.fetchSites()
     }

     get columns() {
          return cols()
     } 

     async fetchSites() {
          this.loading = true

          try {
               

               const tempRecs = await getRecords({ accountId: this.recordId })
               const tempRec = JSON.parse(JSON.stringify(tempRecs))
               
               if (!tempRec) {
                    return 
               }

               this.accounts = this.traverse(tempRec)

               console.log(tempRec)
          } catch (error) {
               console.error(error)
          } finally {
               this.loading = false
          }
     }

     traverse(accounts) {
          for (let account of accounts) {
     
               if (typeof(account.items) == "object") {
     
                    if (account?.items.length) {
                         account['_children'] = account.items
                         account['isExpanded'] = true
                    }
                    
                    this.expandedRows = [...this.expandedRows, account.name]
     
                    this.traverse(account.items);
               }
          }

          return accounts
     }

     toast(title, message, variant) {
          this.dispatchEvent(
               new ShowToastEvent({
                    title,
                    message,
                    variant
               })
          )
     }
}