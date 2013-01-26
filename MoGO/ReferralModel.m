//
//  ReferralModel.m
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import "ReferralModel.h"
#import "ZXingObjC.h"

@implementation ReferralModel

- (ReferralModel*)initWithId:(NSInteger)document doctor:(DoctorModel*)author date:(NSDate*)date note:(NSString*)note  newDoctor:(NSString*)newDoctor reason:(Reason)reason diagnoses:(NSString*)diagnoses task:(NSString*)task
{
    self = [super initWithId:document doctor:author date:date note:note];
    if (self) {
        self.target = newDoctor;
        self.reason = reason;
        self.diagnosesSoFar = diagnoses;
        self.task = task;
        self.reasonString = [self reasonToString:reason];
        [self generateQRCode];

    }
    
    return self;
}

- (ReferralModel*)initWithDictionary:(NSDictionary*)dict {
    self = [super initWithDictionary:dict];
    
    if (self) {
        NSDictionary *subDict = [dict valueForKeyPath:@"document"];
        self.reason = [[subDict valueForKeyPath:@"reason"] integerValue];
        self.reasonString = [self reasonToString:self.reason];
        self.diagnosesSoFar = [subDict valueForKeyPath:@"diagnosis"];
        self.task = [subDict valueForKeyPath:@"task"];
        self.target = [subDict valueForKeyPath:@"discipline"];
        [self generateQRCode];
    }
    
    return self;
}

- (NSString *)reasonToString:(Reason)reason {
    switch (reason) {
        case 0:
            return NSLocalizedString(@"Konsiliaruntersuchung", @"CONSULTATE");
            break;
        case 1:
            return NSLocalizedString(@"Auftragsleistungen", @"MISSION");
            break;
        case 2:
            return NSLocalizedString(@"Mit-/Weiterbehandlung", @"FURTHER_PROCESSING");
            break;
        default:
            return @"";
    }
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
        
        self.qrcode = [UIImage imageWithCGImage:image];
    } else {
        NSString* errorMessage = [error localizedDescription];
        NSLog(@"%@", errorMessage);
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"doctor: %d\npatient: 1\ntarget: %@\ndate: %@\nreason: %d\ndiagnosis: %@\ntask: %@",
            self.doctor.idNumber, self.target, self.creationDate, self.reason, self.diagnosesSoFar, self.task];
}

@end
