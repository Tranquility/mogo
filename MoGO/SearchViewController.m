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
#import "MedicDetailViewController.h"

@interface SearchViewController ()

@property (nonatomic) DoctorModel *chosenDoctor;

@end

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
                                        
                                        CLLocationCoordinate2D location;
                                        location.latitude = [[doctorJson valueForKeyPath:@"latitude"] floatValue];
                                        location.longitude = [[doctorJson valueForKeyPath:@"longitude"] floatValue];
                                        
                                        AddressModel *address = [[AddressModel alloc] initWithStreet:[doctorJson valueForKeyPath:@"street"]
                                                                                        streetNumber:[[doctorJson valueForKeyPath:@"street_number"] intValue]
                                                                                             zipCode:[doctorJson valueForKeyPath:@"zip_code"]
                                                                                                city:[doctorJson valueForKeyPath:@"city"]
                                                                                          coordinate:&location];
                                        
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithId:[[doctorJson valueForKeyPath:@"id"] intValue]
                                                                                        discipline:@"Frauenarzt"
                                                                                             title:[doctorJson valueForKeyPath:@"title"]
                                                                                            gender:[doctorJson valueForKeyPath:@"gender"]
                                                                                         firstName:[doctorJson valueForKeyPath:@"firstname"]
                                                                                          lastName:[doctorJson valueForKeyPath:@"lastname"]
                                                                                              mail:[doctorJson valueForKeyPath:@"mail"]
                                                                                         telephone:[doctorJson valueForKeyPath:@"telephone"]
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
    
    cell.textLabel.text = [[NSString stringWithFormat:@"%@ %@ %@", currentDoctor.title, currentDoctor.firstName, currentDoctor.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.chosenDoctor = [self.arrayChosen objectAtIndex:indexPath.row];
    
    NSLog(@"%d", indexPath.row);
    
    [self performSegueWithIdentifier:@"toDoctorDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDoctorDetail"]) {
        MedicDetailViewController *destination = [segue destinationViewController];
        destination.doctor = self.chosenDoctor;
    }
}

@end
