({
    init: function (cmp, event, helper) {
        
        helper.fetchColumns(cmp);
    },

    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        
        var lstSelectedIDs = [];
        for(var i = 0; i < selectedRows.length; i++)
        {
            lstSelectedIDs.push(selectedRows[i].id);
        }
        cmp.set('v.firstSelectedId', null);
        if (lstSelectedIDs.length > 0)
        {
            cmp.set('v.firstSelectedId', lstSelectedIDs[0]);
        }
        
        cmp.set('v.lstSelectedIds', lstSelectedIDs);
        
        cmp.set('v.selectedRowsCount', selectedRows.length);
    }
})