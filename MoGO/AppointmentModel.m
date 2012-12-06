//
//  AppointmentModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentModel.h"

@implementation AppointmentModel

- (AppointmentModel*)initWithId:(NSInteger)idNumber doctor:(DoctorModel*)doctor andDate:(NSDate*)date andNote:(NSString*)note {
    self = [super init];
    if (self)
    {
        self.idNumber = idNumber;
        self.doctor = doctor;
        self.date = date;
        self.note = note;
    }
    return self;
}

@end
