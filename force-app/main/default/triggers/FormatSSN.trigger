trigger FormatSSN on Artist__c (before insert, before update) {
    for (Artist__c obj : Trigger.new) {
        if (obj.Social_Security_Number__c != null && obj.Social_Security_Number__c.length() == 9) {
            obj.Social_Security_Number__c = obj.Social_Security_Number__c.substring(0, 3) + '-' + 
                                            obj.Social_Security_Number__c.substring(3, 5) + '-' + 
                                            obj.Social_Security_Number__c.substring(5, 9);
        }
    }
}