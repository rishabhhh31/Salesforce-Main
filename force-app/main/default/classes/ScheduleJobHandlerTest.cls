@IsTest
public with sharing class ScheduleJobHandlerTest {
    @TestSetup
    static void makeTestData(){
        List<Account> accList = new List<Account>();
        for(Integer i = 0 ; i <= 5 ; i++){
            accList.add(new Account(Name = 'Test :' + i));
        }        
        if(!accList.isEmpty()){
            insert accList;
            List<Contact> conList = new List<Contact>();
            for(Account acc : accList){
                if(acc.Id != null){
                    conList.add(new Contact(FirstName = acc.Name, LastName = 'Test', AccountId = acc.Id));
                }
            }
            if(!conList.isEmpty()){
                insert conList;
            }
        }
    }
    
    @IsTest
    static void testSchedulableJob(){
        Test.startTest();
        Test.stopTest();
        Account acc = [SELECT Active__c, (SELECT Email FROM Contacts) FROM Account LIMIT 1];
        System.debug(JSON.serializePretty(acc));
    }
}