//
//  QrDetailViewController.h
//  MoGO
//
//  Created by Jutta Dr. Kirschner on 26.01.13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    Prescription,
    Referral
} QrSender;

@interface QrDetailViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *topicLabel;
@property (nonatomic) IBOutlet UILabel *detailLabel;
@property (nonatomic) IBOutlet UIImageView *qrcodeView;

@property (nonatomic) UIImage *qrcode;
@property (nonatomic) QrSender sender;

@end
