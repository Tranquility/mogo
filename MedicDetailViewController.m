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
    
    //Bilder Setzen
    UIImage *btnImageGelb = [UIImage imageNamed:@"sternGelb.jpg"];
    UIImage *btnImageNormal = [UIImage imageNamed:@"sternNormal.jpg"];
    
    //Button states setzen
    [self.favoritButton setImage:btnImageGelb forState:UIControlStateSelected];
    [self.favoritButton setImage:btnImageNormal forState:UIControlStateNormal];
    
    //Pfad
    NSString *myPath = [self saveFilePath];
    
    //wenn Liste exestiert dann ersetzen
	if ([[NSFileManager defaultManager] fileExistsAtPath:myPath])
	{
        self.docFavList = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
	}
    else
    {
        self.docFavList = [[NSMutableArray alloc] init];
    }
    
    //Id in String umwandeln
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    if ([self.docFavList containsObject:idNumber])
    {
        [self.favoritButton setSelected:YES];
    }
    else
    {
        [self.favoritButton setSelected:NO];
    }
    
    
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
    
    //Id in String umwandeln
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    //Auswählen zwischen selected und normal
    if (self.favoritButton.selected) {
        
        //Arzt entfernen
        [self.favoritButton setSelected:NO];
        [self.docFavList removeObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.docFavList toFile: self.saveFilePath];
        UIAlertView *remove = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Entfernt", @"remove") message:NSLocalizedString(@"Arzt aus den Favoriten entfernt", @"arzt entfernen") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [remove show];
        
    }
    else {
        
        //Arzt hinzufügen
        [self.favoritButton setSelected:YES];
        [self.docFavList addObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.docFavList toFile: self.saveFilePath];
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

//File erstellen zum saven
- (NSString *) saveFilePath
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}

@end
