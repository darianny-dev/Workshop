/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
private class OpportunityPaymentStatusServiceTest {

    @IsTest
    static void shouldUpdateCaseStatus_WhenOpportunityMeetsPaymentThreshold() {
        Account acct = TestDataFactory.createAccount();

        Opportunity opp = TestDataFactory.createOpportunity(acct.Id, 75);
        Case relatedCase = TestDataFactory.createCase(opp.Id, 'New');

        Test.startTest();
        OpportunityPaymentStatusService.process(
            new List<Opportunity>{ opp },
            new Map<Id, Opportunity>{
                opp.Id => new Opportunity(
                    Id = opp.Id,
                    Paid_Percentage__c = 0
                )
            }
        );
        Test.stopTest();

        Case updatedCase = [
            SELECT Status
            FROM Case
            WHERE Id = :relatedCase.Id
        ];

        Assert.areEqual(
            'Compliance Call',
            updatedCase.Status,
            'Case status should be updated when Opportunity reaches the payment threshold.'
        );
    }
}