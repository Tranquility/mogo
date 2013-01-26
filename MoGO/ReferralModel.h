//
//  ReferralModel.h
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import "DocumentModel.h"

@interface ReferralModel : DocumentModel

typedef enum {
    Consultation = 0,
    Task,
    FurtherProcessing
} Reason;

@property (nonatomic) NSString *target; // Evtl. auch gleich der Zielarzt
@property (nonatomic) Reason reason; // Grund für die Überweisung, das sollte am besten ein Enum sein.
@property (nonatomic) NSString *reasonString;
@property (nonatomic) NSString *diagnosesSoFar; // Was bisher vom Arzt gemacht wurde
@property (nonatomic) NSString *task; // Was soll der nächste Arzt machen
@property (nonatomic) UIImage *qrcode;

- (ReferralModel*)initWithId:(NSInteger)document doctor:(DoctorModel*)author date:(NSDate*)date note:(NSString*)note  newDoctor:(NSString*)newDoctor reason:(Reason)reason diagnoses:(NSString*)diagnoses task:(NSString*)task;

@end
