/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class OpportunityTriggerHandler {

    public static void afterUpdate(
        List<Opportunity> newList,
        Map<Id, Opportunity> oldMap
    ) {
        OpportunityPaymentStatusService.process(
            newList,
            oldMap
        );
    }
}