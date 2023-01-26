public with sharing class GilmoreLabs_FlowTileGridController 
{
    @AuraEnabled
    public static List<Task> getData(List<string> lstInput) 
    {
        List<Task> objItems = new List<Task>();
        integer counter = 1;
        TimeZone tz = UserInfo.getTimeZone();
        
        for (String currentVal : lstInput)
            {
                Task newItem = new Task();
                newItem.Subject = currentVal.contains('<') ? currentVal : '<span class="slds-text-heading_medium">' + currentVal + '</span>'; //<span class="slds-text-title"></span>
                newItem.CallDurationInSeconds = counter;
                system.debug(currentVal);
                newItem.CallObject = currentVal.contains('|') ? currentVal.split('\\|')[1] : currentVal;
                objItems.add(newItem);
                counter++;
            }
        return objItems;
    }
}