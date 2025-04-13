trigger AccountTrigger on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.sendAccountExternal(Trigger.new);
    }
}