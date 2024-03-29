//
//  PrescriptionModel.m
//  MoGO
//
//  Created by 0schleew on 16.12.12.
//
//

#import "PrescriptionModel.h"
#import "ZXingObjC.h"

@implementation PrescriptionModel

- (PrescriptionModel*)initWithId:(NSInteger)document doctor:(DoctorModel*)author date:(NSDate*)date note:(NSString*)note medication:(NSString*)medication fee:(BOOL)fee {
    self = [super initWithId:document doctor:author date:date note:note];
    if (self) {
        self.medication = medication;
        self.fee = fee;
        [self generateQRCode];
    }
    
    return self;
}

- (PrescriptionModel*)initWithDictionary:(NSDictionary*)dict {
    self = [super initWithDictionary:dict];
    
    if (self) {
        NSDictionary *subDict = [dict valueForKeyPath:@"document"];
        self.medication = [subDict valueForKeyPath:@"drug"];
        self.fee = [[subDict valueForKeyPath:@"fee"] boolValue];
        [self generateQRCode];
    }
    
    return self;
}

- (void)generateQRCode {
    NSError* error = nil;
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:[self description]
                                  format:kBarcodeFormatQRCode
                                   width:200
                                  height:200
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        
        self.qrCode = [UIImage imageWithCGImage:image];
    } else {
        NSString* errorMessage = [error localizedDescription];
        NSLog(@"%@", errorMessage);
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"doctor: %d\npatient: 1\ndate: %@\nmedication: %@\nnote: %@\ncharge: %d",
            self.doctor.idNumber, [self.creationDate description], self.medication, self.note, self.fee];
}

@end
