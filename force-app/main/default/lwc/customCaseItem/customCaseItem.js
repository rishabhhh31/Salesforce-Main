import { LightningElement, api } from 'lwc';
export default class CustomCaseItem extends LightningElement {
    @api record;
    viewCase() {
        this.dispatchEvent(new CustomEvent('viewcase', { detail: this.record }));
    }
}