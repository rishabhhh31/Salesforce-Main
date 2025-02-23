import { LightningElement, wire } from 'lwc';
import getFieldMetadata from '@salesforce/apex/ParseFileHandler.getFieldMetadata';
import parseCsv from '@salesforce/apex/ParseFileHandler.parseCsv';
import uploadContacts from '@salesforce/apex/ParseFileHandler.uploadContacts';
import getAllAccounts from '@salesforce/apex/ParseFileHandler.getAllAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMN = [];
export default class BulkContactUpload extends LightningElement {
    columns = COLUMN;
    accept = ".csv";
    draftValues = [];
    contacts = [];
    fieldMap = [];
    picklistKeyValue = [];
    uploadedFile = null

    @wire(getAllAccounts)
    accountRecords({ data, error }) {
        if (data) {
            this.picklistKeyValue = data;
        } else if (error) {
        }
    }

    connectedCallback() {
        this.fetchFieldMetadata();
    }

    async fetchFieldMetadata() {
        try {
            this.fieldMap = await getFieldMetadata();
        } catch (error) {
            this.showToast('Error', 'Failed to fetch field metadata', 'error');
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    async handleFileUpload(event) {
        this.uploadedFile = event.target.files[0];
        if (!this.uploadedFile) return;

        const reader = new FileReader();
        reader.onload = async () => {
            try {
                const base64 = reader.result.split(',')[1];
                const stringData = atob(base64);
                if (!stringData) return;

                const csvColumns = stringData.split('\n')[0];
                const columnValue = this.mapCsvColumns(csvColumns);

                if (!columnValue) return;

                this.columns = columnValue;
                const csvContacts = await parseCsv({ blobBody: base64 });
                this.contacts = this.mapCsvContacts(csvContacts);
            } catch (error) {
                this.showToast('Error', 'Failed to process file', 'error');
            }
        };
        reader.readAsDataURL(this.uploadedFile);
    }

    get isFileUploaded() {
        return this.uploadedFile != null;
    }

    mapCsvColumns(csvColumns) {
        let invalidFieldFound = false;

        const columns = csvColumns.split(',').map(item => {
            const fieldApiName = item?.trim();
            const selectedField = this.fieldMap.find(field => field.fieldName === fieldApiName);

            if (!selectedField) {
                this.contacts = [];
                this.showToast('Invalid Field', `Field not found: ${fieldApiName}`, 'error');
                invalidFieldFound = true;
                return null;
            }

            return {
                label: selectedField.fieldLabel,
                fieldName: selectedField.fieldName,
                type: this.getFieldType(selectedField),
                editable: fieldApiName === 'AccountId',
                typeAttributes: this.getTypeAttributes(selectedField)
            };
        }).filter(col => col !== null);

        return invalidFieldFound ? null : columns;
    }

    getFieldType(selectedField) {
        if (selectedField.fieldType === 'reference' && selectedField.fieldName === 'AccountId') {
            return 'accountPicklist';
        }
        return selectedField.fieldType === 'string' ? 'text' : selectedField.fieldType;
    }

    getTypeAttributes(selectedField) {
        if (selectedField.fieldName === 'AccountId') {
            return {
                options: { fieldName: 'accountNameOptions' },
                label: 'Account Name'
            };
        }
        return {};
    }

    handleRemove(event) {
        let fileName = event.detail.name;
        if (fileName == this.uploadedFile.name) {
            this.uploadedFile = null;
            this.contacts = [];
        }
    }

    mapCsvContacts(csvContacts) {
        let count = 1;
        return csvContacts?.map(con => ({
            ...con,
            conId: count++,
            accountNameOptions: this.picklistKeyValue
        })) || [];
    }

    get hasRecords() {
        return this.contacts.length > 0;
    }

    async handleSave(event) {
        try {
            this.draftValues = event.detail.draftValues;

            const contactsList = this.contacts.map(con => {
                const editedContact = this.draftValues.find(draftValue => con.conId === draftValue.conId);
                if (editedContact) {
                    con.AccountId = editedContact.AccountId;
                }
                const { conId, ...contactData } = con;
                return contactData;
            });

            try {
                await uploadContacts({ conList: contactsList });
                this.draftValues = [];
                this.contacts = [];
                this.uploadedFile = null;
                this.showToast('Success', 'Contacts uploaded successfully', 'success');
            } catch (error) {
                this.showToast('Error', error.body.message, 'error');
            }
        } catch (error) {
            this.showToast('Error', 'Failed to save contacts', 'error');
        }
    }
}