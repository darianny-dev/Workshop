/**
 * @description       : Recalculates priorities for pending Service Requests.
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 07-10-2026
 * @last modified by  : darianny@theradical1s.com
**/
public without sharing class ServiceRequestPriorityBatch
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(
        Database.BatchableContext context
    ) {
        return Database.getQueryLocator([
            SELECT
                Id,
                Priority__c,
                Region__c,
                Score__c
            FROM Service_Request__c
            WHERE Priority_Recalculation_Required__c = true
            AND Status__c IN ('Draft', 'Active')
        ]);
    }

    public void execute(
        Database.BatchableContext context,
        List<SObject> scope
    ) {
        List<Service_Request__c> serviceRequests =
            (List<Service_Request__c>) scope;

        ServiceRequestPriorityResult result =
            ServiceRequestPriorityService.evaluate(serviceRequests);

        if (!result.recordsToUpdate.isEmpty()) {
            Database.update(result.recordsToUpdate, false);
        }
    }

    public void finish(Database.BatchableContext context) {
    }
}