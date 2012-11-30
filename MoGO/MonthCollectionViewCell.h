//
//  MonthCollectionViewCell.h
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
// CUSTOM CELL FÜR COLLECTION VIEW

#import <UIKit/UIKit.h>

@interface MonthCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) IBOutlet UILabel *cellLabel;

- (BOOL)setText:(NSString *)labelText;


@end
