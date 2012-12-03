//
//  PatientModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "PatientModel.h"

@implementation PatientModel

- (PatientModel*)initWithId:(NSInteger)idNumber firstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone {
    self = [super init];
    if (self) {
        self.idNumber = idNumber;
        self.firstName = first;
        self.lastName = last;
        self.mail = mail;
        self.telephone = phone;
    }
    
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %@, %@, %@", self.firstName, self.lastName, self.mail, self.telephone];
}

@end
