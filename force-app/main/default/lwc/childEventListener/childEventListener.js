import { LightningElement } from 'lwc';

export default class ChildEventListener extends LightningElement {
    childButtonClick() {
        this.dispatchEvent(new CustomEvent('buttonclick', { bubbles: true, composed: true }));
    }
}