//
//  AppointmentViewController.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppointmentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) IBOutlet UITableView *appointmentsTableView;

@property (nonatomic) NSMutableArray *appointmentList;
@property (nonatomic) NSMutableArray *doctorList;
@property (nonatomic) NSMutableArray *favouriteDoctorIDList;
@property (nonatomic) NSString* selectedDoctorIDforAppointment;


@end
