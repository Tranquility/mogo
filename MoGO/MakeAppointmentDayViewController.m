//
//  MakeAppointmentDayViewController.m
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import "MakeAppointmentDayViewController.h"

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
        
        
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch *touch = [touches anyObject];
    
    //[self showDay:touch.view.tag];
    NSLog(@"CLICKED");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
