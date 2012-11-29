//
//  AppointmentTableViewCell.h
//  MoGO
//
//  Created by 0eisenbl on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *doctorLabel;
@property (nonatomic, weak) IBOutlet UILabel *doctorDisciplineLabel;
@property (nonatomic, weak) IBOutlet UILabel *DateLabel;

@end
