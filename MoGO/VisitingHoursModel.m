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

@end
