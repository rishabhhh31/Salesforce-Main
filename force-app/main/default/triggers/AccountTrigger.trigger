trigger AccountTrigger on Account (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        // AccountTriggerHandler.stopAccountUpdateOneHour(Trigger.new);
    }
}