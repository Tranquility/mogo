//
//  PatientModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "PatientModel.h"

@implementation PatientModel

- (PatientModel*)initWithFirstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone {
    self = [super init];
    if (self) {
        self.firstName = first;
        self.lastName = last;
        self.mail = mail;
        self.telephone = phone;
    }
    
    return self;
}

- (NSString*)toString {
    return [NSString stringWithFormat:@"%@ %@, %@, %@", self.firstName, self.lastName, self.mail, self.telephone];
}

@end
