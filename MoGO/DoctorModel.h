//
//  DoctorModel.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface DoctorModel : NSObject

@property (nonatomic) NSInteger idNumber;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *mail;
@property (nonatomic) NSString *telephone;
@property (nonatomic) AddressModel *address;

- (DoctorModel*)initWithId:(NSInteger)idNumber title:(NSString*)title gender:(NSString*)gender firstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone address:(AddressModel*)address;

- (NSString*)description;

@end
