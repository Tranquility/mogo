//
//  MonthTemplateView.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "MonthTemplateView.h"

@implementation MonthTemplateView

@synthesize mainView = _mainView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MonthTemplateView" owner:self options:nil];
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];
        self.backgroundColor = UIColor.redColor;
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
