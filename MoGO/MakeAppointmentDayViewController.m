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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    self.slotsView.contentSize = CGSizeMake(320, 500);

    //
    //Size of one SlotView
    CGRect r = CGRectMake(0,0,320,500);
        
    //Create Slot View with the given day/month/year
    self.day = [[DaySlotView alloc] initWithFrame:r andDay:self.currentDay andMonth:self.currentMonth andYear:self.currentYear];
    
    //Add Slot View as a subview 
    [self.slotsView addSubview:self.day.slotView];



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 63;
    }
    else
    {
        return 45;
    }
}

@end
