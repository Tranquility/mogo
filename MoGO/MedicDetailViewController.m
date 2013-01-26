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
#import "CredentialStore.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserDefaultConstants.h"

@interface MedicDetailViewController ()
@property (nonatomic) CredentialStore *credentialStore;
@end

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
    UIImage *btnImageYellow = [UIImage imageNamed:@"sternGelb.png"];
    UIImage *btnImageNormal = [UIImage imageNamed:@"sternNormal.png"];
    
    //Set up Buttons depending on States
    [self.favouriteButton setImage:btnImageYellow forState:UIControlStateSelected];
    [self.favouriteButton setImage:btnImageNormal forState:UIControlStateNormal];
    
    //Path to the favourite Doctors file
    NSString *myPath = [self saveFilePath];
    
    //Set up Favourite-List depending on whether there exists a file or not
	if ([[NSFileManager defaultManager] fileExistsAtPath:myPath])
	{
        self.favouriteDoctors = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
	}
    else
    {
        self.favouriteDoctors = [[NSMutableArray alloc] init];
    }
    
    //get the doctorID as a String
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    //Check if the current doctor is in Favourite-List
    if ([self.favouriteDoctors containsObject:idNumber])
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
	NSString *name = [self.doctor fullName];
    
    //Create and format doctors address
    AddressModel *doctorAddress = self.doctor.address;
    NSString *address = [NSString stringWithFormat:@"%@ %d\n%@ %@", doctorAddress.street, doctorAddress.streetNumber, doctorAddress.zipCode, doctorAddress.city];
    
    //Set up fields
    self.nameField.text = name;
    self.typeField.text = self.doctor.discipline;
    self.addressField.text = address;
    
    CLLocationCoordinate2D location;
    location.latitude = [doctorAddress.latitude floatValue];
    location.longitude = [doctorAddress.longitude floatValue];
    [self drawMapWithCoordinate:location andString:name];
    [self.mapOutlet setMapType:MKMapTypeStandard];
    
    self.credentialStore = [[CredentialStore alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {

    [self setMapOutlet:nil];
    [self setFavouriteButton:nil];
    [self setAppointmentItem:nil];
    [super viewDidUnload];
}

-(void)drawMapWithCoordinate:(CLLocationCoordinate2D)location andString:(NSString*)doctorName
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, 500, 500);
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
        [self.favouriteDoctors removeObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.favouriteDoctors toFile: self.saveFilePath];
        //Show no notification
        //        UIAlertView *removeNotification = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Entfernt", @"REMOVED")
        //                                                                     message:NSLocalizedString(@"Arzt aus den Favoriten entfernt", @"REMOVE_DOCTOR_FROM_FAV")
        //                                                                    delegate:nil cancelButtonTitle:@"Ok"
        //                                                           otherButtonTitles:nil];
        //        [removeNotification show];
        
    }
    else {
        //Otherwise it is currently not selected. Set Btn selected and add Doctor to Favourite-List
        
        //add doctor and switch the Buttons status
        [self.favouriteButton setSelected:YES];
        [self.favouriteDoctors addObject:idNumber];
        [NSKeyedArchiver archiveRootObject: self.favouriteDoctors toFile: self.saveFilePath];
        //Show no notification
        //        UIAlertView *addNotification = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hinzugefügt", @"ADDED")
        //                                                                  message:NSLocalizedString(@"Arzt zu den Favoriten hinzugefügt", @"ADD_DOCTOR_TO_FAV")
        //                                                                 delegate:nil cancelButtonTitle:@"Ok"
        //                                                        otherButtonTitles:nil];
        //        [addNotification show];
    }

}

//Called whenever the user taps the map
- (IBAction)mapClicked:(id)sender
{
    CLLocationCoordinate2D location;
    location.latitude = [self.doctor.address.latitude floatValue];
    location.longitude = [self.doctor.address.longitude floatValue];
    
    [self openMapsAppWithDestination:location];
    
}

- (void)openMapsAppWithDestination:(CLLocationCoordinate2D)destination
{
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil]];
        toLocation.name = self.doctor.fullName;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    else //iOS 5 or lower
    {
        NSMutableString *url = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
        [url appendFormat:@"saddr=Current Location"];
        [url appendFormat:@"&daddr=%f,%f", destination.latitude, destination.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}
//Method which initiates a call to the doctor when invoked
- (IBAction)initiateCall:(id)sender
{
    NSString *callURL = [NSString stringWithFormat:@"tel://%@",self.doctor.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
    NSLog(@"Initiating a call using the url: %@", callURL);
    //included NSLog due to the fact the iOS simulator doesn't allow to test methods requiering the phone (intended by apple)
    //nslog included so one can see something on the simulator. 
}
//Method to Send Email from Iphone
- (IBAction)sendEmail:(id)sender
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@""];
     NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", self.doctor.mail], nil];
    [mailer setToRecipients:toRecipients];
    NSString *emailBody = [NSString stringWithFormat:@"Guten Tag %@", self.doctor.fullName];
    [mailer setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:mailer animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"docDetailToMakeAppointment"]) {
        MakeAppointmentViewController *destination = [segue destinationViewController];
        destination.doctor = self.doctor;
    }
}

-(IBAction)appointmentClicked:(id)sender
{
    
    if ([self.credentialStore isLoggedIn]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults boolForKey:UD_USER_DATA_COMPLETE])
        {
            [self performSegueWithIdentifier:@"docDetailToMakeAppointment" sender:self];
        }
        else{
            UIAlertView *redirect = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profil nicht ausreichend ausgefüllt", @"UNCOMPLETE_PROFILE")
                                                             message:NSLocalizedString(@"Möchten Sie zu den Einstellungen weitergeleitet werden?", @"REDIRECT_SETTINGS")
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                   otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
            
            [redirect show];
        }

        
    } else {
        UIAlertView *login = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nur mit Anmeldung Möglich", @"ONLY_LOGGEDIN")
                                                         message:NSLocalizedString(@"Möchten Sie zur Anmeldung weitergeleitet werden?", @"REDIRECT_LOGIN")
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                               otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
        
        [login show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqualToString:NSLocalizedString(@"Profil nicht ausreichend ausgefüllt", @"UNCOMPLETE_PROFILE")])
    {
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"ToSettings" sender:self];
        }
    }
    else{
        if (buttonIndex == 1) {
            [self performSegueWithIdentifier:@"ToLogin" sender:self];
        }
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
