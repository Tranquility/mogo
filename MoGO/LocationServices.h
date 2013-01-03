//
//  LocationServices.h
//  MoGO
//
//  Created by DW on 31.12.12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationServices : NSObject <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *usersGeoLocation;


-(LocationServices*)initWithRunningLocationService;


//Generates a location object from to given float values
-(CLLocation*) generateLocation:(double)latitude longitude:(double)longitude;


//returns the user's current position
-(CLLocation*) usersCurrentLocation;


//computes the distance between two locations in meter
-(CLLocationDistance) distanceBetweenTwoLocations:(CLLocation*)firstLocation andSecondLocation:(CLLocation*)secondLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;



@end
