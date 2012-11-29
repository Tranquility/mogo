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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self drawMapWithLatitude:53.556581 andLongitute:9.990402 andString:@"Dr. No"];
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

-(void)drawMapWithLatitude:(double)latitude andLongitute:(double)longitude andString:(NSString*)doctorName
{
    CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
    
    NSLog(@"%f", location.latitude);
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*ZOOMFACTOR, 0.5*ZOOMFACTOR);
    MKCoordinateRegion adjustedRegion = [_mapOutlet regionThatFits:viewRegion];
    [self.mapOutlet setRegion:adjustedRegion animated:YES];
    
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:doctorName andCoordinate:location];
	[self.mapOutlet addAnnotation:newAnnotation];
    
}

@end
