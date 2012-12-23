//
//  SlotTemplateView.h
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import <UIKit/UIKit.h>
#import "MakeAppointmentViewController.h"
#import "Time.h"

@interface SlotTemplateView : UIControl

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UILabel* appointmentLabel;
@property (nonatomic) MakeAppointmentViewController* myParentVC;

@property (nonatomic) NSString* startString;
@property (nonatomic) NSString* endString;


- (id)initWithFrame:(CGRect)frame startTime:(Time*)time parent:(MakeAppointmentViewController*)parentVC;

- (IBAction)saveNewAppointment:(id)sender;


@end
