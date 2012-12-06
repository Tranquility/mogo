//
//  DayTemplateView.h
//  MoGO
//
//  Created by 0eisenbl on 03.12.12.
//
//

#import <UIKit/UIKit.h>

@interface DayTemplateView : UIView

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UILabel *dayLabel;

- (id)initWithFrame:(CGRect)frame andWithStatus:(NSInteger)status andWithDay:(NSInteger)day;

@end
