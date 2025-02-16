trigger SubscriberTrigger on Subscriber__c (after insert, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            // SubscriberHandler.handlerSubscribers(Trigger.new);
        }
        if(Trigger.isDelete){
            // SubscriberHandler.handlerSubscribers(Trigger.old);
        }
    }
}