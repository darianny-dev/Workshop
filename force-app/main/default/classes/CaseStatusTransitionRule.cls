/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public class CaseStatusTransitionRule {
    public Decimal minimumPaidPercentage;
    public String targetStatus;

    public CaseStatusTransitionRule(
        Decimal minimumPaidPercentage,
        String targetStatus
    ) {
        this.minimumPaidPercentage = minimumPaidPercentage;
        this.targetStatus = targetStatus;
    }
}