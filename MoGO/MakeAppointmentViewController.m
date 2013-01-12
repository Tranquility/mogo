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
#import "ApiClient.h"
#import <EventKit/EventKit.h>

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
@property (nonatomic) NSDate *timeStamp;



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
    
    //ask for user permission to use calendar. Only called at first startup of the app
    [self askForCalendarPermissionOnce];
    
    
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
    
    //Adjust the title depending on whether we want to reschedule or make a new apointment
    if (self.selectedAction == CHANGE)
    {
        self.navigationItem.title = @"Termin verschieben";
    }
    // This adds GestureRecognizing to this View
    // Add swipeGestures (the selector will be the moveCalendarViewtoLeft and moveCalendarViewtoRight)
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveCalendarViewtoRight:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveCalendarViewtoLeft:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
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
    id params = @{
    @"month":[NSNumber numberWithInteger:month],
    @"year":[NSNumber numberWithInteger:year],
    @"doctor":[NSNumber numberWithInteger:self.doctor.idNumber]
    };
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade Kalenderansicht", @"LOAD_CALENDAR")];
    
    [[ApiClient sharedInstance] getPath:@"time_slots.json"
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
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
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
        
        self.buttonRight.hidden = NO;
        self.buttonLeft.hidden = self.currentOffset == 0;
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
        
        //Show the Button if we are not at the end yet
        self.buttonLeft.hidden = NO;
        self.buttonRight.hidden = self.currentOffset == 960;
    }
    
    //Hide Button if we reached the end
    
    
    
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
    
    MakeAppointmentDayViewController *dayController = [[MakeAppointmentDayViewController alloc]initWithNibName:@"MakeAppointmentDayViewController"
                                                                                                        bundle:Nil
                                                                                                           day:day
                                                                                                         month:self.currentMonth
                                                                                                          year:self.currentYear
                                                                                                      observer:self
                                                                                            otherAvailableDays:otherDays];
    
    dayController.doctor = self.doctor;
    
    [[self navigationController] pushViewController:dayController animated:YES];
}

//This is called by the SlotTemplateView when a user clicks a slot that he wants to reserve
- (void)saveNewAppointment:(NSDate*)timeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = RUBY_DATE;
    self.timeStamp = timeStamp;
    
    NSString *timeString = [dateFormatter stringFromDate:timeStamp];
    id params = @{
    @"appointment": @{
    @"doctor_id": [NSNumber numberWithInt:self.doctor.idNumber],
    @"patient_id": @1,
    @"start_at": timeString
    }
    };
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lege Termin an", @"MAKE_APPOINTMENT")];
    
    [[ApiClient sharedInstance] postPath:@"appointments.json"
                              parameters:params
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if (self.selectedAction == CHANGE) {
                                         [self deleteAppointment];
                                     }
                                     else
                                     {
                                         //TODO: Replace condition with check for user setting about saving into calendar
                                         if(YES)
                                         {
                                             //User doesn't have a appointment yet
                                             if([self checkForUserAppointmentsAtTime:timeStamp] == nil )
                                             {
                                                 [self saveAppointmentToCalendar:timeStamp];
                                                 [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde gespeichert", @"APPOINTMENT_SAVED")];
                                             }
                                             else
                                             {
                                                 EKEvent *firstEvent = [self checkForUserAppointmentsAtTime:timeStamp];
                                                 UIAlertView *confirmAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sie haben bereits einen Termin", @"HAS_TITLE")
                                                                                                              message:[NSString stringWithFormat:@"Termin: %@ \n Soll der Termin trotzdem gebucht werden?", firstEvent.title]
                                                                                                             delegate:self
                                                                                                    cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                                                                    otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
                                                 
                                                 [confirmAppointment show];
                                             }//else
                                         }//if
                                         
                                     }//else
                                     
                                     
                                     [self performSelector:@selector(popToRootView) withObject:nil afterDelay:1.5];
                                 }//success
     
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                 }];
    
    //Add this doctor to the fav. list
    [self addDoctorToFavList];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Termin wurde nicht gespeichert", @"APPOINTMENT_NOT_SAVED")];
    }
    else if (buttonIndex == 1)
    {
        [self saveAppointmentToCalendar:self.timeStamp];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde gespeichert", @"APPOINTMENT_SAVED")];
        
    }
}

- (void)deleteAppointment {
    
    NSString *path = [NSString stringWithFormat:@"appointments/%d.json", self.idNumber];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Sage Termin ab", @"CANCEL_APPOINTMENT")];
    
    [[ApiClient sharedInstance] deletePath:path
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id response) {
                                       [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Termin wurde verschoben", @"APPOINTMENT_RESCHEDULED")];
                                       [self performSelector:@selector(popToRootView) withObject:nil afterDelay:1.5];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                   }];
}

- (void)popToRootView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Creates the FilePath for the Favourite-List
- (NSString *) saveFilePath
{
	NSArray *path =	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"data.archive"];
    
}

-(void) addDoctorToFavList {
    NSString *myPath = [self saveFilePath];
    
    NSMutableArray *favouriteDoctors = [[NSMutableArray alloc] init];
    
    //Set up Favourite-List depending on whether there exists a file or not
    if ([[NSFileManager defaultManager] fileExistsAtPath:myPath])
    {
        favouriteDoctors = [NSKeyedUnarchiver unarchiveObjectWithFile: myPath];
    }
    
    //get the doctorID as a String
    NSString *idNumber = [NSString stringWithFormat:@"%d", self.doctor.idNumber];
    
    //If this doctor is not a favourite, add it
    if (![favouriteDoctors containsObject:idNumber]) {
        [favouriteDoctors addObject:idNumber];
    }
    [NSKeyedArchiver archiveRootObject: favouriteDoctors toFile:self.saveFilePath];
}

//Calendar related methods

-(void)saveAppointmentToCalendar:(NSDate*)startDate
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title     = [NSString stringWithFormat:@"Termin bei %@",self.doctor.fullName];
        event.startDate = startDate;
        //we save a appointment with 30 minutes duration by default
        //TODO: can probably fetch the lenght of the selected slot from server somehow
        event.endDate   = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:event.startDate];
        event.notes = NSLocalizedString(@"Mit MoGo erstellter Termin", @"CREATED_WITH_MOGO");
        
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        
    }];
    
}

-(EKEvent*)checkForUserAppointmentsAtTime:(NSDate*)dateToCheck
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //we check a certain time
    NSDate *endDate   = [[NSDate alloc] initWithTimeInterval:1800 sinceDate:dateToCheck];
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:dateToCheck
                                                                 endDate:endDate
                                                               calendars:nil];
    NSArray *usersAppointmentsInRange = [[NSArray alloc]init];
    
    usersAppointmentsInRange = [eventStore eventsMatchingPredicate:predicate];
    if([usersAppointmentsInRange count] > 0)
    {
        return [usersAppointmentsInRange objectAtIndex:0];
    }
    else
    {
        return nil;
    }
}

-(void)askForCalendarPermissionOnce
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if(!granted)
        {
            UIAlertView *notGrantedAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rechte zur Kalendernutzung nicht gewährt", @"CALENDAR_NOT_GRANTED")
                                                                      message:NSLocalizedString(@"MoGo kann keine Termine n Ihren Kalender speichern. Sie können die Rechte in den Systemeinstellungen gewähren", @"GRANT_CALENDAR_IN_OPTIONS")
                                                                     delegate:self
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil, nil];
            [notGrantedAlert show];
        }
        
    }];
}



@end
