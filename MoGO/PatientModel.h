//
//  PatientModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface PatientModel : NSObject

@property (nonatomic) NSInteger idNumber;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) AddressModel *address;
@property (nonatomic) NSString *mail;
@property (nonatomic) NSString *telephone;
@property (nonatomic) NSDate *dateOfBirth;
@property (nonatomic) NSString *healthInsurance;

- (PatientModel*)initWithId:(NSInteger)idNumber firstName:(NSString*)first lastName:(NSString*)last address:(AddressModel*)address mail:(NSString*)mail telephone:(NSString*)phone dateOfBirth:(NSDate*)day healthInsurance:(NSString*)insurance;

@end
