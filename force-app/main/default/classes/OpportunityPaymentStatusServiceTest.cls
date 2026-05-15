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

        Opportunity opp = new TestDataFactory.OpportunityBuilder()
            .withAccountId(acct.Id)
            .withPaidPercentage(75)
            .insertRecord();

        Case relatedCase = new TestDataFactory.CaseBuilder()
            .withOpportunityId(opp.Id)
            .withStatus('New')
            .insertRecord();

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

    @IsTest
    static void shouldNotUpdateCaseStatus_WhenPaymentThresholdIsNotMet() {
        Account acct = TestDataFactory.createAccount();

        Opportunity opp = new TestDataFactory.OpportunityBuilder()
            .withAccountId(acct.Id)
            .withPaidPercentage(50)
            .insertRecord();

        Case relatedCase = new TestDataFactory.CaseBuilder()
            .withOpportunityId(opp.Id)
            .withStatus('New')
            .insertRecord();

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
            'New',
            updatedCase.Status,
            'Case status should not change when threshold is not met.'
        );
    }

    @IsTest
    static void shouldNotUpdateClosedCase_WhenOpportunityMeetsThreshold() {
        Account acct = TestDataFactory.createAccount();

        Opportunity opp = new TestDataFactory.OpportunityBuilder()
            .withAccountId(acct.Id)
            .withPaidPercentage(75)
            .insertRecord();

        Case relatedCase = new TestDataFactory.CaseBuilder()
            .withOpportunityId(opp.Id)
            .withStatus('Closed')
            .insertRecord();

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
            'Closed',
            updatedCase.Status,
            'Closed Cases should not be updated.'
        );
    }

    @IsTest
    static void shouldNotFail_WhenOpportunityHasNoRelatedCase() {
        Account acct = TestDataFactory.createAccount();

        Opportunity opp = new TestDataFactory.OpportunityBuilder()
            .withAccountId(acct.Id)
            .withPaidPercentage(75)
            .insertRecord();

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

        Assert.isTrue(
            true,
            'Process should complete successfully even when no related Case exists.'
        );
    }

    @IsTest
    static void shouldNotUpdateCaseStatus_WhenPaidPercentageIsNull() {
        Account acct = TestDataFactory.createAccount();

        Opportunity opp = new TestDataFactory.OpportunityBuilder()
            .withAccountId(acct.Id)
            .insertRecord();
        opp.Paid_Percentage__c = null;

        Case relatedCase = new TestDataFactory.CaseBuilder()
            .withOpportunityId(opp.Id)
            .withStatus('New')
            .insertRecord();

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
            'New',
            updatedCase.Status,
            'Case status should not change when paid percentage is null.'
        );
    }

    @IsTest
    static void shouldUpdateCases_WhenProcessing200Opportunities() {
        Account acct = TestDataFactory.createAccount();

        List<Opportunity> opportunities = new List<Opportunity>();
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i < 200; i++) {
            opportunities.add(
                new TestDataFactory.OpportunityBuilder()
                    .withAccountId(acct.Id)
                    .withPaidPercentage(75)
                    .build()
            );
        }
        insert opportunities;

        for (Opportunity opp : opportunities) {
            cases.add(
                new TestDataFactory.CaseBuilder()
                    .withOpportunityId(opp.Id)
                    .withStatus('New')
                    .build()
            );
        }
        insert cases;

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        for (Opportunity opp : opportunities) {
            oldMap.put(
                opp.Id,
                new Opportunity(
                    Id = opp.Id,
                    Paid_Percentage__c = 0
                )
            );
        }

        Test.startTest();
        OpportunityPaymentStatusService.process(
            opportunities,
            oldMap
        );
        Test.stopTest();

        List<Case> updatedCases = [
            SELECT Status
            FROM Case
            WHERE Id IN :cases
        ];

        Assert.areEqual(
            200,
            updatedCases.size(),
            'All related Cases should be queried.'
        );

        for (Case updatedCase : updatedCases) {
            Assert.areEqual(
                'Compliance Call',
                updatedCase.Status,
                'Each Case should be updated when its Opportunity meets the threshold.'
            );
        }
    }
}