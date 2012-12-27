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

CLLocationManager *locationManager;
NSString *usersLocation;
CLLocation *usersGeoLocation;
NSString *practiceOwner;


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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

    sleep(1); //Workaround for locationManager needs some time to come up with first value
    usersLocation = [self getUsersCurrentPosition];
    
    
    //DB THINGIES
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response)
     {
                                    for (id doctorJson in response) {
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                        [self.allDoctors addObject:doctorModel];
                                                                        }
                                    [self checkForDoctorInRange];
                                    if([practiceOwner isEqualToString:@"NO"])
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
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);                                    
                                }];
    
}

- (void) checkForDoctorInRange
{
    for(DoctorModel* doc in self.allDoctors)
    {
        CLLocation *docLocation = [[CLLocation alloc] initWithLatitude:[doc.address.latitude floatValue]
                                                             longitude:[doc.address.longitude floatValue]];
        CLLocationDistance meters = [usersGeoLocation distanceFromLocation:docLocation];
        
        if(meters < 6.0)
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

-(NSString*) getUsersCurrentPosition {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f",
                             locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    usersGeoLocation = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude
                                                  longitude:locationManager.location.coordinate.longitude];
    return theLocation;
}

- (IBAction)checkinPressed:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Bei %@ angemeldet", practiceOwner];
    UIAlertView *checkinConfirmed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ckeck-In erfolgreich", @"Check-In erfolgreich") message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [checkinConfirmed show];
    
}
@end
