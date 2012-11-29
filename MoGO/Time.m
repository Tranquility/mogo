//
//  Time.m
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import "Time.h"

@interface Time (Private)

@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;

@end

@implementation Time


- (Time*)initWithHour:(NSInteger)hour andMinute:(NSInteger)minute {
    self = [super init];
    
    if (hour <= 0 || hour >= 23 || minute <= 0 || minute >= 59) {
        [NSException raise:@"Invalid time value" format:@"Hour (%d) or Minute (%d) is invalid!", hour, minute];
    }
    
    if (self) {
        self.hour = hour;
        self.minute = minute;
    }
    
    return self;
}

- (Time*)differenceTo:(Time *)time {
    if (![self isEarlierThan:time]) {
        [NSException raise:@"Invalid time value" format:@"%@ is later than %@", self, time];
    }
    
    NSInteger hour = time.hour - self.hour;
    NSInteger minute = time.minute - self.minute;
    
    if (minute < 0) {
        hour -= 1;
        minute += 60;
    }
    
    return [[Time alloc] initWithHour:hour andMinute:minute];
}

- (BOOL)isEarlierThan:(Time *)time {
    if (self.hour < time.hour) {
        return YES;
    }
    else if (self.hour = time.hour && self.minute < time.minute) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSInteger)inMinutes {
    return 60 * self.hour + self.minute;
}

- (NSString*)description {
    NSString *minute;
    if (self.minute > 9) {
        minute = [NSString stringWithFormat:@"%d", self.minute];
    } else if (self.minute > 0) {
        minute = [NSString stringWithFormat:@"0%d", self.minute];
    } else {
        minute = @"00";
    }
    
    return [NSString stringWithFormat:@"%d:%@", self.hour, minute];
}

@end
