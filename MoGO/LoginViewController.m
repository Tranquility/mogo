//
//  LoginViewController.m
//  MoGO
//
//  Created by DW on 04.12.12.
//
//

#import "LoginViewController.h"
#import "MailManipulator.h"
#define PASSWORD_MIN_SIZE 5

@interface LoginViewController ()

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
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


-(BOOL)textFieldShouldReturn:(UITextField *) theTextField
{
    [theTextField   resignFirstResponder];
    return YES;
}



@end
