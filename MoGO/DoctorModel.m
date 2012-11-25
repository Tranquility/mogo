//
//  DoctorModel.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "DoctorModel.h"

@implementation DoctorModel

@synthesize id = _id;
@synthesize name = _name;
@synthesize discipline = _discipline;
@synthesize street = _street;
@synthesize zipcode = _zipcode;
@synthesize city = _city;
@synthesize coordinate = _coordinate;
@synthesize phone = _phone;
@synthesize fax = _fax;
@synthesize openinghours = _openinghours;

- (DoctorModel*)initWithId:(int)id andName:(NSString*)name andDiscipline:(NSString*)discipline andStreet:(NSString*)street andZipcode:(int)zipcode andCity:(NSString*)city andCoordinate:(CLLocationCoordinate2D*)coordinate andPhone:(NSString*)phone andFax:(NSString*)fax andOpeninghours:(NSMutableArray*)openinghours
{
    self = [super init];
    if (self)
    {
        _name = name;
        _discipline = discipline;
        _street = street;
        _zipcode = zipcode;
        _city = city;
        _coordinate = coordinate;
        _phone = phone;
        _fax = fax;
        _openinghours = openinghours;
    }
    return self;
}

- (DoctorModel*)initWithId:(int)id andName:(NSString*)name andDiscipline:(NSString*)discipline
{
    self = [super init];
    if (self)
    {
    _name = name;
    _discipline = discipline;
    }
    return self;
}

@end
