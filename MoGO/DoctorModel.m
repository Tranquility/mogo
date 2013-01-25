//
//  DoctorModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "DoctorModel.h"

@implementation DoctorModel

- (DoctorModel*)initWithId:(NSInteger)idNumber discipline:(NSString*)discipline title:(NSString*)title gender:(NSString*)gender firstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone address:(AddressModel*)address {
    self = [super init];
    if (self) {
        self.idNumber = idNumber;
        self.discipline = discipline;
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

- (DoctorModel*)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    
    if (self) {
        AddressModel *address = [[AddressModel alloc] initWithDictionary:dict];
        
        self.idNumber = [[dict valueForKeyPath:@"id"] intValue];
        self.discipline = [dict valueForKeyPath:@"discipline.name"];
        self.title = [dict valueForKeyPath:@"title"];
        self.gender = [dict valueForKeyPath:@"gender"];
        self.firstName = [dict valueForKeyPath:@"firstname"];
        self.lastName = [dict valueForKeyPath:@"lastname"];
        self.mail = [dict valueForKeyPath:@"email"];
        self.telephone = [dict valueForKeyPath:@"telephone"];
        self.address = address;
    }
    
    return self;
}


- (NSString*)fullName {
    return [[NSString stringWithFormat:@"%@ %@ %@", self.title, self.firstName, self.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];}

@end
