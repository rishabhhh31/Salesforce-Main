import { LightningElement } from 'lwc';

export default class Child_Life_Cycle_Comp extends LightningElement {
    isRendered = false;
    constructor() {
        super(); // comment this line to check errorCallback in Parent Component
        console.log('Constructor Called in Child');
    }

    connectedCallback() {
        console.log('ConnectedCallback called in Child', this.isConnected);
    }

    renderedCallback() {
        if (!this.isRendered) {
            console.log('renderedCallback Called in Child');
            this.isRendered = true;
        }
    }

    disconnectedCallback() {
        console.log('disconnectedCallback Called in Child');
    }
}