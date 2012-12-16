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

- (DocumentModel*)initWithId:(NSInteger)document doctorId:(NSInteger)author date:(NSDate*)date note:(NSString*)note {
    self = [super init];
    if (self) {
        self.documentId = document;
        self.doctorId = author;
        [self getDoctorForId:author];
        self.creationDate = date;
        self.note = note;
    }
    
    return self;
}

- (void)getDoctorForId:(NSInteger)doctorId {
    NSString *path = [NSString stringWithFormat:@"doctors/%d.json", doctorId];
    
    [[ApiClient sharedInstance] getPath:path
                             parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id doctorJson) {
                                    self.doctor = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                }];
    
}

@end
