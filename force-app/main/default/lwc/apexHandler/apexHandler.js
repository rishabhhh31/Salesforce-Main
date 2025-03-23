import { LightningElement, wire, api } from 'lwc';
import getAllAccountWithContacts from '@salesforce/apex/SOQL_Handler.getAllAccountWithContacts';
import { refreshApex } from "@salesforce/apex";
import { createRecord, updateRecord, deleteRecord } from "lightning/uiRecordApi";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";

const COLUMN = [
    { label: 'Account Name', fieldName: 'Name', editable: true },
    { label: 'Phone', fieldName: 'Phone', editable: true, type: 'phone' },
    { label: 'Industry', fieldName: 'Industry', editable: true },
    { label: 'Rating', fieldName: 'Rating', editable: true }
]
export default class ApexHandler extends LightningElement {
    @api recordId;
    columns = COLUMN;
    accountResult;
    accounts = [];
    selectedDeletionRows = [];
    field = {};
    draftValues = [];
    @wire(getAllAccountWithContacts)
    accountInfo(result) {
        this.accountResult = result;
        let { data, error } = result;
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.log(error);
        }
    }

    async refreshStaleData() {
        try {
            await refreshApex(this.accountResult);
        } catch (error) {
            console.log(error);
        }
    }

    handleChange(event) {
        let { fieldName } = event.target.dataset;
        this.field[fieldName] = event.target.value;
    }

    async createAccount() {
        try {
            const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields: this.field };
            const account = await createRecord(recordInput);
            let inputFields = [...this.template.querySelectorAll('lightning-input')];
            inputFields.forEach(input => {
                input.value = null;
            })
        } catch (error) {
            console.log(error);
        }
    }

    async handleSave(event) {
        try {
            this.draftValues = event.detail.draftValues
            let records = this.draftValues.map(fields => {
                return { fields };
            })

            let promiseToResolve = records.map(rec => {
                return updateRecord(rec);
            })

            await Promise.all(promiseToResolve);
            await refreshApex(this.accountResult);
            this.draftValues = [];
        }
        catch (error) {
            console.log(error);
        }
    }

    handleRowSelection(event) {
        this.selectedDeletionRows = event.detail.selectedRows;
    }

    async handleDeletion() {
        try {
            let deletedPromise = this.selectedDeletionRows.map(row => {
                return deleteRecord(row.Id);
            });
            await Promise.all(deletedPromise);
            await refreshApex(this.accountResult);
        } catch (error) {
            console.log(error);
        }
    }

    get isRowSelected() {
        return !(this.selectedDeletionRows.length > 0);
    }
}