//
//  AppDelegate.h
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
//Array which holds all registered doctors, gets filled on startup
@property (nonatomic)  NSArray *allDoctors;


@end
