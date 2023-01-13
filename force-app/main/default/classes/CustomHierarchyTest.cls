@isTest
public with sharing class CustomHierarchyTest {
    
    @TestSetup
    private static void makeData() {

		Account parentAccount = new Account();
            parentAccount.Name = 'Tokyo';
        insert parentAccount;

		Account childAccount = new Account();
            childAccount.Name = 'TheCat';
            childAccount.ParentId = parentAccount.Id;
        insert childAccount;
    }

    @isTest
    private static void getRecordsTest() {

        List<TreeStructure> records = CustomHierarchy.getRecords([SELECT Id FROM Account LIMIT 1].Id); 

        system.assertEquals(records.size(), 1);
    }
}