public with sharing class ExternalAccountController implements Queueable, Database.AllowsCallouts {

    private List<Account> accounts;

    public ExternalAccountController(List<Account> accList) {
        this.accounts = accList;
    }

    public void execute(QueueableContext context) {
        try {
            HttpRequest req = createRequest('/services/apexrest/api/Account', 'POST', accounts);
            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                List<CreateResponseHandler> responseList = (List<CreateResponseHandler>)JSON.deserialize(res.getBody(), List<CreateResponseHandler>.class);
                List<Account> accountsToUpdate = new List<Account>();

                for (CreateResponseHandler handler : responseList) {
                    if (handler.status == 200 && String.isNotBlank(handler.id) && String.isNotBlank(handler.message)) {
                        accountsToUpdate.add(new Account(
                            Id = handler.id,
                            External_Account_Id__c = handler.message
                        ));
                    }
                }

                if (!accountsToUpdate.isEmpty()) {
                    try {
                        Database.update(accountsToUpdate, false);
                    } catch (DmlException dmlEx) {
                        System.debug('DML Exception while updating accounts: ' + dmlEx.getMessage());
                    }
                }
            } else {
                System.debug('HTTP callout failed with status: ' + res.getStatusCode() + ' and body: ' + res.getBody());
            }
        } catch (CalloutException calloutEx) {
            System.debug('Callout exception occurred: ' + calloutEx.getMessage());
        } catch (Exception ex) {
            System.debug('Unexpected exception: ' + ex.getMessage());
        }
    }

    private HttpRequest createRequest(String endpoint, String method, List<Account> accountList) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Salesforce' + endpoint);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json');
        if(accountList != null){
            req.setBody(JSON.serialize(accountList));
        }
        return req;
    }

    public class CreateResponseHandler {
        public Integer status;
        public String message;
        public String id;
    }
}