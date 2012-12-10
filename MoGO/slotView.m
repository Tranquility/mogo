//
//  slotView.m
//  MoGO
//
//  Created by 0eisenbl on 10.12.12.
//
//

#import "slotView.h"

@implementation slotView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
     [[NSBundle mainBundle] loadNibNamed:@"slotView" owner:self options:nil];
    
    
    if (self) {
        self.clipsToBounds = NO;
        self.mainView.frame = self.bounds;
        
        self.mainView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];

        NSLog(@"yes");
    }
    [self addSubview:self.mainView];
    
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
