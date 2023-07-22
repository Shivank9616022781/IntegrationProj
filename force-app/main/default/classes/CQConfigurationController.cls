/* Class to handle the CQCOnfiguration */
public with sharing class CQConfigurationController {
    /* Name  : SyncPartData
     * Input : none
     * output : Map<String, String> to show success or error message */
    @AuraEnabled
    public static Map<String,String> syncPartData(){
        CQConfigurationRestService configRest = new CQConfigurationRestService();
        Map<String,String> responseMap = new Map<String, String>();
        if(!checkCustomPermission()){
            responseMap.put('ERROR',Label.User_is_Not_Eligible);
            return responseMap;
        }
        
        if(!(CQCOnfigurationLogic.checkDMLPermissionsForSQXObject() && CQCOnfigurationLogic.checkDMLPermissionForSQLFields())){
            responseMap.put('ERROR',Label.Permission_Denied);
            return responseMap;
        }
        responseMap = configRest.getPartRecords();
        if(responseMap != null && String.isNotBlank(responseMap.get('NOERROR'))){
            return CQCOnfigurationLogic.processCQResponse((List<Object>) JSON.deserializeUntyped(responseMap.get('NOERROR')));
        }else{
            return responseMap;
        }
        
    }
    
     /* Name  : SyncPartData
     * Input : none
     * output : Boolean to show whether custome permission is enable or not */
    private static Boolean checkCustomPermission(){
        return FeatureManagement.checkPermission('Integration_Admin_Custom_Permission');
    }
    
}