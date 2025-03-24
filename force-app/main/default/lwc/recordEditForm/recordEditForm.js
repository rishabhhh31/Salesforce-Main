import { api, LightningElement } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import CLOSE_DATE_FIELD from '@salesforce/schema/Opportunity.CloseDate';

export default class RecordEditForm extends LightningElement {
    @api recordId;
    @api objectApiName;

    nameField = NAME_FIELD;
    stageField = STAGE_FIELD;
    closeDateField = CLOSE_DATE_FIELD;

    opportunityId;

    submitHandler(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Amount = 12000;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    resetHandler() {
        this.template.querySelectorAll('lightning-input-field').forEach(input => {
            input.reset();
        })
    }

    successHandler(event) {
        this.opportunityId = event.detail.id;
        this.resetHandler();
    }

    errorHandler(event) {
        console.log(event);
    }
}