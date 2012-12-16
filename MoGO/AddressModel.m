//
//  AddressModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "AddressModel.h"

@implementation AddressModel

- (AddressModel*)initWithStreet:(NSString*)street streetNumber:(NSInteger)number zipCode:(NSString*)zipCode city:(NSString*)city latitude:(NSNumber*)latitude longitude:(NSNumber*)longitude {
    self = [super init];
    if (self) {
        self.street = street;
        self.streetNumber = number;
        self.zipCode = zipCode;
        self.city = city;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}

- (AddressModel*)initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        self.street = [dict valueForKeyPath:@"street"];
        self.streetNumber = [[dict valueForKeyPath:@"street_number"] intValue];
        self.zipCode = [dict valueForKeyPath:@"zip_code"];
        self.city = [dict valueForKeyPath:@"city"];
        self.latitude = [dict valueForKeyPath:@"latitude"];
        self.longitude = [dict valueForKeyPath:@"longitude"];
    }
    
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %d, %@ %@", self.street, self.streetNumber, self.zipCode, self.city];
}
@end
