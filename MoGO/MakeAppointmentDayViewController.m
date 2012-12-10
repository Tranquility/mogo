//
//  MakeAppointmentDayViewController.m
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import "MakeAppointmentDayViewController.h"
#import "slotView.h"

@interface MakeAppointmentDayViewController ()

@end

@implementation MakeAppointmentDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.currentDay = startDay;
        self.currentMonth = startMonth;
        self.currentYear = startYear;
        self.slotsView.bounds=CGRectMake(0,0,320, 500);
    }
    //
    //Loop through the whole day:
    //TODO: This needs to be connected to the slot-Datastructure
    for (int i=0; i<5; i++) {
        
        //Split the whole Canvas to tiles
        CGRect r = CGRectMake(0,0, 320,100);
        
        //Draw Slot to Day-View (by adding a sub-view)
        [self.slotsView addSubview:[[slotView alloc] initWithFrame:r].mainView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
