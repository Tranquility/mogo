//
//  MakeAppointmentDayViewController.m
//  MoGO
//
//  Created by 0eisenbl on 08.12.12.
//
//

#import "MakeAppointmentDayViewController.h"
#import "ApiClient.h"
#import "Time.h"
#import "UserCalendarManipulator.h"

@interface MakeAppointmentDayViewController()

@property (nonatomic) NSInteger currentDay;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic) NSArray *availableDaysInMonth;
@property (nonatomic) NSArray* availableAppointments;
@property (nonatomic) NSDate* selectedDate;
@property (nonatomic) UserCalendarManipulator *manipulator;


@end

@implementation MakeAppointmentDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year  observer:(id<Observer>)observer otherAvailableDays:(NSArray*)otherDays;
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
    self.manipulator = [[UserCalendarManipulator alloc]init];
    
    self.availableAppointments = [[NSArray alloc] init];
    //Set name and discipline of the doctor
    self.doctorLabel.text = [self.doctor fullName];
    self.doctorDisciplineLabel.text = self.doctor.discipline;
    
    NSInteger index = [self.availableDaysInMonth indexOfObject:[NSNumber numberWithInteger:self.currentDay]];
    
    [self refreshEverything:index];
    
    /*
     // This adds GestureRecognizing to this View
     */
    // Add swipeGestures (the selector will be the moveCalendarViewtoLeft and moveCalendarViewtoRight)
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextDay:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousDay:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
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

    [self refreshEverything:index];
}

//Switches the slotsView to the previous day that has available slots open
-(void)showPreviousDay:(id)sender
{
    //Find the day BEFORE the current day but WITHIN that month which has available slots
    NSInteger currentIndex = [self.availableDaysInMonth indexOfObject:[NSNumber numberWithInteger:self.currentDay]];
    NSInteger index = currentIndex > 0 ? currentIndex - 1 : 0;
        
    self.currentDay = [[self.availableDaysInMonth objectAtIndex:index] intValue];

    [self refreshEverything:index];
}

- (void)refreshEverything:(NSInteger)index
{
    //Set the Title to the new Values:
    [self updateDateLabel];

    //then load the new Data
    [self loadAppointmentData];
    
}

- (void)loadAppointmentData
{    
    NSString *path = [NSString stringWithFormat:@"appointments.json"];
    
    id params = @{
    @"day": [NSNumber numberWithInteger:self.currentDay],
    @"month": [NSNumber numberWithInteger:self.currentMonth],
    @"year":[NSNumber numberWithInteger:self.currentYear],
    @"doctor": [NSNumber numberWithInteger:self.doctor.idNumber]
    };
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade freie Termine", @"LOAD_APPOINTMENTS")];
    
    [[ApiClient sharedInstance] getPath:path
                             parameters:params
                                success:^(AFHTTPRequestOperation *operation, id appointments) {
                                    [SVProgressHUD dismiss];
                                    
                                    //Save the list in the property (we need this to be a property because we have to access it in the Delegate methods for the TableViewCells)
                                    self.availableAppointments = [self findAvailableAppointments:appointments];
                                    
                                    //Reload the table with the received data
                                    [self.appointmentsTableView reloadData];
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Verbindungsfehler", @"CONNECTION_FAIL")];
                                }];
    
}

//Generates all available appointments for the day
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

/*
 //Implement the DataSource protocol for the AppointmentTable (we need 2 Methods, numberOfSections is 1 by default, which is fine)
 */

//1) return a cell for a given indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"viewcell1";
    
    //Create Cell if necessary
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell according to the Date
    NSDate *appointmentDate = [self.availableAppointments objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NSLocalizedString(@"HH:mm", "DATE_FORMAT")];
    
    //Update the Text-Label
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:appointmentDate]];
   
    //check for overlapping appointments with user's calendar, adding a hint to cell if any
    if([self.manipulator checkForUserAppointmentsAtTime:appointmentDate] != nil)
    {
        cell.detailTextLabel.text = [NSLocalizedString(@"Konflikt: ", @"CONFLICT") stringByAppendingString:[self.manipulator checkForUserAppointmentsAtTime:appointmentDate].title];
    }
    else
    {
        cell.detailTextLabel.text = @"";
    }
    
    //This activates the small arrow to indicate that you can accept the date
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}
//2) return the number of items - This needs to be 0 if we have not received the availableAppointments yet
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availableAppointments.count;
}

/*
 //Implement some methods of the Delegate protocol for the AppointmentTable
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Save the selected Date globally (needed for the alertView protocol method)
    self.selectedDate = [self.availableAppointments objectAtIndex:indexPath.row];
    
    //Format and stuff...print message etc.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"'am' dd.MM.yyyy 'um' HH:mm 'Uhr'";
    NSString *dateString = [formatter stringFromDate:self.selectedDate];
    NSString *message = [NSString stringWithFormat:@"Wollen Sie %@ verbindlich einen Termin vereinbaren?\n", dateString];
    if([self.manipulator checkForUserAppointmentsAtTime:self.selectedDate] != nil)
    {
        message = [NSString stringWithFormat:@"%@ %@ \n\"%@\"", message, NSLocalizedString(@"Achtung: Sie haben zur selben Zeit den Termin: ", @"APPOINTMENT_SAME_TIME"), [self.manipulator checkForUserAppointmentsAtTime:self.selectedDate].title];
    }
    
    UIAlertView *confirmAppointment = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bitte bestätigen", @"PLEASE_COMFIRM")
                                                                 message:NSLocalizedString(message, @"ADD_DOCTOR_TO_FAV")
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Nein", @"NO")
                                                       otherButtonTitles:NSLocalizedString(@"Ja", @"YES"), nil];
    
    [confirmAppointment show];
    
    //Deselect Row when finished
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIAlertView Delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.observer notifyFromSender:slotTemplate withValue:self.selectedDate];
    }
}



@end
