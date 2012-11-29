//
//  MoGOTests.m
//  MoGOTests
//
//  Created by 0leschen on 28.11.12.
//
//

#import "MoGOTests.h"

@implementation MoGOTests

- (void)setUp
{
    [super setUp];
    self.address = [[AddressModel alloc] initWithStreet:@"Landstraße" streetNumber:4 zipCode:@"23909" city:@"Ratzeburg" coordinate:self.coordinate];
    self.doctor = [[DoctorModel alloc] initWithTitle:@"Dr." gender:@"male" firstName:@"Thomas" lastName:@"Block" mail:@"info@block.de" telephone:@"04541877966" adress:self.address];
    STAssertNotNil(self.doctor, nil);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testExample
{
    STAssertEquals(@"Dr.", self.doctor.title, nil);
}

@end
