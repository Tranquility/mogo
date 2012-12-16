//
//  PatientModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "PatientModel.h"

@implementation PatientModel

- (PatientModel*)initWithId:(NSInteger)idNumber firstName:(NSString*)first lastName:(NSString*)last address:(AddressModel*)address mail:(NSString*)mail telephone:(NSString*)phone dateOfBirth:(NSDate*)day healthInsurance:(NSString*)insurance {
    self = [super init];
    if (self) {
        self.idNumber = idNumber;
        self.firstName = first;
        self.lastName = last;
        self.address = address;
        self.mail = mail;
        self.telephone = phone;
        self.dateOfBirth = day;
        self.healthInsurance = insurance;
    }
    
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@, %@, %@", self.firstName, self.lastName, self.mail, self.telephone];
}

@end
