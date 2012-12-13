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

@synthesize favoritButton;

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
    
    AddressModel *doctorAddress = self.doctor.address;
    NSString *address = [NSString stringWithFormat:@"%@ %d\n%@ %@", doctorAddress.street, doctorAddress.streetNumber, doctorAddress.zipCode, doctorAddress.city];
    
    self.nameField.text = name;
    self.typeField.text = @"Frauenarzt";
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
    [self setFavoritButton:nil];
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

//Action für FavoritButton
-(IBAction)doFavorit:(id)favorit {
    
    //Bilder Setzen
    UIImage *btnImageGelb = [UIImage imageNamed:@"sternGelb.jpg"];
    UIImage *btnImageNormal = [UIImage imageNamed:@"sternNormal.jpg"];
    
    //Bilder  den States hinzufügen
    [favoritButton setImage:btnImageGelb forState:UIControlStateSelected];
    [favoritButton setImage:btnImageNormal forState:UIControlStateNormal];
    
    //Auswählen zwischen selected und normal
    if (favoritButton.selected) {
        
        //Arzt entfernen
        [favoritButton setSelected:NO];
        UIAlertView *remove = [[UIAlertView alloc] initWithTitle:@"Entfernt" message:@"Arzt aus den Favoriten entfernt" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [remove show];
        
    }
    else {
        
        //Arzt hinzufügen
        [favoritButton setSelected:YES];
        UIAlertView *add = [[UIAlertView alloc] initWithTitle:@"Hinzugefügt" message:@"Arzt zu den Favoriten hinzugefügt" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [add show];
    }

}



@end