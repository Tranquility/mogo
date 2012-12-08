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
@property (nonatomic) IBOutlet UIView *kalView;
@property (nonatomic) MakeAppointmentViewController *myParentVC;

- (id)initWithFrame:(CGRect)frame andWithMonth:(NSInteger)currentMonth andWithYear:(NSInteger)currentYear andwithParentVC:(MakeAppointmentViewController*)myParentVC;
-(void)informParentVC:(NSInteger)day;
@end
