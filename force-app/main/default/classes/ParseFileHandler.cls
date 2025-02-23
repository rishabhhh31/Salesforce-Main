public with sharing class ParseFileHandler {
    @AuraEnabled
    public static List<FieldMetadata> getFieldMetadata(){
        try {
            List<FieldMetadata> fieldMetadataList = new List<FieldMetadata>();
            Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            Schema.SObjectType sobjType = gd.get('Contact');
            Schema.DescribeSObjectResult r = sobjType.getDescribe();
            Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
            for(String fieldName : MapofField.keySet()) {
                Schema.SObjectField field = MapofField.get(fieldName);
                Schema.DescribeFieldResult F = field.getDescribe();
                FieldMetadata fm = new FieldMetadata();
                fm.fieldName = F.getName();
                fm.fieldLabel = F.getLabel();
                fm.fieldType = F.getType().name().toLowerCase();
                fieldMetadataList.add(fm);
            }
            return fieldMetadataList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Contact> parseCsv(String blobBody){
        try {
            String fileData = EncodingUtil.base64Decode(blobBody).toString();
            List<String> csvRows = fileData.split('\n');
            if(csvRows.isEmpty()){
                return null;
            }
            List<String> columns = csvRows[0].split(',');
            List<Contact> contactList = new List<Contact>();
            for(Integer i = 1 ; i < csvRows.size() ; i++){
                List<String> rowVaues = csvRows[i].split(',');
                Contact con = new Contact();
                for(Integer j = 0 ; j < rowVaues.size() ; j++){
                    con.put(columns[j]?.trim(), rowVaues[j]?.trim());
                }
                contactList.add(con);
            }
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean uploadContacts(List<Contact> conList){
        try {
            Database.insert(conList);
            return true;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<PicklistValuePair> getAllAccounts(){
        try {
            List<PicklistValuePair> picklistPairList = new List<PicklistValuePair>();
            for(Account acc :  [SELECT Id, Name FROM Account WITH USER_MODE ORDER BY Name ASC]){
                PicklistValuePair pick = new PicklistValuePair();
                pick.label = acc.Name;
                pick.value = acc.Id;
                picklistPairList.add(pick);
            }
            return picklistPairList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class PicklistValuePair{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }

    public class FieldMetadata{
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String fieldLabel;
        @AuraEnabled
        public String fieldType;
    }
}