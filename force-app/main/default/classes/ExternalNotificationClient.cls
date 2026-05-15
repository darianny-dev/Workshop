/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class ExternalNotificationClient
implements IExternalNotificationClient {

    private static final String ENDPOINT =
        'https://example.com/api/case-status-notification';

    public void notifyCaseStatusChanged(Case updatedCase) {
        if (updatedCase == null || updatedCase.Id == null) {
            return;
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new NotificationPayload(updatedCase)));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() < 200 || res.getStatusCode() >= 300) {
            throw new CalloutException(
                'External notification failed. Status code: ' +
                res.getStatusCode()
            );
        }
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