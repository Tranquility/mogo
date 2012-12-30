//
//  SlotTemplateView.h
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import <UIKit/UIKit.h>
#import "Observer.h"
#import "Time.h"

@interface SlotTemplateView : UIControl

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UILabel* appointmentLabel;
@property (nonatomic) Observer* observer;

@property (nonatomic) NSString* startString;
@property (nonatomic) NSString* endString;


- (id)initWithFrame:(CGRect)frame startTime:(Time*)time observer:(Observer*)observer;

- (IBAction)saveNewAppointment:(id)sender;


@end
