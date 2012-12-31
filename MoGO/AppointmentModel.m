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

- (AppointmentModel*)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    
    if (self) {
        self.doctor = [[DoctorModel alloc] initWithDictionary:[dict valueForKeyPath:@"doctor"]];
        
        self.idNumber = [[dict valueForKeyPath:@"id"] intValue];
        self.note = [dict valueForKeyPath:@"note"];
        
        NSString *dateString = [dict valueForKeyPath:@"start_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        self.date = [formatter dateFromString:dateString];
    }
    
    return self;
}

@end
