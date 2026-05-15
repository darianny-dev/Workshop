/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class DefaultCaseStatusTransitionRuleProvider
implements ICaseStatusTransitionRuleProvider {

    public List<CaseStatusTransitionRule> getRules() {
        return new List<CaseStatusTransitionRule>{
            new CaseStatusTransitionRule(
                75,
                'Compliance Call'
            )
        };
    }
}