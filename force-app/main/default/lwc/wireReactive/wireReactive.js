import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from "@salesforce/schema/Account.Name";
import OWNER_NAME_FIELD from "@salesforce/schema/Account.Owner.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";

export default class WireReactive extends LightningElement {
    @api recordId;
    account;
    @wire(getRecord, {
        recordId: "$recordId",
        fields: [NAME_FIELD, INDUSTRY_FIELD],
        optionalFields: [PHONE_FIELD, OWNER_NAME_FIELD],
    })
    accountInfo({ data, error }) {
        if (data) {
            this.account = data;
            console.log(data);
        } else if (error) {
            console.log(error);
        }
    }

    get name() {
        return getFieldValue(this.account, NAME_FIELD);
    }

    get phone() {
        return getFieldValue(this.account, PHONE_FIELD);
    }

    get industry() {
        return getFieldValue(this.account, INDUSTRY_FIELD);
    }

    get owner() {
        return getFieldValue(this.account, OWNER_NAME_FIELD);
    }
}