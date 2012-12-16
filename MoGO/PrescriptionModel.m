//
//  PrescriptionModel.m
//  MoGO
//
//  Created by 0schleew on 16.12.12.
//
//

#import "PrescriptionModel.h"

@implementation PrescriptionModel

- (PrescriptionModel*)initWithId:(NSInteger)document doctorId:(NSInteger)author date:(NSDate*)date note:(NSString*)note medication:(NSString*)medication additionalCharge:(float)charge qrCode:(UIImage*)code {
    self = [super initWithId:document doctorId:author date:date note:note];
    if (self) {
        self.medication = medication;
        self.additionalCharge = charge;
        self.qrCode = code;
    }
    
    return self;
}

@end
