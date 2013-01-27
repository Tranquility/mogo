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
@interface SocketClient ()


@end

@implementation SocketClient

static SocketIO *sharedInstance = nil;

+ (SocketIO *)sharedInstanceWithDelegate:(id<SocketIODelegate>)delegate {
    if (sharedInstance == nil) {
        sharedInstance = [[SocketIO alloc] initWithDelegate:delegate];
    };
    
    return sharedInstance;
}

@end
