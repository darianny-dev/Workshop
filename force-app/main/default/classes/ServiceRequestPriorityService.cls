/**
 * @description       : Evaluates Service Requests and prepares the required updates.
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 07-10-2026
 * @last modified by  : darianny@theradical1s.com
**/
public class ServiceRequestPriorityService {

    public static ServiceRequestPriorityResult evaluate(
        List<Service_Request__c> requestRecords
    ) {
        ServiceRequestPriorityResult result =
            new ServiceRequestPriorityResult();

        if (requestRecords == null || requestRecords.isEmpty()) {
            return result;
        }

        for (Service_Request__c requestRecord : requestRecords) {
            String calculatedPriority =
                ServiceRequestPriorityCalculator.calculate(requestRecord);

            result.addRecord(
                requestRecord,
                calculatedPriority
            );
        }

        return result;
    }
}