public with sharing class HarryPotterAPIService {

    @AuraEnabled
    public static List<HarryPotterCharacterWrapper> getCharacterById(String characterId){
        try {
            String endpoint = '/api/character/'+characterId;
            HttpRequest request = createHttpRequest(endpoint);
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                List<HarryPotterCharacterWrapper> harryPotterStaffs = (List<HarryPotterCharacterWrapper>)JSON.deserialize(response.getBody(), List<HarryPotterCharacterWrapper>.class);
                return harryPotterStaffs;
            }else{
                throw new AuraHandledException(response.getBody());
            }
        } catch (CalloutException ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    
    @AuraEnabled
    public static List<HarryPotterCharacterWrapper> getCharacters(String characterType) {
        try {
            String endpoint = '/api/characters';
            
            if (characterType == 'students') {
                endpoint += '/students';
            } else if (characterType == 'staff') {
                endpoint += '/staff';
            }

            HttpRequest request = createHttpRequest(endpoint);
            HttpResponse response = new Http().send(request);
            
            if (response.getStatusCode() == 200) {
                return (List<HarryPotterCharacterWrapper>) JSON.deserialize(response.getBody(), List<HarryPotterCharacterWrapper>.class);
            } else {
                throw new AuraHandledException('Error from API: ' + response.getBody());
            }
        } catch (Exception ex) {
            System.debug('Exception in getCharacters: ' + ex.getMessage());
            throw new AuraHandledException('Failed to fetch characters: ' + ex.getMessage());
        }
    }

    private static HttpRequest createHttpRequest(String endpoint) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:HarryPotter' + endpoint);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        return request;
    }

    public class HarryPotterCharacterWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public List<String> alternate_names;
        @AuraEnabled public String species;
        @AuraEnabled public String gender;
        @AuraEnabled public String house;
        @AuraEnabled public String dateOfBirth;
        @AuraEnabled public Integer yearOfBirth;
        @AuraEnabled public Boolean wizard;
        @AuraEnabled public String ancestry;
        @AuraEnabled public String eyeColour;
        @AuraEnabled public String hairColour;
        @AuraEnabled public Wand wand;
        @AuraEnabled public String patronus;
        @AuraEnabled public Boolean hogwartsStudent;
        @AuraEnabled public Boolean hogwartsStaff;
        @AuraEnabled public String actor;
        @AuraEnabled public List<String> alternate_actors;
        @AuraEnabled public Boolean alive;
        @AuraEnabled public String image;
    }
    
    public class Wand {
        @AuraEnabled public String wood;
        @AuraEnabled public String core;
        @AuraEnabled public Double length;
    }
}