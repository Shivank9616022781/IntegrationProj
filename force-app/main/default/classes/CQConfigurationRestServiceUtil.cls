public with sharing class CQConfigurationRestServiceUtil {
	public String CQ_REST_ENDPOINT;
    public String X_API_KEY;
	public Boolean isActive;
    public String CONTENT_TYPE = 'application/json';
    public String METHOD = 'GET';
    
    private static CQConfigurationRestServiceUtil instance;
    
    private CQConfigurationRestServiceUtil(){
        //Integration setup configuration details form Custom setting
        CQ_Customisation_Setup__c cqSetupRec = CQ_Customisation_Setup__c.getOrgDefaults();
        CQ_REST_ENDPOINT = cqSetupRec.Endpoint_URL__c;
        X_API_KEY = cqSetupRec.Api_Key__c;
        isActive = cqSetupRec.Active__c; 
    }
    
    public static CQConfigurationRestServiceUtil getInstance()
    {
        if (instance == null){
            instance = new CQConfigurationRestServiceUtil();
        }  
        return instance;
    }
}