//
//  Observer.h
//  MoGO
//
//  Created by Andreas Holtz on 30.12.12.
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
