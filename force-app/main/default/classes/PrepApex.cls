public with sharing class PrepApex {
    @AuraEnabled(cacheable = true)
    public static List<Case> getAllCases(){
        try {
            return [SELECT Id, CaseNumber, Priority, Status, Origin, Reason FROM Case ORDER BY CaseNumber];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}