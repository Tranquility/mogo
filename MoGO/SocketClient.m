//
//  SocketClient.m
//  DoctorApplication
//
//  Created by Ole Reifschneider on 27.01.13.
//  Copyright (c) 2013 uni-hh. All rights reserved.
//

#import "SocketClient.h"

#define SOCKET @"ole-reifschneider.de"
#define SOCKET_PORT 8000

@implementation SocketClient


+ (SocketIO *)sharedInstanceWithDelegate:(id<SocketIODelegate>)delegate {
    static SocketIO *sharedInstance = nil;

    if (sharedInstance == nil) {
        sharedInstance = [[SocketIO alloc] initWithDelegate:delegate];
        [sharedInstance connectToHost:SOCKET onPort:SOCKET_PORT];
        [sharedInstance sendEvent:@"adduser" withData:@"iphone"];
    };
    
    return sharedInstance;
}

@end
