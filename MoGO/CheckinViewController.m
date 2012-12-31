//
//  CheckinViewController.m
//  MoGO
//
//  Created by DW on 24.12.12.
//
//

#import "CheckinViewController.h"
#import "ApiClient.h"
#import "DoctorModel.h"
#import "LocationServices.h"

#define NO_DOCTOR_FOUND  @"NO"
#define MAX_DISTANCE_TO_PRACTICE  6.0

CLLocation *usersGeoLocation;
NSString *practiceOwner;
LocationServices *locationService;


@interface CheckinViewController ()
@property (nonatomic) DoctorModel *chosenDoctor;
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSMutableArray *doctorsForDiscipline;
@end

@implementation CheckinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        usersGeoLocation = [[CLLocation alloc] init];
        practiceOwner = @"NO";
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.allDoctors = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    //TODO: Unproper use of NSLocalizedString because project isn't localized yet. Fix when changed.
    //(Replace first line with actual key then)
    [self.checkinButton setTitle:NSLocalizedString(@"Anmeldung druchführen", @"Anmeldung durchführen") forState:UIControlStateNormal];
    //init Location Manager
    
    //DB THINGIES
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response)
     {
                                    for (id doctorJson in response)
                                    {
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                        [self.allDoctors addObject:doctorModel];
                                    }//asked for every doctor from DB
                                    locationService = [[LocationServices alloc] initWithRunningLocationService];
                                    [self checkForDoctorInRange];
         
                                    if([practiceOwner isEqualToString:NO_DOCTOR_FOUND])
                                    {
                                        [self.practiceLabel setText:@"Kein Arzt in der Nähe"];
                                         self.checkinButton.enabled = NO;
                                    }//no doctor around
                                    else
                                    {
                                        [self.practiceLabel setText:practiceOwner];
                                    }
        }//success
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    UIAlertView *errorOccurred = [[UIAlertView alloc] initWithTitle:error
                                                                                               message:@"Das tut uns leid, versuchen Sie es erneut"
                                                                                               delegate:nil
                                                                                               cancelButtonTitle:@"Ok"
                                                                                               otherButtonTitles:nil, nil];
                                    [errorOccurred show];
                                }];
    
}

- (void) checkForDoctorInRange
{
    for(DoctorModel* doc in self.allDoctors)
    {
        usersGeoLocation = [locationService getUsersCurrentLocation];
        CLLocation *docLocation = [locationService generateLocation:[doc.address.latitude floatValue]
                                                          longitude:[doc.address.longitude floatValue]];
        double distanceInMeters = [locationService distanceBetweenTwoLocations:docLocation andSecondLocation:usersGeoLocation];
        
        if(distanceInMeters < MAX_DISTANCE_TO_PRACTICE)
        {
            practiceOwner = doc.fullName;
            break;
        }
        else
        {
            practiceOwner = @"NO";
        }

    }//queue
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDescriptionField:nil];
    [self setActualDoctorLabel:nil];
    [self setPracticeLabel:nil];
    [self setCheckinButton:nil];
    [super viewDidUnload];
}


- (IBAction)checkinPressed:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Bei %@ angemeldet", practiceOwner];
    UIAlertView *checkinConfirmed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ckeck-In erfolgreich", @"Check-In erfolgreich") message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [checkinConfirmed show];
    
}
@end
