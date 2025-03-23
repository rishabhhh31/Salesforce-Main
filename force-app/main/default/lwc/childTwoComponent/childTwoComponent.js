import { LightningElement, api } from 'lwc';

export default class ChildTwoComponent extends LightningElement {
    @api messageFromChildOne;
}