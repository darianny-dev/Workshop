/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class ExternalNotificationClient implements IExternalNotificationClient {

    private static final String ENDPOINT =
        'https://example.com/api/case-status-notification';

    private static final String HTTP_METHOD_POST = 'POST';
    private static final String CONTENT_TYPE_HEADER = 'Content-Type';
    private static final String CONTENT_TYPE_JSON = 'application/json';

    public void notifyCaseStatusChanged(Case updatedCase) {
        if (!isValidCase(updatedCase)) {
            return;
        }

        HttpResponse response = sendNotificationRequest(updatedCase);

        validateResponse(response);
    }

    private static Boolean isValidCase(Case updatedCase) {
        return updatedCase != null &&
            updatedCase.Id != null;
    }

    private static HttpResponse sendNotificationRequest(Case updatedCase) {
        HttpRequest request = buildRequest(updatedCase);

        return new Http().send(request);
    }

    private static HttpRequest buildRequest(Case updatedCase) {
        HttpRequest request = new HttpRequest();

        request.setEndpoint(ENDPOINT);
        request.setMethod(HTTP_METHOD_POST);
        request.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON);
        request.setBody(buildRequestBody(updatedCase));

        return request;
    }

    private static String buildRequestBody(Case updatedCase) {
        return JSON.serialize(
            new NotificationPayload(updatedCase)
        );
    }

    private static void validateResponse(HttpResponse response) {
        Integer statusCode = response.getStatusCode();

        if (statusCode >= 200 && statusCode < 300) {
            return;
        }

        throw new CalloutException(
            'External notification failed. Status code: ' +
            statusCode
        );
    }

    private class NotificationPayload {
        public Id caseId;
        public String status;

        NotificationPayload(Case updatedCase) {
            this.caseId = updatedCase.Id;
            this.status = updatedCase.Status;
        }
    }
}