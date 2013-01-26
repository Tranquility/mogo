//
//  DrugDetailViewController.m
//  MoGO
//
//  Created by 0leschen on 06.12.12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "DrugDetailViewController.h"
#import "QrDetailViewController.h"

@interface DrugDetailViewController ()

@end

@implementation DrugDetailViewController

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
    NSString *date = [dateFormatter stringFromDate:self.prescription.creationDate];
    
    self.medication.text = self.prescription.medication;
    self.doctor.text = [self.prescription.doctor fullName];
    self.date.text = date;
    self.note.text = [self.prescription.note isKindOfClass:[NSNull class]] ? @"" : self.prescription.note;
    if (self.prescription.fee) {
        self.fee.text = NSLocalizedString(@"gebührenpflichtig", @"CHARGEABLE");
    }
    
    [self.qrButton setImage:self.prescription.qrCode forState:UIControlStateNormal];
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
    destination.qrcode = self.prescription.qrCode;
    destination.sender = Prescription;
}

@end
