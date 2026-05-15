/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
trigger OpportunityTrigger on Opportunity (after update) {
    OpportunityTriggerHandler.afterUpdate(
        Trigger.new,
        Trigger.oldMap
    );
}