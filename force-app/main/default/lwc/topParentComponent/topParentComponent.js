import { LightningElement } from 'lwc';

export default class TopParentComponent extends LightningElement {
    handleChildOneData(event) {
        this.template.querySelector('c-child-two-component').messageFromChildOne = event.detail;
    }
}