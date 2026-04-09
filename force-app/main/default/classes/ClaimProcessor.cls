/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 04-09-2026
 * @last modified by  : darianny@theradical1s.com
**/
public class ClaimProcessor {

    public static void processAll() { // Static abuse

        // 1. Acoplamiento total a la DB (No es testeable en aislamiento)
        List<Claim__c> claims = [
            SELECT Id, Amount__c, Country__c, Policy_Type__c,
                   (SELECT Id, Status__c FROM Requirements__r)
            FROM Claim__c
            WHERE Status__c = 'Pending'
        ];

        for (Claim__c c : claims) {

            // 2. Reglas rígidas encadenadas (Complejidad Ciclomática alta)
            if (c.Country__c == 'US') {
                if (c.Policy_Type__c == 'Life') {
                    c.Tax_Amount__c = c.Amount__c * 0.10;
                } else {
                    c.Tax_Amount__c = c.Amount__c * 0.05;
                }
            } else if (c.Country__c == 'FR') {
                c.Tax_Amount__c = c.Amount__c * 0.20;
            }

            // 3. Validación manual (Difícil de extender)
            Boolean allMet = true;
            for (Requirement__r req : c.Requirements__r) {
                if (req.Status__c != 'Completed') {
                    allMet = false;
                }
            }

            if (allMet) {
                c.Status__c = 'Approved';

                // 4. Dependencia oculta (No se puede mockear)
                ExternalService.notifyStatus(c.Id, 'Approved');

                // 5. DML en loop (No es bulk-safe)
                update c;
            }
        }
    }
}
