import { LightningElement } from 'lwc';

export default class ParentCommunication extends LightningElement {
    message = 'This value is from Parent'

    clickHandler() {
        this.template.querySelector('c-child-communication')?.callChildMethod('Click Handler Child');
    }

    notifyHandler(event) {
        this.template.querySelector('c-child-communication')?.callChildMethod(event.detail.message);
    }
}