import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import UNRELATED from '@salesforce/messageChannel/unrelated__c';

export default class PublishComponent extends LightningElement {
    @wire(MessageContext)
    messageContext;

    handleClick() {
        let payload = {
            data: {
                name: 'Rishabh Jain',
                email: 'rishabh@gmail.com'
            },
            recordId: '12345676543'
        }
        publish(this.messageContext, UNRELATED, payload);
    }
}