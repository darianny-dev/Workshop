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

        Map<Id, Opportunity> opportunitiesById = new Map<Id, Opportunity>();
        Set<Id> opportunityIds = new Set<Id>();

        for (Opportunity opp : newList) {
            if (opp.Id == null || opp.Paid_Percentage__c == null) {
                continue;
            }

            if (opp.Paid_Percentage__c >= 75) {
                opportunitiesById.put(opp.Id, opp);
                opportunityIds.add(opp.Id);
            }
        }

        if (opportunityIds.isEmpty()) {
            return;
        }

        List<Case> relatedCases = [
            SELECT Id, Status, Opportunity__c
            FROM Case
            WHERE Opportunity__c IN :opportunityIds
        ];

        List<Case> casesToUpdate = new List<Case>();
        CaseStatusTransitionEvaluator evaluator = new CaseStatusTransitionEvaluator();

        for (Case relatedCase : relatedCases) {
            Opportunity relatedOpp = opportunitiesById.get(relatedCase.Opportunity__c);

            String nextStatus = evaluator.determineNextStatus(
                relatedOpp.Paid_Percentage__c,
                relatedCase.Status
            );

            if (nextStatus == null) {
                continue;
            }

            casesToUpdate.add(new Case(
                Id = relatedCase.Id,
                Status = nextStatus
            ));
        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}