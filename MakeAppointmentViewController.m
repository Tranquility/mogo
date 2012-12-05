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

//Right now we hold 4 calendar-months at once
//TODO: this could be changed to a list, enabling better switches of months 
@property (nonatomic,strong) MonthTemplateOverviewView *month1;
@property (nonatomic,strong) MonthTemplateOverviewView *month2;
@property (nonatomic,strong) MonthTemplateOverviewView *month3;
@property (nonatomic,strong) MonthTemplateOverviewView *month4;

@end

@implementation MakeAppointmentViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Size of one Calendar
    CGRect r = CGRectMake(0,0,320,364);
    
    //Initialize the calendar elements with month and year
    //TODO: this needs to be non-static, by starting with the current month and the 3 following
    self.month1 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:12 andWithYear:2012];
    self.month2 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:01 andWithYear:2013];
    self.month3 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:02 andWithYear:2013];
    self.month4 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:03 andWithYear:2013];

    
    //Set ScrollView width to 4*Size of a calendar. height=height of one calendar
    self.calendarScrollView.contentSize = CGSizeMake(4*320, 364);
    
    //add all calendards to the scrollview
    [self.calendarScrollView addSubview:self.month1.mainView];
    [self.calendarScrollView addSubview:self.month2.mainView];
    [self.calendarScrollView addSubview:self.month3.mainView];
    [self.calendarScrollView addSubview:self.month4.mainView];
        
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
