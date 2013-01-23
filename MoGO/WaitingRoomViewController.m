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

@interface WaitingRoomViewController ()

@end

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
    [socketIO sendEvent:@"sendchat" withData:@"hello"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"message: %@", packet.data);
    
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"error >>> data: %@", error);
}

@end
