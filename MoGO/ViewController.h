//
//  ViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

// Need this because there is a line wrap in the button text
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
@property (weak, nonatomic) IBOutlet UIButton *documentsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@end
