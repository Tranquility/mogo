//
//  VisitingHoursModel.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/Foundation.h>
#import "Time.h"

@interface VisitingHoursModel : NSObject

@property (nonatomic) NSMutableArray *monday;
@property (nonatomic) NSMutableArray *tuesday;
@property (nonatomic) NSMutableArray *wednesday;
@property (nonatomic) NSMutableArray *thursday;
@property (nonatomic) NSMutableArray *friday;

typedef enum {
    Monday = 1,
    Tuesday = 2,
    Wednesday = 3,
    Thursday = 4,
    Friday = 5
} Weekdays;

- (void)addOpeningTime:(Time*)opening andClosingTime:(Time*)closing forDay:(Weekdays)day;

- (BOOL)isOpenAtTime:(Time*)time andDay:(Weekdays)day;

@end
