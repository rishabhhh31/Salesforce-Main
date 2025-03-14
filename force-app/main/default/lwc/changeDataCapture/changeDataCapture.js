import { LightningElement } from 'lwc';
import {
    subscribe,
    unsubscribe
} from 'lightning/empApi';

export default class ChangeDataCapture extends LightningElement {
    channelName = '/data/FilteredChannel__chn';
    subscription = {};

    connectedCallback() {
        this.handleSubscribe();
    }

    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription, (response) => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }
}
