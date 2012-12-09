//
//  LoginViewController.h
//  MoGO
//
//  Created by DW on 05.12.12.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mailAdressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)loginButtonPressed:(id)sender;

@end
