//
//  SearchViewController.m
//  MoGO
//
//  Created by 0schleew on 24.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "ApiClient.h"
#import "DoctorModel.h"

@implementation SearchViewController


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
    self.arrayChosen = [[NSMutableArray alloc] init];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
    
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    for (id doctorJson in response) {
                                        NSString *firstname = [doctorJson valueForKeyPath:@"firstname"];
                                        NSString *lastname = [doctorJson valueForKeyPath:@"lastname"];
                                        NSString *gender = [doctorJson valueForKeyPath:@"gender"];
                                        NSString *mail = [doctorJson valueForKeyPath:@"mail"];
                                        NSString *telephone = [doctorJson valueForKeyPath:@"telephone"];
                                        NSString *title = [doctorJson valueForKeyPath:@"title"];
                                        CLLocationCoordinate2D location;
                                        location.latitude = 1.123456;
                                        location.longitude = 6.54321;
                                        AddressModel *address = [[AddressModel alloc] initWithStreet:@"sesamstraße"
                                                                                        streetNumber:15
                                                                                             zipCode:@"123456"
                                                                                                city:@"Hamburg"
                                                                                          coordinate:&location];
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithTitle:title
                                                                                               gender:gender
                                                                                            firstName:firstname
                                                                                             lastName:lastname
                                                                                                 mail:mail
                                                                                            telephone:telephone
                                                                                              address:address];
                                        [self.arrayChosen addObject:doctorModel];
                                    }
                                    [self.tableView reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                    
                                }];
    
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
    // TOO: return discipline count
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //TODO: set discipline for current row
    return @"title";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //TODO: Set disciplines
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

- (IBAction)updateNameTextField:(id)sender {
    
    [self.arrayChosen removeAllObjects];
    
    //NSString* text = [self.doctorNameField.text lowercaseString];
    //NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:text options:0 error:NULL];
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
    
    DoctorModel *currentDoctor = [self.arrayChosen objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentDoctor.description;
    
    return cell;
}

@end
