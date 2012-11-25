//
//  AppointmentDetailViewController.h
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import <UIKit/UIKit.h>

@interface AppointmentDetailViewController : UIViewController
@property (nonatomic,strong) IBOutlet UILabel *doctorLabel;
@property (nonatomic,strong) IBOutlet UILabel *disciplineLabel;
@property (nonatomic,strong) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UITextView *noteTextView;
@property (nonatomic,strong) IBOutlet UIButton *changeButton;
@property (nonatomic,strong) IBOutlet UIButton *cancelButton;

@end
