@IsTest
public with sharing class IntegrationQueueableTest {
    @IsTest
    static void testIntegrationInQueuebale() {
        Test.setMock(HttpCalloutMock.class, new IntegrationQueueableTestMock());
        Test.startTest();
        System.enqueueJob(new IntegrationQueueable());
        Test.stopTest();
    }
}