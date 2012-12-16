//
//  ApiClient.m
//  MoGO
//
//  Created by Ole Reifschneider on 29.11.12.
//
//

#import "ApiClient.h"
#import "CredentialStore.h"

#define APIBaseURLString @"mogo.ole-reifschneider.de"


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
        [self setAuthTokenHeader];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tokenChanged:)
                                                     name:@"token-changed"
                                                   object:nil];
    }
    
    return self;
}

- (void)setAuthTokenHeader {
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    [self setAuthorizationHeaderWithToken:authToken];
}

- (void)tokenChanged:(NSNotification *)notification {
    [self setAuthTokenHeader];
}


@end
