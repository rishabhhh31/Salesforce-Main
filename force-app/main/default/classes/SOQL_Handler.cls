public with sharing class SOQL_Handler {
    @AuraEnabled
    public static List<Account> getSOQL_Result(){
        try {
            return [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Rating IN ('Hot', 'Warm', 'Cold') AND Industry IN ('Electronics') AND Active__c IN ('Yes', 'No', null)];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}