public with sharing class DeleteExternalAccount implements Queueable, Database.AllowsCallouts {

    private Set<Id> accountIds;

    public DeleteExternalAccount(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {
        try {
            if (accountIds == null || accountIds.isEmpty()) {
                System.debug('No Account IDs provided for deletion.');
                return;
            }

            String recordIdParam = EncodingUtil.urlEncode(String.join(new List<Id>(accountIds), ','), 'UTF-8');
            HttpRequest req = createRequest('/services/apexrest/api/Account?recordIds=' + recordIdParam, 'DELETE');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                List<DeletedResponseHandler> responseList = 
                    (List<DeletedResponseHandler>) JSON.deserialize(res.getBody(), List<DeletedResponseHandler>.class);
                for (DeletedResponseHandler response : responseList) {
                    System.debug('Deleted External Account - Id: ' + response.id + ', Status: ' + response.status + ', Message: ' + response.message);
                }
            } else {
                System.debug('Callout failed - Status: ' + res.getStatusCode() + ', Body: ' + res.getBody());
            }

        } catch (CalloutException calloutEx) {
            System.debug('Callout exception: ' + calloutEx.getMessage());
        } catch (Exception ex) {
            System.debug('Unexpected error: ' + ex.getMessage());
        }
    }

    private HttpRequest createRequest(String endpoint, String method) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Salesforce' + endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        return req;
    }

    public class DeletedResponseHandler {
        public Integer status;
        public String message;
        public String id;
    }
}
