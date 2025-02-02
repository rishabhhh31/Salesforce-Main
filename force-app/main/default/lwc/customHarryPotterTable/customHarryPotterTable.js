import LightningDatatable from "lightning/datatable";
import customImageTemplate from "./customImage.html";

export default class CustomHarryPotterTable extends LightningDatatable {
    static customTypes = {
        customImage: {
            template: customImageTemplate,
            standardCellLayout: true,
            typeAttributes: ["imageUrl", "altText"],
        }
    };
}