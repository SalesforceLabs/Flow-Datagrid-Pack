({
    doInit : function(component, event) 
    
    {
        var action = component.get("c.getObjs");
        
        var preSelect = component.get("v.lstpreSelectedIds");
        component.set('v.firstSelectedId', null);
        if (preSelect == null)
        {
            preSelect = [];
        }
        else if (preSelect.length > 0)
        {
            component.set('v.firstSelectedId', preSelect[0]);
        }
        
        action.setParams({ "objectName" : component.get("v.strObjectName"), "lstIds" : component.get("v.lstIds"),"lstpreSelectedIds": preSelect, "strTitleField" : component.get("v.strTitleField"),"strLatField" : component.get("v.strLatField"),"strLngField" : component.get("v.strLngField"),"descriptionTemplate" : component.get("v.strDescription") });
        action.setCallback(this, function(a) {
            component.set("v.objs", a.getReturnValue());
            
            //Set the preselected rows to the output
            var lstSelectedIDs = component.get("v.lstpreSelectedIds");
            component.set('v.lstSelectedIds', lstSelectedIDs);
            component.set('v.selectedRowsCount', lstSelectedIDs.length);
            //alert(lstSelectedIDs.length);
            
            window.setTimeout($A.getCallback(function() {
                var event = $A.get("e.c:GilmoreLabs_MapObjectsLoaded");
                event.setParams({"objs": a.getReturnValue()});
                event.fire();
            }), 500);
        });
        $A.enqueueAction(action);
    },
    
    mapObjectSelected: function(component, event, helper) 
    {
        // Center the map on the account selected in the list
        var myObj = event.getParam("obj");
        var isSelected = event.getParam("isselected");
        
        if (isSelected != null)
        {
            var lstSelectedIDs = component.get('v.lstSelectedIds');
            var isFound = false;
            for(var i = lstSelectedIDs.length - 1; i >= 0; i--)
            {
                if (!isSelected && lstSelectedIDs[i] == myObj.Id)
                {
                    lstSelectedIDs.splice(i, 1);
                }
            }
            if (isSelected && !isFound)
            {
                lstSelectedIDs.push(myObj.Id);
            }
            
            component.set('v.selectedRowsCount', lstSelectedIDs.length);
            //alert(lstSelectedIDs.length);
            component.set('v.lstSelectedIds', lstSelectedIDs);
            component.set('v.firstSelectedId', null);
            if (lstSelectedIDs != null && lstSelectedIDs.length > 0)
            {
                component.set('v.firstSelectedId', lstSelectedIDs[0]);
            }
            //alert(lstSelectedIDs);
        }
    }
})