public with sharing class QueueableApexScenario implements Queueable {
    public String apiName;
    public String value;
    public QueueableApexScenario(String apiName, String value){
        this.apiName = apiName;
        this.value = value;
    }

    public void execute(QueueableContext context) {
        List<Account> accList = new List<Account>();
        for(Account acc : [SELECT Id FROM Account WITH USER_MODE]){
            acc.put(apiName, value);
            accList.add(acc);
        }
        Database.update(accList, false, AccessLevel.USER_MODE);
        System.enqueueJob(new QueueableContactScenario(accList, 'Email', 'test@queueable.com'));
    }
}