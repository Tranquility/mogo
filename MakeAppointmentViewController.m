//
//  MakeAppointmentViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "MakeAppointmentViewController.h"
#import "MonthTemplateView.h"

@interface MakeAppointmentViewController ()
@property (nonatomic,strong) MonthTemplateView *month1;
@property (nonatomic,strong) MonthTemplateView *month2;

@end

@implementation MakeAppointmentViewController


@synthesize calendarScrollView = _calendarScrollView;
@synthesize month1 = _month1;
@synthesize month2 = _month2;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _month1 = [[MonthTemplateView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [_calendarScrollView addSubview:_month1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.month1 = [[MonthTemplateView alloc] initWithFrame:CGRectMake(0, 0,320, 283)];
    self.month2 = [[MonthTemplateView alloc] initWithFrame:CGRectMake(320, 0,320, 283)];

    [_calendarScrollView addSubview:_month1];
    [_calendarScrollView addSubview:_month2];
    self.calendarScrollView.contentSize = CGSizeMake(640, 283);
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
