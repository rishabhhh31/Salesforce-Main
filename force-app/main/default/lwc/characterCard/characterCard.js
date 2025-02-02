import { LightningElement, wire } from 'lwc';
import getCharacterById from '@salesforce/apex/HarryPotterAPIService.getCharacterById';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
} from 'lightning/messageService';
import characterDetail from '@salesforce/messageChannel/characterDetails__c';
import UserLogo from "@salesforce/resourceUrl/UserLogo";


export default class CharacterCard extends LightningElement {
    subscription = null;
    characterId = null;
    characterDetailResponse = {};

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessageChannel();
    }

    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                characterDetail,
                (response) => this.handleCharacterDetails(response),
                { scope: APPLICATION_SCOPE }
            );
        }
    }


    async handleCharacterDetails(response) {
        this.characterId = response.characterId;
        let result = await getCharacterById({ characterId: this.characterId })
        if (result) {
            result.image = result.image ?? UserLogo;
        }
        this.characterDetailResponse = result;
    }

    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    get isCharacterSelected() {
        return this.characterId != null;
    }
}