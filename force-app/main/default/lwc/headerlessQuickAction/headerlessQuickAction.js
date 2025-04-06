import { api, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HeaderlessQuickAction extends LightningElement {
    _recordId;

    @api
    get recordId() {
        return this._recordId;
    }

    set recordId(recordId) {
        if (recordId !== this._recordId) {
            this._recordId = recordId;
        }
    }

    @api
    async invoke() {
        let event = new ShowToastEvent({
            title: 'I am a headless action!',
            message: 'Hi there! Starting...',
            variant: 'success'
        });
        this.dispatchEvent(event);

        await this.sleep(2000);
        
        event = new ShowToastEvent({
            title: 'I am a headless action on record with id ' + this.recordId,
            message: 'All done!',
            variant: 'success'
        });
        this.dispatchEvent(event);

    }

    sleep(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }
}