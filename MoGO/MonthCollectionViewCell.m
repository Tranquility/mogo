//
//  MonthCollectionViewCell.m
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import "MonthCollectionViewCell.h"

@implementation MonthCollectionViewCell


@synthesize cellLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (BOOL)setText:(NSString *)labelText {
    if (cellLabel!= nil && labelText.length > 0) {
        cellLabel.text = labelText;
        return YES;
    }
    return NO;
}

@end
