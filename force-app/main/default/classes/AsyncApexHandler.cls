public with sharing class AsyncApexHandler{
    @AuraEnabled(cacheable = true)
    public static List<ContactWrapper> getAllContacts(){
        try {
            List<ContactWrapper> contactList = new List<ContactWrapper>();
            for(Contact con : [SELECT Id, FirstName, LastName, Email FROM Contact ORDER BY FirstName]){
                ContactWrapper conWrap = new ContactWrapper();
                conWrap.firstName = con.FirstName;
                conWrap.lastName = con.LastName;
                conWrap.email = con.Email;
                contactList.add(conWrap);
            }
            return contactList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ContactWrapper{
        @AuraEnabled
        public String firstName;
        @AuraEnabled
        public String lastName;
        @AuraEnabled
        public String email;
    }
}