//
//  CheckinViewController.m
//  MoGO
//
//  Created by DW on 24.12.12.
//
//

#import "AppDelegate.h"
#import "CheckinViewController.h"
#import "ApiClient.h"
#import "DoctorModel.h"

#define NO_DOCTOR_FOUND  @"NO"
#define MAX_DISTANCE_TO_OFFICE_IN_METERS  25.0



@interface CheckinViewController ()

@property (nonatomic) DoctorModel *chosenDoctor;
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSMutableArray *doctorsForDiscipline;
@property (nonatomic) CLLocation *usersGeoLocation;
@property (nonatomic) NSString *officeOwner;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;

@end

@implementation CheckinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.location = [[CLLocation alloc] init];
        self.officeOwner = @"NO";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.checkinButton.enabled = NO;
    [self.locationManager startUpdatingLocation];
    
    [self checkLocationForCurrentAppointment];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:NSLocalizedString(@"Fehler beim Laden Ihres Standorts", @"FAIL_LOADING_LOCATION")
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        [self.locationManager stopUpdatingLocation];
        self.location = currentLocation;
    }
}

#pragma mark Private helper methods

- (void)checkLocationForCurrentAppointment {
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Überprüfe Standort", @"CHECK_LOCATION")];
    
    [[ApiClient sharedInstance] getPath:@"appointments.json?now=true"
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    if (((NSArray*) response).count> 0) {
                                        for (NSDictionary *dict in response) {
                                            NSDictionary *subDict = [dict valueForKey:@"doctor"];
                                            DoctorModel *doctor = [[DoctorModel alloc] initWithDictionary:subDict];
                                            if ([self isDoctorInRange:doctor]) {
                                                self.officeOwner = doctor.fullName;
                                                self.doctorLabel.text = doctor.fullName;
                                                self.checkinMsgLabel.hidden = NO;
                                                self.checkinButton.enabled = YES;
                                            }
                                        }
                                        
                                        if (!self.checkinButton.enabled) {
                                            NSString *message = NSLocalizedString(@"Kein Arzt in Ihrer Nähe", @"NO_MEDIC_IN_RANGE");
                                            self.doctorLabel.text = message;
                                        }
                                    } else {
                                        NSString *message = NSLocalizedString(@"Sie haben zur Zeit keinen Termin", @"NO_APPOINTMENT_CURRENTLY");
                                        self.doctorLabel.text = message;
                                    }
                                    [SVProgressHUD dismiss ];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDescriptionField:nil];
    [self setDoctorLabel:nil];
    [self setCheckinButton:nil];
    [super viewDidUnload];
}

- (BOOL)isDoctorInRange:(DoctorModel*)doctor {
    
    CLLocationDegrees latitude = [doctor.address.latitude floatValue];
    CLLocationDegrees longitude = [doctor.address.longitude floatValue];
    CLLocation *doctorLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    double distanceInMeters = [self.location distanceFromLocation:doctorLocation];
    
    return distanceInMeters < MAX_DISTANCE_TO_OFFICE_IN_METERS;
}

-(void)popToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)checkinPressed:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Bei %@ angemeldet", self.officeOwner];
    UIAlertView *checkinConfirmed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ckeck-In erfolgreich", @"CHECKIN_SUCCESSFUL")
                                                               message:message
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
    [checkinConfirmed show];
    
}
@end
