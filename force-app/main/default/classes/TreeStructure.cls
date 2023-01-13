public class TreeStructure {
    @AuraEnabled public String label;
    @AuraEnabled public String name;
    @AuraEnabled public Boolean expanded;
    @AuraEnabled public String metatext;
    
    @AuraEnabled public List<TreeStructure> items;

    public TreeStructure(){}

    public TreeStructure(String label, String name, Boolean expanded, List<TreeStructure> items, String metatext) {
        this.label = label;
        this.name = name;
        this.expanded = expanded;
        this.metatext = metatext;
        
        this.items = (items != null && items.size() > 0) ? items : new List<TreeStructure>();
        
    }
}