//
//  PatientModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>

@interface PatientModel : NSObject

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *mail;
@property (nonatomic) NSString *telephone;

- (PatientModel*)initWithFirstName:(NSString*) lastName:(NSString*) mail:(NSString*)mail telephone:(NSString*)phone;

- (NSString*)toString;

@end
