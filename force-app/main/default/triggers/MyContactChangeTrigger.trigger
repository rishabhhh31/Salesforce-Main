trigger MyContactChangeTrigger on ContactChangeEvent (after insert) {
    List<Task> tasks = new List<Task>();
    for (ContactChangeEvent event : Trigger.New) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        if (header.changetype == 'CREATE') {
            Task tk = new Task();
            tk.Subject = 'Follow up on new account for record or group of records: ' +
              header.recordIds;
            tk.OwnerId = header.CommitUser; 
            tasks.add(tk);
        }        
        else if ((header.changetype == 'UPDATE')) {
            for (String field : header.changedFields) {
                if (null == event.get(field)) {
                } else {
                }
            }
        }     
    }
    
    if (tasks.size() > 0) {
        insert tasks;
    }
}