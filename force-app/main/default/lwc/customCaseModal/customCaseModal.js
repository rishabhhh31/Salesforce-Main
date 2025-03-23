import { api } from 'lwc';
import LightningModal from 'lightning/modal';
export default class CustomCaseModal extends LightningModal {
    @api caseId;
    handleClose(event) {
        const { id } = event.detail;
        const selectEvent = new CustomEvent('select', {
            detail: { id }
        });
        this.dispatchEvent(selectEvent);
        this.close('close');
    }
}