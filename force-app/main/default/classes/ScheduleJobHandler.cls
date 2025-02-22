public with sharing class ScheduleJobHandler implements Schedulable{
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new QueueableApexScenario('Active__c', 'No'));
    }
}