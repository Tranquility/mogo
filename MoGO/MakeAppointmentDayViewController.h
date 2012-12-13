//
//  MakeAppointmentDayViewController.h
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import <UIKit/UIKit.h>
#import "DaySlotView.h"
#import "MakeAppointmentViewController.h"
#import "DoctorModel.h"

@interface MakeAppointmentDayViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIButton *buttonRight;
@property (nonatomic) IBOutlet UILabel *dayLabel;
@property (nonatomic) IBOutlet UIScrollView *slotsView;

@property (nonatomic) MakeAppointmentViewController* myParentVC;
@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) DaySlotView* day;

@property (nonatomic) NSInteger currentDay;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear  andParentVC:(MakeAppointmentViewController*)myParentVC;

-(IBAction)showNextDay:(id)sender;
-(IBAction)showPreviousDay:(id)sender;

@end
