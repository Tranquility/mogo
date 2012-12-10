//
//  MedicDetailViewController.m
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import "MedicDetailViewController.h"
#import "MapViewAnnotation.h"
#import "AddressModel.h"

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
    
	NSString *name = [NSString stringWithFormat:@"%@ %@ %@", self.doctor.title, self.doctor.firstName, self.doctor.lastName];
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    AddressModel *doctorAddress = self.doctor.address;
    NSString *address = [NSString stringWithFormat:@"%@ %d\n%@ %@", doctorAddress.street, doctorAddress.streetNumber, doctorAddress.zipCode, doctorAddress.city];
    
    self.nameField.text = name;
    self.typeField.text = self.doctor.discipline;
    self.addressField.text = address;
    self.phoneField.text = self.doctor.telephone;
    
    [self drawMapWithCoordinate:*(doctorAddress.coordinate) andString:@"Dr. No"];
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

-(void)drawMapWithCoordinate:(CLLocationCoordinate2D)location andString:(NSString*)doctorName
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 0.5*ZOOMFACTOR, 0.5*ZOOMFACTOR);
    MKCoordinateRegion adjustedRegion = [self.mapOutlet regionThatFits:viewRegion];
    [self.mapOutlet setRegion:adjustedRegion animated:YES];
    
//    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:doctorName andCoordinate:location];
//	[self.mapOutlet addAnnotation:newAnnotation];
    
}

@end
