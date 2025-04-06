import { LightningElement } from 'lwc';

export default class ParentEventListener extends LightningElement {
    clickHandler() {
        console.log('Parent Called');
    }
}