//
//  LoginViewController.h
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mailAdressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
- (IBAction)registerButtonPressed:(id)sender;


@end
