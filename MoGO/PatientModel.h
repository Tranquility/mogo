//
//  PatientModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>

@interface PatientModel : NSObject

@property (nonatomic) NSInteger idNumber;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *mail;
@property (nonatomic) NSString *telephone;

- (PatientModel*)initWithId:(NSInteger)idNumber firstName:(NSString*)first lastName:(NSString*)last mail:(NSString*)mail telephone:(NSString*)phone;

@end