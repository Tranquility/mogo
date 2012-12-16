//
//  CredentialStore.h
//  MoGO
//
//  Created by Ole Reifschneider on 15.12.12.
//
//

#import <Foundation/Foundation.h>

@interface CredentialStore : NSObject

- (BOOL)isLoggedIn;
- (void)clearSavedCredentials;
- (NSString*)authToken;
- (void)setAuthToken:(NSString*)authToken;

@end
