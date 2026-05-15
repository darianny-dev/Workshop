/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class CaseStatusTransitionEvaluator {

    public static String determineNextStatus(
        Decimal paidPercentage,
        String currentStatus
    ) {
        if (paidPercentage == null || String.isBlank(currentStatus)) {
            return null;
        }

        if (currentStatus == 'Closed') {
            return null;
        }

        if (paidPercentage >= 75) {
            return 'Compliance Call';
        }

        return null;
    }
}