//
//  SearchViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (nonatomic) IBOutlet UIPickerView* pickerView;
@property (nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic) IBOutlet UIView* subView;
@property (nonatomic) IBOutlet UITextField* doctorNameField;
@property (nonatomic) NSMutableArray* arrayChosen;


@end
