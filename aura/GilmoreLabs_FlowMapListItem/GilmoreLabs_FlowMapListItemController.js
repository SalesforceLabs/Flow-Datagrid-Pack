({
	objSelected : function(component) {
        var event = $A.get("e.c:GilmoreLabs_MapObjectsSelected");
        event.setParams({"obj": component.get("v.obj")});
        event.fire();
    },
    
    onCheck: function(cmp, evt) 
    {
        var checkCmp = cmp.find("ckBeachSelected");
        //alert(checkCmp.get("v.checked"));
        var isChecked = checkCmp.get("v.checked");
        
        var maxCount = cmp.get("v.maxRowSelection");
        var myCount = cmp.get("v.selectedRowsCount");
        if (isChecked) myCount += 1;
        else myCount -= 1;
        //alert(myCount);
        
        //See if we want to prevent this selection....
        if (isChecked && maxCount != null && maxCount >= 0 && myCount > maxCount)
        {
            //Do NOT Update
            checkCmp.set("v.checked", false);
            //alert('You can select up to a maximum of ' + maxCount + ' records.');
        }
        else
        {
            //Fire Event
            var event = $A.get("e.c:GilmoreLabs_MapObjectsSelected");
            event.setParams({"obj": cmp.get("v.obj"), "isselected": isChecked});
            event.fire();
        }
    }
})