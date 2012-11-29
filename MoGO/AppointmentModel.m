//
//  AppointmentModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentModel.h"

@implementation AppointmentModel

- (AppointmentModel*)initWithDoctor:(DoctorModel*)doctor andDate:(NSDate*)date andNote:(NSString*)note{
    self = [super init];
    if (self)
    {
        self.doctor = doctor;
        self.date = date;
        self.note = note;
    }
    return self;
}

@end
