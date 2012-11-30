//
//  MedicDetailViewController.h
//  MoGO
//
//  Created by DW on 24.11.12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

#define ZOOMFACTOR 500.344


@interface MedicDetailViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapOutlet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
