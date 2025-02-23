import { LightningElement, api } from 'lwc';

export default class SelectedValueLabel extends LightningElement {
    @api value;
    @api options;

    get getLabel() {
        return this.options?.find(op => op.value == this.value)?.label;
    }
}