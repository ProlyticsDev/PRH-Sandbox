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
private class TestManuscriptClass {

    static testMethod void testManuscript() {
        // TO DO: implement unit test
        Manuscript__c man = new Manuscript__c(Name = 'Test', Author_First_Name__c = 'test', Author_Last_Name__c = 'Test',
            Manuscript_Status__c = 'For Initial Review');
        insert man;
        Manuscript__c revMan = new Manuscript__c(Id = man.Id, Manuscript_Status__c = 'Accepted');
        update revMan;
        System.assertNotEquals(null, [Select id, Author_Contact__c from Manuscript__c where id = :revMan.id].Author_Contact__c);
        update revMan;
    }
}