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

@synthesize doctorLabel = _doctorLabel;
@synthesize disciplineLabel = _disciplineLabel;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
@synthesize noteTextView = _noteTextView;
@synthesize changeButton = _changeButton;
@synthesize cancelButton = _cancelButton;


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
