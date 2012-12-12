//
//  MakeAppointmentDayViewController.m
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import "MakeAppointmentDayViewController.h"
#import "DaySlotView.h"

@interface MakeAppointmentDayViewController() 
@end

@implementation MakeAppointmentDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear andParentVC:(MakeAppointmentViewController*)myParentVC
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.myParentVC = myParentVC;
        self.currentDay = startDay;
        self.currentMonth = startMonth;
        self.currentYear = startYear;
    }
        
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set ContentSitze as needed
    //TODO: This could be done better by calculating the height as heightOfOneSlot*numberOfSLots
    self.slotsView.contentSize = CGSizeMake(320, 500);

    //Size of one SlotView
    //Again: this could be set as heightOfOneSlot*numberOfSLots instead of fixed 500px
    CGRect r = CGRectMake(0,0,320,500);
        
    //Create Slot View with the given day/month/year
    self.day = [[DaySlotView alloc] initWithFrame:r andDay:self.currentDay andMonth:self.currentMonth andYear:self.currentYear andParentVC:self.myParentVC];
    
    //Add Slot View as a subview 
    [self.slotsView addSubview:self.day.slotView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Switches the slotsView to the next day that has available slots open
-(void)showNextDay:(id)sender
{
    //Size of one SlotView
    CGRect r = CGRectMake(0,0,320,500);
    
    //TODO: Connect this to the dataSource and search for the next day
    //      that has available slots. Then set self.day,self.month,self.year to the new values
    
    //Create Slot View with the given day/month/year
    self.day = [[DaySlotView alloc] initWithFrame:r andDay:self.currentDay andMonth:self.currentMonth andYear:self.currentYear andParentVC:self.myParentVC];
    
    //Add Slot View as a subview
    [self.slotsView addSubview:self.day];

}


//Switches the slotsView to the previous day that has available slots open
-(void)showPreviousDay:(id)sender
{
    //Size of one SlotView
    CGRect r = CGRectMake(0,0,320,500);
    
    //TODO: Connect this to the dataSource and search for the previous day
    //      that has available slots. Then set self.day,self.month,self.year to the new values
    
    //Create Slot View with the given day/month/year
    self.day = [[DaySlotView alloc] initWithFrame:r andDay:self.currentDay andMonth:self.currentMonth andYear:self.currentYear andParentVC:self.myParentVC];
    
    //Add Slot View as a subview
    [self.slotsView addSubview:self.day.slotView];
    
}

@end
