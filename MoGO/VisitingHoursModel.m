//
//  VisitingHoursModel.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "VisitingHoursModel.h"

@implementation VisitingHoursModel

- (void)addOpeningTime:(Time*)opening andClosingTime:(Time*)closing forDay:(Weekdays)day {
    NSArray *timetuple = [[NSArray alloc] initWithObjects:opening, closing, nil];
    switch (day) {
        case 1:
            [self.monday addObject:timetuple];
            break;
        case 2:
            [self.tuesday addObject:timetuple];
            break;
        case 3:
            [self.wednesday addObject:timetuple];
            break;
        case 4:
            [self.thursday addObject:timetuple];
            break;
        case 5:
            [self.friday addObject:timetuple];
            break;
        default:
            break;
    }
}

- (BOOL)isOpenAtTime:(Time*)time andDay:(Weekdays)day {
    NSMutableArray *chosen;
    
    switch (day) {
        case 1:
            chosen = self.monday;
            break;
        case 2:
            chosen = self.tuesday;
            break;
        case 3:
            chosen = self.wednesday;
            break;
        case 4:
            chosen = self.thursday;
            break;
        case 5:
            chosen = self.friday;
            break;
        default:
            break;
    }
    
    for (NSArray *tuple in chosen) {
        if (![time isEarlierThan:[tuple objectAtIndex:0]] && [time isEarlierThan:[tuple objectAtIndex:1]]) {
            return YES;
        }
    }
    
    return NO;
    
}



@end
