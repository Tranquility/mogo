//
//  Observer.h
//  MoGO
//
//  Created by 0schleew on 30.12.12.
//
//

#import <UIKit/UIKit.h>

@interface Observer : UIViewController

typedef enum {
    slotTemplate,
    dayTemplate,
} Listeners;

- (void)notifyFromSender:(Listeners)sender withValue:(id)value;

@end
