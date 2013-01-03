//
//  LocationServices.m
//  MoGO
//
//  Created by DW on 31.12.12.
//
//

#import "LocationServices.h"

CLLocationManager *locationManager;
CLLocation *usersGeoLocation;
@implementation LocationServices

-(LocationServices*)initWithRunningLocationService
{
    self = [super init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    return self;
}

-(CLLocation*) generateLocation:(double)latitude longitude:(double)longitude
{
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

-(CLLocation*) getUsersCurrentLocation
{
    return [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude
                                                  longitude:locationManager.location.coordinate.longitude];

}

-(CLLocationDistance) distanceBetweenTwoLocations:(CLLocation*)firstLocation andSecondLocation:(CLLocation*)secondLocation
{
    return [firstLocation distanceFromLocation:secondLocation];
}


@end
