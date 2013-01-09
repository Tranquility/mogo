//
//  MakeAppointmentViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"
#import "Observer.h"

@interface MakeAppointmentViewController : UIViewController <Observer>

typedef enum {
    CANCEL,
    CHANGE,
    NEW
} Action;

@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic) IBOutlet UIScrollView *calendarScrollView;
@property (nonatomic) IBOutlet UILabel *monthLabel;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIButton *buttonRight;

@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) Action selectedAction;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic) NSInteger idNumber;

@property (nonatomic) NSMutableArray *favouriteDoctors;

- (IBAction)moveCalendarViewtoLeft:(id)sender;
- (IBAction)moveCalendarViewtoRight:(id)sender;
- (void)showDay:(int)sender;
- (void)saveNewAppointment:(id)sender;

@end
