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

- (DocumentModel*)initWithId:(NSInteger)document doctor:(DoctorModel*)author date:(NSDate*)date note:(NSString*)note {
    self = [super init];
    if (self) {
        self.documentId = document;
        self.doctor = author;
        self.creationDate = date;
        self.note = note;
    }
    
    return self;
}

- (DocumentModel*) initWithDictionary:(NSDictionary*)dict {
    self = [super init];
    
    if (self) {
        self.doctor = [[DoctorModel alloc] initWithDictionary:[dict valueForKeyPath:@"doctor"]];
        
        self.documentId = [[dict valueForKeyPath:@"document_id"] intValue];
        self.note = [dict valueForKeyPath:@"content"];
        
        NSString *dateString = [dict valueForKeyPath:@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        self.creationDate = [formatter dateFromString:dateString];
    }
    
    return self;
}

@end
