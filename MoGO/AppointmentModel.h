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

@property (nonatomic) int id;
@property (nonatomic,strong) DoctorModel *doctor;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *note;

- (AppointmentModel*)initWithId:(int)id andDoctor:(DoctorModel*)doctor andDate:(NSDate*)date andNote:(NSString*)note;
@end
