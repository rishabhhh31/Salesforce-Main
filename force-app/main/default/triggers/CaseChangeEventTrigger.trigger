trigger CaseChangeEventTrigger on CaseChangeEvent (after insert) {
    
    List<CaseChangeEvent> changes = Trigger.new;
    Set<String> caseIds = new Set<String>();
    
    // Collect all Record Ids from the ChangeEventHeader
    for (CaseChangeEvent change : changes) {
        List<String> recordIds = change.ChangeEventHeader.getRecordIds();
        caseIds.addAll(recordIds);
    }
    
    // Perform computation to determine Red Account status based on case changes
    RedAccountPredictor predictor = new RedAccountPredictor();
    Map<String, Boolean> accountsToRedAccountStatus = predictor.predictForCases(new List<String>(caseIds));
    
    // Prepare platform events for accounts predicted as Red
    List<Red_Account__e> redAccountEvents = new List<Red_Account__e>();
    
    for (String acctId : accountsToRedAccountStatus.keySet()) {
        String rating = accountsToRedAccountStatus.get(acctId) ? 'Red' : 'Green';
        
        if (rating == 'Red') {
            redAccountEvents.add(new Red_Account__e(
                Account_Id__c = acctId, 
                Rating__c = rating
            ));
        }
    }
    
    System.debug('RED_ACCT: ' + redAccountEvents);
    
    // Publish events if there are any Red Account predictions
    if (!redAccountEvents.isEmpty()) {
        EventBus.publish(redAccountEvents);
    }
}