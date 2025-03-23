import { LightningElement, wire } from 'lwc';
import INDUSTRY from "@salesforce/schema/Account.Industry";
import RATING from "@salesforce/schema/Account.Rating";
import TYPE from "@salesforce/schema/Account.Type";
import ACTIVE from "@salesforce/schema/Account.Active__c";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import { getPicklistValues, getObjectInfo } from "lightning/uiObjectInfoApi";
import updateAccount from '@salesforce/apex/SOQL_Handler.updateAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ErrorHandling extends LightningElement {
    accountDefaultRecordTypeId;
    ratings = [];
    industries = [];
    active = [];
    types = [];

    account = {};

    timeout;

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo({ data, error }) {
        if (data) {
            this.accountDefaultRecordTypeId = data.defaultRecordTypeId;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountDefaultRecordTypeId", fieldApiName: INDUSTRY })
    industryPicklistResult({ error, data }) {
        if (data) {
            console.log('INDUSTRY', data);
            this.industries = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountDefaultRecordTypeId", fieldApiName: RATING })
    ratingPicklistResult({ error, data }) {
        if (data) {
            console.log('RATING', data);
            this.ratings = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountDefaultRecordTypeId", fieldApiName: ACTIVE })
    activePicklistResult({ error, data }) {
        if (data) {
            console.log('ACTIVE', data);
            this.active = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountDefaultRecordTypeId", fieldApiName: TYPE })
    typePicklistResult({ error, data }) {
        if (data) {
            console.log('TYPE', data);
            this.types = data.values;
        } else if (error) {
            console.log(error);
        }
    }

    handleAccountChange(event) {
        let { field } = event.target.dataset;
        let { value } = event.target;
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            this.account[field] = value;
        }, 0)
    }

    handleReset() {
        this.account = {};
        [...this.template.querySelectorAll('lightning-input, lightning-combobox')].forEach(input => {
            input.value = null;
        });
    }

    async handleSave() {
        try {
            let isValid = this.validityCheck();
            if (!isValid) {
                this.showToast('', 'Please Fill All Required Fields', 'error');
                return;
            }
            let result = await updateAccount({ acc: this.account });
            this.handleReset();
            window.open(`/${result}`, '_blank');
        } catch (error) {
            this.showToast('', error.body.message, 'error');
            console.log(error);
        }
    }

    showToast(title, message, variant = 'success') {
        const event = new ShowToastEvent({
            title, message, variant
        });
        this.dispatchEvent(event);
    }

    validityCheck() {
        const allValid = [
            ...this.template.querySelectorAll('lightning-input, lightning-combobox'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }
}