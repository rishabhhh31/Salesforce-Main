@IsTest
global with sharing class HarryPotterAPIServiceMock implements HttpCalloutMock {
    /**
     * This method is a mock implementation of an HTTP callout response.
     * It simulates an API response for a Harry Potter character.
     * 
     * @param req - The incoming HTTP request object.
     * @return HttpResponse - A simulated response based on the request.
     */
    global HTTPResponse respond(HTTPRequest req) {
        // Create a new HTTP response object
        HttpResponse res = new HttpResponse();
        
        // Mock JSON response representing Harry Potter's details
        String jsonBody = '['+
        '  {'+
        '    "id": "9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8",'+
        '    "name": "Harry Potter",'+
        '    "alternate_names": ['+
        '      "The Boy Who Lived",'+
        '      "The Chosen One",'+
        '      "Undesirable No. 1",'+
        '      "Potty"'+
        '    ],'+
        '    "species": "human",'+
        '    "gender": "male",'+
        '    "house": "Gryffindor",'+
        '    "dateOfBirth": "31-07-1980",'+
        '    "yearOfBirth": 1980,'+
        '    "wizard": true,'+
        '    "ancestry": "half-blood",'+
        '    "eyeColour": "green",'+
        '    "hairColour": "black",'+
        '    "wand": {'+
        '      "wood": "holly",'+
        '      "core": "phoenix tail feather",'+
        '      "length": 11'+
        '    },'+
        '    "patronus": "stag",'+
        '    "hogwartsStudent": true,'+
        '    "hogwartsStaff": false,'+
        '    "actor": "Daniel Radcliffe",'+
        '    "alternate_actors": [],'+
        '    "alive": true,'+
        '    "image": "https://ik.imagekit.io/hpapi/harry.jpg"'+
        '  }]'+
        '';

        // Set the content type of the response to JSON
        res.setHeader('Content-Type', 'application/json');

        // Determine status code based on the request endpoint
        // If the endpoint contains 'error', return a 400 (Bad Request) status code
        // Otherwise, return a 200 (OK) status code
        Integer statusCode = req.getEndpoint().contains('error') ? 400 : 200;
        
        // Set response body and status code
        res.setBody(jsonBody);
        res.setStatusCode(statusCode);

        // Return the mocked response
        return res;
    }
}