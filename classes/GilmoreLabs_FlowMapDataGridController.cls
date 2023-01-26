public with sharing class GilmoreLabs_FlowMapDataGridController 
{
    @AuraEnabled
    public static List<LeafMarker> getObjs(List<string> lstIds, List<string> lstpreSelectedIds, String objectName, 
                                           String strTitleField, String strLatField,
                                          String strLngField, String descriptionTemplate)
    {
        List<LeafMarker> obResults = new List<LeafMarker>();
        List<ID> myIDs = new List<ID>();
        for (string currentID : lstIds)
        {
            if (String.isNotBlank(currentID))
            {
                myIDs.add(currentID);
            }
        }
        
        TimeZone tz = UserInfo.getTimeZone();
        string objFields = '';
        Map<String,Schema.SObjectField> mfields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for( integer i=0; i < mfields.values().size()-1; i++ )
        {
            objFields += mfields.values()[i].getDescribe().getName() + ', ';
        }
        objFields += mfields.values()[ mfields.values().size() - 1 ].getDescribe().getName();
        List<sObject> sobjList = Database.query('SELECT ' + objFields + ' FROM ' + objectName + ' WHERE ID IN:myIDs');
        for (sObject currentObject : sobjList)
        {
            //get description template
            string currentDescription = descriptionTemplate;
            //Peform the merge operation
            for (SObjectField field: mfields.values()) 
            {
                // Passed in object has the field
                string fieldName = field.getDescribe().getName();
                try
                {
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    string matchString = '{' + fieldName + '}';
                    if (currentObject.get(fieldName) == null)
                    {
                        currentDescription = currentDescription.replace(matchString, '');
                    }
                    else if (fieldType == Schema.DisplayType.DATETIME)
                    {
                        system.debug('formatting to tz: ' + tz.getDisplayName());
                        currentDescription = currentDescription.replace(matchString, ((datetime)currentObject.get(fieldName)).format('EEE MMM d h:mmaaa', tz.getID()));
                    }
                    else
                    {
                        currentDescription = currentDescription.replace(matchString, String.valueOf(currentObject.get(fieldName)));
                    }           
                }
                catch (Exception ex)
                {
                    
                }
            }
            
            LeafMarker newMarker = new LeafMarker();
            newMarker.Id = (string)currentObject.get('Id');
            newMarker.Title = (string)currentObject.get(strTitleField);
            newMarker.Lat = String.valueof(currentObject.get(strLatField));
            newMarker.Lng = String.valueof(currentObject.get(strLngField));
            newMarker.Description = currentDescription;
            newMarker.Preselected = lstpreSelectedIds.Contains((string)currentObject.get('Id'));
            obResults.add(newMarker);
        }
        return obResults;
    }
    
    public class LeafMarker
    {
        @AuraEnabled public string Id{get;set;}
        @AuraEnabled public string Title{get;set;}
        @AuraEnabled public String Lat{get;set;}
        @AuraEnabled public String Lng{get;set;}
        @AuraEnabled public string Description{get;set;}
        @AuraEnabled public Boolean Preselected{get;set;}
    }
}