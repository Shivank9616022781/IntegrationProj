public interface ICQConfigSelector {
	List<sObject> getSObjectRecords(String query);
    String getSObjectFieldList(String fieldList);
    String setLimit(String limitVal);
    String getSobject(String objectName);
    String setCondition(String condition);
    String setSecurity();
}