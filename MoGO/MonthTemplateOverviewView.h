//
//  MonthTemplateOverviewView.h
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import <UIKit/UIKit.h>
#import "Observer.h"

@interface MonthTemplateOverviewView : UIView

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIView *calendarView;
@property (nonatomic) Observer *observer;

- (id)initWithFrame:(CGRect)frame month:(NSInteger)month year:(NSInteger)year observer:(Observer*)observer slots:(NSArray*)slots;
@end
