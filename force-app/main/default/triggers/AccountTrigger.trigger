trigger AccountTrigger on Account (after insert, after delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.sendAccountExternal(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        AccountTriggerHandler.sendDeletedAccountInfo(Trigger.oldMap);
    }
}