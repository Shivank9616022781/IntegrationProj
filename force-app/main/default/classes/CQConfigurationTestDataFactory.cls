@isTest
public class CQConfigurationTestDataFactory {
    public static void createUserWithSystemAsAdmin(){
        String orgId = UserInfo.getOrganizationId();
        UserRole userRole = createRole('Integration Admin');
        insert userRole;
        Profile profileId = getProfile('Integration Admin');
        String uniqueName = generateUniqueName();
		PermissionSet permissionSet = getIntegrationPermissionSet();
        User userRecord = createUser(orgId, 'Admin', 'Value',uniqueName ,'@adminuser', String.valueOf(profileId.Id), String.valueOf(userRole.Id));
        insert userRecord;
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = userRecord.id, PermissionSetId = permissionSet.Id);
        insert permissionSetAssignment;
    }
    
     public static void createUserWithSystemAsAdminWithoutPermission(){
        String orgId = UserInfo.getOrganizationId();
        UserRole userRole = createRole('Integration Admin No Permission');
        insert userRole;
        Profile profileId = getProfile('Integration Admin');
        String uniqueName = generateUniqueName();
		PermissionSet permissionSet = getIntegrationPermissionSet();
        User userRecord = createUser(orgId, 'Admin No Access', 'Value',uniqueName ,'@adminuser', String.valueOf(profileId.Id), String.valueOf(userRole.Id));
        insert userRecord;
    }
    
    public static void createUserWithStandardUser(){
        String orgId = UserInfo.getOrganizationId();
        UserRole userRole = createRole('Integration User');
        insert userRole;
        Profile profileId = getProfile('Standard User');
        String uniqueName = generateUniqueName();
		PermissionSet permissionSet = getIntegrationPermissionSet();
        User userRecord = createUser(orgId, 'Standard', 'Value',uniqueName ,'@standarduser', String.valueOf(profileId.Id), String.valueOf(userRole.Id));
        insert userRecord;
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = userRecord.id, PermissionSetId = permissionSet.Id);
        insert permissionSetAssignment;
    }
    
    public static void createUserWithStandardUserNoPermission(){
        String orgId = UserInfo.getOrganizationId();
        UserRole userRole = createRole('Standard No Access');
        insert userRole;
        Profile profileId = getProfile('Standard User');
        String uniqueName = generateUniqueName();
		PermissionSet permissionSet = getIntegrationPermissionSet();
        User userRecord = createUser(orgId, 'Standard No Access', 'Value', uniqueName ,'@standarduser', String.valueOf(profileId.Id), String.valueOf(userRole.Id));
        insert userRecord;
        
    }
    
    public static UserRole createRole(String roleName){
        UserRole obj = new UserRole(Name = roleName); 
        return obj;
    }
    
   public static Profile getProfile(String profileName){
        return [Select Id from profile where Name =: profileName];
    }
    
    public static String generateUniqueName(){
        String orgId = UserInfo.getOrganizationId(); 
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer RandomId = Integer.valueOf(Math.rint(Math.random()*1000000)); 
        return orgId+dateString+RandomId; 
    }
    
    public static PermissionSet getIntegrationPermissionSet(){
        return [SELECT Id, PermissionsManageCustomPermissions FROM PermissionSet WHERE Name = 'Integration_Admin'];
    }
    
    public static User createUser(String orgId, String firstInputName, String lastInputName, String uniqueName, String userType, String profileId, String userRoleId){
        User userRecord = new User(firstname = firstInputName, 
                                   lastName = lastInputName, 
                                   email = uniqueName + userType + orgId + '.com', 
                                   Username = uniqueName + userType + orgId + '.com', 
                                   EmailEncodingKey = 'ISO-8859-1', 
                                   Alias = uniqueName.substring(18, 23), 
                                   TimeZoneSidKey = 'America/Los_Angeles', 
                                   LocaleSidKey = 'en_US', 
                                   LanguageLocaleKey = 'en_US', 
                                   ProfileId = profileId, 
                                   UserRoleId = userRoleId);
        return userRecord;
    }
    
    @future
    public static void createIntegrationSettingRec(Boolean statusValue){
        CQ_Customisation_Setup__c cs = new CQ_Customisation_Setup__c();
        cs.Active__c = statusValue;
        cs.Api_Key__c = 'b96d75ce0f9f342d10af6710ef8ea7ed0ad06';
        cs.Endpoint_URL__c = 'https://cqparts-3d06.restdb.io/rest/cqpart';
        insert cs;
    }
    
    @future
    public static void createAccountRecords(){
        List<Account> accRecList = new List<Account>();
        
        Account acc = new Account(
        	Name =  'High Volume'
        );
        accRecList.add(acc);
        
        Account acc1 = new Account(
            Name =  'Low Volume'
        );
        accRecList.add(acc1);
        
        insert(accRecList);
    }
    
    public static void generateCustomMetadataRec(){
        List<CQ_Integration_Mapping__mdt> cqIntegrationMapping = (List<CQ_Integration_Mapping__mdt>)Json.deserialize('[{"Source_Field_API__c": "Part Name","Destination_Field_API__c": "Name","Active__c": true},{"Source_Field_API__c": "_id","Destination_Field_API__c": "Part_Number__c","Active__c": true},{"Source_Field_API__c": "Total Quantity Shipped","Destination_Field_API__c": "Related_Account__c","Active__c": true}]', List<CQ_Integration_Mapping__mdt>.class);
    }
}