//
//  Time.h
//  MoGO
//
//  Created by 0schleew on 29.11.12.
//
//

#import <Foundation/NSObject.h>

@interface Time : NSObject

@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;

- (Time*)initWithHour:(NSInteger)hour andMinute:(NSInteger)minute;

- (Time*)differenceTo:(Time*)time;

- (BOOL)isEarlierThan:(Time*)time;

- (NSInteger)inMinutes;

@end
