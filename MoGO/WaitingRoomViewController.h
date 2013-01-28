//
//  WaitingRoomViewController.h
//  MoGO
//
//  Created by Ole Reifschneider on 23.01.13.
//
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface WaitingRoomViewController : UIViewController <UIAlertViewDelegate, SocketIODelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *userId;

@end
