//
//  LocationServices.m
//  MoGO
//
//  Created by DW on 31.12.12.
//
//

#import "LocationServices.h"

@implementation LocationServices

-(LocationServices*)initWithRunningLocationService
{
    self = [super init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    return self;
}

-(CLLocation*) generateLocation:(double)latitude longitude:(double)longitude
{
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

-(CLLocation*) usersCurrentLocation
{
    return [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude
                                                  longitude:self.locationManager.location.coordinate.longitude];

}

-(CLLocationDistance) distanceBetweenTwoLocations:(CLLocation*)firstLocation andSecondLocation:(CLLocation*)secondLocation
{
    return [firstLocation distanceFromLocation:secondLocation];
}


@end
