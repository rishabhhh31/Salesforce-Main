import { LightningElement } from 'lwc';

export default class GrandParentEventListener extends LightningElement {
    clickHandler() {
        console.log('GrandParent Called');
    }
}