({
    init : function(component, event, helper) 
    {
        component.set("v.idRand", Math.floor(Math.random() * 1000000));
        helper.fetchdata(component);
    },
    
    handleSelection : function( cmp, evt,  h )
    {
        var selectedSection = evt.currentTarget;
        var index = selectedSection.dataset.index;
        
        var lstSelectedItems = [];
        var targetItem = index;
        
        if (!cmp.get('v.multiSelection'))
        {
            lstSelectedItems.push(targetItem);
        }
        else
        {
            //This is multiselect
            var oldSelectedItems = cmp.get('v.lstSelectedItems');
            if (oldSelectedItems == null || oldSelectedItems.length == 0)
            {
                lstSelectedItems.push(targetItem);
            }
            else
            {
                var isFound = false;
                for(var i = 0; i < oldSelectedItems.length; i++)
                {
                    if (targetItem != oldSelectedItems[i])
                    {
                        lstSelectedItems.push(oldSelectedItems[i]);
                        //console.log('Adding:' + oldSelectedItems[i]);
                    }
                    else
                    {
                        isFound = true;
                    }
                }
                if (!isFound)
                {
                    lstSelectedItems.push(targetItem);
                }
            }
            
        }
        cmp.set('v.lstSelectedItems', lstSelectedItems);
        cmp.set('v.firstSelectedItem', targetItem);
        
        
        console.log('Selected items:' + lstSelectedItems);
        //alert(evt.getSource().get("v.label"));
    }
})