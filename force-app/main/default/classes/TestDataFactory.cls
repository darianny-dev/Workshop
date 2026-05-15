/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
public class TestDataFactory {

    public static Account createAccount() {
        Account acct = new Account(
            Name = 'Test Account'
        );
        insert acct;
        return acct;
    }

    public static Opportunity createOpportunity(Id accountId, Decimal paidPercentage) {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Paid_Percentage__c = paidPercentage
        );
        insert opp;
        return opp;
    }

    public static Case createCase(Id opportunityId, String status) {
        Case c = new Case(
            Subject = 'Test Case',
            Status = status,
            Origin = 'Phone',
            Opportunity__c = opportunityId
        );
        insert c;
        return c;
    }
}