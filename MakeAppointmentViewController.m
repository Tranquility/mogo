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

//Variable for creating one calendar view and add it to the subvie
@property (nonatomic,strong) MonthTemplateOverviewView *month;
//The current Offset of the ScrollView (between [0...4*320]
@property NSInteger currentOffset;

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
   
    //Set ScrollView width to 4*Size of a calendar. height=height of one calendar
    self.calendarScrollView.contentSize = CGSizeMake(4 * 320, 334);

    //Current offset is 0 (actual month)
    self.currentOffset = 0;
    
    //Initialize the calendar elements with month and year
    //TODO: this needs to be non-static, by starting with the current month
    int startMonth = 12;
    int startYear = 2012;
    for(int i = 0; i < 4; i++)
    {
        //Size of one Calendar
        CGRect r = CGRectMake(i * 320, 0, 320, 334);
        
        //Create calendarmonth ViewController
        self.month = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:startMonth andWithYear:startYear andwithParentVC:self];

        //Add Calendar View as a subview to the scrollview and tell the buttons which function to call when they are pressed
        [self.calendarScrollView addSubview:self.month.mainView];
        [self.month.buttonLeft addTarget:self action:@selector(moveCalendarViewtoLeft) forControlEvents:UIControlEventTouchUpInside];
        [self.month.buttonRight addTarget:self action:@selector(moveCalendarViewtoRight) forControlEvents:UIControlEventTouchUpInside];
        
        //next month
        startMonth++;
        if(startMonth==13)
        {
            startMonth=01;
            startYear++;
        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Moves the calendarScrollView to the previous month
-(void) moveCalendarViewtoLeft{
    if(self.currentOffset!=0)
    {
        self.currentOffset = self.currentOffset - 320;
        [self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0) animated:YES];
    }
}

//Moves the calendarScrollView to the next month
-(void) moveCalendarViewtoRight{
    self.currentOffset = self.currentOffset + 320;
    if(self.currentOffset > 960)
    {
        self.currentOffset = 960;
    }
    [self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0) animated:YES];
}


@end
