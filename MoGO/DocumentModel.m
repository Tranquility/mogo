//
//  DocumentModel.m
//  MoGO
//
//  Created by 0schleew on 06.12.12.
//
//

#import "DocumentModel.h"
#import "AFNetworking.h"
#import "ApiClient.h"

@implementation DocumentModel

- (DocumentModel*)initWithId:(NSInteger)document author:(NSInteger)author date:(NSDate*)date note:(NSString*)note {
    self = [super init];
    if (self) {
        self.documentId = document;
        self.authorId = author;
        self.authorName = [self getNameForId:author];
        self.creationDate = date;
        self.note = note;
    }
    
    return self;
}

- (NSString*)getNameForId:(NSInteger)doctorId {
    __block NSString *result;
    NSString *path = [NSString stringWithFormat:@"doctors/%d.json", doctorId];
    
    [[ApiClient sharedInstance] getPath:path
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id doctorJson) {
                                    NSString *title = [doctorJson valueForKeyPath:@"title"];
                                    NSString *firstName = [doctorJson valueForKeyPath:@"firstname"];
                                    NSString *lastName  = [doctorJson valueForKeyPath:@"lastname"];
                                    
                                    result = [[NSString stringWithFormat:@"%@ %@ %@", title, firstName, lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                }];
    return result;
}

@end
