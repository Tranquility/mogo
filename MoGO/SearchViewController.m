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
@synthesize subView = _subView;
@synthesize tableView = _tableView;
@synthesize doctorNameField = _doctorNameField;

@synthesize arrayDisciplines = _arrayDisciplines;
@synthesize arrayDentists = _arrayDentists;
@synthesize arrayPediatritians = _arrayPediatritians;
@synthesize arrayGynecologists = _arrayGynecologists;
@synthesize arrayGeneralDoctors = _arrayGeneralDoctors;
@synthesize arrayAll = _arrayAll;
@synthesize arrayChosen = _arrayChosen;



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
    self.arrayGeneralDoctors = [[NSArray alloc] initWithObjects:@"Dr. Block", @"Dr. Rauhhut", @"Dr. Kranz", nil];
    self.arrayDentists = [[NSArray alloc] initWithObjects:@"Dr. Bohr", @"Dr. Merk", @"Dr. Schmelz", nil];
    self.arrayPediatritians = [[NSArray alloc] initWithObjects:@"Dr. Hals", @"Dr. Nase", @"Dr. Ohr", nil];
    self.arrayGynecologists = [[NSArray alloc] initWithObjects:@"Dr. Sommer", @"Dr. Winter", @"Dr. Herbst", nil];
    self.arrayAll = [[NSArray alloc] initWithObjects:
                     self.arrayDentists,
                     self.arrayGeneralDoctors,
                     self.arrayPediatritians,
                     self.arrayGynecologists, nil];
    self.arrayChosen = [[NSArray alloc] init];
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

- (IBAction)closeKeyboard:(id)sender {
    [self.doctorNameField resignFirstResponder];
}

#pragma mark - UIPickerViewDataSource/Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return self.arrayDisciplines.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arrayDisciplines objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.arrayChosen = [self.arrayAll objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate method


- (IBAction)closeDisciplinePicker:(id)sender {
    self.subView.hidden = YES;
}

- (IBAction)showDisciplinePicker:(id)sender {
    self.subView.hidden = NO;
}

- (IBAction)chooseDiscipline:(id)sender {
    self.subView.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource/Delegates methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayChosen.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        NSString* CellIdentifier = @"standard";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell.
        cell.textLabel.text = [self.arrayChosen objectAtIndex:[indexPath row]];
        
        return cell;
}

@end
