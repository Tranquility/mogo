//
//  ApiClient.m
//  MoGO
//
//  Created by Ole Reifschneider on 29.11.12.
//
//

#import "ApiClient.h"

#define APIBaseURLString @"http://mogo.ole-reifschneider.de/"


@implementation ApiClient

+ (id)sharedInstance {
    static ApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[ApiClient alloc] initWithBaseURL:
                            [NSURL URLWithString:APIBaseURLString]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}


@end
