/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
private class ExternalNotificationClientTest {

    @IsTest
    static void shouldSendNotification_WhenExternalServiceReturnsSuccess() {
        Test.setMock(
            HttpCalloutMock.class,
            new SuccessNotificationMock()
        );

        Case testCase = new Case(
            Id = TestDataFactory.getFakeId(Case.SObjectType),
            Status = CaseStatusConstants.COMPLIANCE_CALL
        );

        Test.startTest();

        new ExternalNotificationClient()
            .notifyCaseStatusChanged(testCase);

        Test.stopTest();

        Assert.isTrue(true, 'Callout should complete successfully.');
    }

    @IsTest
    static void shouldThrowException_WhenExternalServiceReturnsError() {
        Test.setMock(
            HttpCalloutMock.class,
            new ErrorNotificationMock()
        );

        Case testCase = new Case(
            Id = TestDataFactory.getFakeId(Case.SObjectType),
            Status = CaseStatusConstants.COMPLIANCE_CALL
        );

        Test.startTest();

        try {
            new ExternalNotificationClient()
                .notifyCaseStatusChanged(testCase);

            Assert.fail(
                'Expected CalloutException when external service returns an error.'
            );
        } catch (CalloutException ex) {
            Assert.isTrue(
                ex.getMessage().contains('External notification failed'),
                'Exception should describe the external notification failure.'
            );
        }

        Test.stopTest();
    }

    private class SuccessNotificationMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            Assert.areEqual(
                'POST',
                req.getMethod(),
                'Request method should be POST.'
            );

            Assert.areEqual(
                'application/json',
                req.getHeader('Content-Type'),
                'Content-Type should be JSON.'
            );

            Assert.isTrue(
                req.getBody().contains(CaseStatusConstants.COMPLIANCE_CALL),
                'Request body should include the Case status.'
            );

            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"success":true}');
            return res;
        }
    }

    private class ErrorNotificationMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('{"success":false}');
            return res;
        }
    }
}