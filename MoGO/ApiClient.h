//
//  ApiClient.h
//  MoGO
//
//  Created by Ole Reifschneider on 29.11.12.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface ApiClient : AFHTTPClient

+ (id)sharedInstance;

@end
