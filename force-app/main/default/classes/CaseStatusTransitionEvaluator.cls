/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class CaseStatusTransitionEvaluator {

    private ICaseStatusTransitionRuleProvider ruleProvider;

    public CaseStatusTransitionEvaluator() {
        this.ruleProvider =
            new DefaultCaseStatusTransitionRuleProvider();
    }

    public CaseStatusTransitionEvaluator(
        ICaseStatusTransitionRuleProvider ruleProvider
    ) {
        this.ruleProvider = ruleProvider;
    }

    public String determineNextStatus(
        Decimal paidPercentage,
        String currentStatus
    ) {
        if (paidPercentage == null ||
            String.isBlank(currentStatus)) {
            return null;
        }

        if (currentStatus == 'Closed') {
            return null;
        }

        for (CaseStatusTransitionRule rule :
            ruleProvider.getRules()) {

            if (paidPercentage >= rule.minimumPaidPercentage) {
                return rule.targetStatus;
            }
        }

        return null;
    }
}