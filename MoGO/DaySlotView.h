//
//  DaySlotView.h
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import <UIKit/UIKit.h>
#import "DaySlotView.h"
#import "MakeAppointmentViewController.h"

@interface DaySlotView : UIView

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UIView* slotView;
@property (nonatomic) MakeAppointmentViewController* myParentVC;

- (id)initWithFrame:(CGRect)frame andDay:(int)startDay andMonth:(int)startMonth andYear:(int)startYear andParentVC:(MakeAppointmentViewController*)myParentVC;


@end
