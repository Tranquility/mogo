//
//  MedicDetailViewController.m
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import "MedicDetailViewController.h"
#import "MapViewAnnotation.h"

@implementation MedicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //Statischer Aufruf weil Test.
    [self drawMap:53.556581 andLongitute:9.990402 andString:@"Dr. Arzt"];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)drawMap:(double)withLatitude andLongitute:(double)longitude andString:(NSString*)arztname
{
    CLLocationCoordinate2D location;
	location.latitude = withLatitude;
	location.longitude = longitude;
    
        NSLog(@"%f", location.latitude);
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*ZOOMFACTOR, 0.5*ZOOMFACTOR);
    MKCoordinateRegion adjustedRegion = [_mapOutlet regionThatFits:viewRegion];
    [_mapOutlet setRegion:adjustedRegion animated:YES];
    
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:arztname andCoordinate:location];
	[self.mapOutlet addAnnotation:newAnnotation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidUnload {

    [self setMapOutlet:nil];
    [super viewDidUnload];
}
@end
