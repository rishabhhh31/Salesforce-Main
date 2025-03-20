import { api, LightningElement } from 'lwc';

export default class ChildCommunication extends LightningElement {
    @api message_Value;

    @api
    callChildMethod(message) {
        this.message_Value = message;
    }

    callParent() {
        let event = new CustomEvent('notify', {
            detail: {
                message: 'This is custom event fired from child'
            }
        })
        this.dispatchEvent(event);
    }
}