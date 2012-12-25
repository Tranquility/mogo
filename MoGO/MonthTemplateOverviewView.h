//
//  MonthTemplateOverviewView.h
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import <UIKit/UIKit.h>
#import "MakeAppointmentViewController.h"

@interface MonthTemplateOverviewView : UIView

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIView *calendarView;
@property (nonatomic) MakeAppointmentViewController *myParentVC;

- (id)initWithFrame:(CGRect)frame month:(NSInteger)month year:(NSInteger)year parent:(MakeAppointmentViewController*)parent slots:(NSArray*)slots;
@end
