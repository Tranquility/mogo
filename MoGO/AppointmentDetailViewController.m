//
//  AppointmentDetailViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentDetailViewController.h"
#import "ApiClient.h"
#import "SVProgressHUD.h"

@interface AppointmentDetailViewController ()

typedef enum {
    CANCEL,
    CHANGE
} Action;

@property (nonatomic) Action selectedAction;

@end

@implementation AppointmentDetailViewController

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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"dd.MM.yyyy", @"DAY_FORMAT")];
    NSString *date = [dateFormatter stringFromDate:self.appointment.date];
    
    [dateFormatter setDateFormat:NSLocalizedString(@"HH:mm", @"TIME_FORMAT")];
    NSString *time = [dateFormatter stringFromDate:self.appointment.date];
    
    self.doctorLabel.text = [self.appointment.doctor fullName];
    self.disciplineLabel.text = self.appointment.doctor.discipline;
    self.dateLabel.text = date;
    self.timeLabel.text = time;
    self.noteTextView.text = self.appointment.note;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {
    self.selectedAction = CANCEL;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"'am' dd.MM.yyyy 'um' HH:mm 'Uhr'";
    NSString *dateString = [formatter stringFromDate:self.appointment.date];
    NSString *doctorString = self.appointment.doctor.fullName;
    
    NSString *message = [NSString stringWithFormat:@"Wollen Sie den Termin %@ bei %@ absagen?", dateString, doctorString];
    
    UIAlertView *confirmAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                                 message:NSLocalizedString(message, @"CANCEL_APPOINTMENT")
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                       otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    
    [confirmAppointment show];
    
}

- (IBAction)changeButton:(id)sender {
    self.selectedAction = CHANGE;
}

#pragma mark UIAlertViewDelegage methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.selectedAction == CANCEL) {
        if (buttonIndex == 1) {
            [self cancelAppointment];
        }
    } else if (self.selectedAction == CHANGE) {
        if (buttonIndex) {
            // change appointment
        }
    }
}

#pragma mark Private helper methods

- (void)cancelAppointment {
    [SVProgressHUD show];
    
    NSString *path = [NSString stringWithFormat:@"appointments/%d.json", self.appointment.idNumber];
    
    [[ApiClient sharedInstance] deletePath:path
                                parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    [SVProgressHUD dismiss];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD dismiss];
                                    NSLog(@"Error fetching Disciplines!");
                                    NSLog(@"%@", error);
                                    
                                }];
}

@end
