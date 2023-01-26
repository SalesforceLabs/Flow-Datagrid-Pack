({
	fetchdata: function (cmp)
    {
        var action = cmp.get("c.getData");
        action.setParams({ "lstInput" : cmp.get("v.lstInput")});
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) 
        {
            cmp.set("v.Spinner", false);
            //alert('returned: ' + response.getReturnValue());
            var lstSelectedItems = [];
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.tileItems', response.getReturnValue());
                cmp.set("v.Spinner", false);
                var preSelectedItems = cmp.get("v.preSelectedItems");
                var allTiles = cmp.get("v.tileItems");
                for (var thisPreSelectedItem of preSelectedItems) {
                    for (var thisTile of allTiles) {
                        if (thisPreSelectedItem == thisTile.CallObject) {
                            lstSelectedItems.push (thisTile.CallObject);
                            thisTile.checked = true;
                       	}
                  	}
                }
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                cmp.set("v.Spinner", false);
                var errorText = 'Error rendering tiles';
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorText = errors[0].message;
                        console.log("Error rendering tiles: " + 
                                 errors[0].message);
                    }
                } else 
                {
                    console.log("Unknown error");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error rendering tiles",
                    "type": "error",
                    "message": errorText
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})