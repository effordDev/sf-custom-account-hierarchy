@isTest
public with sharing class TreeStructureTest {
    
    @isTest
    private static void treeStructureTest() {

        List<TreeStructure> childItems = new List<TreeStructure>();

        TreeStructure child = new TreeStructure();
            child.label = 'childLabel';
            child.name = 'childName';
            child.expanded = false;
            child.items = null;
            child.metatext = 'childmetatext';
        

        childItems.add(child);

        TreeStructure tree = new TreeStructure(
            'parentLabel',
            'parentName',
            false,
            null,
            'parentmetatext'
        );

        tree.items = childItems;
        
        system.assertEquals(tree.name, 'parentName');
        system.assertEquals(tree.items[0].name, 'childName');
    }
}