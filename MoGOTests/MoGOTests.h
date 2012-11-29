//
//  MoGOTests.h
//  MoGOTests
//
//  Created by 0leschen on 28.11.12.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "DoctorModel.h"
#import "AddressModel.h"

@interface MoGOTests : SenTestCase

@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) AddressModel *address;
@property (nonatomic) CLLocationCoordinate2D *coordinate;

@end
