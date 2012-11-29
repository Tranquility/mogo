//
//  TimeslotModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>

@interface TimeslotModel : NSObject

@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;
@property (nonatomic, readonly) NSInteger appointmentDuration;
@property (nonatomic) NSMutableArray *appointments;

- (TimeslotModel*)initWithStartTime:(NSDate*)start andEndTime:(NSDate*)end andAppointmentDuration:(NSInteger)duration;

- (NSInteger)numberOfAppointments;

- (BOOL) isAppointmentAvailable:(NSInteger)id;

@end
