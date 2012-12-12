//
//  MakeAppointmentDayViewController.h
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import <UIKit/UIKit.h>
#import "DaySlotView.h"

@interface MakeAppointmentDayViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *doctorLabel;
@property (nonatomic,strong) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic,strong) IBOutlet UIButton *buttonLeft;
@property (nonatomic,strong) IBOutlet UIButton *buttonRight;
@property (nonatomic,strong) IBOutlet UILabel *dayLabel;
@property (nonatomic,strong) IBOutlet UIScrollView *slotsView;

@property (nonatomic) NSInteger currentDay;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic) DaySlotView* day;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear;
-(IBAction)showNextDay:(id)sender;
-(IBAction)showPreviousDay:(id)sender;

@end
