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
    self.locationManager.delegate = self;
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
    return self.usersGeoLocation;
}

-(CLLocationDistance) distanceBetweenTwoLocations:(CLLocation*)firstLocation andSecondLocation:(CLLocation*)secondLocation
{
    return [firstLocation distanceFromLocation:secondLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Fehler: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"Fehler", @"Fehler") message:NSLocalizedString(@"Position konnte nicht bestimmt werden. Probieren Sie es erneut", @"Position konnte nicht bestimmt werden. Probieren Sie es erneut") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;    
    if (currentLocation != nil)
    {
        self.usersGeoLocation = currentLocation;
    }

}


@end
