//
//  SocketClient.h
//  DoctorApplication
//
//  Created by Ole Reifschneider on 27.01.13.
//  Copyright (c) 2013 uni-hh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@interface SocketClient : NSObject

+ (SocketIO *)sharedInstanceWithDelegate:(id<SocketIODelegate>)delegate;

@end
