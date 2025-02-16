public with sharing class SubscriberHandler {
    public static void handlerSubscribers(List<Subscriber__c> subscribers){
        Set<Id> accIds = new Set<Id>();
        for(Subscriber__c sub : subscribers){
            if(sub.Account__c != null){
                accIds.add(sub.Account__c);
            }
        }

        if(accIds.isEmpty()){
            return;
        }

        List<Subscriber__c> recentSubscriberList = [SELECT Id, Account__c FROM Subscriber__c WHERE Account__c IN : accIds ORDER BY CreatedDate DESC];
        Map<Id, Subscriber__c> recentSubMap = new Map<Id, Subscriber__c>();
        for(Subscriber__c sub : recentSubscriberList){
            if(!recentSubMap.containsKey(sub.Account__c)){
                sub.Recent_Subscriber__c = true;
                recentSubMap.put(sub.Account__c, sub);
            }else {
                sub.Recent_Subscriber__c = false;
            }
        }
        if(recentSubscriberList.isEmpty()){
            return;
        }

        Database.update(recentSubscriberList, false, AccessLevel.USER_MODE);
    }
}