//
//  MoGOTests.m
//  MoGOTests
//
//  Created by 0leschen on 28.11.12.
//
//

#import "MoGOTests.h"

@implementation MoGOTests

@synthesize doctorModel;

- (void)setUp
{
    [super setUp];
    self.doctorModel = [[DoctorModel alloc]initWithId:1 andName:@"Dr.Arzt" andDiscipline:@"KinderArzt"];
    STAssertNotNil(doctorModel, nil);
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    //Funktions Test
    STAssertEquals(@"Dr.Arz", doctorModel.name, nil);
}

@end
