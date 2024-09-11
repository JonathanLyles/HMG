public without sharing class TourAttendanceCalculator {
    public TourAttendanceCalculator() {
    }
    @InvocableMethod(label='Calculate Total Attendance' description='Calculate Total Attendance of all shows on the same tour')
    public static void calculateTotalAttendance(){
        List<Tour__c> tours = getTours();
        System.debug(tours);
        upsert tours;
    }
    //Get all Tour__c
    private static List<Tour__c> getTours(){
        //If a tour needs to be updated it will be added to List<Tour__c> toursToUpdate
        List<Tour__c> toursToUpdate = new List<Tour__c>();
        DateTime currentDateTime = DateTime.now();
        List<Tour__c> myTours = [
            SELECT Id, Name, Tour_Status__c, Total_Tour_Revenue__c, Average_Tour_Attendance__c,
                (SELECT Id, Name, Revenue__c, Show_Date__c, Ticket_Sales__c FROM Tour_Schedules__r WHERE Show_Date__c < :currentDateTime) FROM Tour__c];
        //Outer loop - Iterate through each Tour__c
        for(Tour__c tour : myTours){
            System.debug('Current Tour: ' + tour.Name);
            //Reset counters for each tour
            //Integer to count how many shows completed shows the tour has
            Integer showCount = 0; 
            //Decimal to keep track of the tour's revenue
            Decimal tourRevenue = 0.00;
            //Integer to count attendance at all completed shows of the tour
            Integer tourAttendance = 0;
            //Inner loop - Iterate through each Tour_Schedules__r (shows)
            if(tour.Tour_Schedules__r.size() > 0){
                //initialize tour
                tour.Total_Tour_Revenue__c = 0.00;
                tour.Average_Tour_Attendance__c = 0;
                for(Tour_Schedule__c show : tour.Tour_Schedules__r){
                    if(show.Show_Date__c < DateTime.now()){
                        showCount ++;
                        tour.Total_Tour_Revenue__c += show.Revenue__c;
                        tourAttendance += (Integer) show.Ticket_Sales__c;
                        tour.Average_Tour_Attendance__c = (Integer) tourAttendance / showCount;
                    }else{
                        System.debug('The show didn\'t happen yet');
                    }                 
                }
                toursToUpdate.add(tour);
            }
            System.debug('Show Count for ' + tour.Name + ': ' + showCount);
            System.debug('Current tour Id: ' + tour.Id);
            System.debug('Total Revenue:' + tourRevenue);
            System.debug('Total Attendance:' + tourAttendance);
            }    
         
        return toursToUpdate;
    }
}