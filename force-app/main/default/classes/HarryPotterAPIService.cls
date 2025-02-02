public with sharing class HarryPotterAPIService {

    /**
     * Retrieves a specific Harry Potter character by their ID.
     * 
     * @param characterId The ID of the character to retrieve.
     * @return The character details as a HarryPotterCharacterWrapper object.
     * @throws AuraHandledException if there is an API error or exception.
     */
    @AuraEnabled
    public static HarryPotterCharacterWrapper getCharacterById(String characterId) {
        try {
            // Construct API endpoint URL for fetching a specific character
            String endpoint = '/api/character/' + characterId;
            
            // Create and send HTTP request
            HttpRequest request = createHttpRequest(endpoint);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            // Check if the response status is OK (200)
            if (response.getStatusCode() == 200) {
                // Deserialize JSON response into a list of character objects
                List<HarryPotterCharacterWrapper> harryPotterCharacters = 
                    (List<HarryPotterCharacterWrapper>)JSON.deserialize(response.getBody(), List<HarryPotterCharacterWrapper>.class);
                
                // Ensure the response contains at least one character to prevent out-of-bounds errors
                if (!harryPotterCharacters.isEmpty()) {
                    return harryPotterCharacters[0];  // Return the first character
                } else {
                    throw new AuraHandledException('No character found for the given ID.');
                }
            } else {
                throw new AuraHandledException('API Error: ' + response.getBody());
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Exception thrown: ' + ex.getMessage());
        }
    }

    /**
     * Retrieves a list of Harry Potter characters based on the given category (students, staff, or all).
     * 
     * @param characterType The type of characters to fetch: 'students', 'staff', or 'error' (for testing error handling).
     * @return A list of HarryPotterCharacterWrapper objects.
     * @throws AuraHandledException if there is an API error or exception.
     */
    @AuraEnabled
    public static List<HarryPotterCharacterWrapper> getCharacters(String characterType) {
        try {
            // Base API endpoint for retrieving all characters
            String endpoint = '/api/characters';
            
            // Append category-specific endpoints
            if (characterType == 'students') {
                endpoint += '/students';
            } else if (characterType == 'staff') {
                endpoint += '/staff';
            } else if (characterType == 'error') {
                endpoint += '/error';  // Simulating an error response
            }

            // Create and send HTTP request
            HttpRequest request = createHttpRequest(endpoint);
            HttpResponse response = new Http().send(request);
            
            // Check if the response status is OK (200)
            if (response.getStatusCode() == 200) {
                return (List<HarryPotterCharacterWrapper>) 
                    JSON.deserialize(response.getBody(), List<HarryPotterCharacterWrapper>.class);
            } else {
                throw new AuraHandledException('Error from API: ' + response.getBody());
            }
        } catch (Exception ex) {
            throw new AuraHandledException('Exception thrown: ' + ex.getMessage());
        }
    }

    /**
     * Helper method to create and configure an HTTP request.
     * 
     * @param endpoint The API endpoint to call.
     * @return A configured HttpRequest object.
     */
    private static HttpRequest createHttpRequest(String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:HarryPotter' + endpoint);  // Use Named Credential 'HarryPotter'
        request.setMethod('GET');  // GET request to retrieve data
        request.setHeader('Content-Type', 'application/json');  // Set content type
        return request;
    }

    /**
     * Wrapper class to represent a Harry Potter character.
     */
    public class HarryPotterCharacterWrapper {
        @AuraEnabled public String id;  // Unique character ID
        @AuraEnabled public String name;  // Character name
        @AuraEnabled public List<String> alternate_names;  // List of alternative names
        @AuraEnabled public String species;  // Species (e.g., human, elf, etc.)
        @AuraEnabled public String gender;  // Gender of the character
        @AuraEnabled public String house;  // Hogwarts house (Gryffindor, Slytherin, etc.)
        @AuraEnabled public String dateOfBirth;  // Date of birth (string format)
        @AuraEnabled public Integer yearOfBirth;  // Year of birth (integer format)
        @AuraEnabled public Boolean wizard;  // Indicates if the character is a wizard
        @AuraEnabled public String ancestry;  // Ancestry information (e.g., Pure-blood, Half-blood)
        @AuraEnabled public String eyeColour;  // Eye color of the character
        @AuraEnabled public String hairColour;  // Hair color of the character
        @AuraEnabled public Wand wand;  // Wand details
        @AuraEnabled public String patronus;  // Patronus animal (if applicable)
        @AuraEnabled public Boolean hogwartsStudent;  // Indicates if the character is a student
        @AuraEnabled public Boolean hogwartsStaff;  // Indicates if the character is a staff member
        @AuraEnabled public String actor;  // Actor who portrayed the character in movies
        @AuraEnabled public List<String> alternate_actors;  // List of alternative actors
        @AuraEnabled public Boolean alive;  // Indicates if the character is still alive
        @AuraEnabled public String image;  // URL to the character's image
    }
    
    /**
     * Inner class to represent a character's wand.
     */
    public class Wand {
        @AuraEnabled public String wood;  // Type of wood used in the wand
        @AuraEnabled public String core;  // Core material of the wand (e.g., Phoenix feather)
        @AuraEnabled public Double length;  // Wand length in inches
    }
}