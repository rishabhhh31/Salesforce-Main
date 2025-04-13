public with sharing class ScheduleExternalAccountUpdate implements Schedulable {
    public void execute(SchedulableContext SC) {
        BatchUpdateAccount batchAccounts = new BatchUpdateAccount();
        Database.executeBatch(batchAccounts);
    }
}