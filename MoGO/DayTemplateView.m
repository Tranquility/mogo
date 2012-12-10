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

- (id)initWithFrame:(CGRect)frame andWithStatus:(NSInteger)status andWithDay:(NSInteger)day andWithResponder:myParentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Load the nib-File and set this object as owner
        [[NSBundle mainBundle] loadNibNamed:@"DayTemplateView" owner:self options:nil];
        
        //Depending on what status this day has, set the color accordingly
        if (status == 0) //Day disabled; Will not be shown at all
        {
            self.dayLabel.text=@"";
            self.dayLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:1.0];
        }
        else if(status==1) //Day not available (no appointment slots available)
        {
            //Appointment SLot available at this day, set color accordingly
            self.dayLabel.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            self.dayLabel.text = [NSString stringWithFormat:@"%d",day];
        }
        else
        {
            //Appointment SLot available at this day, set color accordingly
            self.dayLabel.backgroundColor = [UIColor colorWithRed:133.0 green:255.0 blue:133.0 alpha:100.0];
            self.dayLabel.text = [NSString stringWithFormat:@"%d",day];
        }
        
        //Add this view to the mainView, which will later be added to the Calendar-View
        self.clipsToBounds = NO;
        self.mainView.frame = self.bounds;
        self.tag = day;
        [self addSubview:self.mainView];
        self.myParentVC = myParentVC;
        
    }
    return self;
}

- (void)showDay {
    
    [self.myParentVC showDay:0];
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
