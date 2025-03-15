@isTest
public class TestMyAccountChangeTrigger {
    @isTest static void testNewAndUpdatedAccount() {
        // Enable all Change Data Capture entities for notifications.
        Test.enableChangeDataCapture();

        // Insert an account to generate a change event. 
        Contact newAcct = new Contact(FirstName='TestAccount', LastName='4155551212'); 
        insert newAcct;
        
        // Call deliver to fire the trigger and deliver the test change event.
        Test.getEventBus().deliver();
        
        // VERIFICATIONS
        // Check that the change event trigger created a task.
        Task[] taskList = [SELECT Id,Subject FROM Task];        
        System.assertEquals(1, taskList.size(),
            'The change event trigger did not create the expected task.');
            
        // Update account record
        Contact queriedAcct = [SELECT Id,FirstName,LastName FROM Contact WHERE Id=:newAcct.Id];
        // Debug
        System.debug('Retrieved account record: ' + queriedAcct);
        // Update one field and empty another
        queriedAcct.Title = 'Developer';
        queriedAcct.Phone = null;
        update queriedAcct;
        
        // Call deliver to fire the trigger for the update operation
        Test.getEventBus().deliver();
        
        // VERIFICATIONS
        // Check that the change event trigger did NOT create a task.
        // We should still have only 1 task.
        Task[] taskList2 = [SELECT Id,Subject FROM Task];
        System.assertEquals(1, taskList2.size(),
            'The change event trigger created a task unepextedly.');
    }    
}