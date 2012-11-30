//
//  MonthTemplateOverviewView.m
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import "MonthTemplateOverviewView.h"

@implementation MonthTemplateOverviewView
@synthesize mainView = _mainView;
@synthesize buttonLeft = _buttonLeft;
@synthesize buttonRight = _buttonRight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MonthTemplateOverviewView" owner:self options:nil];
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
