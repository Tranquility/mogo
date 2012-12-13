

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (MapViewAnnotation*)initWithTitle:(NSString*)title andCoordinate:(CLLocationCoordinate2D)coordinate;

@end