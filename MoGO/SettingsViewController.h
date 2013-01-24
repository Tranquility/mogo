//
//  SettingsViewController.h
//  MoGO
//
//  Created by 0leschen on 14.01.13.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *saveToCalendarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePasswordSwitch;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *surnameField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *streetnumberField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *townField;
@property (weak, nonatomic) IBOutlet UILabel *insuranceField;


@end
