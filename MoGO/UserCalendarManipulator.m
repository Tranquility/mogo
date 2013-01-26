//
//  UserCalendarManipulator.m
//  MoGO
//
//  Created by DW on 14.01.13.
//
//

#import "UserCalendarManipulator.h"
#import "UserDefaultConstants.h"

@implementation UserCalendarManipulator

- (id)init
{
    self = [super init];
    if (self)
    {
        [self askForCalendarPermissionOnce];
    }
    return self;
}


-(void)askForCalendarPermissionOnce
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(!granted)
        {
            UIAlertView *notGrantedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rechte zur Kalendernutzung nicht gewährt", @"CALENDAR_NOT_GRANTED")
                                                                      message:NSLocalizedString(@"MoGo kann keine Termine n Ihren Kalender speichern. Sie können die Rechte in den Systemeinstellungen gewähren", @"GRANT_CALENDAR_IN_OPTIONS")
                                                                     delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil, nil];
            [notGrantedAlert show];
        }
        
    }];
}

//Saves an appointment consisting of a given date and the full name of the doctor to the calendar
-(void)saveAppointmentToCalendar:(NSDate*)startDate withDoctorName:(NSString*)doctorFullName
{
    //if user doesn't want mogo appointments to be saved in his calendar
    if([[NSUserDefaults standardUserDefaults] boolForKey:UD_SYSTEM_SAVE_TO_CALENDAR])
    {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title = [NSLocalizedString(@"Termin bei: ", @"APPOINTMENT_AT") stringByAppendingString:doctorFullName];
        event.startDate = startDate;
        //we save a appointment with 30 minutes duration by default
        //TODO: can probably fetch the lenght of the selected slot from server somehow
        //(or we do it that way so the user has a little time buffer)
        event.endDate   = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:event.startDate];
        event.notes = NSLocalizedString(@"Mit MoGo erstellter Termin", @"CREATED_WITH_MOGO");
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        }];
    }//if
}

//Checks if the user already has an appointment in the time from dateToCheck to dateToCheck+30Min
//returns one of these appointments if any, nil if he doesn't have an appointment
-(EKEvent*)checkForUserAppointmentsAtTime:(NSDate*)dateToCheck
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //we check a certain time - timeframe from dateToCheck to DateToCheck+30
    NSDate *endDate   = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:dateToCheck];
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:dateToCheck
                                                                 endDate:endDate
                                                               calendars:nil];
    NSArray *usersAppointmentsInRange = [[NSArray alloc]init];
    
    usersAppointmentsInRange = [eventStore eventsMatchingPredicate:predicate];
    if([usersAppointmentsInRange count] > 0)
    {
        return [usersAppointmentsInRange objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}


-(void) deleteCalendarAppointment:(NSDate*)appointment
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //we check a certain time
    NSDate *endDate   = [[NSDate alloc] initWithTimeInterval:300 sinceDate:appointment];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:appointment 
                                                                 endDate:endDate
                                                               calendars:nil];
    
    NSArray *usersAppointmentsInRange = [[NSArray alloc]init];
    
    usersAppointmentsInRange = [eventStore eventsMatchingPredicate:predicate];
    for(EKEvent* event in usersAppointmentsInRange)
    {
        //make sure selected appointment has really been created with MoGo
        if([event.notes isEqualToString:NSLocalizedString(@"Mit MoGo erstellter Termin", @"CREATED_WITH_MOGO")])
        {
            NSError *error;
            [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
            break;
        }
    }
    
}

@end
