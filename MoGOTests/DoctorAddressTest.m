//
//  DoctorAddressTest.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "DoctorAddressTest.h"

@implementation DoctorAddressTest

- (void)setUp
{
    [super setUp];
    
    CLLocationCoordinate2D location;
    location.latitude = 53.694216;
    location.longitude = 10.786232;
    
    self.address = [[AddressModel alloc] initWithStreet:@"Schweriner Straße" streetNumber:49 zipCode:@"23909" city:@"Ratzeburg" coordinate:&location];
    self.doctor = [[DoctorModel alloc] initWithId:0 title:@"Dr." gender:@"male" firstName:@"Thomas" lastName:@"Block" mail:@"info@block.de" telephone:@"045412041" address:self.address];
    
    STAssertNotNil(self.doctor, nil);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testProperties
{
    STAssertEqualObjects(@"Dr.", self.doctor.title, nil);
    STAssertEqualObjects(@"Thomas", self.doctor.firstName, nil);
    STAssertEqualObjects(@"Block", self.doctor.lastName, nil);
    STAssertEqualObjects(@"info@block.de", self.doctor.mail, nil);
    STAssertEqualObjects(@"045412041", self.doctor.telephone, nil);
    
    STAssertEqualObjects(@"Schweriner Straße", self.doctor.address.street, nil);
    STAssertEquals(49, self.doctor.address.streetNumber, nil);
    STAssertEqualObjects(@"23909", self.doctor.address.zipCode, nil);
    STAssertEqualObjects(@"Ratzeburg", self.doctor.address.city, nil);
}

@end
