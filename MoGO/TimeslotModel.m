//
//  TimeslotModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "TimeslotModel.h"
#import "Time.h"

@interface TimeslotModel (Private)

@property (nonatomic) NSDate *start;
@property (nonatomic) NSDate *end;
@property (nonatomic) NSInteger appointmentDuration;

@end

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
    self.appointments = [[NSMutableArray alloc] init];
    
    NSTimeInterval interval = [self.end timeIntervalSinceDate:self.start];
    NSInteger numberOfAppointments = interval / 60 / self.appointmentDuration;
    
    for (NSInteger i = 0; i < numberOfAppointments; i += 1) {
        [self.appointments addObject:NO];
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

    return (BOOL)[self.appointments objectAtIndex:index];
}


@end
