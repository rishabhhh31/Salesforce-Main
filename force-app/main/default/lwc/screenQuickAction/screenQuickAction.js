import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { updateRecord } from "lightning/uiRecordApi";
import { CloseActionScreenEvent } from "lightning/actions";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import RATING_FIELD from "@salesforce/schema/Account.Rating";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";

const FIELDS = [NAME_FIELD, RATING_FIELD, INDUSTRY_FIELD];

export default class ScreenQuickAction extends LightningElement {
    disabled = false;
    @api recordId;
    @api objectApiName;
    accountRecord = {};

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    account;

    get name() {
        return getFieldValue(this.account.data, NAME_FIELD);
    }

    get industry() {
        return getFieldValue(this.account.data, INDUSTRY_FIELD);
    }

    get rating() {
        return getFieldValue(this.account.data, RATING_FIELD);
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleChange(event) {
        if (event.target.name == 'Name') {
            if (!event.target.value) {
                event.target.reportValidity();
                this.disabled = true;
            } else {
                this.disabled = false;
            }
        }
        this.accountRecord[event.target.name] = event.target.value;
    }

    async handleSubmit() {
        this.accountRecord['Id'] = this.account.data.id;
        const recordInput = { fields: this.accountRecord };
        try {
            await updateRecord(recordInput)
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Success",
                    message: "Record updated!",
                    variant: "success",
                }),
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error",
                    message: error.body.message,
                    variant: "error",
                }),
            );
        }
    }
}