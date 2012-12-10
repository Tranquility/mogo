//
//  MakeAppointmentDayViewController.h
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import <UIKit/UIKit.h>
#import "slotView.h"

@interface MakeAppointmentDayViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *doctorLabel;
@property (nonatomic,strong) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic,strong) IBOutlet UIButton *buttonLeft;
@property (nonatomic,strong) IBOutlet UIButton *buttonRight;
@property (nonatomic,strong) IBOutlet UILabel *dayLabel;
@property (nonatomic,strong) IBOutlet UIView *slotsView;

@property (nonatomic) slotView* slot;
@property (nonatomic) NSInteger currentDay;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear;


@end
