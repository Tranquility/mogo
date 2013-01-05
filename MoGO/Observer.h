//
//  Observer.h
//  MoGO
//
//  Created by 0schleew on 05.01.13.
//
//

typedef enum {
    slotTemplate,
    dayTemplate,
} Listeners;

@protocol Observer

- (void)notifyFromSender:(Listeners)sender withValue:(id)value;

@end
