/*Rest service class to handle Rest Response and callout*/
public with sharing  class CQConfigurationRestService {
    public Map<String, String> getPartRecords(){
        CQConfigurationRestServiceUtil cqRestUtil =  CQConfigurationRestServiceUtil.getInstance();
        Map<String, String> responseMap = new Map<String,String>();
        List<SQX_Part__c> sqxPartRecList = new List<SQX_Part__c>();
        if(checkConfigStatus(cqRestUtil)){
            HttpResponse response = calloutForPartRecords(cqRestUtil);
            if(response.getStatusCode() == 200) {
                responseMap.put('NOERROR',response.getBody());
                return responseMap;
            }else{
                responseMap.put('ERROR',Label.Unable_to_get_config);
                return responseMap;
            }
        }else{
            responseMap.put('ERROR',Label.Configuration_is_deactivated);
            return responseMap;
        }
    }
    
    /* Name  : checkConfigStatus
     * Input : CQConfigurationRestServiceUtil
     * output : Boolean to show whether Integration setup is active or not */
    private Boolean checkConfigStatus(CQConfigurationRestServiceUtil cqRestUtil){
        return cqRestUtil != null && cqRestUtil.isActive;
    }
    
    /* Name  : calloutForPartRecords
     * Input : CQConfigurationRestServiceUtil
     * output : HttpResponse */
    private HttpResponse calloutForPartRecords(CQConfigurationRestServiceUtil cqRestUtil){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(cqRestUtil.CQ_REST_ENDPOINT);
        request.setMethod(cqRestUtil.METHOD);
        request.setHeader('Content-Type',cqRestUtil.CONTENT_TYPE);
        request.setHeader('x-api-key', cqRestUtil.X_API_KEY);
        HttpResponse response = http.send(request);
        return response;
    }
}