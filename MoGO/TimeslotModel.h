//
//  TimeslotModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>

@interface TimeslotModel : NSObject

@property (nonatomic) NSDate *start;
@property (nonatomic) NSDate *end;
@property (nonatomic) NSInteger appointmentDuration;
@property (nonatomic) NSMutableArray *appointments;

- (TimeslotModel*)initWithStartTime:(NSDate*)start andEndTime:(NSDate*)end andAppointmentDuration:(NSInteger)duration;

- (NSInteger)numberOfAppointments;

- (BOOL) isAppointmentAvailable:(NSInteger)index;

@end
