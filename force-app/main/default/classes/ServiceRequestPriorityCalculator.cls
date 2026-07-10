/**
 * @description       : Calculates the expected priority for a Service Request.
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 07-10-2026
 * @last modified by  : darianny@theradical1s.com
**/
public class ServiceRequestPriorityCalculator {

    public static final String PRIORITY_HIGH = 'High';
    public static final String PRIORITY_MEDIUM = 'Medium';
    public static final String PRIORITY_LOW = 'Low';

    private static final String NORTH_REGION = 'North';
    private static final Decimal HIGH_SCORE_THRESHOLD = 80;
    private static final Decimal MEDIUM_SCORE_THRESHOLD = 50;

    /**
     * @description Calculates the expected priority based on region and score.
     *
     * High:
     * - Region is North.
     * - Score is greater than 80.
     *
     * Medium:
     * - Score is greater than 50.
     *
     * Low:
     * - Any other scenario.
     *
     * @param requestRecord Service Request to evaluate.
     * @return Calculated priority.
     */
    public static String calculate(Service_Request__c requestRecord) {
        if (requestRecord == null) {
            return null;
        }

        if (
            requestRecord.Region__c == NORTH_REGION &&
            requestRecord.Score__c > HIGH_SCORE_THRESHOLD
        ) {
            return PRIORITY_HIGH;
        }

        if (requestRecord.Score__c > MEDIUM_SCORE_THRESHOLD) {
            return PRIORITY_MEDIUM;
        }

        return PRIORITY_LOW;
    }
}