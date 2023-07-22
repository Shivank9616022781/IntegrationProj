@isTest
public class CQConfigurationControllerTest {
    
    @TestSetup
    public static void setupTestData(){
        CQConfigurationTestDataFactory.createUserWithSystemAsAdmin();
        CQConfigurationTestDataFactory.createUserWithSystemAsAdminWithoutPermission();
        CQConfigurationTestDataFactory.createIntegrationSettingRec(true);
        CQConfigurationTestDataFactory.generateCustomMetadataRec(); 
        CQConfigurationTestDataFactory.createAccountRecords(); 
        CQConfigurationTestDataFactory.createUserWithStandardUser(); 
        CQConfigurationTestDataFactory.createUserWithStandardUserNoPermission();
    }
    
   @isTest
    static void syncPartData_Positive(){
        User user = [SELECT Id FROM User WHERE firstname = 'Admin'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000},{"_id": "619683d69402c24f000237e912","Part Name": "Sensor","Total Quantity Shipped": 32}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String,String> result  = CQConfigurationController.syncPartData();
            Test.stopTest();
            system.assertEquals(result.get('NOERROR'), Label.Successfully_Synced_Data);
        }
    }
    
    @isTest
    static void syncPartData_DMLTest(){
        User user = [SELECT Id FROM User WHERE firstname = 'Admin'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000},{"_id": "619683d69402c24f000237e9","Part Name": "Sensor","Total Quantity Shipped": 32}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String,String> result  = CQConfigurationController.syncPartData();
            Test.stopTest();
            system.assertEquals(result.get('ERROR'), 'Duplicate external id specified: 619683d69402c24f000237e9');
        }
    }

    @isTest
    static void syncPartData_NoResponseTest(){
        User user = [SELECT Id FROM User WHERE firstname = 'Admin'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(404,'NOT FOUND','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000},{"_id": "619683d69402c24f000237e9","Part Name": "Sensor","Total Quantity Shipped": 32}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String,String> result  = CQConfigurationController.syncPartData();
            Test.stopTest();
            system.assertEquals(result.get('ERROR'), Label.Unable_to_get_config);
        }
    }
    
    
    @isTest
    static void syncPartData_SQXRecordCreatPostive(){
        User user = [SELECT Id FROM User WHERE firstname = 'Admin'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            CQConfigurationController.syncPartData();
            List<SQX_Part__c> sqxRecList = [SELECT id FROM SQX_Part__c];
            Test.stopTest();
            System.assertEquals(true, sqxRecList.size() > 0);
        }
    }
    
    @isTest
    static void customSettingTest_Positive() {
        User user = [SELECT Id FROM User WHERE firstname = 'Admin'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String, String> result = CQConfigurationController.syncPartData();
            Test.stopTest();
            System.assertNotEquals(null, result);
            System.assertEquals(null, result.get('ERROR'));
        }
    }
    
    @isTest
    static void customSettingTest_Negative() {
        User user = [SELECT Id FROM User WHERE firstname = 'Admin No Access'];
        System.runAs(user){
            Test.startTest();          
            Map<String, String> result = CQConfigurationController.syncPartData();
            Test.stopTest();
            System.assertEquals(Label.User_is_Not_Eligible, result.get('ERROR'));
        }
    }
    
    @isTest
    static void standardUserWithCustomPermission_Test() {
        User user = [SELECT Id FROM User WHERE firstname = 'Standard'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String, String> result = CQConfigurationController.syncPartData();
            Test.stopTest();
            System.assertEquals(Label.Permission_Denied, result.get('ERROR'));
        }
    }
    
    @isTest
    static void standardUserWithoutCustomPermission_Test() {
        User user = [SELECT Id FROM User WHERE firstname = 'Standard No Access'];
        System.runAs(user){
            Test.startTest();
            HttpMockFactory mock = new HttpMockFactory(200,'SUCCESS','[{"_id": "619683d69402c24f000237e9","Part Name": "Population Sensor","Total Quantity Shipped": 350000}]',new Map<String,String>());
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String, String> result = CQConfigurationController.syncPartData();
            Test.stopTest();
            System.assertEquals(Label.User_is_Not_Eligible, result.get('ERROR'));
        }
    }
}