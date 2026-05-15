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

        Set<Id> opportunityIds = new Set<Id>();

        for (Opportunity opp : newList) {
            if (opp.Paid_Percentage__c >= 75) {
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

        for (Case c : relatedCases) {
            Opportunity relatedOpp = opportunitiesById.get(c.Opportunity__c);

            String nextStatus = CaseStatusTransitionEvaluator.determineNextStatus(
                relatedOpp.Paid_Percentage__c,
                c.Status
            );

            if (nextStatus != null) {
                casesToUpdate.add(new Case(
                    Id = c.Id,
                    Status = nextStatus
                ));
            }
        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}