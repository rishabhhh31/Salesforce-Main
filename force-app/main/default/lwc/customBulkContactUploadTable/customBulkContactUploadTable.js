import LightningDatatable from "lightning/datatable";
import accountNamePicklistTemplate from "./accountNamePicklist.html";
import accountNamePicklistEditTemplate from "./accountNamePicklistEdit.html";

export default class CustomBulkContactUploadTable extends LightningDatatable {
    static customTypes = {
        accountPicklist: {
            template: accountNamePicklistTemplate,
            editTemplate: accountNamePicklistEditTemplate,
            standardCellLayout: true,
            typeAttributes: ["options", "label"],
        }
    };
}