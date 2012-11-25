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
@property (nonatomic) NSArray* arrayDisciplines;
@property (nonatomic) NSArray* arrayDentists;
@property (nonatomic) NSArray* arrayPediatritians;
@property (nonatomic) NSArray* arrayGynecologists;
@property (nonatomic) NSArray* arrayGeneralDoctors;
@property (nonatomic) NSArray* arrayAll;
@property (nonatomic) NSMutableArray* arrayChosen;


@end
