/**
 * @description       : Contains the result of a Service Request priority evaluation.
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 07-10-2026
 * @last modified by  : darianny@theradical1s.com
**/
public class ServiceRequestPriorityResult {

    public List<Service_Request__c> recordsToUpdate { get; private set; }

    public ServiceRequestPriorityResult() {
        recordsToUpdate = new List<Service_Request__c>();
    }

    public void addRecord(
        Service_Request__c sourceRecord,
        String calculatedPriority
    ) {
        Service_Request__c recordToUpdate = new Service_Request__c(
            Id = sourceRecord.Id,
            Priority_Recalculation_Required__c = false
        );

        if (sourceRecord.Priority__c != calculatedPriority) {
            recordToUpdate.Priority__c = calculatedPriority;
        }

        recordsToUpdate.add(recordToUpdate);
    }
}