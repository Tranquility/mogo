//
//  DocumentModel.h
//  MoGO
//
//  Created by 0schleew on 06.12.12.
//
//

#import <Foundation/Foundation.h>
#import "DoctorModel.h"

@interface DocumentModel : NSObject

@property (nonatomic) NSInteger documentId;
@property (nonatomic) NSInteger doctorId;
@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSString *note;

- (DocumentModel*)initWithId:(NSInteger)document doctorId:(NSInteger)author date:(NSDate*)date note:(NSString*)note;

@end
