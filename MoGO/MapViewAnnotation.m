

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation


- (MapViewAnnotation*)initWithTitle:(NSString*)title andCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.title = title;
        self.coordinate = coordinate;
    }
    
    return self;
}

@end