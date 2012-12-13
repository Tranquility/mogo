//
//  LoginViewController.h
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    CGFloat scrollDistance;
    CGFloat animatedDistance;
}

@property (weak, nonatomic) IBOutlet UITextField *mailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;

- (IBAction)registerButtonPressed:(id)sender;


@end
