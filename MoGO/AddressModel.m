//
//  AddressModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "AddressModel.h"

@implementation AddressModel

- (AddressModel*)initWithStreet:(NSString*)street streetNumber:(NSInteger)number zipCode:(NSString*)zipCode city:(NSString*)city coordinate:(CLLocationCoordinate2D*)coordinate {
    self = [super init];
    if (self) {
        self.street = street;
        self.streetNumber = number;
        self.zipCode = zipCode;
        self.city = city;
        self.coordinate = coordinate;
    }
    
    return self;
}

- (NSString*)toString {
    return [NSString stringWithFormat:@"%@ %d, %@ %@", self.street, self.streetNumber, self.zipCode, self.city];
}
@end
