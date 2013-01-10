//
//  ProfileEditViewController.m
//  MoGO
//
//  Created by 0leschen on 07.01.13.
//
//

#import "ProfileEditViewController.h"

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

-(IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

@end
