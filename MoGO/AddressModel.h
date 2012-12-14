//
//  AddressModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface AddressModel : NSObject

@property (nonatomic) NSString *street;
@property (nonatomic) NSInteger streetNumber;
@property (nonatomic) NSString *zipCode;
@property (nonatomic) NSString *city;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;

- (AddressModel*)initWithStreet:(NSString*)street streetNumber:(NSInteger)number zipCode:(NSString*)zipCode city:(NSString*)city latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;

@end
