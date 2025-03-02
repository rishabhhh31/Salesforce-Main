import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/BoxHandler.uploadFile';

export default class BoxIntegration extends LightningElement {
    fileData;
    disabledBtn = false;
    isLoading = false;

    openfileUpload(event) {
        const file = event.target.files[0];
        let reader = new FileReader()
        reader.onload = () => {
            let base64 = reader.result.split(',')[1]
            this.fileData = {
                'filename': file.name,
                'base64': base64,
            }
        }
        reader.readAsDataURL(file)
    }

    handleClick() {
        this.isLoading = true;
        this.disabledBtn = true;
        const { base64, filename } = this.fileData
        uploadFile({ base64, filename, folderId: '' }).then(result => {
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
            this.toast(title);
            this.disabledBtn = false;
            this.isLoading = false;
        }).catch(error => {
            this.toast(error.body.message, 'error');
            this.disabledBtn = false;
            this.isLoading = false;
        })
    }

    toast(title, variant = "success") {
        const toastEvent = new ShowToastEvent({
            title,
            variant
        })
        this.dispatchEvent(toastEvent)
    }
}