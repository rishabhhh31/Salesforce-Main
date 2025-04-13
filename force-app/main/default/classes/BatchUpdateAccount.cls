public with sharing class BatchUpdateAccount implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {

    private List<UpdateResponse> allResponses = new List<UpdateResponse>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT AccountNumber, AccountSource, Active__c, AnnualRevenue, BillingAddress, BillingCity, BillingCountry, BillingGeocodeAccuracy, BillingLatitude, BillingLongitude, BillingPostalCode, BillingState, BillingStreet, CustomerPriority__c, Description, Id, Industry, Name, NumberOfEmployees, NumberofLocations__c, Ownership, Rating, SLAExpirationDate__c, SLASerialNumber__c, SLA__c, ShippingAddress, ShippingCity, ShippingCountry, ShippingGeocodeAccuracy, ShippingLatitude, ShippingLongitude, ShippingPostalCode, ShippingState, ShippingStreet, Type FROM Account');
    }

    public void execute(Database.BatchableContext bc, List<Account> accList) {
        try {
            HttpRequest req = createRequest('/services/apexrest/api/Account', 'PATCH', accList);
            HttpResponse res = new Http().send(req);

            if (res.getStatusCode() == 200) {
                List<UpdateResponse> responseList = (List<UpdateResponse>) JSON.deserialize(res.getBody(), List<UpdateResponse>.class);
                allResponses.addAll(responseList);
                for (UpdateResponse response : responseList) {
                    System.debug('✔ Updated External Account - Id: ' + response.id + ', Status: ' + response.status + ', Message: ' + response.message);
                }
            } else {
                System.debug('✖ Callout failed - Status: ' + res.getStatusCode() + ', Body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('⚠️ Exception during callout: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('✅ Batch process completed for Account updates.');

        List<String> adminEmails = new List<String>();
        for (User u : [SELECT Email FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true AND Email != null]) {
            adminEmails.add(u.Email);
        }

        if (adminEmails.isEmpty()) {
            System.debug('⚠️ No admin emails found.');
            return;
        }

        String emailBody = 'Account Update Summary:\n\n';
        for (UpdateResponse response : allResponses) {
            emailBody += 'Account Id: ' + response.id + ', Status: ' + response.status + ', Message: ' + response.message + '\n';
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(adminEmails);
        mail.setSubject('Batch Update Account - Status Summary');
        mail.setPlainTextBody(emailBody);

        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('📧 Summary email sent to admins.');
        } catch (Exception ex) {
            System.debug('⚠️ Failed to send email: ' + ex.getMessage());
        }
    }

    private HttpRequest createRequest(String endpoint, String method, List<Account> accountList) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Salesforce' + endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(accountList));
        return req;
    }

    public class UpdateResponse {
        public String message;
        public String id;
        public Integer status;

        public UpdateResponse() {}
        public UpdateResponse(String message, String id, Integer status) {
            this.message = message;
            this.id = id;
            this.status = status;
        }
    }
}