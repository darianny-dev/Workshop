/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
private class CaseStatusNotificationServiceTest {

    private class MockNotificationClient implements IExternalNotificationClient {
        public Boolean wasCalled = false;
        public Id notifiedCaseId;

        public void notifyCaseStatusChanged(Case updatedCase) {
            wasCalled = true;
            notifiedCaseId = updatedCase.Id;
        }
    }

    @IsTest
    static void shouldNotifyExternalService_WhenCaseStatusChanged() {
        Case testCase = new Case(
            Id = TestDataFactory.getFakeId(Case.SObjectType),
            Status = 'Compliance Call'
        );

        MockNotificationClient mockClient = new MockNotificationClient();

        CaseStatusNotificationService service =
            new CaseStatusNotificationService(mockClient);

        service.notifyStatusChanges(
            new List<Case>{ testCase }
        );

        Assert.isTrue(
            mockClient.wasCalled,
            'External notification client should be called.'
        );

        Assert.areEqual(
            testCase.Id,
            mockClient.notifiedCaseId,
            'Notification should be sent for the updated Case.'
        );
    }

    @IsTest
    static void shouldNotBreakProcess_WhenExternalNotificationFails() {
        Case testCase = new Case(
            Id = TestDataFactory.getFakeId(Case.SObjectType),
            Status = 'Compliance Call'
        );

        CaseStatusNotificationService service =
            new CaseStatusNotificationService(
                new FailingNotificationClient()
            );

        Test.startTest();

        service.notifyStatusChanges(
            new List<Case>{ testCase }
        );

        Test.stopTest();

        Assert.isTrue(
            true,
            'Notification failures should be handled without breaking the main process.'
        );
    }

    private class FailingNotificationClient implements IExternalNotificationClient {
        public void notifyCaseStatusChanged(Case updatedCase) {
            throw new CalloutException('Simulated external service failure.');
        }
    }
}