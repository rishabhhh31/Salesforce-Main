import { LightningElement } from 'lwc';

export default class FetchApiIntegration extends LightningElement {
    dogUrl = '';
    getDogImage() {
        fetch("https://dog.ceo/api/breeds/image/random")
            .then(response => response.json())
            .then(data => {
                this.dogUrl = data.message;
            })
            .catch(error => console.error("Error:", error));
    }
}