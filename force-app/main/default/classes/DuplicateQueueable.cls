public with sharing class DuplicateQueueable  implements Queueable{
    public void execute(QueueableContext qc){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
    }

    /*
    //Execute Anonymouse code
    
    try {
        AsyncOptions options = new AsyncOptions();
        options.DuplicateSignature = new System.QueueableDuplicateSignature.Builder()
            .addId([SELECT Id FROM ApexClass WHERE Name = 'DuplicateQueueable'].Id)
            .addString('DuplicateQueueable')
            .addInteger(1)
            .build();
        System.enqueueJob(new DuplicateQueueable(), options);
    } catch (Exception ex) {
        //signature
        System.debug('Attempt to enqueue job with duplicate queueable signature'+
                    ex.getMessage());
    }
    */
}