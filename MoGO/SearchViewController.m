//
//  SearchViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController

@synthesize pickerView = _pickerView;
@synthesize arrayDisciplines = _arrayDisciplines;
@synthesize subView = _subView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayDisciplines = [[NSArray alloc] initWithObjects:@"Zahnarzt", @"Allgemeinarzt", @"Kinderarzt", @"Frauenarzt", nil];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - UIPickerViewDataSource/Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return [self.arrayDisciplines count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arrayDisciplines objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate method


- (IBAction) closeDisciplinePicker:(id)sender {
    self.subView.hidden = YES;
}

- (IBAction)showDisciplinePicker:(id)sender {
    self.subView.hidden = NO;
}

@end
