//
//  DaySlotView.h
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import <UIKit/UIKit.h>
#import "MakeAppointmentDayViewController.h"

@interface DaySlotView : UIView

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UIView* slotView;
@property (nonatomic) MakeAppointmentDayViewController* myParentVC;

- (id)initWithFrame:(CGRect)frame day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year appointments:(NSArray*)appointments parent:(MakeAppointmentDayViewController*)parentViewController;


@end
