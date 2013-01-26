//
//  ReferralDetailViewController.h
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import <UIKit/UIKit.h>
#import "ReferralModel.h"

@interface ReferralDetailViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *targetLabel;
@property (nonatomic) IBOutlet UITextView *taskTextView;
@property (nonatomic) IBOutlet UILabel *reasonLabel;
@property (nonatomic) IBOutlet UILabel *fromDoctorLabel;
@property (nonatomic) IBOutlet UITextView *diagnosisTextView;
@property (nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) IBOutlet UIButton *qrButton;

@property (nonatomic) ReferralModel *referral;
@end
