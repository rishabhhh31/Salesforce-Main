public with sharing class BatchApexScenarios implements Database.Batchable<sObject>, Database.AllowsCallouts{
   public final String query;
   public final String field;
   public final String value;

   public BatchApexScenarios(String q, String f, String v){
        Query=q; Field=f;Value=v;
   }

   public Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext bc,  List<sObject> scope){
      SpotifyHandler.getUserInfo();
      for(Sobject s : scope){
        s.put(Field,Value); 
      }     
      update scope;
   }

   public void finish(Database.BatchableContext bc){
   }

}