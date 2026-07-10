/**
 * @description Schedules the Service Request priority recalculation.
 */
public without sharing class ServiceRequestPriorityScheduler
    implements Schedulable {

    private static final Integer BATCH_SIZE = 200;

    public void execute(SchedulableContext context) {
        if (hasActiveBatch()) {
            return;
        }

        Database.executeBatch(
            new ServiceRequestPriorityBatch(),
            BATCH_SIZE
        );
    }

    private static Boolean hasActiveBatch() {
        return [
            SELECT COUNT()
            FROM AsyncApexJob
            WHERE ApexClass.Name = 'ServiceRequestPriorityBatch'
            AND JobType = 'BatchApex'
            AND Status IN (
                'Holding',
                'Queued',
                'Preparing',
                'Processing'
            )
        ] > 0;
    }
}