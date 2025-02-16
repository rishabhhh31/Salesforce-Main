public with sharing class QueueableContactScenario implements Queueable {
    public List<Account> accounts;
    public String apiName;
    public String value;
    public QueueableContactScenario(List<Account> accounts, String apiName, String value){
        this.accounts = accounts;
        this.apiName = apiName;
        this.value = value;
    }

    public void execute(QueueableContext context) {
        List<Contact> contacts = new List<Contact>();
        for(Contact con : [SELECT Id FROM Contact WHERE AccountId IN : accounts WITH USER_MODE]){
            con.put(apiName, value);
            contacts.add(con);
        }
        Database.update(contacts, false, AccessLevel.USER_MODE);
    }
}