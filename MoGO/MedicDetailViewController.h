//
//  MedicDetailViewController.h
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DoctorModel.h"

@interface MedicDetailViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *addFavourite;
@property (nonatomic) IBOutlet UIBarButtonItem *makeAppointment;
@property (nonatomic) IBOutlet MKMapView *mapOutlet;
@property (nonatomic) IBOutlet UILabel *nameField;
@property (nonatomic) IBOutlet UILabel *typeField;
@property (nonatomic) IBOutlet UITextView *addressField;
@property (nonatomic) IBOutlet UILabel *phoneField;
@property (nonatomic) IBOutlet UILabel *hoursField;
@property (nonatomic) IBOutlet UIButton *favouriteButton;

@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) NSMutableArray *favouriteDoctors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)setFavourite:(id)favourite;
- (IBAction)mapClicked:(id)sender;
- (IBAction)initiateCall:(id)sender;

@end
