//
//  ReferralDetailViewController.m
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "ReferralDetailViewController.h"
#import "QrDetailViewController.h"

#define RUBY_DATE @"dd.MM.yyyy"

@interface ReferralDetailViewController ()

@end

@implementation ReferralDetailViewController

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
    self.targetLabel.text = self.referral.target;
    self.reasonLabel.text = self.referral.reasonString;
    self.fromDoctorLabel.text = [self.referral.doctor fullName];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = RUBY_DATE;
    self.dateLabel.text = [formatter stringFromDate:self.referral.creationDate];
    self.diagnosisTextView.text = self.referral.diagnosesSoFar;
    self.taskTextView.text = self.referral.task;
    
    [self.qrButton setImage:self.referral.qrcode forState:UIControlStateNormal];
    self.qrButton.layer.borderWidth = 1.4;
    self.qrButton.layer.cornerRadius = 3;
    self.qrButton.layer.borderColor = [UIColor grayColor].CGColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QrDetailViewController *destination = [segue destinationViewController];
    destination.qrcode = self.referral.qrcode;
    destination.sender = Referral;
}

@end
