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
    self.insurence = [[NSMutableArray alloc] init];
    [self.insurence addObject:@"Allianz"];
    [self.insurence addObject:@"Technische"];
    [self.insurence addObject:@"Meine"];
    
    [self.pickerView selectRow:1 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstName:nil];
    [self setSureName:nil];
    [self setBirthDate:nil];
    [self setPickerView:nil];
    [self setInsurence:nil];
    [self setInsurenceLabel:nil];
    [super viewDidUnload];
    }

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.insurence.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.insurence objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.insurenceLabel.text = [self.insurence objectAtIndex:row];
}


@end
