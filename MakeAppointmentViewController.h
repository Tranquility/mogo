//
//  MakeAppointmentViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>

@interface MakeAppointmentViewController : UIViewController

@property (nonatomic,strong) IBOutlet UILabel *doctorLabel;
@property (nonatomic,strong) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic,strong) IBOutlet UIScrollView *calendarScrollView;
@property (nonatomic,strong) IBOutlet UILabel *monthLabel;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic,strong) IBOutlet UIButton *buttonLeft;
@property (nonatomic,strong) IBOutlet UIButton *buttonRight;

-(void) moveCalendarViewtoLeft;
-(void) moveCalendarViewtoRight;
-(void)setTitleToMonth:(int)currentMonth andYear:(int)currentYear;
-(void)showDay:(int)sender;
-(void)saveNewAppointment:(id)sender;

@end
