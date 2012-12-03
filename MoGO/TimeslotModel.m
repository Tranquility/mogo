//
//  TimeslotModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "TimeslotModel.h"
#import "Time.h"

@implementation TimeslotModel

- (TimeslotModel*)initWithStartTime:(NSDate*)start andEndTime:(NSDate*)end andAppointmentDuration:(NSInteger)duration {
    self = [super init];
    if (self) {
        self.start = start;
        self.end = end;
        self.appointmentDuration = duration;
        [self initAppointmentArray];
    }
    
    return self;
}

- (void)initAppointmentArray {
    
    NSTimeInterval interval = [self.end timeIntervalSinceDate:self.start];
    NSInteger numberOfAppointments = interval / 60 / self.appointmentDuration;
    NSLog(@"%d", numberOfAppointments);
    self.appointments = [[NSMutableArray alloc] init];
    NSNumber *empty = [NSNumber numberWithBool:NO];
    for (NSInteger i = 0; i < numberOfAppointments; i += 1) {
        [self.appointments addObject: empty];
    }
}

- (NSInteger)numberOfAppointments {
    return self.appointments.count;
}

- (BOOL) isAppointmentAvailable:(NSInteger)index {
    if (index >= self.appointments.count)
    {
       [NSException raise:@"Invalid index value" format:@"Index (%d) is out of bounds!", index];
    }

    return ![[self.appointments objectAtIndex:index] boolValue];
}


@end
