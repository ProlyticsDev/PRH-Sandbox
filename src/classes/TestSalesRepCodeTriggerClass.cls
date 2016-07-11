/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestSalesRepCodeTriggerClass {

    static testMethod void myUnitTest() {
        //Add Supporting Objects
        Account supportingAccount = new Account(AccountNo__c = 'TEST');
        Contact supportingContact = new Contact();
        Sales_Rep_Code__c supportingCode1 = new Sales_Rep_Code__c();
        Sales_Rep_Code__c supportingCode2 = new Sales_Rep_Code__c();
        User supportingUser = [SELECT Id FROM User where isActive = true LIMIT 1];
    
        supportingCode1.Name = 'DEFAULT';
        supportingCode1.OwnerId = supportingUser.Id;
        insert supportingCode1;
        
        supportingCode2.Name = 'ABC';
        supportingCode2.OwnerId = supportingUser.Id;
        insert supportingCode2;
        
        supportingAccount.Name = 'Test Account';
        supportingAccount.Phone = '0345634534';
        supportingAccount.Sales_Rep_Code__c = 'ABC';
        insert supportingAccount;
        supportingContact.LastName = 'Test Contact';
        supportingContact.AccountId = supportingAccount.Id;
        insert supportingContact;
        supportingAccount.Sales_Rep_Code__c = '';
        update supportingAccount;
        supportingAccount.Sales_Rep_Code__c = 'NOT THERE';
        update supportingAccount;
    
        
    }
}