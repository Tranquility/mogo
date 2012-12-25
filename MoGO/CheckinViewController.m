//
//  CheckinViewController.m
//  MoGO
//
//  Created by DW on 24.12.12.
//
//

#import "CheckinViewController.h"

CLLocationManager *locationManager;
NSString *usersLocation;

@interface CheckinViewController ()
@end

@implementation CheckinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //TODO: Unproper use of NSLocalizedString because project isn't localized yet. Fix when changed.
    //(Replace first line with actual key then)
    [self.checkinButton setTitle:NSLocalizedString(@"Anmeldung druchführen", @"Anmeldung durchführen") forState:UIControlStateNormal];
    
    //init Location Manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

    sleep(1); //Workaround for locationManager needs some time to come up with first value
    usersLocation = [self getUsersCurrentPosition];
    [self.currentUserPosition setText:usersLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDescriptionField:nil];
    [self setActualPracticeLabel:nil];
    [self setPracticeLabel:nil];
    [self setCurrentUserPosition:nil];
    [self setCheckinButton:nil];
    [super viewDidUnload];
}

-(NSString*) getUsersCurrentPosition {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}

- (IBAction)checkinPressed:(id)sender {
    UIAlertView *checkinConfirmed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ckeck-In erfolgreich", @"Check-In erfolgreich") message:NSLocalizedString(@"Bei Dr. ermittelter Arzt angemeldet", @"Bei Dr. ermittelter Arzt angemeldet") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [checkinConfirmed show];
}
@end
