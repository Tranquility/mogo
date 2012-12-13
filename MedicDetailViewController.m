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
    
    [self drawMapWithCoordinate:*(doctorAddress.coordinate) andString:name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [self setMapOutlet:nil];
    [self setFavoritButton:nil];
    [super viewDidUnload];
}

-(void)drawMapWithCoordinate:(CLLocationCoordinate2D)location andString:(NSString*)doctorName
{
    double miles = 5.0;
    double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location;
    
    [self.mapOutlet setRegion:region animated:YES];
    
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:doctorName andCoordinate:location];
	[self.mapOutlet addAnnotation:newAnnotation];
    
}

//Action für FavoritButton
-(IBAction)doFavorit:(id)favorit {
    
    //Bilder Setzen
    UIImage *btnImageGelb = [UIImage imageNamed:@"sternGelb.jpg"];
    UIImage *btnImageNormal = [UIImage imageNamed:@"sternNormal.jpg"];
    
    //Bilder  den States hinzufügen
    [self.favoritButton setImage:btnImageGelb forState:UIControlStateSelected];
    [self.favoritButton setImage:btnImageNormal forState:UIControlStateNormal];
    
    //Auswählen zwischen selected und normal
    if (self.favoritButton.selected) {
        
        //Arzt entfernen
        [self.favoritButton setSelected:NO];
        UIAlertView *remove = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Entfernt", @"remove") message:NSLocalizedString(@"Arzt aus den Favoriten entfernt", @"arzt entfernen") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [remove show];
        
    }
    else {
        
        //Arzt hinzufügen
        [self.favoritButton setSelected:YES];
        UIAlertView *add = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hinzugefügt", @"added") message:NSLocalizedString(@"Arzt zu den Favoriten hinzugefügt", @"arzt hinzugefügt") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [add show];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"docDetailToMakeAppointment"]) {
        MakeAppointmentViewController *destination = [segue destinationViewController];
        destination.doctor = self.doctor;
    }
}



@end
