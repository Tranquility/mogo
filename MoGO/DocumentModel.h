//
//  DocumentModel.h
//  MoGO
//
//  Created by 0schleew on 06.12.12.
//
//

#import <Foundation/Foundation.h>

@interface DocumentModel : NSObject

@property (nonatomic) NSInteger documentId;
@property (nonatomic) NSInteger authorId;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSString *note;

- (DocumentModel*)initWithId:(NSInteger)document author:(NSInteger)author date:(NSDate*)date note:(NSString*)note;

@end
