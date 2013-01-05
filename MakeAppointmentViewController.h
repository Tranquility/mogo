//
//  MakeAppointmentViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"
#import "MoGO/Observer.h"

@interface MakeAppointmentViewController : UIViewController <Observer>

@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic) IBOutlet UIScrollView *calendarScrollView;
@property (nonatomic) IBOutlet UILabel *monthLabel;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIButton *buttonRight;

@property (nonatomic) DoctorModel *doctor;

@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;

- (IBAction)moveCalendarViewtoLeft:(id)sender;
- (IBAction)moveCalendarViewtoRight:(id)sender;
- (void)showDay:(int)sender;
- (void)saveNewAppointment:(id)sender;

@end
