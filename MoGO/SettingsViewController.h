//
//  SettingsViewController.h
//  MoGO
//
//  Created by 0leschen on 14.01.13.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    CGFloat scrollDistance;
    CGFloat animatedDistance;
}

@property IBOutlet UIScrollView *scroller;

@property (weak, nonatomic) IBOutlet UILabel *birthDate;
@property (weak, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *subViewDate;
@property (weak, nonatomic) IBOutlet UITextField *firstnameText;
@property (weak, nonatomic) IBOutlet UITextField *surenameText;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeText;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *streetText;
@property (weak, nonatomic) IBOutlet UITextField *streetNr;

- (IBAction)closeDisciplinePicker:(id)sender;

- (IBAction)showDisciplinePicker:(id)sender;

- (IBAction)chooseDiscipline:(id)sender;

- (IBAction)closeDatePicker:(id)sender;

- (IBAction)showDatePicker:(id)sender;

- (IBAction)chooseDate:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)saveProfile:(id)sender;

@end
