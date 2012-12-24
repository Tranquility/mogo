//
//  DrugDetailViewController.m
//  MoGO
//
//  Created by 0leschen on 06.12.12.
//
//

#import "DrugDetailViewController.h"

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
    self.note.text = self.prescription.note;
    self.qrcode.image = self.prescription.qrCode;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
