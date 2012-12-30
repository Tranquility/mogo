//
//  MakeAppointmentDayViewController.m
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import "MakeAppointmentDayViewController.h"
#import "DaySlotView.h"
#import "ApiClient.h"
#import "Time.h"
#import "SVProgressHUD.h"

@interface MakeAppointmentDayViewController()

@property (nonatomic) NSInteger currentDay;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic) NSArray *availableDaysInMonth;
@property (nonatomic) DaySlotView* day;

@end

@implementation MakeAppointmentDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year  observer:(Observer*)observer otherAvailableDays:(NSArray*)otherDays;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.observer = observer;
        self.currentDay = day;
        self.currentMonth = month;
        self.currentYear = year;
        self.availableDaysInMonth = otherDays;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set name and discipline of the doctor
    self.doctorLabel.text = [self.doctor fullName];
    self.doctorDisciplineLabel.text = self.doctor.discipline;
    
    [self refreshEverything];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Switches the slotsView to the next day that has available slots open
-(void)showNextDay:(id)sender
{
    //Find the day BEFORE the current day but WITHIN that month which has available slots
    NSInteger index = MIN([self.availableDaysInMonth indexOfObject:[NSNumber numberWithInteger:self.currentDay]] + 1, self.availableDaysInMonth.count - 1);
    
    self.currentDay = [[self.availableDaysInMonth objectAtIndex:index] intValue];
    
    [self refreshEverything];
}

//Switches the slotsView to the previous day that has available slots open
-(void)showPreviousDay:(id)sender
{
    //Find the day BEFORE the current day but WITHIN that month which has available slots
    NSInteger currentIndex = [self.availableDaysInMonth indexOfObject:[NSNumber numberWithInteger:self.currentDay]];
    NSInteger index = currentIndex > 0 ? currentIndex - 1 : 0;
    
    self.currentDay = [[self.availableDaysInMonth objectAtIndex:index] intValue];
    
    [self refreshEverything];
    
}

- (void)refreshEverything
{
    //Set the Title to the new Values:
    [self updateDateLabel];
    
    //Create Slot View with the given day/month/year
    [self createSlotView];
}

- (void)createSlotView
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade alle Termine", @"LOAD_APPOINTMENTS")];
    
    NSString *path = [NSString stringWithFormat:@"appointments.json"];
    
    id params = @{
    @"day": [NSNumber numberWithInteger:self.currentDay],
    @"month": [NSNumber numberWithInteger:self.currentMonth],
    @"year":[NSNumber numberWithInteger:self.currentYear],
    @"doctor": [NSNumber numberWithInteger:self.doctor.idNumber]
    };
    
    [[ApiClient sharedInstance] getPath:path
                             parameters:params
                                success:^(AFHTTPRequestOperation *operation, id appointments) {
                                    [SVProgressHUD dismiss];
                                    
                                    NSArray *availableAppointments = [self findAvailableAppointments:appointments];
                                    self.day = [[DaySlotView alloc] initWithFrame:CGRectMake(0,0,320,500) day:self.currentDay month:self.currentMonth year:self.currentYear appointments: availableAppointments observer:self.observer container:self.slotsView];
                                    
                                    //Add Slot View as a subview
                                    [self.slotsView addSubview:self.day.slotView];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                }];
    
}

- (NSArray*)findAvailableAppointments:(id)appointments {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray *availableAppointments = [[NSMutableArray alloc] init];
    
    //Date formatter for rails timestamps
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

    for (id appointment in appointments) {
        NSDate *date = [dateFormatter dateFromString:appointment];
        [availableAppointments addObject:date];
    }
    return availableAppointments;
}

//Sets the CalendarTitle for a specific date
-(void)updateDateLabel
{
    NSString *dayString = [NSString stringWithFormat:@"%d", self.currentDay];
    if (self.currentDay < 10) {
        dayString = [NSString stringWithFormat:@"0%@", dayString];
    }
    
    NSString *monthString = [NSString stringWithFormat:@"%d", self.currentMonth];
    if (self.currentMonth < 10) {
        monthString = [NSString stringWithFormat:@"0%@", monthString];
    }
    
    NSString *yearString = [NSString stringWithFormat:@"%d", self.currentYear];
    
    self.dayLabel.text = [NSString stringWithFormat:@"%@.%@.%@", dayString, monthString, yearString];
}

@end
