import { LightningElement } from 'lwc';
import getSOQL_Result from '@salesforce/apex/SOQL_Handler.getSOQL_Result';

export default class ApexHandler extends LightningElement {
    connectedCallback() {
        this.getSoqlFieldResult();
    }

    async getSoqlFieldResult() {
        let response = await getSOQL_Result();
        console.log(response);
    }
}