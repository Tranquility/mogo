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
@property (nonatomic) float additionalCharge;
@property (nonatomic) UIImage *qrCode;

- (PrescriptionModel*)initWithId:(NSInteger)document doctorId:(NSInteger)author date:(NSDate*)date note:(NSString*)note medication:(NSString*)medication additionalCharge:(float)charge qrCode:(UIImage*)code;

@end
