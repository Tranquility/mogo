//
//  MakeAppointmentViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "MakeAppointmentViewController.h"
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
    self.currentMonth = 12;
    self.currentYear = 2012;
    [self setTitleToMonth:self.currentMonth  andYear:self.currentYear];
   
    //Set Listener on Buttons
    [self.buttonLeft addTarget:self action:@selector(moveCalendarViewtoLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonRight addTarget:self action:@selector(moveCalendarViewtoRight) forControlEvents:UIControlEventTouchUpInside];
    
    //helper variable
    int initMonth = self.currentMonth;
    int initYear = self.currentYear;
    for(int i=0;i<4;i++)
    {
        //Size of one Calendar
        CGRect r = CGRectMake(i * 320, 0, 320, 334);
        
        //Create calendarmonth ViewController
        self.month = [[MonthTemplateOverviewView alloc] initWithFrame:r andWithMonth:initMonth andWithYear:initYear andwithParentVC:self];
        
        //Add Calendar View as a subview to the scrollview and tell the buttons which function to call when they are pressed
        [self.calendarScrollView addSubview:self.month.mainView];
               
        //next month
        initMonth++;
        if(initMonth==13)
        {
            initMonth=01;
            initYear++;
        }
        
    }

}
-(BOOL)canBecomeFirstResponder{return YES;}

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
        //previous month
        self.currentMonth-=1;
        if(self.currentMonth==0)
        {
            self.currentMonth=12;
            self.currentYear-=1;
        }
    }
    [self setTitleToMonth:self.currentMonth andYear:self.currentYear];

}

//Moves the calendarScrollView to the next month
-(void) moveCalendarViewtoRight{
    self.currentOffset = self.currentOffset + 320;
    if(self.currentOffset > 960)
    {
        self.currentOffset = 960;
        
    }
    else{
        //next month
        self.currentMonth+=1;
        if(self.currentMonth==13)
        {
            self.currentMonth=1;
            self.currentYear+=1;
        }
    }
    [self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0) animated:YES];
    [self setTitleToMonth:self.currentMonth andYear:self.currentYear];
}

//Sets the CalendarTitle for a specific date
-(void)setTitleToMonth:(int)currentMonth andYear:(int)currentYear
{
    // Set the Title
    NSMutableString *title = [NSMutableString stringWithFormat:@"%d", currentMonth];
    [title appendString:[NSString stringWithFormat:@" / %d",currentYear]];
    self.monthLabel.text = title;
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    
    [self showDay:touch.view.tag];
    NSLog(@"CLICKED");
}

-(void)showDay:(int)day
{
    self.monthLabel.text = @"CLICKED";
}


@end
