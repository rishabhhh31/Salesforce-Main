public with sharing class OpportunityTriggerHandler {
    public static void preventMultipleOpportunityInADay(List<Opportunity> newOpps){
        Map<Id, List<Opportunity>> accountOppMap = new Map<Id, List<Opportunity>>();

        for(Opportunity op : newOpps){
            if(op.AccountId != null){
                if(!accountOppMap.containsKey(op.AccountId)){
                    accountOppMap.put(op.AccountId, new List<Opportunity>());
                }
                accountOppMap.get(op.AccountId).add(op);
            }
        }

        if(!accountOppMap.isEmpty()){
            DateTime lastDayTime = System.now().addDays(-1);
            List<AggregateResult> accountResult = [SELECT count(Id)oppCount, AccountId FROM Opportunity WHERE AccountId IN: accountOppMap.keySet() AND CreatedDate >: lastDayTime GROUP BY AccountId];
            for(AggregateResult aagr : accountResult){
                Integer count = (Integer)aagr.get('oppCount');
                String accId = (String)aagr.get('AccountId');
                if(accountOppMap.keySet().contains(accId) && count > 0){
                    for(Opportunity opp : accountOppMap.get(accId)){
                        opp.addError('You can not create more than one Opportunity in a day');
                    }
                }
            }
        }
    }
}