//
//  MakeAppointmentViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"

@interface MakeAppointmentViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic) IBOutlet UIScrollView *calendarScrollView;
@property (nonatomic) IBOutlet UILabel *monthLabel;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIButton *buttonRight;

@property (nonatomic) DoctorModel *doctor;

@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;

- (void)moveCalendarViewtoLeft;
- (void)moveCalendarViewtoRight;
- (void)setTitleToMonth:(int)currentMonth andYear:(int)currentYear;
- (void)showDay:(int)sender;
- (void)saveNewAppointment:(id)sender;

@end
