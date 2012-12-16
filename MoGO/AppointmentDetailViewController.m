//
//  AppointmentDetailViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "AppointmentDetailViewController.h"

@interface AppointmentDetailViewController ()

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

@end
