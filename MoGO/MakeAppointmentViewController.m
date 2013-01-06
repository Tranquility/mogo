//
//  MakeAppointmentViewController.m
//  MoGO
//
//  Created by 0eisenbl on 25.11.12.
//
//

#import "MakeAppointmentViewController.h"
#import "MonthTemplateOverviewView.h"
#import "MakeAppointmentDayViewController.h"
#import "AppointmentViewController.h"
#import "SlotTemplateView.h"
#import "ApiClient.h"
#import "SVProgressHUD.h"

#define RUBY_DATE @"yyyy-MM-dd'T'HH:mm:ss'Z'"


/*
 MakeAppointmentViewController
 
 This object handles all the workflow for making an appointment.
 
 At first it will create a certain number of MonthTemplateOverview's, which will be display in the ScrollView.
 
 If the user clicks a day in the MonthTemplateOverview, this Class will be notified by calling its "showDay" Method.
 
 Upon this, a MakeAppointmentDayViewController is pushed to the navigation Stack, which shows all slots of a specific day.
 
 When the user clicks a slot to book it, this object is informed by using the "saveNewAppointment" method.
 
 
 
 TODO: This need to be connected to the dataSources for Slots and Appointments, as well as all its connected Classes.
 
 TODO: After a new appointment has been saved, this class needs to pop the navigation stack, and perhaps also move via to the startScreen or the appointmentDetails.
 
 */

@interface MakeAppointmentViewController ()

@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) NSMutableDictionary *slotsPerMonth;

@end

@implementation MakeAppointmentViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slotsPerMonth = [NSMutableDictionary dictionary];
    //Set name and discipline of the doctor
    self.doctorLabel.text = [self.doctor fullName];
    self.doctorDisciplineLabel.text = self.doctor.discipline;
    
    //Set ScrollView width to 4*Size of a calendar. height=height of one calendar
    self.calendarScrollView.contentSize = CGSizeMake(4 * 320, 334);
    
    //Current offset is 0 (actual month)
    self.currentOffset = 0;
    
    //Initialize the calendar elements with month and year
    NSDate *today = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *monthString = [formatter stringFromDate:today];
    formatter.dateFormat = @"yyyy";
    NSString *yearString = [formatter stringFromDate:today];
    
    self.currentMonth = [monthString integerValue];
    self.currentYear = [yearString integerValue];
    [self updateMonthLabel];
    
    //helper variable
    NSInteger month = self.currentMonth;
    NSInteger year = self.currentYear;
    for (NSInteger i = 0; i < 4; i++)
    {
        [self generateMonthOverviewWithIndex:i year:year month:month];
        year += (NSInteger) (month / 12);
        month = month % 12 + 1;
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Observer methods
- (void)notifyFromSender:(Listeners)sender withValue:(id)value {
    if (sender == slotTemplate) {
        [self saveNewAppointment:value];
    } else if (sender == dayTemplate) {
        [self showDay:[value intValue]];
    }
}

- (void)generateMonthOverviewWithIndex:(int)i year:(int)year month:(int)month
{
    NSString *path = [NSString stringWithFormat:@"time_slots.json"];
    
    id params = @{
    @"month":[NSNumber numberWithInteger:month],
    @"year":[NSNumber numberWithInteger:year],
    @"doctor":[NSNumber numberWithInteger:self.doctor.idNumber]
    };
    
    [SVProgressHUD show];
    
    [[ApiClient sharedInstance] getPath:path
                             parameters:params
                                success:^(AFHTTPRequestOperation *operation, id slots) {
                                    NSArray *availableSlots = [self findAvailableSlots:slots];
                                    NSNumber *monthObj = [NSNumber numberWithInteger:month];
                                    [self.slotsPerMonth setObject:availableSlots forKey:monthObj];
                                                                        
                                    //Size of one Calendar
                                    CGRect r = CGRectMake(i * 320, 0, 320, 334);
                                    
                                    //Create calendarmonth ViewController
                                    MonthTemplateOverviewView *monthView = [[MonthTemplateOverviewView alloc] initWithFrame:r month:month year:year observer:self slots:availableSlots];
                                    
                                    //Add Calendar View as a subview to the scrollview and tell the buttons which function to call when they are pressed
                                    [self.calendarScrollView addSubview:monthView.mainView];
                                    
                                    [SVProgressHUD dismiss];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                }];
}

/**
 * Find the days with available slots and stuff them in an integer array
 */
- (NSArray *)findAvailableSlots:(id)slots
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableArray *availableSlots = [[NSMutableArray alloc] init];
    
    //Date formatter for rails timestamps
    dateFormatter.dateFormat = RUBY_DATE;
    
    //Date formatter for a single day
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    dayFormatter.dateFormat = @"dd";
    
    for (id slot in slots) {
        //Convert the string into a date object
        NSDate *date = [dateFormatter dateFromString:slot];
        //extract the day of the date
        NSString *day = [dayFormatter stringFromDate:date];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * dayValue = [numberFormatter numberFromString:day];
        //Store the day
        [availableSlots addObject:dayValue];
    }
    return availableSlots;
}

//Moves the calendarScrollView to the previous month
-(IBAction)moveCalendarViewtoLeft:(id)sender {
    if (self.currentOffset > 0)
    {
        self.currentOffset = self.currentOffset - 320;
        self.currentMonth = (self.currentMonth + 10) % 12 + 1;
        self.currentYear -= (NSInteger) (self.currentMonth / 12);
        
        [self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0) animated:YES];
        [self updateMonthLabel];
    }
}

//Moves the calendarScrollView to the next month
-(IBAction)moveCalendarViewtoRight:(id)sender {
    if (self.currentOffset < 960)
    {
        self.currentOffset = self.currentOffset + 320;
        self.currentYear += (NSInteger) (self.currentMonth / 12);
        self.currentMonth = self.currentMonth % 12 + 1;
        
        [self.calendarScrollView setContentOffset:CGPointMake((float)self.currentOffset, 0) animated:YES];
        [self updateMonthLabel];
    }
}

//Sets the CalendarTitle for a specific date
- (void)updateMonthLabel
{
    NSString *monthString = [NSString stringWithFormat:@"%d", self.currentMonth];
    if (self.currentMonth < 10) {
        monthString = [NSString stringWithFormat:@"0%@", monthString];
    }
    
    NSString *yearString = [NSString stringWithFormat:@"%d", self.currentYear];
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@ / %@", monthString, yearString];
}

//Navigate to the dayViewController with the given start day/month/year
- (void)showDay:(int)day
{
    NSArray *otherDays = [self.slotsPerMonth objectForKey:[NSNumber numberWithInteger:self.currentMonth]];
    
    MakeAppointmentDayViewController *dayController = [[MakeAppointmentDayViewController alloc]initWithNibName:@"MakeAppointmentDayViewController" bundle:Nil day:day month:self.currentMonth year:self.currentYear observer:self otherAvailableDays:otherDays];
    
    dayController.doctor = self.doctor;
    
    [[self navigationController] pushViewController:dayController animated:YES];
}

//This is called by the SlotTemplateView when a user clicks a slot that he wants to reserve
- (void)saveNewAppointment:(NSDate*)timeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = RUBY_DATE;
    
    NSString *timeString = [dateFormatter stringFromDate:timeStamp];
    id params = @{
        @"appointment": @{
            @"doctor_id": [NSNumber numberWithInt:self.doctor.idNumber],
            @"patient_id": @1,
            @"start_at": timeString
        }
    };
    
    [SVProgressHUD show];
    
    [[ApiClient sharedInstance] postPath:@"appointments.json"
                              parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if (self.selectedAction == CHANGE) {
                                         [self deleteAppointment];
                                     } else {
                                         [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde gespeichert", @"APPOINTMENT_SAVED")];
                                         [self performSelector:@selector(popToRootView) withObject:nil afterDelay:1.5];
                                     }
                                     
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     if (operation.response.statusCode == 500) {
                                         NSLog(@"Unknown Error");
                                         [SVProgressHUD showErrorWithStatus:@"Something went wrong!"];
                                     } else {
                                         NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                              options:0
                                                                                                error:nil];
                                         NSString *errorMessage = [json objectForKey:@"errors"];
                                         [SVProgressHUD showErrorWithStatus:errorMessage];
                                     }
                                 }];
}

- (void)deleteAppointment {
    
    NSString *path = [NSString stringWithFormat:@"appointments/%d.json", self.idNumber];
    
    [[ApiClient sharedInstance] deletePath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id response) {
                                       [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde verschoben", @"APPOINTMENT_RESCHEDULED")];
                                       [self performSelector:@selector(popToRootView) withObject:nil afterDelay:1.5];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD dismiss];
                                       NSLog(@"Error deleting appointment");
                                       NSLog(@"%@", error);
                                   }];
}

- (void)popToRootView {    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
