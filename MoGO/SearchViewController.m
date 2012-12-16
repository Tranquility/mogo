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
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSMutableArray *doctorsForDiscipline;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    self.allDoctors = [[NSMutableArray alloc] init];
    self.disciplines = [[NSMutableArray alloc] init];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
    [[ApiClient sharedInstance] getPath:@"disciplines.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    
                                    NSArray *tuple = @[@0, @"Alle Fachbereiche"];
                                    
                                    [self.disciplines addObject:tuple];
                                    
                                    //Add all Disciplines from the Backend
                                    for (id disciplineJson in response) {
                                        NSNumber *ident = [disciplineJson valueForKeyPath:@"id"];
                                        NSString *discipline = [disciplineJson valueForKeyPath:@"name"];
                                        tuple = @[ident, discipline];
                                        [self.disciplines addObject:tuple];
                                    }
                                    [self.pickerView reloadAllComponents];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error fetching Disciplines!");
                                    NSLog(@"%@", error);
                                    
                                }];
    
    
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
                                                                            latitude:[doctorJson valueForKeyPath:@"latitude"]
                                                                           longitude:[doctorJson valueForKeyPath:@"longitude"]];
                                        
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithId:[[doctorJson valueForKeyPath:@"id"] intValue]
                                                                                        discipline:[self disciplineIdToString:[[doctorJson valueForKeyPath:@"discipline.id"] intValue]]
                                                                                             title:[doctorJson valueForKeyPath:@"title"]
                                                                                            gender:[doctorJson valueForKeyPath:@"gender"]
                                                                                         firstName:[doctorJson valueForKeyPath:@"firstname"]
                                                                                          lastName:[doctorJson valueForKeyPath:@"lastname"]
                                                                                              mail:[doctorJson valueForKeyPath:@"mail"]
                                                                                         telephone:[doctorJson valueForKeyPath:@"telephone"]
                                                                                           address:address];
                                        [self.allDoctors addObject:doctorModel];
                                    }
                                    self.chosenDoctors = [[NSMutableArray alloc] initWithArray:self.allDoctors copyItems:NO];
                                    self.doctorsForDiscipline = [[NSMutableArray alloc] initWithArray:self.allDoctors copyItems:NO];
                                    
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

- (NSString*)disciplineIdToString:(NSInteger)disciplineId {
    NSString *result;
    
    for (NSArray *tuple in self.disciplines) {
        if ([[tuple objectAtIndex:0] intValue] == disciplineId)
            result = [tuple objectAtIndex:1];
    }
    
    return result;
}

#pragma mark - UIPickerViewDataSource/Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.disciplines.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.disciplines objectAtIndex:row] objectAtIndex:1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenDiscipline = [self.disciplines objectAtIndex:row];
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
        
    if ([[self.chosenDiscipline objectAtIndex:0] intValue] == 0) {
        self.chosenDoctors = [[NSMutableArray alloc] initWithArray:self.allDoctors copyItems:NO];
    } else {
        
        
        [self.chosenDoctors removeAllObjects];
        NSString *discipline = [self.chosenDiscipline objectAtIndex:1];
        
        for (DoctorModel *doctor in self.allDoctors) {
            if ([doctor.discipline isEqualToString:discipline]) {
                [self.chosenDoctors addObject: doctor];
            }
        }
    }
    
    self.doctorsForDiscipline = [[NSMutableArray alloc] initWithArray:self.chosenDoctors copyItems:NO];
    
    [self.tableView reloadData];
}

/**
 * This reacts on keyboard input and checks the list of currently chosen doctors (all or of one discipline) if they match the input
 */
- (IBAction)updateNameTextField:(id)sender {
    
    [self.chosenDoctors removeAllObjects];
    
    NSString* text = [NSString stringWithFormat:@"^%@", [self.doctorNameField.text lowercaseString]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:text options:0 error:NULL];
    for (DoctorModel *doctor in self.doctorsForDiscipline) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", [doctor.firstName lowercaseString], [doctor.lastName lowercaseString]];
        NSTextCheckingResult *match = [regex firstMatchInString:name options:0 range:NSMakeRange(0, name.length)];
        if (match) {
            [self.chosenDoctors addObject:doctor];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource/Delegates methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chosenDoctors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* CellIdentifier = @"standard";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    DoctorModel *currentDoctor = [self.chosenDoctors objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [[NSString stringWithFormat:@"%@ %@ %@", currentDoctor.title, currentDoctor.firstName, currentDoctor.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.chosenDoctor = [self.chosenDoctors objectAtIndex:indexPath.row];
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
