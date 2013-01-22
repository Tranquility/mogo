//
//  UserCalendarManipulator.h
//  MoGO
//
//  Created by DW on 14.01.13.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface UserCalendarManipulator : NSObject
-(void) deleteCalendarAppointment:(NSDate*)appointment;
-(void)saveAppointmentToCalendar:(NSDate*)startDate withDoctorName:(NSString*)doctorFullName;
-(EKEvent*)checkForUserAppointmentsAtTime:(NSDate*)dateToCheck;


@end
