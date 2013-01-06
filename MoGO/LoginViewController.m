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
    
    self.credentialStore = [[CredentialStore alloc] init];
    
    if ([self.credentialStore isLoggedIn]) {
        NSLog(@"User is already Logged in");
    } else {
        NSLog(@"User is not Logged in");
    }
    
    [self setTitle:@"LogIn"];
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
    
    [SVProgressHUD show];

    [[ApiClient sharedInstance] postPath:@"/tokens.json"
                                parameters:params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSString *authToken = [responseObject objectForKey:@"token"];
                                       [self.credentialStore setAuthToken:authToken];
                                       
                                       [SVProgressHUD dismiss];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       if (operation.response.statusCode == 500) {
                                           NSLog(@"Unknown Error");
                                       } else {
                                           NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                           NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                options:0
                                                                                                  error:nil];
                                           NSString *errorMessage = [json objectForKey:@"error"];
                                           NSLog(@"%@",errorMessage);
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


@end
