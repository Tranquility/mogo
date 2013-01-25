//
//  WaitingRoomViewController.m
//  MoGO
//
//  Created by Ole Reifschneider on 23.01.13.
//
//

#import "WaitingRoomViewController.h"

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
    NSLog(@"start");
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:SOCKET onPort:SOCKET_PORT];
    [socketIO sendEvent:@"adduser" withData:@"iphone"];
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

@end
