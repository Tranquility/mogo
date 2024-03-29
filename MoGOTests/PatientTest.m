//
//  PatientTest.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "PatientTest.h"

@implementation PatientTest

- (void)setUp
{
    [super setUp];
    
    self.patient = [[PatientModel alloc] initWithId:11 firstName:@"Max" lastName:@"Mustermann" mail:@"mmustermann@gmail.com" telephone:@"0401726354"];

    STAssertNotNil(self.patient, nil);
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPatient
{
    STAssertEqualObjects(@"Max", self.patient.firstName, nil);
    STAssertEqualObjects(@"Mustermann", self.patient.lastName, nil);
    STAssertEqualObjects(@"mmustermann@gmail.com", self.patient.mail, nil);
    STAssertEqualObjects(@"0401726354", self.patient.telephone, nil);
}


@end
