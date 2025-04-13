import { api, LightningElement } from 'lwc';

export default class ApiReadOnlyChild extends LightningElement {
    @api message;

    changeHandler(event) {
        let clones = { ...this.message };
        clones.name = event.target.value;
        console.log(JSON.stringify(clones));
    }
}