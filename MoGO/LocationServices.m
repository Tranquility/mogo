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
    usersGeoLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude
                                                  longitude:locationManager.location.coordinate.longitude];
    return usersGeoLocation;
}

-(CLLocationDistance) distanceBetweenTwoLocations:(CLLocation*)firstLocation andSecondLocation:(CLLocation*)secondLocation
{
    return [firstLocation distanceFromLocation:secondLocation];
}


@end
