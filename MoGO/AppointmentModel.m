//
//  AppointmentModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentModel.h"

@implementation AppointmentModel
@synthesize id = _id;
@synthesize doctor = _doctor;
@synthesize note = _note;

- (AppointmentModel*)initWithId:(int)id andDoctor:(DoctorModel*)doctor andDate:(NSDate*)date andNote:(NSString*)note{
    self = [super init];
    if (self)
    {
        _id = id;
        _doctor = doctor;
        _note = note;
    }
    return self;
}

@end
