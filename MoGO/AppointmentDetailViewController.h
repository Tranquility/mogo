//
//  AppointmentDetailViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>

@interface AppointmentDetailViewController : UIViewController
@property (nonatomic) IBOutlet UILabel *doctorLabel;
@property (nonatomic) IBOutlet UILabel *disciplineLabel;
@property (nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic) IBOutlet UIButton *changeButton;
@property (nonatomic) IBOutlet UIButton *cancelButton;

@end
