//
//  AppointmentViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppointmentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic,strong) NSArray *appointmentList;
@property (nonatomic,strong) NSArray *doctorsList;
@property (nonatomic,strong) IBOutlet UITableView *appointmentsTableView;
@property (nonatomic,strong) IBOutlet UITableView *doctorsTableView;

@end
