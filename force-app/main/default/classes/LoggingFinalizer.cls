public class LoggingFinalizer implements Finalizer, Queueable {

  // Queueable implementation
  // A queueable job that uses LoggingFinalizer to buffer the log
  // and commit upon exit, even if the queueable execution fails

    public void execute(QueueableContext ctx) {
        String jobId = '' + ctx.getJobId();
        System.debug('Begin: executing queueable job: ' + jobId);
        try {
            // Create an instance of LoggingFinalizer and attach it
            // Alternatively, System.attachFinalizer(this) can be used instead of instantiating LoggingFinalizer
            LoggingFinalizer f = new LoggingFinalizer();
            System.attachFinalizer(f);

            // While executing the job, log using LoggingFinalizer.addLog()
            // Note that addlog() modifies the Finalizer's state after it is attached 
            f.addLog(jobId);

            while (true) {
                //Intention unhandled exception
                List<Account> accList = [SELECT Id FROM Account];
            }
        } catch (Exception e) {
            System.debug('Error executing the job [' + jobId + ']: ' + e.getMessage());
        } finally {
            System.debug('Completed: execution of queueable job: ' + jobId);
        }
    }

  // Finalizer implementation
  // Logging finalizer provides a public method addLog(message,source) that allows buffering log lines from the Queueable job.
  // When the Queueable job completes, regardless of success or failure, the LoggingFinalizer instance commits this buffered log.
  // Custom object Log_Message__c has four custom fields-see addLog() method.

    // internal log buffer
    private List<Log_Message__c> logRecords = new List<Log_Message__c>();

    public void execute(FinalizerContext ctx) {
        System.debug('Request Id=>'+ctx.getRequestId());
        System.debug('getException=>'+ctx.getException());
        System.debug('getResult=>'+ctx.getResult());

        String parentJobId = ctx.getAsyncApexJobId();
        System.debug('Begin: executing finalizer attached to queueable job: ' + parentJobId);

        // Update the log records with the parent queueable job id
        System.Debug('Updating job id on ' + logRecords.size() + ' log records');
        for (Log_Message__c log : logRecords) {
            log.Request__c = parentJobId; // or could be ctx.getRequestId()
            log.Message__c = ctx.getRequestId();
        }
        // Commit the buffer
        System.Debug('committing log records to database');
        Database.insert(logRecords, false);

        if (ctx.getResult() == ParentJobResult.SUCCESS) {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
        } else {
            System.debug('Parent queueable job [' + parentJobId + '] failed due to unhandled exception: ' + ctx.getException().getMessage());
            System.debug('Enqueueing another instance of the queueable...');
        }
        System.debug('Completed: execution of finalizer attached to queueable job: ' + parentJobId);
    }

    public void addLog(String source) {
        // append the log message to the buffer
        logRecords.add(new Log_Message__c(
            Log_Date_Time__c = DateTime.now(),
            Source__c = source
        ));
    }
}