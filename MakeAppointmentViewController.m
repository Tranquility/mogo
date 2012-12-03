//
//  MakeAppointmentViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "MakeAppointmentViewController.h"
#import "MonthTemplateView.h"
#import "MonthTemplateOverviewView.h"

@interface MakeAppointmentViewController ()
@property (nonatomic,strong) MonthTemplateOverviewView *month1;
@property (nonatomic,strong) MonthTemplateOverviewView *month2;

@end

@implementation MakeAppointmentViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // CGRect r = CGRectMake(0,0,320,364);
       // self.month1 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:12 andWithYear:2012];
        
       // [self.calendarScrollView addSubview:self.month1.mainView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.month1 = [[MonthTemplateOverviewView alloc] initWithFrame:CGRectMake(0, 0,320, 283)];
    //self.month2 = [[MonthTemplateOverviewView alloc] initWithFrame:CGRectMake(320, 0,320, 283)];
    CGRect r = CGRectMake(0,0,320,364);
    self.month1 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:12 andWithYear:2012];
    //[_calendarScrollView addSubview:_month2];
    self.calendarScrollView.contentSize = CGSizeMake(320, 364);
    [self.calendarScrollView addSubview:self.month1.mainView];

    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
