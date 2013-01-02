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

@interface SlotTemplateView : UIControl <UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UILabel* appointmentLabel;
@property (nonatomic) Observer* observer;

- (id)initWithFrame:(CGRect)frame date:(NSDate*)date observer:(Observer*)observer;

- (IBAction)saveNewAppointment:(id)sender;


@end
