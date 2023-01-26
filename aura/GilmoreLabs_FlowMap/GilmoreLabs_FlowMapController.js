({
    jsLoaded: function(component, event, helper) 
    {
      var map = L.map('map', {zoomControl: true, tap: true})
                  .setView([37.784173, -122.401557], 10);
      L.tileLayer(
       'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
       {
              attribution: 'Tiles © Esri'
       }).addTo(map);
        component.set("v.map", map);
      L.control.scale().addTo(map);
        
    },
    objectsLoaded: function(component, event, helper) {
        // Add markers
        var map = component.get('v.map');
        var myobjs = event.getParam('objs');
        
        var theMarkers = [];
        var latlngArray = [];
        for (var i=0; i<myobjs.length; i++) {
            var myobj = myobjs[i];
            if (myobj.Lat == null || myobj.Lng == null)
            {
                continue;
            }
            var latLng = [myobj.Lat, myobj.Lng];
            latlngArray.push(latLng);
            var marker = L.marker(latLng).addTo(map);
            if (!myobjs[i].Preselected)
            {
                marker.setOpacity(.5);
            }
            marker.bindPopup("<b>" + myobj.Title + "</b><br>" + myobj.Description);
            theMarkers.push(marker);
        }
        
        if (myobjs.length > 0)
        {
            map.fitBounds(latlngArray);
        }
        
		component.set('v.theMarkers', theMarkers);
    },
    mapObjectSelected: function(component, event, helper) 
    {
        // Center the map on the account selected in the list
        var map = component.get('v.map');
        var myObj = event.getParam("obj");
        if (myObj.Lat == null || myObj.Lng == null)
        {
            return;
        }
        
        var isSelected = event.getParam("isselected");
        
        var theMarkers = component.get('v.theMarkers');
        
        for (var i = 0 ; i < theMarkers.length ; i++)
        {
            //alert(theMarkers[i].getLatLng().lat);
            if (theMarkers[i].getLatLng().lat == myObj.Lat && theMarkers[i].getLatLng().lng == myObj.Lng)
            {
                if (isSelected != null && isSelected)
                {
                    theMarkers[i].setOpacity(1);
                }
                else if(isSelected != null && !isSelected)
                {
                    theMarkers[i].setOpacity(.5);
                }
                theMarkers[i].openPopup();
            }
        }
        
        map.panTo([myObj.Lat, myObj.Lng]);
    }

})