@RestResource(urlMapping='/api/Account/*')
global class ExternalAccountHandlerAPI {

    @HttpPost
    global static void createNewAccount() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<CreateResponse> responses = new List<CreateResponse>();

        try {
            String accountsJson = req.requestBody.toString();
            if (String.isBlank(accountsJson)) {
                res.statusCode = 400;
                responses.add(new CreateResponse('Request body is empty', null, 400));
                res.responseBody = Blob.valueOf(JSON.serialize(responses));
                return;
            }

            List<Account> incomingAccounts = (List<Account>) JSON.deserialize(accountsJson, List<Account>.class);
            List<Account> accountsToInsert = new List<Account>();

            for (Account acc : incomingAccounts) {
                Account accCopy = acc.clone(false, false, false, false);
                accCopy.External_Account_Id__c = acc.Id;
                accCopy.OwnerId = UserInfo.getUserId();
                accountsToInsert.add(accCopy);
            }

            if (!accountsToInsert.isEmpty()) {
                Database.SaveResult[] results = Database.insert(accountsToInsert, false);
                for (Integer i = 0; i < results.size(); i++) {
                    CreateResponse cr = new CreateResponse();
                    cr.id = incomingAccounts[i].Id;
                    if (results[i].isSuccess()) {
                        cr.status = 200;
                        cr.message = results[i].getId();
                    } else {
                        cr.status = 400;
                        cr.message = results[i].getErrors()[0].getMessage();
                    }
                    responses.add(cr);
                }
            }

            res.statusCode = 200;
        } catch (JSONException ex) {
            res.statusCode = 400;
            responses.add(new CreateResponse('Invalid JSON format: ' + ex.getMessage(), null, 400));
        } catch (Exception ex) {
            res.statusCode = 500;
            responses.add(new CreateResponse('Unexpected server error: ' + ex.getMessage(), null, 500));
        } finally {
            res.responseBody = Blob.valueOf(JSON.serialize(responses));
        }
    }

    global class CreateResponse {
        public String message;
        public String id;
        public Integer status;

        public CreateResponse() {}
        public CreateResponse(String message, String id, Integer status) {
            this.message = message;
            this.id = id;
            this.status = status;
        }
    }

    @HttpDelete
    global static void deleteAccounts() {
        RestResponse res = RestContext.response;
        List<DeleteResponse> responses = new List<DeleteResponse>();

        try {
            RestRequest req = RestContext.request;
            String idsParam = req.params.get('recordIds');

            if (String.isBlank(idsParam)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(
                    new List<DeleteResponse>{ new DeleteResponse('Missing required parameter: recordIds', null, 400) }
                ));
                return;
            }

            List<String> recordIds = idsParam.split(',');
            if (recordIds.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(
                    new List<DeleteResponse>{ new DeleteResponse('No record IDs provided', null, 400) }
                ));
                return;
            }

            List<Account> accountsToDelete = [
                SELECT Id FROM Account WHERE External_Account_Id__c IN :recordIds
            ];

            if (accountsToDelete.isEmpty()) {
                res.statusCode = 404;
                res.responseBody = Blob.valueOf(JSON.serialize(
                    new List<DeleteResponse>{ new DeleteResponse('No matching external accounts found for deletion', null, 404) }
                ));
                return;
            }

            List<Database.DeleteResult> deleteResults = Database.delete(accountsToDelete, false);

            for (Database.DeleteResult resultItem : deleteResults) {
                DeleteResponse delRes = new DeleteResponse();
                delRes.id = resultItem.getId();
                if (resultItem.isSuccess()) {
                    delRes.status = 200;
                    delRes.message = 'Record deleted successfully';
                } else {
                    delRes.status = 400;
                    delRes.message = resultItem.getErrors()[0].getMessage();
                }
                responses.add(delRes);
            }

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(responses));

        } catch (Exception ex) {
            responses.add(new DeleteResponse('Unexpected error: ' + ex.getMessage(), null, 500));
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(responses));
        }
    }

    global class DeleteResponse {
        public String message;
        public String id;
        public Integer status;

        public DeleteResponse() {}

        public DeleteResponse(String message, String id, Integer status) {
            this.message = message;
            this.id = id;
            this.status = status;
        }
    }

    @HttpPatch
    global static void updateAccounts() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<UpdateResponse> responses = new List<UpdateResponse>();
        try {
            String accountJson = req.requestBody != null ? req.requestBody.toString() : '';
            if (String.isBlank(accountJson)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(
                    new List<UpdateResponse>{
                        new UpdateResponse('Request body is empty or invalid', null, 400)
                    }
                ));
                return;
            }

            List<Account> incomingAccounts = (List<Account>)JSON.deserialize(accountJson, List<Account>.class);
            if (incomingAccounts.isEmpty()) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf(JSON.serialize(
                    new List<UpdateResponse>{
                        new UpdateResponse('No accounts provided for update', null, 400)
                    }
                ));
                return;
            }
            
            Map<Id, Account> accountMap = new Map<Id, Account>();
            for(Account account :  incomingAccounts){
                accountMap.put(account.Id, account);
            }
    
            List<Account> accountToUpdate = [SELECT Id, External_Account_Id__c FROM Account WHERE External_Account_Id__c IN : accountMap.keySet() AND External_Account_Id__c != null];
            List<Account> accountList = new List<Account>();
            for(Account acc : accountToUpdate){
                if(accountMap.containsKey(acc.External_Account_Id__c)){
                    Account accUpd = accountMap.get(acc.External_Account_Id__c).clone(false, false, false, false);
                    accUpd.Id = acc.Id;
                    accUpd.OwnerId = UserInfo.getUserId();
                    accountList.add(accUpd);
                }
            }
            if(!accountList.isEmpty()){
                Database.SaveResult[] results = Database.update(accountList, false);
                for (Database.SaveResult result : results) {
                    responses.add(
                        new UpdateResponse(
                            result.isSuccess() ? 'Record updated successfully' : result.getErrors()[0].getMessage(),
                            result.getId(),
                            result.isSuccess() ? 200 : 400
                        )
                    );
                }
                RestContext.response.statusCode = 200;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responses));
            } else {
                responses.add(new UpdateResponse('No matching accounts found to update', null, 404));
            }

        } catch (Exception ex) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(
                new List<UpdateResponse>{
                    new UpdateResponse('Unexpected Error: ' + ex.getMessage(), null, 500)
                }
            ));
        }
    }

    global class UpdateResponse {
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
