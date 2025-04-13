public with sharing class AccountTriggerHandler {
    public static void stopAccountUpdateOneHour(List<Account> newAccList){
        try {
            Datetime pastTime = System.now().addHours(-1);
            for(Account acc : newAccList){
                if(acc.LastModifiedDate > pastTime){
                    acc.addError('Record is recently updated. Please try again after an hour');
                }
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());            
        }
    }

    public static void sendAccountExternal(List<Account> newAccounts){
        System.enqueueJob(new ExternalAccountController(newAccounts));
    }
    public static void sendDeletedAccountInfo(Map<Id, Account> deletedAccounts){
        System.enqueueJob(new DeleteExternalAccount(deletedAccounts.keySet()));
    }
}