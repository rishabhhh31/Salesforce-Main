@IsTest
public with sharing class QueueableApexScenarioTest {
    @TestSetup
    static void makeTestData(){
        List<Account> accList = new List<Account>();
        for(Integer i = 1 ; i <= 5 ; i++){
            Account acc = new Account();
            acc.Name = 'Test '+i;
            accList.add(acc);
        }
        Database.insert(accList, false, AccessLevel.USER_MODE);   
        
        List<Contact> conList = new List<Contact>();
        for(Account acc : accList){
            Contact con = new Contact();
            con.LastName = acc.Name + ' Test';
            con.AccountId = acc.Id;
            conList.add(con);
        }
        Database.insert(conList, false, AccessLevel.USER_MODE);   
    }
    @IsTest
    static void testQueueableApexScenario() {
        QueueableApexScenario first = new QueueableApexScenario('Industry','Banking');
        first.execute(null);
        QueueableContactScenario second = new QueueableContactScenario([SELECT Id FROM Account], 'Email', 'test@queueable.com');
        second.execute(null);

        Account acc = [SELECT Id, Industry FROM Account LIMIT 1];
        Assert.areEqual('Banking', acc.Industry, 'Industry should be Banking');
        Contact con = [SELECT Id, Email FROM Contact LIMIT 1];
        Assert.areEqual('test@queueable.com', con.Email, 'Email should be test@queueable.com');
    }
}