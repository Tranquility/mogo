//
//  DayTemplateView.h
//  MoGO
//
//  Created by 0eisenbl on 03.12.12.
//
//

#import <UIKit/UIKit.h>
#import "MakeAppointmentViewController.h"

@interface DayTemplateView : UIControl

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UILabel *dayLabel;
@property (nonatomic) MakeAppointmentViewController *myParentVC;
-(IBAction) showDay: (id) sender;


- (id)initWithFrame:(CGRect)frame andWithStatus:(NSInteger)status andWithDay:(NSInteger)day andWithResponder:myParentVC;

@end
