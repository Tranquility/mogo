//
//  TimeslotTest.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "TimeslotTest.h"

@implementation TimeslotTest

- (void)setUp
{
    [super setUp];
    
    NSDate *start = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    NSDate *end = [[NSDate alloc] initWithTimeIntervalSinceNow:7200];
    
    self.slot = [[TimeslotModel alloc] initWithStartTime:start andEndTime:end andAppointmentDuration:15];
    
    
    STAssertNotNil(self.slot, nil);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testProperties
{
    STAssertEquals(15, self.slot.appointmentDuration, nil);
    STAssertEquals(8, [self.slot numberOfAppointments], nil);
    STAssertTrue([self.slot isAppointmentAvailable:0], nil);
}

@end
