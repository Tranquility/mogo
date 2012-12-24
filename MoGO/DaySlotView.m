//
//  DaySlotView.m
//  MoGO
//
//  Created by 0eisenbl on 12.12.12.
//
//

#import "DaySlotView.h"
#import "SlotTemplateView.h"

@implementation DaySlotView

- (id)initWithFrame:(CGRect)frame day:(int)day month:(int)month year:(int)year appointments:(NSArray*)appointments parent:(MakeAppointmentDayViewController*)parentViewController;
{
    self = [super initWithFrame:frame];
    [[NSBundle mainBundle] loadNibNamed:@"DaySlotView" owner:self options:nil];
 
    if (self) {
        self.myParentVC = parentViewController;
        self.mainView.frame = frame;
        
        NSInteger counter = 0;
        
        for (Time *time in appointments) {
            CGRect r = CGRectMake(0, counter * 50, 320, 49);
            SlotTemplateView *slot = [[SlotTemplateView alloc] initWithFrame:r startTime:time parent:self.myParentVC.myParentVC];
            [self.slotView addSubview:slot];
            
            counter++;
        }
        
        self.myParentVC.slotsView.contentSize = CGSizeMake(320, counter * 50);
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
