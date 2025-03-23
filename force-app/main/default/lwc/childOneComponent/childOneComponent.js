import { LightningElement } from 'lwc';

export default class ChildOneComponent extends LightningElement {
    sendData() {
        let value = this.template.querySelector('lightning-input')?.value;
        let event = new CustomEvent('childtwo', { detail: value });
        this.dispatchEvent(event);
    }
}