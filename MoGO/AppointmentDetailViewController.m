//
//  AppointmentDetailViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentDetailViewController.h"
#import "ApiClient.h"
#import "MakeAppointmentViewController.h"
#import "UserCalendarManipulator.h"
@interface AppointmentDetailViewController ()

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
    
    NSString *doctorString = self.appointment.doctor.fullName;
    
    NSString *message = [NSString stringWithFormat:@"Wollen Sie den Termin bei %@ absagen?", doctorString];
    
    UIAlertView *cancelAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                                 message:NSLocalizedString(message, @"CANCEL_APPOINTMENT")
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                       otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    
    [cancelAppointment show];
    
}

- (IBAction)changeButton:(id)sender {
    self.selectedAction = CHANGE;
    
    NSString *doctorString = self.appointment.doctor.fullName;
    
    NSString *message = [NSString stringWithFormat:@"Wollen Sie den Termin bei %@ verschieben?", doctorString];
    
    UIAlertView *rescheduleAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                                message:NSLocalizedString(message, @"RESCHEDULE_APPOINTMENT")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                      otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    
    [rescheduleAppointment show];
}

#pragma mark UIAlertViewDelegage methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.selectedAction == CANCEL) {
        if (buttonIndex == 1) {
            [self cancelAppointment];
        }
    } else if (self.selectedAction == CHANGE) {
        if (buttonIndex == 1) {
            [self changeAppointment];
        }
    }
}

#pragma mark Private helper methods

- (void)cancelAppointment {    
    NSString *path = [NSString stringWithFormat:@"appointments/%d.json", self.appointment.idNumber];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Sage Termin ab", @"CANCEL_APPOINTMENT")];
    
    [[ApiClient sharedInstance] deletePath:path
                                parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde abgesagt", @"APPOINTMENT_CANCELED")];
                                    UserCalendarManipulator *calendarManipulator = [[UserCalendarManipulator alloc] init];
                                    [calendarManipulator deleteCalendarAppointment:self.appointment.date];
                                    
                                    [self performSelector:@selector(popToParentController) withObject:nil afterDelay:1.5];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                }];
}

- (void)changeAppointment {
    MakeAppointmentViewController *makeAppointment = [self.storyboard instantiateViewControllerWithIdentifier:@"MakeAppointmentViewController"];
    
    makeAppointment.doctor = self.appointment.doctor;
    makeAppointment.selectedAction = self.selectedAction;
    makeAppointment.idNumber = self.appointment.idNumber;
    makeAppointment.timeStamp = self.appointment.date;
    
    [self.navigationController pushViewController:makeAppointment animated:YES];
}

- (void)popToParentController {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
