//
//  LoginViewController.m
//  MoGO
//
//  Created by DW on 05.12.12.
//
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "ApiClient.h"
#import "CredentialStore.h"

@interface LoginViewController ()
    @property (nonatomic) CredentialStore *credentialStore;
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
    self.navigationItem.hidesBackButton = YES;
    self.credentialStore = [[CredentialStore alloc] init];
    
    if ([self.credentialStore isLoggedIn]) {
        NSLog(@"User is already Logged in");
    } else {
        NSLog(@"User is not Logged in");
    }
    
    [self setTitle:@"Login"];
    
    //Adding a tap recognizer to react on tap events on the screen
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    
//    Later: Check if already logged in
//    TODO: Improve sequirity
    
//    NSUserDefaults *saveLogin = [NSUserDefaults standardUserDefaults];
//    NSString* registeredMail = [saveLogin stringForKey:@"currentUserMail"];
//    if(registeredMail.length > 1)
//    {
//        [self.navigationController pushViewController:[[ViewController alloc]init]
//                                             animated:YES];
//        NSLog(@"WIR SIND IM VIEWDIDLOAD IF");
//    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)loginButtonPressed:(id)sender {
    //generate querry to server
    id params = @{
    @"email": self.mailAdressField.text,
    @"password": self.passwordField.text
    };
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Einloggen", @"LOGIN")];

    [[ApiClient sharedInstance] postPath:@"/tokens.json"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSString *authToken = [responseObject objectForKey:@"token"];
                                       [self.credentialStore setAuthToken:authToken];
                                       
                                       [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login erfolgreich", @"LOGIN_SUCCESSFUL")];
                                       [[self navigationController] popToRootViewControllerAnimated:YES];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                      
                                       if([[error domain] isEqualToString:@"AFNetworkingErrorDomain"] && ([error code]==-1011))
                                       {
                                           [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Logindaten nicht korrekt", @"CONNECTION_FAIL")];
                                       }
                                       else
                                       {
                                           [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                       }
                                       
                                   }];
    
//    if (YES) //change with server confirms account
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login erfolgreich", @"LOGIN_SUCCESSFULL")
//                                                          message:NSLocalizedString(@"Viel Spaß bei der Nutzung von MoGO", @"ENJOY_MOGO")
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        
//        NSUserDefaults *saveLogin = [NSUserDefaults standardUserDefaults];
//        [saveLogin setObject:userMail forKey:@"currentUserMail"];
//        [message show];
//        //TODO: Push to right controller if login worked
//        
//    }
//    else
//    {
//        //ask server for fail reason (mail unknown? password wrong? give more detailed feedback)
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login gescheitert", @"LOGIN_FAILED")
//                                                          message:NSLocalizedString(@"Dies kann verschiedene Gründe haben", @"FAIL_REASONS")
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        
//        [message show];
//        
//    }
}


-(BOOL)textFieldShouldReturn:(UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}


@end
