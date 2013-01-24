//
//  SettingsViewController.m
//  MoGO
//
//  Created by 0leschen on 14.01.13.
//
//

#import "SettingsViewController.h"
#import "AddressModel.h"
#import "PatientModel.h"

#import "UserDefaultConstants.h"




@interface SettingsViewController ()
@property(nonatomic) UIDatePicker *datePicker;
@property(nonatomic) NSDate *birthdate;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self =  [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Adding a tap recognizer to react on tap events on the screen
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.savePasswordSwitch.on = [userDefaults boolForKey:UD_SAVE_PASSWORD];
    self.saveToCalendarSwitch.on = [userDefaults boolForKey:UD_SAVE_TO_CALENDAR];
    self.nameField.text = [userDefaults stringForKey:UD_USER_NAME];
    self.surnameField.text = [userDefaults stringForKey:UD_USER_SURNAME];
    self.streetField.text = [userDefaults stringForKey:UD_USER_STREET];
    self.streetnumberField.text = [userDefaults stringForKey:UD_USER_STREET_NR];
    self.zipField.text = [userDefaults stringForKey:UD_USER_ZIP];
    self.townField.text = [userDefaults stringForKey:UD_USER_TOWN];
    self.birthdayText.text = [userDefaults stringForKey:UD_USER_BIRTHDATE];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; 
    self.insuranceField.text = [userDefaults stringForKey:UD_USER_INSURANCE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeKeyboard
{
    [self.view endEditing:YES];
    if([self.view.subviews containsObject:self.datePicker])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:self.datePicker.date];
        [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:UD_USER_BIRTHDATE];
        [self.datePicker removeFromSuperview];
        NSLog(@"Date we safe: %@", dateString);
        self.navigationItem.backBarButtonItem.enabled =  YES;
         [(UIScrollView*)[self view] setScrollEnabled:YES];
        [self viewDidLoad];
    }
    
}

//save current options when user leaves the settings screen   
-(void) viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:self.saveToCalendarSwitch.isOn forKey:UD_SAVE_TO_CALENDAR];
    [userDefaults setBool:self.savePasswordSwitch.isOn forKey:UD_SAVE_PASSWORD];
    [userDefaults setObject:self.nameField.text forKey:UD_USER_NAME];
    [userDefaults setObject:self.surnameField.text forKey:UD_USER_SURNAME];
    [userDefaults setObject:self.streetField.text forKey:UD_USER_STREET];
    [userDefaults setObject:self.streetnumberField.text forKey:UD_USER_STREET_NR];
    [userDefaults setObject:self.zipField.text forKey:UD_USER_ZIP];
    [userDefaults setObject:self.townField.text forKey:UD_USER_TOWN];
}

- (void)viewDidUnload {
    [self setSaveToCalendarSwitch:nil];
    [self setSavePasswordSwitch:nil];
    [self setNameField:nil];
    [self setSurnameField:nil];
    [self setStreetnumberField:nil];
    [self setZipField:nil];
    [self setTownField:nil];
    [self setStreetField:nil];
    [self setInsuranceField:nil];
 
    [self setBirthdayText:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //display Picker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,245,0,0)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    NSDate *loadedDate = [dateFormatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:UD_USER_BIRTHDATE]];
    if(loadedDate != nil)
    {
        self.datePicker.date = loadedDate;
    }
    else
    {
        NSDateComponents *comp = [[NSDateComponents alloc] init];
        [comp setDay:1];
        [comp setMonth:1];
        [comp setYear: 1970];
        NSDate *defaultDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
        self.datePicker.date = defaultDate;
    }
    [self.view addSubview:self.datePicker];
    self.navigationItem.backBarButtonItem.enabled =  NO;
    [(UIScrollView*)[self view] setScrollEnabled:NO];
    return NO;
}


@end
