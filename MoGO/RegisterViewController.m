//
//  LoginViewController.m
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import "RegisterViewController.h"
#import "MailManipulator.h"
#define PASSWORD_MIN_SIZE 5

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HIGHT = 216;
static const CGFloat LANDSCPE_KEYBOARD_HIGHT = 140;


@interface RegisterViewController ()


@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Registrieren"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMailAdressField:nil];
    [self setPasswordField:nil];
    [self setPasswordConfirmField:nil];
    [self setAgeField:nil];
    [super viewDidUnload];
}
- (IBAction)registerButtonPressed:(id)sender {
    if([self isInputValid]) //+check for unique mail adress with server
    {
        NSLog(@"Wir sind in isInputValid if");
        //send data to server, wait for confirm
        //send confirmation mail
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Anmeldung erfolgreich"
                                                          message:@"Bestätigungsmail wird versendet. Sie können sich nun einloggen"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
         [message show];
        //pushviewzuLogIn
    }
    else
    {
        MailManipulator* mailChecker = [[MailManipulator alloc] init];
        
        NSLog(@"Wir sind in isInputValid else");
        NSString* error = @"";
        if(![self passwordsEqual])
            error = @"Die Passwörter müssen identisch sein";
        else if(![self passwordLengthValid])
            error = @"Ein Passwort muss aus mindestens sechs Zeichen bestehen";
        else if(![self isEveryFieldFilled])
            error = @"Jedes Feld muss gefüllt sein";
        else if(![mailChecker isMailFormatValid:_mailAdressField.text])
            error = @"E-Mail-Adressformat ist fehlerhaft";
        else
            error = @"Ein unbekannter Fehler ist aufgetreten";
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:error
                                                          message:@"Bitte versuchen Sie es erneut"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
         [message show];
        
        
    }
    NSLog(@"Wir sind am Ende");
    
}

-(BOOL)passwordsEqual
{
    return [_passwordField.text isEqualToString:_passwordConfirmField.text];
}

-(BOOL)passwordLengthValid
{
    return [_passwordField.text length] > PASSWORD_MIN_SIZE;
}

-(BOOL)isEveryFieldFilled
{
    return ([_mailAdressField.text length] > 0) && ([_passwordField.text length] > 0) && ([_ageField.text length] > 0);
}

-(BOOL)isInputValid
{
    MailManipulator* mailChecker = [[MailManipulator alloc] init];
    return [self passwordsEqual] && [self passwordLengthValid] && [self isEveryFieldFilled] && [mailChecker isMailFormatValid:_mailAdressField.text];
}

// Text field specific functions below

-(BOOL)textFieldShouldReturn:(UITextField *) theTextField
{
    [theTextField   resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midLine = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midLine - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCPE_KEYBOARD_HIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}



@end
