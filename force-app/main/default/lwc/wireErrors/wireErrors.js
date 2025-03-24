import { LightningElement, wire } from 'lwc';
import getAllCases from '@salesforce/apex/PrepApex.getAllCases';
const COLUMN = [
    { label: 'Case Number', fieldName: 'CaseNumber' },
    { label: 'Case Priority', fieldName: 'Priority' },
    { label: 'Case Status', fieldName: 'Status' },
    { label: 'Case Origin', fieldName: 'Origin' },
    { label: 'Case Reason', fieldName: 'Reason' },
]

export default class WireErrors extends LightningElement {
    columns = COLUMN;
    cases;
    @wire(getAllCases)
    caseInfo({ data, error }) {
        if (data) {
            this.cases = data;
            console.log(data);
        } else if (error) {
            console.log(error);
        }
    }
}