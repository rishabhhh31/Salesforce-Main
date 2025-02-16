public with sharing class IntegrationQueueable implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext qc) {
        String endpoint = '/v1/me';
        String method = 'GET';
        for(Integer i = 1 ; i <= 100 ; i++){
            HttpRequest request = createRequest(endpoint, method, null);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
        }
    }

    public static HttpRequest createRequest(String endpoint, String method, String body){
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:Spotify'+endpoint);
		request.setMethod(method);
		if(body != null){
			request.setBody(body);
		}
		request.setHeader('Accept', 'application/json');
		return request;
	}
}