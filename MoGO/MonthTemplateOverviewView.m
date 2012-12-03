//
//  MonthTemplateOverviewView.m
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import "MonthTemplateOverviewView.h"
#import "DayTemplateView.h"

@implementation MonthTemplateOverviewView 

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    [[NSBundle mainBundle] loadNibNamed:@"MonthTemplateOverviewView" owner:self options:nil];
    if (self) {
        //
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                CGRect r = CGRectMake(j*40, i*40, 39,39);

                [self.kalView addSubview:[[DayTemplateView alloc] initWithFrame:r andWithStatus:0 andWithDay:0]];
                                
            }
        }
       
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
