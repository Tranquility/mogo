//
//  DayTemplateView.m
//  MoGO
//
//  This represents a single Calendar-Day view
//
//  Created by 0eisenbl on 03.12.12.
//
//

#import "DayTemplateView.h"

@implementation DayTemplateView

- (id)initWithFrame:(CGRect)frame state:(State)state day:(NSInteger)day observer:(id<Observer>)observer;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.day = day;
        self.myState = state;
        self.observer = observer;
        
        //Load the nib-File and set this object as owner
        [[NSBundle mainBundle] loadNibNamed:@"DayTemplateView" owner:self options:nil];
        
        //Not a valid day
        if (state == HIDDEN)
        {
            self.dayLabel.text=@"";
            self.dayLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:1.0];
        }
        else if (state == FULLY_BOOKED) //Day not available (no appointment slots available)
        {
            //Appointments not available at this day, set color accordingly
            self.dayLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            self.dayLabel.text = [NSString stringWithFormat:@"%d",day];
        }
        else if (state == FREE_SLOTS)
        {
            //Appointments available at this day, set color accordingly
            //self.dayLabel.backgroundColor = [UIColor colorWithRed:22.0 green:139.0 blue:22.0 alpha:1.0];
            self.dayLabel.text = [NSString stringWithFormat:@"%d",day];
        }
        
        //Add this view to the mainView, which will later be added to the Calendar-View
        self.clipsToBounds = NO;
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];
    }
    return self;
}

- (void)showDay:(id)sender {
    if (self.myState == FREE_SLOTS) {
        [self.observer notifyFromSender:dayTemplate withValue:[NSNumber numberWithInt:self.day]];
    }
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
