//
//  LoginViewController.m
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import "RegisterViewController.h"
#import "MailManipulator.h"
#import "ApiClient.h"
#import "CredentialStore.h"

#define PASSWORD_MIN_SIZE 6

//constant vars for scrolling if user changes from textfield to next textfield
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HIGHT = 215;
static const CGFloat LANDSCPE_KEYBOARD_HIGHT = 140;


@interface RegisterViewController ()
@property (nonatomic) CredentialStore *credentialStore;

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
    
    //Adding a tap recognizer to react on tap events on the screen
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.credentialStore = [[CredentialStore alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)registerButtonPressed:(id)sender {
    if([self isInputValid])
    {
        id params = @{
        @"patient": @{
        @"email": self.mailAddressField.text,
        @"password": self.passwordField.text,
        @"password_confirmation": self.passwordField.text
        }
        };
        
        //Perform Registration
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Lege Account an", @"REGISTER_ACCOUNT")];
        [[ApiClient sharedInstance] postPath:@"/patients.json"
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Account angelegt! Sie werden angemeldet...", @"PATIENT_CREATED")];
                                         
                                         //Wait for 3 seconds and then perform login
                                         NSDate *future = [NSDate dateWithTimeIntervalSinceNow:3];
                                         [NSThread sleepUntilDate:future];
                                         
                                         //Login Query starts here
                                         id loginParams = @{
                                         @"email": self.mailAddressField.text,
                                         @"password": self.passwordField.text
                                         };
                                         
                                         [[ApiClient sharedInstance] postPath:@"/tokens.json"
                                                                   parameters:loginParams
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                          NSString *authToken = [responseObject objectForKey:@"token"];
                                                                          [self.credentialStore setAuthToken:authToken];
                                                                          
                                                                          [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login erfolgreich", @"LOGIN_SUCCESSFUL")];
                                                                         
                                                                          //Wait for 2 seconds
                                                                          NSDate *future = [NSDate dateWithTimeIntervalSinceNow:2];
                                                                          [NSThread sleepUntilDate:future];
                                                                          
                                                                          [[self navigationController] popToRootViewControllerAnimated:YES];
                                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                                          
                                                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          
                                                                          //If there is an error, show appropriate message and wait 2 seconds, then redirect to login view
                                                                          if([[error domain] isEqualToString:@"AFNetworkingErrorDomain"] && ([error code]==-1011))
                                                                          {
                                                                              [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Logindaten nicht korrekt", @"CONNECTION_FAIL")];
                                                                              NSDate *future = [NSDate dateWithTimeIntervalSinceNow:2];
                                                                              [NSThread sleepUntilDate:future];
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }
                                                                          else
                                                                          {
                                                                              [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                                                              NSDate *future = [NSDate dateWithTimeIntervalSinceNow:2];
                                                                              [NSThread sleepUntilDate:future];
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }
                                                                          
                                                                      }];

                                         
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"%@", error);
                                         [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_ERROR")];
                                     }];
        
    }
    else
    {
        MailManipulator* mailChecker = [[MailManipulator alloc] init];
        NSString* error;
        if(![self arePasswordsEqual])
            error = NSLocalizedString(@"Die Passwörter müssen identisch sein", @"PWD_NOT_IDENTICAL");
        else if(![self isPasswordLengthValid])
            error = NSLocalizedString(@"Ein Passwort muss aus mindestens sechs Zeichen bestehen", @"PWD_TOO_SHOORT");
        else if(![self isEveryFieldFilled])
            error = NSLocalizedString(@"Jedes Feld muss gefüllt sein", @"FILL_ALL_FIELDS");
        else if(![mailChecker isMailFormatValid:self.mailAddressField.text])
            error = NSLocalizedString(@"E-Mail-Adressformat ist fehlerhaft", @"EMAIL_INVALID");
        else
            error = NSLocalizedString(@"Ein unbekannter Fehler ist aufgetreten", @"UNKNOWN_ERROR");
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:error
                                                          message:NSLocalizedString(@"Bitte versuchen Sie es erneut", @"TRY_AGAIN")
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        
    }
    
}

-(BOOL) arePasswordsEqual
{
    return [self.passwordField.text isEqualToString:self.passwordConfirmField.text];
}

-(BOOL) isPasswordLengthValid
{
    return [self.passwordField.text length] >= PASSWORD_MIN_SIZE;
}

-(BOOL) isEveryFieldFilled
{
    return (self.mailAddressField.text.length > 0) && (self.passwordField.text.length > 0);
}

-(BOOL) isInputValid
{
    MailManipulator* mailChecker = [[MailManipulator alloc] init];
    return [self arePasswordsEqual] && [self isPasswordLengthValid] && [self isEveryFieldFilled] && [mailChecker isMailFormatValid:self.mailAddressField.text];
}

// Text field specific functions below

-(BOOL)textFieldShouldReturn:(UITextField *) theTextField
{
    [theTextField   resignFirstResponder];
    return YES;
}

//scroll down after tabbing from textfield to next textfield below
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

//Scroll up after leaving textField if necessarry
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

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}



@end
