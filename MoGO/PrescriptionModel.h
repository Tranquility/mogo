//
//  PrescriptionModel.h
//  MoGO
//
//  Created by 0schleew on 16.12.12.
//
//

#import <Foundation/Foundation.h>
#import "DocumentModel.h"

@interface PrescriptionModel : DocumentModel

@property (nonatomic) NSString *medication;
@property (nonatomic) BOOL fee;
@property (nonatomic) UIImage *qrCode;

- (PrescriptionModel*)initWithId:(NSInteger)document doctor:(DoctorModel*)author date:(NSDate*)date note:(NSString*)note medication:(NSString*)medication fee:(BOOL)fee;

- (PrescriptionModel*)initWithDictionary:(NSDictionary*)dict;

@end
