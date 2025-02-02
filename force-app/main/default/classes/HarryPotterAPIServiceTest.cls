@IsTest
public with sharing class HarryPotterAPIServiceTest {
    
    /**
     * Test case to verify the API response when an error condition is simulated.
     * It ensures that the API correctly handles error scenarios.
     */
    @IsTest
    static void getCharactersforCharactersErrorTest(){
        try {
            // Set mock response for HTTP callout
            Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

            // Make API call with 'error' endpoint
            List<HarryPotterAPIService.HarryPotterCharacterWrapper> wrapper = HarryPotterAPIService.getCharacters('error');

            // Validate the response
            Assert.areEqual(1, wrapper.size(), '1 character should have been returned');
            HarryPotterAPIService.HarryPotterCharacterWrapper potter = wrapper[0];
            Assert.areEqual('Harry Potter', potter.name);
            Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
        }
        catch (AuraHandledException ex) {
            // Verify the exception message when an error occurs
            Assert.isTrue(ex.getMessage().contains('Script-thrown exception'), 'Exception message is wrong');
        }
    }

    /**
     * Test case to verify that the API fetches character details correctly.
     */
    @IsTest
    static void getCharactersforCharactersTest(){
        Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

        // Fetch characters without any filter
        List<HarryPotterAPIService.HarryPotterCharacterWrapper> wrapper = HarryPotterAPIService.getCharacters('');

        // Validate the response
        Assert.areEqual(1, wrapper.size(), '1 character should have been returned');
        HarryPotterAPIService.HarryPotterCharacterWrapper potter = wrapper[0];
        Assert.areEqual('Harry Potter', potter.name);
        Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
    }

    /**
     * Test case to verify the API response for Hogwarts staff filter.
     */
    @IsTest
    static void getCharactersforStudentsTest(){
        Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

        // Fetch characters with 'staff' filter
        List<HarryPotterAPIService.HarryPotterCharacterWrapper> wrapper = HarryPotterAPIService.getCharacters('staff');

        // Validate the response
        Assert.areEqual(1, wrapper.size(), '1 character should have been returned');
        HarryPotterAPIService.HarryPotterCharacterWrapper potter = wrapper[0];
        Assert.areEqual('Harry Potter', potter.name);
        Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
    }

    /**
     * Test case to verify the API response for Hogwarts students filter.
     */
    @IsTest
    static void getCharactersforStaffTest(){
        Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

        // Fetch characters with 'students' filter
        List<HarryPotterAPIService.HarryPotterCharacterWrapper> wrapper = HarryPotterAPIService.getCharacters('students');

        // Validate the response
        Assert.areEqual(1, wrapper.size(), '1 character should have been returned');
        HarryPotterAPIService.HarryPotterCharacterWrapper potter = wrapper[0];
        Assert.areEqual('Harry Potter', potter.name);
        Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
    }

    /**
     * Test case to verify fetching character details by a specific character ID.
     */
    @IsTest
    static void getCharacterByIdTest(){
        Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

        // Fetch character by ID
        HarryPotterAPIService.HarryPotterCharacterWrapper potter = HarryPotterAPIService.getCharacterById('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8');

        // Validate the response
        Assert.isNotNull(potter, 'API should return at least 1 character details.');
        Assert.areEqual('Harry Potter', potter.name);
        Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
    }

    /**
     * Test case to verify the API response when an error occurs while fetching a character by ID.
     */
    @IsTest
    static void getCharacterByIdErrorTest(){
        try {
            Test.setMock(HttpCalloutMock.class, new HarryPotterAPIServiceMock());

            // Fetch character by ID that triggers an error
            HarryPotterAPIService.HarryPotterCharacterWrapper potter = HarryPotterAPIService.getCharacterById('error');

            // Validate the response
            Assert.isNotNull(potter, 'API should return at least 1 character details.');
            Assert.areEqual('Harry Potter', potter.name);
            Assert.areEqual('9e3f7ce4-b9a7-4244-b709-dae5c1f1d4a8', potter.id);
        }
        catch (AuraHandledException ex) {
            // Verify the exception message when an error occurs
            Assert.isTrue(ex.getMessage().contains('Script-thrown exception'), 'Exception message is wrong');
        }
    }
}