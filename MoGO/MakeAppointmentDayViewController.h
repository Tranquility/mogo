//
//  MakeAppointmentDayViewController.h
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import <UIKit/UIKit.h>
#import "MakeAppointmentViewController.h"
#import "DoctorModel.h"

@interface MakeAppointmentDayViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIButton *buttonRight;
@property (nonatomic) IBOutlet UILabel *dayLabel;
@property (nonatomic) IBOutlet UIScrollView *slotsView;

@property (nonatomic) Observer* observer;
@property (nonatomic) DoctorModel *doctor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year  observer:(Observer*)observer otherAvailableDays:(NSArray*)otherDays;

- (IBAction)showNextDay:(id)sender;
- (IBAction)showPreviousDay:(id)sender;

@end
