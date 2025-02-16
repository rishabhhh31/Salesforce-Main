@IsTest
public with sharing class IntegrationQueueableTestMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        String jsonBody =   '{'+
                            '  "country": "IN",'+
                            '  "display_name": "Rishabh Jain",'+
                            '  "email": "rishabh3123jain@gmail.com",'+
                            '  "explicit_content": {'+
                            '    "filter_enabled": false,'+
                            '    "filter_locked": false'+
                            '  },'+
                            '  "external_urls": {'+
                            '    "spotify": "https://open.spotify.com/user/31jb6ccbssqi654knifm6p5yzklu"'+
                            '  },'+
                            '  "followers": {'+
                            '    "href": null,'+
                            '    "total": 0'+
                            '  },'+
                            '  "href": "https://api.spotify.com/v1/users/31jb6ccbssqi654knifm6p5yzklu",'+
                            '  "id": "31jb6ccbssqi654knifm6p5yzklu",'+
                            '  "images": [],'+
                            '  "product": "free",'+
                            '  "type": "user",'+
                            '  "uri": "spotify:user:31jb6ccbssqi654knifm6p5yzklu"'+
                            '}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonBody);
        res.setStatusCode(200);
        return res;
    }
}