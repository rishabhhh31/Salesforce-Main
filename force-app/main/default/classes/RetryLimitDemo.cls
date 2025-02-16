public class RetryLimitDemo implements Finalizer, Queueable {
    
    // Queueable implementation
    public void execute(QueueableContext ctx) {
        String jobId = '' + ctx.getJobId();
        System.debug('Begin: executing queueable job: ' + jobId);
        try {
            Finalizer finalizer = new RetryLimitDemo();
            System.attachFinalizer(finalizer);
            System.debug('Attached finalizer');
            Integer accountNumber = 1;
            while (true) { // results in limit error
                Account a = new Account();
                a.Name = 'Account-Number-' + accountNumber;
                insert a;
                accountNumber++;
            }
        } catch (Exception e) {
            System.debug('Error executing the job [' + jobId + ']: ' + e.getMessage());
        } finally {
            System.debug('Completed: execution of queueable job: ' + jobId);
        }
    }
    
    // Finalizer implementation
    public void execute(FinalizerContext ctx) {
        String parentJobId = '' + ctx.getAsyncApexJobId();
        System.debug('Begin: executing finalizer attached to queueable job: ' + parentJobId);
        if (ctx.getResult() == ParentJobResult.SUCCESS) {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
        } else {
            System.debug('Parent queueable job [' + parentJobId + '] failed due to unhandled exception: ' + ctx.getException().getMessage());
            System.debug('Enqueueing another instance of the queueable...');
            String newJobId = '' + System.enqueueJob(new RetryLimitDemo()); // This call fails after 5 times when it hits the chaining limit
            System.debug('Enqueued new job: ' + newJobId);
        }
        System.debug('Completed: execution of finalizer attached to queueable job: ' + parentJobId);
    }
}