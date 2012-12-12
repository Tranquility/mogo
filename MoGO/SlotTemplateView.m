//
//  SlotTemplateView.m
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import "SlotTemplateView.h"

@implementation SlotTemplateView

- (id)initWithFrame:(CGRect)frame andStartTime:(NSString*)startTime andEndTime:(NSString*)endTime;
{
    self = [super initWithFrame:frame];
    if (self) {
            
        //Load the nib-File and set this object as owner
        [[NSBundle mainBundle] loadNibNamed:@"SlotTemplateView" owner:self options:nil];
        
        NSMutableString* appointmentText = [NSMutableString stringWithFormat:@""];
        [appointmentText appendString:startTime];
        [appointmentText appendString:@" bis "];
        [appointmentText appendString:endTime];
        
        self.appointmentLabel.text = appointmentText;
        //Add this view to the mainView, which will later be added to the Calendar-View
        self.clipsToBounds = NO;
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
