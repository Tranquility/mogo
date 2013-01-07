//
//  ProfileEditViewController.h
//  MoGO
//
//  Created by 0leschen on 07.01.13.
//
//

#import <UIKit/UIKit.h>

@interface ProfileEditViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *sureName;
@property (weak, nonatomic) IBOutlet UILabel *birthDate;
@property (weak, nonatomic) IBOutlet UILabel *insurenceLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) NSMutableArray *insurence;

@end
