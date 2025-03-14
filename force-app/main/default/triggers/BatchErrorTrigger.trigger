trigger BatchErrorTrigger on BatchApexErrorEvent (after insert) {
    //SELECT Id, ReplayId, CreatedDate, CreatedById, EventUuid, 
    //ExceptionType, Message, StackTrace, RequestId, AsyncApexJobId, JobScope, DoesExceedJobScopeMaxLength
    //, Phase 
    //FROM BatchApexErrorEvent
    if(Trigger.isInsert && Trigger.isAfter){
        List<Task> taskList = new List<Task>();
        for(BatchApexErrorEvent error : Trigger.new){
            Task tk = new Task();
            tk.Subject = error.ExceptionType;
            tk.Description = 'Message => '+error.Message+'\nStackTrace => '+error.StackTrace+'\nRequestId => '+error.RequestId+'\nJobScope => '+error.JobScope;
        	taskList.add(tk);
        }
        if(!taskList.isEmpty()){
            insert taskList;
        }
    }
}