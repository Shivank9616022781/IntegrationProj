/*Class to handle the Response from callout and COnfigure the Logic*/
public with sharing class CQCOnfigurationLogic {
     /* Name  : processCQResponse
     * Input : List<Object>
     * output : Map<String, String> to show success or error message */
    public static Map<String, String> processCQResponse(List<Object> cqResponseList){
        //Map to Hold Configuration details from metadata
        Map<String,String> integrationMappingMap = new Map<String,String>();
        
        //Map to hold response parse data
        Map<String,Id> accMap = new Map<String,Id>();
        
        //List to hold SQX Object Details
        List<SQX_Part__c> sqxPartRecList = new List<SQX_Part__c>();
        
        //Config record from metadata
        For(CQ_Integration_Mapping__mdt mdtRes : [Select DeveloperName, Destination_Field_API__c, Source_Field_API__c, Active__c from CQ_Integration_Mapping__mdt where Active__c = true LIMIT 49999]){
            integrationMappingMap.put(mdtRes.Source_Field_API__c, mdtRes.Destination_Field_API__c);
        }
        
        //Get Account Details 
        For(account acc : CQConfigSelector.getInstance().getAccountRecord()){
            accMap.put(acc.Name, acc.Id);
        }

        //Assigning the response value to SQX record
        for(Integer i = 0; i<cqResponseList.size(); i++){
            Map<String,Object> cqResponseMap = (Map<String,Object>) cqResponseList[i];
            SQX_Part__c sqxPartRec = new SQX_Part__c();
            for(String key : integrationMappingMap.keySet()){
                if(key == 'Total Quantity Shipped'){
                    if(Integer.valueOf(cqResponseMap.get(key)) < 99){
                        sqxPartRec.put(integrationMappingMap.get(key), accMap.get('High Volume'));
                    }else{
                        sqxPartRec.put(integrationMappingMap.get(key), accMap.get('Low Volume'));
                    }
                }else{
                    sqxPartRec.put(integrationMappingMap.get(key), cqResponseMap.get(key));
                }
            }
            sqxPartRecList.add(sqxPartRec);
        }
        
       return upsertSQXRecords(sqxPartRecList);
    }
    
     /* Name  : upsertSQXRecords
     * Input : List<SQX_Part__c>
     * output : Map<String, String> to show success or error message */
    public static Map<String, String> upsertSQXRecords(List<SQX_Part__c> sqxPartRecList){
        system.debug('sqxPartRecList : '+sqxPartRecList);
        Map<String,String> responseMap = new Map<String, String>();
        Schema.SObjectField upsertField = SQX_Part__c.Fields.Part_Number__c;
        for (Database.UpsertResult upsertResult : Database.upsert(sqxPartRecList, upsertField ,false)) {
            if (upsertResult.isSuccess()) {
                responseMap.put('NOERROR',Label.Successfully_Synced_Data );
            }
            else {           
                for(Database.Error errorRec : upsertResult.getErrors()) {
                    responseMap.put('ERROR',errorRec.getMessage());
                }
            }
        }
        return responseMap;
    }
    
        
    /* Name  : checkDMLPermissionsForSQXObject
     * Input : none
     * output : Boolean to show whether Object access is present or not */
   public static Boolean checkDMLPermissionsForSQXObject(){
        return (SQX_Part__c.SObjectType.getDescribe().isAccessible() && 
           SQX_Part__c.SObjectType.getDescribe().isCreateable() &&
           SQX_Part__c.SObjectType.getDescribe().isUpdateable());
    }
    
            
    /* Name  : checkDMLPermissionForSQLFields
     * Input : none
     * output : Boolean to show whether Object's Field access is present or not */
    public static Boolean checkDMLPermissionForSQLFields(){
        SObjectType objType = ((SObject) (Type.forName('Schema.SQX_Part__c').newInstance())).getSObjectType();
        Map<String, SObjectField> fieldsByName = objType.getDescribe().fields.getMap();
        List<String> customFields = new List<String>();
        
        for (SObjectField field : fieldsByName.values()) {
            if (field.getDescribe().isCustom() && !field.getDescribe().isCreateable() && !field.getDescribe().isUpdateable()) {
                return false;
            }
        }
        return true;
    }
}