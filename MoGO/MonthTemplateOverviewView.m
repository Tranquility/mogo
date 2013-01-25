//
//  MonthTemplateOverviewView.m
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import "MonthTemplateOverviewView.h"
#import "DayTemplateView.h"
#import "ApiClient.h"

@implementation MonthTemplateOverviewView

NSInteger const DAY_OFFSET = 1;

- (id)initWithFrame:(CGRect)frame month:(NSInteger)month year:(NSInteger)year observer:(id<Observer>)observer slots:(NSArray*)slots;
{
    
    self = [super initWithFrame:frame];
    
    [[NSBundle mainBundle] loadNibNamed:@"MonthTemplateOverviewView" owner:self options:nil];
    
    if (self) {
        self.mainView.frame = frame;
        self.observer = observer;
        
        //Format the Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
        NSMutableString *dateString = [NSMutableString stringWithFormat:@"%d/01/%d", month, year];
        
        //Create the Date-Object
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        //Find the first weekday of the month
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setFirstWeekday:3]; //Tuesday = 1, Wednesday = 2...
        NSUInteger adjustedWeekdayOrdinal = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
        
        //How many Days do we have in the month?
        NSInteger daysPerMonth = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
        
        [self generateTilesForEachDay:slots days:daysPerMonth start:adjustedWeekdayOrdinal forDate:date];
    }
    return self;
}

- (NSInteger)findIndexOfDay:(NSString *)day
{
    //Determine where the current month starts
    NSInteger start;
    if([day isEqualToString:@"Mon"])
    {
        start = 1 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Tue"])
    {
        start = 2 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Wed"])
    {
        start = 3 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Thu"])
    {
        start = 4 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Fri"])
    {
        start = 5 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Sat"])
    {
        start = 6 - DAY_OFFSET;
    }
    if([day isEqualToString:@"Sun"])
    {
        start = 7 - DAY_OFFSET;
    }
    return start;
}

- (void)generateTilesForEachDay:(NSArray *)availableSlots days:(NSInteger)days start:(NSInteger)start forDate:(NSDate*)date
{
    start = start % 7;
    
    NSDate* currentDateDay = date;
    
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 7; j++) {
            
            //Split the whole Canvas to tiles with a size of 40px, with a border of 1 px between the tiles
            CGRect r = CGRectMake(j * 40, i * 40, 39, 39);
            
            //At which day are we right now?
            NSInteger dayNumber = i * 7 + j + 1 - start;
            
            //A day is disabled if it is before the first Day of the Week
            // _or_ if it is beyond the last day of the week
            State state;
            if ((i == 0 && j < start) || dayNumber > days) {
                state = HIDDEN; //Do not show the day at all
            } else {
                NSNumber *currentDay = [NSNumber numberWithInt:dayNumber];
                
                if ([availableSlots containsObject:currentDay])
                {
                    state = FREE_SLOTS;
                }
                else
                {
                    state = FULLY_BOOKED;
                }
                
                //Check if this day is in the past, then it gets a different color no matter if it has a slot or not
                if([currentDateDay compare:[[NSDate alloc] init]] == NSOrderedAscending)
                {
                    state = DISABLED;
                }
                
            }
            
            currentDateDay = [currentDateDay dateByAddingTimeInterval:60*60*24];
            
            //Draw Day to Calendar-View (by adding a sub-view)
            DayTemplateView *newDay = [[DayTemplateView alloc] initWithFrame:r state:state day:dayNumber observer:self.observer];
            [self.calendarView addSubview:newDay];
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
