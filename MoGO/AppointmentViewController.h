//
//  AppointmentViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppointmentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) NSArray *appointmentList;
@property (nonatomic) NSArray *doctorsList;
@property (nonatomic) IBOutlet UITableView *appointmentsTableView;
@property (nonatomic) IBOutlet UITableView *doctorsTableView;

@end
