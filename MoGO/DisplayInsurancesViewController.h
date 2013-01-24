//
//  DisplayInsurancesViewController.h
//  MoGO
//
//  Created by 0weislow on 24.01.13.
//
//

#import <UIKit/UIKit.h>

@interface DisplayInsurancesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *insuranceTableView;

@end
