/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
private class CaseStatusTransitionEvaluatorTest {

    private class MockRuleProvider implements ICaseStatusTransitionRuleProvider {
        public List<CaseStatusTransitionRule> getRules() {
            return new List<CaseStatusTransitionRule>{
                new CaseStatusTransitionRule(50, 'Custom Status')
            };
        }
    }

    @IsTest
    static void shouldReturnTargetStatus_WhenRuleMatchesPaidPercentage() {
        CaseStatusTransitionEvaluator evaluator =
            new CaseStatusTransitionEvaluator(new MockRuleProvider());

        String nextStatus = evaluator.determineNextStatus(
            50,
            'New'
        );

        Assert.areEqual(
            'Custom Status',
            nextStatus,
            'Evaluator should return the target status from the injected rule provider.'
        );
    }

    @IsTest
    static void shouldReturnNull_WhenNoRuleMatchesPaidPercentage() {
        CaseStatusTransitionEvaluator evaluator =
            new CaseStatusTransitionEvaluator(new MockRuleProvider());

        String nextStatus = evaluator.determineNextStatus(
            40,
            'New'
        );

        Assert.isNull(
            nextStatus,
            'Evaluator should return null when paid percentage does not match any rule.'
        );
    }

    @IsTest
    static void shouldReturnNull_WhenCurrentStatusIsClosed() {
        CaseStatusTransitionEvaluator evaluator =
            new CaseStatusTransitionEvaluator(new MockRuleProvider());

        String nextStatus = evaluator.determineNextStatus(
            100,
            'Closed'
        );

        Assert.isNull(
            nextStatus,
            'Closed Cases should not be transitioned.'
        );
    }

    @IsTest
    static void shouldReturnNull_WhenPaidPercentageIsNull() {
        CaseStatusTransitionEvaluator evaluator =
            new CaseStatusTransitionEvaluator(new MockRuleProvider());

        String nextStatus = evaluator.determineNextStatus(
            null,
            'New'
        );

        Assert.isNull(
            nextStatus,
            'Evaluator should return null when paid percentage is null.'
        );
    }
}