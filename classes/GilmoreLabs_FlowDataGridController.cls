public with sharing class GilmoreLabs_FlowDataGridController 
{
    @AuraEnabled
    public static String getColumnString(String objectName, String fields, String openRecordField) 
    {
        
        fields = fields.remove(' ');
        
        string result = '[';
        SObjectType myObjType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = myObjType.getDescribe().fields.getMap();
        
        for (string currentField : fields.split(','))
        {
            if (string.isBlank(currentField))
            {
                continue;
            }
            string targetField = currentField;
            if (currentField.contains('.'))
            {
                targetField = currentField.split('\\.')[0].replace('__r','__c');
            }
            system.debug('Checking for field:' + targetField);
            for (Schema.SObjectField sField : mfields.values()) 
            {
                schema.DescribeFieldResult dField = sField.getDescribe(); 
                String fieldLabel = dField.getLabel();
                String fieldAPIName = dField.getName();      
                string fieldType = String.ValueOf(dField.getType()).tolowercase();
                
                if (currentField.contains('.'))
                {
                    fieldLabel += '.' + currentField.split('\\.')[1];
                    fieldType = 'string';
                }
                
                //Handle all the types of fields
                if (fieldType == 'id')fieldType = 'string';
                
                if (String.isNotBlank(openRecordField) && targetField.toLowerCase() == fieldAPIName.toLowerCase() && fieldAPIName.toLowerCase() == openRecordField.toLowerCase())
                {
                    result += '{"label": "' + fieldLabel + '", "fieldName": "show__record", "type": "url", "typeAttributes":{"label":{"fieldName":"' + currentField.toLowerCase() + '"}}},';
                    break;
                }
                else if (targetField.toLowerCase() == fieldAPIName.toLowerCase() || (currentField.contains('.') && !currentField.contains('__c') && targetField + 'id' == fieldAPIName.toLowerCase()))
                {
                    system.debug('Adding Field to datagrid:' + fieldLabel);
                    //we need to add the string to this
                    result += '{"label": "' + fieldLabel  + '", "fieldName": "' + currentField.toLowerCase() + '", "type": "' + fieldType + '"' + (fieldType == 'url' ? ', "typeAttributes":{"label":{"fieldName":"name"}}' : '') + '},';
                    break;
                }
            }
        }
        result = result.removeEnd(',') + ']';
        return result;
    }
    
    @AuraEnabled
    public static String getDataString(List<string> lstIds, String objectName, String fields, String openRecordField, integer maxRecords)
    {
        string result = '[';
        fields = fields.remove(' ').replace(',,', ',');
        
        List<ID> myIDs = new List<ID>();
        for (string currentID : lstIds)
        {
            if (String.isNotBlank(currentID))
            {
                myIDs.add(currentID);
            }
        }

        string limitText = '';
        if (maxRecords > 0)
        {
            limitText = ' LIMIT ' + maxRecords;
        }

        List<sObject> sobjList = Database.query('SELECT ' + fields.removeEnd(',').remove('open_record__flow,').remove('open_record__flow') + ' FROM ' + objectName + ' WHERE ID IN:myIDs ' + limitText);
        for (sObject currentObject : sobjList)
        {
            result += '{"id":"' + currentObject.get('Id') + '",';
            for(string currentField : fields.split(','))
            {
                if (String.isNotBlank(openRecordField) && currentField.toLowerCase() == openRecordField.toLowerCase())
                {
                    result += '"show__record":"/' + currentObject.get('Id') + '",';
                }
                if (currentField.toLowerCase() != 'id')
                {
                    if (currentField.contains('.'))
                    {
                        String sFieldSub1 = currentField.SubString(0,currentField.indexof('.'));
                        String sFieldSub2 = currentField.SubString(currentField.indexof('.') + 1,currentField.Length()); //though I imagine you could use a spilt string also.
                        String sValue = '';
                        if (currentObject.getSObject(sFieldSub1) != null)
                        {
                            sValue = String.valueof(currentObject.getSObject(sFieldSub1).get(sFieldSub2));
                        }
                        result += '"' + currentField.toLowerCase() + '":"' + escapeText(sValue) + '",';
                    }
                    else
                    {
                        string myVal = String.valueOf(currentObject.get(currentField));
                        result += '"' + currentField.toLowerCase() + '":"' + escapeText(myVal)  + '",';
                    }
                }
            }
            result = result.removeEnd(',') + '},';
        }
        result = result.removeEnd(',') + ']';
        return result;
    }
    
    public static string escapeText(string input)
    {
        if (input == null) return null;
        return input.replace('<', '&lt;').replace('>', '&gt;').replace('"', '\'');
    }
}