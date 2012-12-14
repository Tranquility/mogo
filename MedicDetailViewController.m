//
//  MedicDetailViewController.m
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import "MedicDetailViewController.h"
#import "MakeAppointmentViewController.h"
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
    
    //Set up images
    UIImage *btnImageYellow = [UIImage imageNamed:@"sternGelb.jpg"];
    UIImage *btnImageNormal = [UIImage imageNamed:@"sternNormal.jpg"];
    
    //Set up Buttons depending on States
    [self.favouriteButton setImage:btnImageYellow forState:UIControlStateSelected];
    [self.favouriteButton setImage:btnImageNormal forState:UIControlStateNormal];
    
    //Path to the favourite Doctors file
    NSString *myPath = [self saveFilePath];
    
    //Set up Favourite-List depending on whether there exists a file or not
	if ([[NSFileManager defaultManager] fileExistsAtPath:myPath])
	{
        self.docFavList = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
	}
    else
    {
        self.docFavList = [[NSMutableArray alloc] init];
    }
    
    //get the doctorID as a String
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    //Check if the current doctor is in Favourite-List
    if ([self.docFavList containsObject:idNumber])
    {
        [self.favouriteButton setSelected:YES];
    }
    else
    {
        [self.favouriteButton setSelected:NO];
    }
    
    //Load super View
    [super viewDidLoad];
    
    //Create and format Doctors name
	NSString *name = [NSString stringWithFormat:@"%@ %@ %@", self.doctor.title, self.doctor.firstName, self.doctor.lastName];
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Create and format doctors address
    AddressModel *doctorAddress = self.doctor.address;
    NSString *address = [NSString stringWithFormat:@"%@ %d\n%@ %@", doctorAddress.street, doctorAddress.streetNumber, doctorAddress.zipCode, doctorAddress.city];
    
    //Set up fields
    self.nameField.text = name;
    self.typeField.text = self.doctor.discipline;
    self.addressField.text = address;
    self.phoneField.text = self.doctor.telephone;
    
    [self drawMapWithCoordinate:*doctorAddress.coordinate andString:name];
    [self.mapOutlet setMapType:MKMapTypeStandard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [self setMapOutlet:nil];
    [self setFavouriteButton:nil];
    [super viewDidUnload];
}

-(void)drawMapWithCoordinate:(CLLocationCoordinate2D)location andString:(NSString*)doctorName
{
    //double miles = 5.0;
    //double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
    
    //MKCoordinateSpan span;
    
    //span.latitudeDelta = miles/69.0;
    //span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    //MKCoordinateRegion region;
    //region.span = span;
    //region.center = location;
    
    //This can be done easier:
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, 50, 50);
    

    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:doctorName andCoordinate:location];
	[self.mapOutlet addAnnotation:newAnnotation];
    
    [self.mapOutlet setRegion:region animated:YES];
    
}

//This Action will be called when the favourite Button is pressed
-(IBAction)setFavourite:(id)favourite {
    
    //Get the doctor number as NSString
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    //is the Button selected? Then the user wants to de-favourite the doctor
    if (self.favouriteButton.selected) {
        
        //remove Doctor and switch buttons select status
        [self.favouriteButton setSelected:NO];
        [self.docFavList removeObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.docFavList toFile: self.saveFilePath];
        //Show a notification
        UIAlertView *removeNotification = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Entfernt", @"remove") message:NSLocalizedString(@"Arzt aus den Favoriten entfernt", @"arzt entfernen") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [removeNotification show];
        
    }
    else {
        //Otherwise it is currently not selected. Set Btn selected and add Doctor to Favourite-List
        
        //add doctor and switch the Buttons status
        [self.favouriteButton setSelected:YES];
        [self.docFavList addObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.docFavList toFile: self.saveFilePath];
        //Show a notification
        UIAlertView *addNotification = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hinzugefügt", @"added") message:NSLocalizedString(@"Arzt zu den Favoriten hinzugefügt", @"arzt hinzugefügt") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [addNotification show];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"docDetailToMakeAppointment"]) {
        MakeAppointmentViewController *destination = [segue destinationViewController];
        destination.doctor = self.doctor;
    }
}

//Creates the FilePath for the Favourite-List
- (NSString *) saveFilePath
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}

@end
