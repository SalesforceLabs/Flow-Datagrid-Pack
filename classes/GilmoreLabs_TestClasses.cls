@isTest
private with sharing class GilmoreLabs_TestClasses {
    static testMethod void validateDatagrid() 
    {
        String colString = GilmoreLabs_FlowDataGridController.getColumnString('Contact', 'Id,FirstName,LastName,Title,Account.Name', 'Id');
        system.debug(colString);
        system.assert(colString.contains('First Name'));

        Account a = new Account();
        a.Name = 'Ohana, Inc.';
        insert a;

        Contact c = new Contact();
        c.accountId = a.id;
        c.FirstName = 'Lauren';
        c.LastName = 'Bailey';
        INSERT c;

        List<string> lstIds = new list<string>{c.id};
        string dataString = GilmoreLabs_FlowDataGridController.getDataString(lstIds, 'Contact', 'Id,FirstName,LastName,Title,Account.Name', 'Id', 10);
        system.assert(dataString.contains('Lauren'));
    }
    
    static testMethod void validateTileDatagrid() 
    {
        List<String> lstTiles = new List<String>();
        lstTiles.add('Test Tile');
        List<Task> objTasks = GilmoreLabs_FlowTileGridController.getData(lstTiles);
        system.assert(objTasks.size() == 1);
    }

    static testMethod void validateMapDatagrid() 
    {
        Account a = new Account();
        a.Name = 'Ohana, Inc.';
        insert a;

        Contact c = new Contact();
        c.accountId = a.id;
        c.FirstName = 'Lauren';
        c.LastName = 'Bailey';
        c.Title = 'CEO';
        INSERT c;

        List<string> lstIds = new list<string>{c.id};
        List<GilmoreLabs_FlowMapDataGridController.LeafMarker> objs = GilmoreLabs_FlowMapDataGridController.getObjs(lstIds, new list<String>(), 'Contact', 'Id', 'FirstName', 'LastName', '{Title}');
        system.assert(objs[0].Lat == 'Lauren');
    }
}