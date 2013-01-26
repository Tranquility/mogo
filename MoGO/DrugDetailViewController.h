//
//  DrugDetailViewController.h
//  MoGO
//
//  Created by 0leschen on 06.12.12.
//
//

#import <UIKit/UIKit.h>
#import "PrescriptionModel.h"

@interface DrugDetailViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *medication;
@property (nonatomic) IBOutlet UILabel *doctor;
@property (nonatomic) IBOutlet UILabel *date;
@property (nonatomic) IBOutlet UILabel *fee;
@property (nonatomic) IBOutlet UITextView *note;
@property (nonatomic) IBOutlet UIButton *qrButton;

@property (nonatomic) PrescriptionModel *prescription;

@end
