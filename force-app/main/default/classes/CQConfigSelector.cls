public with sharing class CQConfigSelector implements ICQConfigSelector{
    private static CQConfigSelector instance;
    private CQConfigSelector(){}
    
    public static CQConfigSelector getInstance(){
        if(instance == null){
            instance = new CQConfigSelector();
        }
        return instance;
    }
    
    public String buildQueryForAccount(){
       return ' SELECT '+getSObjectFieldList('Id, Name')+' FROM '+getSobject('Account')+' WHERE '+setCondition('name = \'High Volume\' OR Name = \'Low Volume\'')+setSecurity()+setLimit('49999');
    }
    
    public List<Account> getAccountRecord(){
        Return getSObjectRecords(buildQueryForAccount());
    }
    
    public List<sObject> getSObjectRecords(String query){
        System.debug('Database.query(query) : '+Database.query(query));
        return Database.query(query);
    }
    
    public String getSObjectFieldList(String fieldList){
        return fieldList;
    }
    
    public String setLimit(String limitVal){
        return ' LIMIT '+limitVal;
    }
    
    public String getSobject(String objectName){
        return objectName;
    }
    
    public String setCondition(String condition){
        return condition;
    }
    
    public String setSecurity(){
        return ' WITH SECURITY_ENFORCED ';
    }
}