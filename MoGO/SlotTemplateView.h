//
//  SlotTemplateView.h
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import <UIKit/UIKit.h>

@interface SlotTemplateView : UIView

@property (nonatomic) IBOutlet UIView* mainView;
@property (nonatomic) IBOutlet UILabel* appointmentLabel;



- (id)initWithFrame:(CGRect)frame andStartTime:(NSString*)startTime andEndTime:(NSString*)endTime;



@end
