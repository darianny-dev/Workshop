/**
 * @description       :
 * @author            : darianny@theradical1s.com
 * @group             :
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class OpportunityPaymentStatusService {

    public static void process(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        if (newList == null || newList.isEmpty()) {
            return;
        }

        Map<Id, Opportunity> eligibleOpportunitiesById =
            getEligibleOpportunitiesById(newList);

        if (eligibleOpportunitiesById.isEmpty()) {
            return;
        }

        List<Case> relatedCases =
            getCasesRelatedToOpportunities(eligibleOpportunitiesById.keySet());

        List<Case> casesToUpdate =
            buildCaseStatusUpdates(relatedCases, eligibleOpportunitiesById);

        updateCasesAndNotify(casesToUpdate);
    }

    private static Map<Id, Opportunity> getEligibleOpportunitiesById(
        List<Opportunity> opportunities
    ) {
        Map<Id, Opportunity> eligibleOpportunitiesById =
            new Map<Id, Opportunity>();

        for (Opportunity opp : opportunities) {
            if (!isEligibleOpportunity(opp)) {
                continue;
            }

            eligibleOpportunitiesById.put(opp.Id, opp);
        }

        return eligibleOpportunitiesById;
    }

    private static Boolean isEligibleOpportunity(Opportunity opp) {
        return opp != null &&
            opp.Id != null &&
            opp.Paid_Percentage__c != null &&
            opp.Paid_Percentage__c >= 75;
    }

    private static List<Case> getCasesRelatedToOpportunities(
        Set<Id> opportunityIds
    ) {
        return [
            SELECT Id, Status, Opportunity__c
            FROM Case
            WHERE Opportunity__c IN :opportunityIds
        ];
    }

    private static List<Case> buildCaseStatusUpdates(
        List<Case> relatedCases,
        Map<Id, Opportunity> opportunitiesById
    ) {
        CaseStatusTransitionEvaluator evaluator =
            new CaseStatusTransitionEvaluator();

        List<Case> casesToUpdate = new List<Case>();

        for (Case relatedCase : relatedCases) {
            Opportunity relatedOpp =
                opportunitiesById.get(relatedCase.Opportunity__c);

            if (relatedOpp == null) {
                continue;
            }

            String nextStatus = evaluator.determineNextStatus(
                relatedOpp.Paid_Percentage__c,
                relatedCase.Status
            );

            if (nextStatus == null) {
                continue;
            }

            casesToUpdate.add(
                new Case(
                    Id = relatedCase.Id,
                    Status = nextStatus
                )
            );
        }

        return casesToUpdate;
    }

    private static void updateCasesAndNotify(List<Case> casesToUpdate) {
        if (casesToUpdate == null || casesToUpdate.isEmpty()) {
            return;
        }

        update casesToUpdate;

        CaseStatusNotificationService notificationService = new CaseStatusNotificationService();

        notificationService.notifyStatusChanges(casesToUpdate);
    }
}