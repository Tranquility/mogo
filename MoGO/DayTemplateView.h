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

typedef enum {
    HIDDEN = 0,
    FULLY_BOOKED = 1,
    FREE_SLOTS = 2,
} State;

//Action performed whenever a day is touched
- (IBAction)showDay:(id)sender;

- (id)initWithFrame:(CGRect)frame state:(State)state day:(NSInteger)day responder:(MakeAppointmentViewController*)parentViewController;

@end
