//
//  ProfileEditViewController.m
//  MoGO
//
//  Created by 0leschen on 07.01.13.
//
//

#import "ProfileEditViewController.h"
#import "AddressModel.h"
#import "PatientModel.h"

//constant vars for scrolling if user changes from textfield to next textfield
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HIGHT = 215;
static const CGFloat LANDSCPE_KEYBOARD_HIGHT = 140;

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.insurence = [[NSMutableArray alloc] initWithObjects:@"Allianz", @"Technische", @"Meine", nil];
    
    UIColor *grey = [UIColor colorWithRed:((float) 39.0f / 255.0f)
                                    green:((float) 40.0f / 255.0f)
                                     blue:((float) 55.0f / 255.0f)
                                    alpha:1.0f];
    
    [self.subViewDate setBackgroundColor:grey];
    [self.subView setBackgroundColor:grey];
    
    //später die insurence von benutzer
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBirthDate:nil];
    [self setPickerView:nil];
    [self setInsurence:nil];
    [self setInsurenceLabel:nil];
    [self setSubView:nil];
    [self setFirstnameText:nil];
    [self setSurenameText:nil];
    [self setPlzText:nil];
    [self setCityText:nil];
    [self setStreetText:nil];
    [self setSubViewDate:nil];
    [self setPickerDate:nil];
    [self setStreetNr:nil];
    [super viewDidUnload];
    }

//Picker Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.insurence.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.insurence objectAtIndex:row];
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    self.insurenceLabel.text = [self.insurence objectAtIndex:row];
//
//}

//Picker Action

- (IBAction)closeDisciplinePicker:(id)sender {
    self.subView.hidden = YES;
}

- (IBAction)showDisciplinePicker:(id)sender {
    self.subView.hidden = NO;
}

- (IBAction)chooseDiscipline:(id)sender {
    self.subView.hidden = YES;
    self.insurenceLabel.text = [self.insurence objectAtIndex: [self.pickerView selectedRowInComponent:0]];
}

//Date picker Action

- (IBAction)closeDatePicker:(id)sender {
    self.subViewDate.hidden = YES;
}

- (IBAction)showDatePicker:(id)sender {
    self.subViewDate.hidden = NO;
}

- (IBAction)chooseDate:(id)sender {
    self.subViewDate.hidden = YES;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.birthDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.pickerDate.date]];
}

//Keys ausblenden

- (IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

//Save Button

- (IBAction)saveProfile:(id)sender{
    AddressModel *adress = [[AddressModel alloc] initWithStreet:self.streetText.text streetNumber:[self.streetNr.text intValue] zipCode:self.plzText.text city:self.cityText.text latitude:nil longitude:nil];
    
    UIAlertView *saveProfile = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Gespeichert", @"SAVED") message:NSLocalizedString(@"Ihre Daten wurden gespeichert", @"SAVE_DATE_PROFILE") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [saveProfile show];
}

//scroll down after tabbing from textfield to next textfield below
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midLine = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midLine - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCPE_KEYBOARD_HIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

//Scroll up after leaving textField if necessarry
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

@end
