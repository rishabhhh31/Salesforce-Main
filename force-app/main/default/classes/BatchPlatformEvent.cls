public with sharing class BatchPlatformEvent implements Database.Batchable<sObject>, Database.RaisesPlatformEvents{

   public Database.QueryLocator start(Database.BatchableContext bc){
      String query = 'SELECT Id FROM Account ORDER BY Name';
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext bc,  List<Account> scope){
      for(Account acc : scope){
         acc.Name = null;
      }
      update scope;
   }

   public void finish(Database.BatchableContext bc){
   }

}