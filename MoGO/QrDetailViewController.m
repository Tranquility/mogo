//
//  QrDetailViewController.m
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import "QrDetailViewController.h"

@interface QrDetailViewController ()

@end

@implementation QrDetailViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    
    [self.view addGestureRecognizer:tap];
	if (self.sender == Referral) {
        self.topicLabel.text = NSLocalizedString(@"QR Code Ihrer Überweisung", @"QR_REFERRAL");
        self.detailLabel.text = NSLocalizedString(@"zur Vorlage beim Arzt", @"SHOW_MEDIC");
    } else if (self.sender == Prescription) {
        self.topicLabel.text = NSLocalizedString(@"QR Code Ihres Rezepts", @"QR_REFERRAL");
        self.detailLabel.text = NSLocalizedString(@"zur Vorlage bei der Apotheke", @"SHOW_PHARMACY");
    }
    
    self.qrcodeView.image = self.qrcode;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
