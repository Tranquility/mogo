//
//  MonthTemplateOverviewView.m
//  MoGO
//
//  Created by 0bruegge on 30.11.12.
//
//

#import "MonthTemplateOverviewView.h"
#import "DayTemplateView.h"

@implementation MonthTemplateOverviewView 



- (id)initWithFrame:(CGRect)frame andWithMonth:(NSInteger)currentMonth andWithYear:(NSInteger)currentYear
{
    
    self = [super initWithFrame:frame];
    [[NSBundle mainBundle] loadNibNamed:@"MonthTemplateOverviewView" owner:self options:nil];
    if (self) {
    
        //
        // Do some preparations for the Calendar
        //
        
        //Format the Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
        NSMutableString *dateString = [NSMutableString stringWithFormat:@"%d", currentMonth];
        [dateString appendString:@"/01/"];
        [dateString appendString:[NSString stringWithFormat:@"%d", currentYear]];
        //Create the Date-Object
        NSDate *d = [dateFormatter dateFromString:dateString];
        
        //Find the first weekday of the month
        dateFormatter.dateFormat = @"EEE";
        NSString *firstDayOfWeek = [dateFormatter stringFromDate:d];
        
        //Helper-Variables
        NSInteger start,status;
        
        //Create a Calendar-Object for some help...
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
        
        //How many Days do we have in the month?
        NSInteger days = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:d].length;
        
        //Determine where the current month starts
        if([firstDayOfWeek isEqualToString:@"Mon"])
        {
            start = 0;
        }
        if([firstDayOfWeek isEqualToString:@"Tue"])
        {
            start = 1;
        }
        if([firstDayOfWeek isEqualToString:@"Wed"])
        {
            start = 2;
        }
        if([firstDayOfWeek isEqualToString:@"Thu"])
        {
            start = 3;
        }
        if([firstDayOfWeek isEqualToString:@"Fri"])
        {
            start = 4;
        }
        if([firstDayOfWeek isEqualToString:@"Sat"])
        {
            start = 5;
        }
        if([firstDayOfWeek isEqualToString:@"Sun"])
        {
            start = 6;
        }
        
        
        //
        //Loop through the whole month:
        //We have max. 6 rows (weeks) and 7 days per week
        //
        for (int i=0; i<6; i++) {
            for (int j=0; j<7; j++) {
                
                //Split the whole Canvas to tiles with a size of 40px, with a border of 1 px between the tiles
                CGRect r = CGRectMake(j*40, i*40, 39,39);
                
                //At which day are we right now?
                NSInteger actualDay = (i*7+j+1)-start;
                
                //A day is disabled if it is before the first Day of the Week
                // _or_ if it is beyond the last day of the week
                if((i==0 && j<start) || actualDay > days)
                {
                    status = 0; //Do not show the day at all
                }
                else{
                    //If there are free appointment-slots for this day, set status=2 (available)
                    //Always true chosen at the moment, for demonstration purpose
                    if(true)
                    {
                        status = 1;
                    }
                    else
                    {
                        status = 2; //else set status=1 (no appointmentslots available)
                    }
                }
               
                //Draw Day to Calendar-View (by adding a sub-view)
                [self.kalView addSubview:[[DayTemplateView alloc] initWithFrame:r andWithStatus:status andWithDay:actualDay]];
                                
            }
        }
       
    }
    return self;
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
