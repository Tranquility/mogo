//
//  CheckinViewController.h
//  MoGO
//
//  Created by DW on 24.12.12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CheckinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

@property (weak, nonatomic) IBOutlet UILabel *actualDoctorLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
- (IBAction)checkinPressed:(id)sender;

@property (nonatomic) NSMutableArray* allDoctors;


@end
