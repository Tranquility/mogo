//
//  AppointmentModel.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <Foundation/Foundation.h>
#import "DoctorModel.h"

@interface AppointmentModel : NSObject

@property (nonatomic) NSInteger idNumber;
@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *note;

- (AppointmentModel*)initWithId:(NSInteger)idNumber doctor:(DoctorModel*)doctor andDate:(NSDate*)date andNote:(NSString*)note;

@end
