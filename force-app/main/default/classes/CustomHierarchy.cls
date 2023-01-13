public with sharing class CustomHierarchy {
    public CustomHierarchy() {}

    private static Map<Id, TreeStructure> result;
    private static Map<Id, Id> childIdMap;

    @AuraEnabled(cacheable=false)
    public static List<TreeStructure> getRecords(Id accountId){

        String recordId = accountId;

        Id parentId = findTopLevelParent(recordId);

        result = new Map<Id, TreeStructure>();
        childIdMap = new Map<Id, Id>();

        Map<Id, Account> accountMap = new Map<Id, Account>([
            SELECT Id, Name
            FROM Account 
            WHERE Id =: parentId
            ORDER BY Name
        ]);

        if(!accountMap.isEmpty()){
            startFetchingAccountDetails(accountMap, recordId);
        }
        
        return result.values();
    }
        
            /**
            * Recursion method to get all levels of Accounts and their related records
            */
        
    public Static Id findTopLevelParent(Id recId) {
        String testObj = 'Account';
        String testField = 'ParentId';
                    
        Boolean isTopLevelAccount = false;
            
        Id currAccountId = recId;

        while (!isTopLevelAccount) {
            
            String sQuery = 'SELECT Id,' + testField + ' FROM ' + testObj + ' WHERE Id =:  currAccountId  LIMIT 1';
            
            sObject a = Database.query(sQuery);
            
            if (String.ValueOf(a.get(testField)) != null) {
                currAccountId = String.ValueOf(a.get(testField));
            } else {
                isTopLevelAccount = true;
            }
            
        }

        return currAccountId;   
    }
        
    private static List<TreeStructure> startFetchingAccountDetails(Map<Id, Account> accountMap, Id recordId){
        Map<Id, TreeStructure> parentStructure = gatherAllAccountInformation(accountMap, recordId);

        //attach the first level to actual result and rest will auotmatically link
        //due to pass by reference way
        if(result == null || result.isEmpty()){
            result.putAll(parentStructure);
        }
        
        Map<Id, Account> childMap = new Map<Id, Account>([
            SELECT Id, Name, ParentId
            FROM Account 
            WHERE ParentId =: accountMap.keySet()
        ]);

        if(childMap != null && !childMap.isEmpty() && childMap.size() > 0) {

            Map<Id, Id> accChildIdMap = new Map<Id, Id>();

            for(Id childSiteId : childMap.keySet()){
                Account child = childMap.get(childSiteId);
                childIdMap.put(child.Id, child.ParentId);
            }

            //run this method recursively to get all child levels.
            List<TreeStructure> childStructure = startFetchingAccountDetails(childMap,recordId);
            for(TreeStructure child : childStructure){
                TreeStructure parent = parentStructure.get(childIdMap.get(child.Name));
                parent.items.add(child);
            }
        }
        return parentStructure.values();
    }
        
    /**
    * Method to gather all information for all accounts recieved
    */
    private static Map<Id, TreeStructure> gatherAllAccountInformation( Map<Id, Account> accountMap, Id recordId){
        Map<Id, TreeStructure> result = new Map<Id, TreeStructure>();
        
        Boolean expandRecord = true;
        for(Id accountId : accountMap.keySet()){
            
            Account account = accountMap.get(accountId);

            TreeStructure accountStructure = new TreeStructure(account.Name, accountId, expandRecord, null, null);
            
            result.put(accountId, accountStructure);
        }
        return result;
    }
}