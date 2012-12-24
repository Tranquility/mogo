//
//  CheckinViewController.m
//  MoGO
//
//  Created by DW on 24.12.12.
//
//

#import "CheckinViewController.h"

IBOutlet CLLocationManager *locationManager;

@interface CheckinViewController ()
@end

@implementation CheckinViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //TODO: Unproper use of NSLocalizedString because project isn't localized yet. Fix when changed.
    //(Replace first line with actual key then)
    [self.checkinButton setTitle:NSLocalizedString(@"Anmeldung druchführen", @"Anmeldung durchführen") forState:UIControlStateNormal];
    NSString *usersLocation = [NSString stringWithFormat:@"lat: %f long: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
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

-(void) getUsersCurrentPosition {


}

- (IBAction)checkinPressed:(id)sender {
}
@end
