//
//  WaitingRoomViewController.m
//  MoGO
//
//  Created by Ole Reifschneider on 23.01.13.
//
//

#import "WaitingRoomViewController.h"
#import "ApiClient.h"
#import "UserDefaultConstants.h"

#define SOCKET @"ole-reifschneider.de"
#define SOCKET_PORT 8000

typedef enum {
    Prescription = 0,
    Referral
} DocType;

@implementation WaitingRoomViewController

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.name = [NSString stringWithFormat: @"%@ %@", [userDefaults stringForKey:UD_USER_NAME], [userDefaults stringForKey:UD_USER_SURNAME]];
    self.userId = [userDefaults stringForKey:UD_USER_ID];
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:SOCKET onPort:SOCKET_PORT];
    [socketIO sendEvent:@"adduser" withData:self.name];
    
    
    NSString *authorization = NSLocalizedString(@"Möchten sie der Praxis ihre Patientakte freigeben?", @"AUTHORIZATION");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hinweis", @"NOTE")
                                                    message:authorization
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                          otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [socketIO disconnect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"message: %@", packet.data);
    NSDictionary *dict = packet.dataAsJSON;
    
    NSString *event = [NSString stringWithFormat:@"%@:", [dict valueForKey:@"name"]];
    SEL selector = NSSelectorFromString(event);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:dict];
    }
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"error >>> data: %@", error);
}

- (void)newDocument:(NSDictionary *)dict {
    NSArray *array = [dict valueForKeyPath:@"args"];
    DocType type = [[array objectAtIndex:1] integerValue];
    NSString *newDoc = @"";
    
    if (type == Prescription) {
        newDoc = NSLocalizedString(@"ein neues Rezept", @"NEW_PRESCRIPTION");
    } else if (type == Referral) {
        newDoc = NSLocalizedString(@"eine neue Überweisung", @"NEW_REFERRAL");
    }
   
    if (newDoc.length > 0) {
        NSString *msg = [NSString stringWithFormat:@"Sie haben %@", newDoc];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Hinweis", @"NOTE")
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark UIAlertViewDelegage methods

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        id params = @{
        @"authorization": @{
            @"doctor_id": @"21",
            @"patient_id": self.userId
            }
        };
        
        [[ApiClient sharedInstance] postPath:@"authorizations.json"
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"success");
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"failure");
                                     }];
        }
}

@end
