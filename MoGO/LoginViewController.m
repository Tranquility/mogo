//
//  LoginViewController.m
//  MoGO
//
//  Created by DW on 05.12.12.
//
//

#import "LoginViewController.h"
#import "ViewController.h"

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
    [self setTitle:@"LogIn"];
	// Do any additional setup after loading the view.
    
    //Later: Check if already logged in
    //TODO: Improve sequirity
    /*NSUserDefaults *saveLogin = [NSUserDefaults standardUserDefaults];
    NSString* registeredMail = [saveLogin stringForKey:@"currentUserMail"];
    if([registeredMail length] > 1)
    {
        [self.navigationController pushViewController:[[ViewController alloc]init]
                                             animated:YES];
        NSLog(@"WIR SIND IM VIEWDIDLOAD IF");
    }*/
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMailAdressField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}
- (IBAction)loginButtonPressed:(id)sender {
    //generate querry to server
    NSString *userMail, *userPassword = @"";
    userMail = self.mailAdressField.text;
    userPassword = self.passwordField.text;
    //send querry, wait for response, then do
    if(TRUE) //change with server confirms account
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login erfolgreich"
                                                          message:@"Viel Spaß bei der Nutzung von MoGo"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        NSUserDefaults *saveLogin = [NSUserDefaults standardUserDefaults];
        [saveLogin setObject:userMail forKey:@"currentUserMail"];
        [message show];
        //TODO: Push to right controller if login worked
        
    }
    else
    {
        //ask server for fail reason (mail unknown? password wrong? give more detailed feedback)
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login gescheitert"
                                                          message:@"DER GRUND FÜRS SCHEITERN"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *) theTextField
{
    [theTextField   resignFirstResponder];
    return YES;
}


@end
