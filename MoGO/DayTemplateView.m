//
//  DayTemplateView.m
//  MoGO
//
//  Created by 0eisenbl on 03.12.12.
//
//

#import "DayTemplateView.h"

@implementation DayTemplateView

- (id)initWithFrame:(CGRect)frame andWithStatus:(NSInteger)status andWithDay:(NSInteger)day
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"DayTemplateView" owner:self options:nil];
        
        
        if (status == 0)
        {
            self.day.text=@"";
        }
        else
        {
            self.day.backgroundColor = UIColor.greenColor;
            self.day.text = [NSString stringWithFormat:@"%d",day];        }
        
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
