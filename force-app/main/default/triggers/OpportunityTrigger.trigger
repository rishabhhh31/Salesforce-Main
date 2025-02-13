trigger OpportunityTrigger on Opportunity (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        // OpportunityTriggerHandler.preventMultipleOpportunityInADay(Trigger.new);
    }
}