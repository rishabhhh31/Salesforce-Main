import { LightningElement } from 'lwc';
import renderTemplate1 from './renderTemplate1.html';
import renderTemplate2 from './renderTemplate2.html';

export default class LifeCycleComponent extends LightningElement {
    isRendered = false;
    showTemp1 = true;
    constructor() {
        super();
        console.log('Constructor Called in Parent');
    }

    connectedCallback() {
        console.log('ConnectedCallback called in Parent', this.isConnected);
    }

    render() {
        console.log('Render Parent')
        return this.showTemp1 ? renderTemplate1 : renderTemplate2;
    }

    renderedCallback() {
        if (!this.isRendered) {
            console.log('renderedCallback Called in Parent');
            this.isRendered = true;
        }
    }

    clickHandler(event) {
        let val = event.target.value;
        this.showTemp1 = (val == 'temp1') ? true : false;
    }

    errorCallback(error, stack) {
        console.log('error', error)
        console.log('stack', stack);
    }
}