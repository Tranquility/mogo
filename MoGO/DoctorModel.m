//
//  DoctorModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "DoctorModel.h"

@implementation DoctorModel

- (DoctorModel*)initWithId:(NSInteger)idNumber title:(NSString*)title gender:(NSString*)gender firstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone address:(AddressModel*)address {
    self = [super init];
    if (self) {
        self.title = title;
        self.gender = gender;
        self.firstName = first;
        self.lastName = last;
        self.mail = mail;
        self.telephone = phone;
        self.address = address;
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@ %@", self.title, self.firstName, self.lastName];
}

@end