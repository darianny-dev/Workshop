/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
public with sharing class CaseStatusNotificationService {

    private IExternalNotificationClient notificationClient;

    public CaseStatusNotificationService() {
        this(new ExternalNotificationClient());
    }

    public CaseStatusNotificationService(
        IExternalNotificationClient notificationClient
    ) {
        this.notificationClient = notificationClient;
    }

    public void notifyStatusChanges(List<Case> updatedCases) {
        if (updatedCases == null || updatedCases.isEmpty()) {
            return;
        }

        for (Case updatedCase : updatedCases) {
            try {
                notificationClient.notifyCaseStatusChanged(updatedCase);
            } catch (Exception ex) {
                System.debug(
                    LoggingLevel.ERROR,
                    'Failed to notify external service: ' + ex.getMessage()
                );
            }
        }
    }
}