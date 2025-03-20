import { LightningElement, wire } from 'lwc';
import getAllContacts from '@salesforce/apex/AsyncApexHandler.getAllContacts';

export default class TemplateLoop extends LightningElement {
    contacts = [];
    @wire(getAllContacts)
    contactInfo({data, error}){
        if(data){
            this.contacts = data;
        }else if(error){
            console.log(error)
        }
    }

    get contactsFound(){
        return this.contacts.length > 0;
    }
}