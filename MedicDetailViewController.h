//
//  MedicDetailViewController.h
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import <Foundation/Foundation.h>
#import "DoctorModel.h"

#define ZOOMFACTOR 500.344

@interface MedicDetailViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *addFavourite;
@property (nonatomic) IBOutlet UIBarButtonItem *makeAppointment;
@property (nonatomic) IBOutlet MKMapView *mapOutlet;
@property (nonatomic) IBOutlet UILabel *nameField;
@property (nonatomic) IBOutlet UILabel *typeField;
@property (nonatomic) IBOutlet UITextView *addressField;
@property (nonatomic) IBOutlet UILabel *phoneField;
@property (nonatomic) IBOutlet UILabel *hoursField;
@property (nonatomic) DoctorModel *doctor;
@property (nonatomic) IBOutlet UIButton *favouriteButton;
@property (nonatomic) NSMutableArray *docFavList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (IBAction)setFavourite:(id)favourite;

@end
