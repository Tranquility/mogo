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


@interface CheckinViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;

- (IBAction)checkinPressed:(id)sender;

@end
