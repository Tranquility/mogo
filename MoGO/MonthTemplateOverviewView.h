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
@property (nonatomic) IBOutlet UIButton *buttonRight;
@property (nonatomic) IBOutlet UIButton *buttonLeft;
@property (nonatomic) IBOutlet UIView *kalView;
@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) MakeAppointmentViewController *myParentVC;

- (id)initWithFrame:(CGRect)frame andWithMonth:(NSInteger)currentMonth andWithYear:(NSInteger)currentYear andwithParentVC:(MakeAppointmentViewController*)myParentVC;
- (void) pressScrollButton: (id) sender;


@end
