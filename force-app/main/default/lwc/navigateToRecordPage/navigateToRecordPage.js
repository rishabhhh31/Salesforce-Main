import { api, LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAllAccountWithContacts from '@salesforce/apex/SOQL_Handler.getAllAccountWithContacts';
import Id from '@salesforce/user/Id';
import isGuest from '@salesforce/user/isGuest';

const actions = [
    { label: 'View', name: 'view' }
];

const COLUMN = [
    { label: 'Account Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Rating', fieldName: 'Rating' },
    {
        type: 'action', typeAttributes: {
            menuAlignment: 'auto',
            rowActions: actions
        }
    }
]

export default class NavigateToRecordPage extends NavigationMixin(LightningElement) {
    @api message;
    userId = Id;
    isGuestUser = isGuest;
    columns = COLUMN;
    accounts = [];
    connectedCallback() {
        console.log('User Id', this.userId);
        console.log('Guest user Id', this.isGuestUser);
    }

    @wire(getAllAccountWithContacts)
    accountInfo({ data, error }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.log(error);
        }
    }

    navigateToRecordPage(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'view',
                recordId
            },
        });
    }

    handleRowAction(event) {
        let { action, row } = event.detail;
        if (action.name === 'view') {
            this.navigateToRecordPage(row.Id);
        }
    }
}