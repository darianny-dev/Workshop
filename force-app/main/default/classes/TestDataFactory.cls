/**
 * @description       : 
 * @author            : darianny@theradical1s.com
 * @group             : 
 * @last modified on  : 05-15-2026
 * @last modified by  : darianny@theradical1s.com
**/
@IsTest
public class TestDataFactory {

    public static Id getFakeId(Schema.SObjectType sObjectType) {
        String keyPrefix = sObjectType.getDescribe().getKeyPrefix();
        return Id.valueOf(keyPrefix + '000000000001AAA');
    }

    public static Account createAccount() {
        Account acct = new Account(
            Name = 'Test Account'
        );

        insert acct;
        return acct;
    }

    public class CaseBuilder {
        private Case caseRecord;

        public CaseBuilder() {
            caseRecord = new Case(
                Subject = 'Test Case',
                Status = 'New',
                Origin = 'Phone'
            );
        }

        public CaseBuilder withOpportunityId(Id opportunityId) {
            caseRecord.Opportunity__c = opportunityId;
            return this;
        }

        public CaseBuilder withSubject(String value) {
            caseRecord.Subject = value;
            return this;
        }

        public CaseBuilder withStatus(String value) {
            caseRecord.Status = value;
            return this;
        }

        public CaseBuilder withOrigin(String value) {
            caseRecord.Origin = value;
            return this;
        }

        public Case build() {
            return caseRecord;
        }

        public Case insertRecord() {
            insert caseRecord;
            return caseRecord;
        }
    }

    public class OpportunityBuilder {
        private Opportunity opp;

        public OpportunityBuilder() {
            Account acct = TestDataFactory.createAccount();

            opp = new Opportunity(
                Name = 'Test Opportunity',
                AccountId = acct.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Paid_Amount__c = 0
            );
        }

        public OpportunityBuilder withAccountId(Id accountId) {
            opp.AccountId = accountId;
            return this;
        }

        public OpportunityBuilder withName(String value) {
            opp.Name = value;
            return this;
        }

        public OpportunityBuilder withStageName(String value) {
            opp.StageName = value;
            return this;
        }

        public OpportunityBuilder withCloseDate(Date value) {
            opp.CloseDate = value;
            return this;
        }

        public OpportunityBuilder withPaidAmount(Decimal value) {
            opp.Paid_Amount__c = value;
            return this;
        }

        public Opportunity build() {
            return opp;
        }

        public Opportunity insertRecord() {
            insert opp;
            return opp;
        }
    }
}