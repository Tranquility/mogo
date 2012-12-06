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
    //[self.calendarScrollView setFrame:CGRectMake(0, 0, 4*320, 334)];
    self.calendarScrollView.contentSize = CGSizeMake(4*320, 334);

    self.currentOffset = 0;
    
    //Initialize the calendar elements with month and year
    //TODO: this needs to be non-static, by starting with the current month
    int startMonth = 12;
    int startYear = 2012;
    for(int i=0;i<4;i++)
    {
        //Size of one Calendar
        CGRect r = CGRectMake(i*320,0,320,334);
        self.month1 = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:startMonth andWithYear:startYear andwithParentVC:self];
        
        //nächster Monat
        startMonth++;
        if(startMonth==13)
        {
            startMonth=01;
            startYear++;
        }
        [self.calendarScrollView addSubview:self.month1.mainView];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) moveCalendarViewtoLeft{
    if(self.currentOffset!=0)
    {
        self.currentOffset = self.currentOffset -320;
        //[self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0)];
    }
}

-(void) moveCalendarViewtoRight{
    self.currentOffset = self.currentOffset + 320;
    if(self.currentOffset >1280)
    {
        self.currentOffset = 1280;
    }
    //[self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0)];
}


@end
