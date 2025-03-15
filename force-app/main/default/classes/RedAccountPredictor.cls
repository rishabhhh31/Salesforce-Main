public class RedAccountPredictor {

    private static final Integer MAX_CASES_EXPECTED = 2;
    
    public RedAccountPredictor() {}
    
    /**
     * First method to be called for performing account status prediction.
     * Get the account IDs related to the passed-in case IDs and call a predictor method.
     * Return a map of account ID to account status Boolean.
     */
    public Map<String, Boolean> predictForCases(List<String> caseIds) {
        List<Case> casesMatchingIds = [
            SELECT Id, AccountId FROM Case WHERE Id IN :caseIds
        ];
        
        if (casesMatchingIds != null && !casesMatchingIds.isEmpty()) {
            List<String> accountIds = new List<String>();
            for (Case c : casesMatchingIds) {
                if (c.Account != null) {
                    accountIds.add(c.AccountId);
                }
            }
            return predictForAccounts(accountIds);
        } else {
            return new Map<String, Boolean>();
        }
    }
    
    /**
     * Perform slow, resource-intensive calculation to determine if an account is in RED status.
     * (e.g., Einstein predictions, etc.)
     */
    public Map<String, Boolean> predictForAccounts(List<String> acctIds) {
        List<Case> casesForAccounts = [
            SELECT Id, Account.Id, Status, CaseNumber, Priority, IsEscalated, SLAViolation__c 
            FROM Case 
            WHERE AccountId IN :acctIds AND Status != 'Closed'
        ];
        
        Map<String, List<Case>> accountsToCases = new Map<String, List<Case>>();
        
        for (Case c : casesForAccounts) {
            if (c.Account == null) continue;
            
            if (!accountsToCases.containsKey(c.Account.Id)) {
                accountsToCases.put(c.Account.Id, new List<Case>());
            }
            accountsToCases.get(c.Account.Id).add(c);
        }
        
        Map<String, Boolean> results = new Map<String, Boolean>();
        
        for (String acctId : accountsToCases.keySet()) {
            results.put(acctId, predict(accountsToCases.get(acctId)));
        }
        
        return results;
    }
    
    /**
     * Perform the account status prediction.
     * Return true if the account is red; otherwise, return false.
     */
    private Boolean predict(List<Case> casesForAccount) {
        Boolean isEscalated = false;
        Boolean hasSlaViolation = false;
        Boolean hasHighPriority = false;
        Boolean allStatusesResolved = true;
        
        for (Case openCase : casesForAccount) {
            isEscalated |= openCase.IsEscalated;
            hasSlaViolation |= (openCase.SLAViolation__c == 'Yes');
            hasHighPriority |= openCase.Priority == 'High';
            allStatusesResolved &= (openCase.Status == 'Closed' || openCase.Status == 'Part Received');
        }
        
        if (allStatusesResolved) {
            return false;
        }
        
        if (casesForAccount.size() > MAX_CASES_EXPECTED) {
            return true;
        } else if (isEscalated || hasSlaViolation) {
            return true;
        } else if (hasHighPriority) {
            return true;
        }
        
        return false;
    }
}