import { api } from 'lwc';
import LightningModal from 'lightning/modal';
export default class CustomCaseModal extends LightningModal {
    @api caseId;
    handleClose() {
        this.close('closed');
    }
}