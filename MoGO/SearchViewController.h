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
@property (nonatomic) IBOutlet UISearchBar* searchBar;
@property (nonatomic) IBOutlet UIBarButtonItem *disciplineButton;

@property (nonatomic) NSMutableArray* chosenDoctors;
@property (nonatomic) NSMutableArray* allDoctors;
@property (nonatomic) NSMutableArray* disciplines;


@end
