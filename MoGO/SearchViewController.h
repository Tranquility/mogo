//
//  SearchViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIPickerView* pickerView;
@property (nonatomic, strong) IBOutlet UIView* subView;
@property (nonatomic, strong) NSArray* arrayDisciplines;

@end
