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
#import <math.h>

@interface SearchViewController ()

@property (nonatomic) DoctorModel *chosenDoctor;
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSArray *chosenDoctors;
@property (nonatomic) NSArray *allDoctors;
@property (nonatomic) NSArray *disciplines;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *userLocation;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.userLocation = [[CLLocation alloc] init];
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
    //Adding a tap recognizer to react on tap events on the screen
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    //start asking for the users location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    UIColor *grey = [UIColor colorWithRed:((float) 39.0f / 255.0f)
                                    green:((float) 40.0f / 255.0f)
                                     blue:((float) 55.0f / 255.0f)
                                    alpha:1.0f];
    
    [self.subView setBackgroundColor:grey];
    
    self.allDoctors = [[NSMutableArray alloc] init];
    self.disciplines = [[NSMutableArray alloc] init];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade alle Ärzte", @"LOAD_MEDICLIST")];
    [[ApiClient sharedInstance] getPath:@"disciplines.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    NSArray *tuple = @[@0, @"Alle Fachbereiche"];
                                    NSMutableArray *tempDisciplines = [[NSMutableArray alloc] init];
                                    
                                    [tempDisciplines addObject:tuple];
                                    
                                    //Add all Disciplines from the Backend
                                    for (id disciplineJson in response) {
                                        NSNumber *ident = [disciplineJson valueForKeyPath:@"id"];
                                        NSString *discipline = [disciplineJson valueForKeyPath:@"name"];
                                        tuple = @[ident, discipline];
                                        [tempDisciplines addObject:tuple];
                                    }
                                    
                                    self.disciplines = tempDisciplines;
                                    self.disciplineButton.enabled = YES;
                                    [self.pickerView reloadAllComponents];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:@"Verbindungsfehler"];
                                }];
    
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    
                                    NSMutableArray *tempDoctors = [[NSMutableArray alloc] init];
                                    for (id doctorJson in response) {
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                        [tempDoctors addObject:doctorModel];
                                    }
                                    self.chosenDoctors = [[NSArray alloc] initWithArray:tempDoctors];
                                    self.allDoctors = [[NSArray alloc] initWithArray:tempDoctors];
                                    
                                    [SVProgressHUD dismiss];
                                    [self.tableView reloadData];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showErrorWithStatus:@"Verbindungsfehler"];
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

#pragma mark - UIPickerViewDataSource/Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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
    [self.searchBar resignFirstResponder];
    self.subView.hidden = NO;
}

- (IBAction)chooseDiscipline:(id)sender {
    self.subView.hidden = YES;

    self.chosenDoctors = [self applyDisciplineFilter:self.chosenDiscipline forArray:self.allDoctors];
    NSString *nameFilter = self.searchBar.text;
    if (nameFilter.length > 0) {
        self.chosenDoctors = [self applyNameFilter:self.searchBar.text forArray:self.chosenDoctors];
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
    CLLocationDegrees latitude = [currentDoctor.address.latitude floatValue];
    CLLocationDegrees longitude = [currentDoctor.address.longitude floatValue];
    CLLocation *doctorLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLLocationDistance distanceInMeters = [self.userLocation distanceFromLocation:doctorLocation];
    cell.textLabel.text = [currentDoctor fullName];
    cell.detailTextLabel.text = currentDoctor.discipline;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    if(self.userLocation != nil)
    {
        if(distanceInMeters < 50)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", currentDoctor.discipline,
                                         NSLocalizedString(@"Direkt in der Nähe", @"DOCTOR_CLOSE")];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@ %@)", currentDoctor.discipline, [self formatDistance:distanceInMeters], NSLocalizedString(@"entfernt", @"DISTANCE_AWAY")];
        }
    }
    else
    {
        cell.detailTextLabel.text = currentDoctor.discipline;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueForTable:indexPath tableView:tableView];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueForTable:indexPath tableView:tableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDoctorDetail"]) {
        MedicDetailViewController *destination = [segue destinationViewController];
        destination.doctor = self.chosenDoctor;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

//Performs the segue for the click on the cell or the disclosure button
- (void)performSegueForTable:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.chosenDoctor = [self.chosenDoctors objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toDoctorDetail" sender:self];
}

#pragma mark UISearchBar Delegate methods

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.chosenDoctors = [self applyNameFilter:searchText forArray:self.allDoctors];
    self.chosenDoctors = [self applyDisciplineFilter:self.chosenDiscipline forArray:self.chosenDoctors];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.chosenDoctors = [[NSMutableArray alloc] initWithArray:self.allDoctors];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self closeDisciplinePicker:searchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark Helper methods

- (NSString*)disciplineIdToString:(NSInteger)disciplineId {
    NSString *result;
    
    for (NSArray *tuple in self.disciplines) {
        if ([[tuple objectAtIndex:0] intValue] == disciplineId)
            result = [tuple objectAtIndex:1];
    }

    return result;
}


- (NSArray*)applyNameFilter:(NSString*)text forArray:(NSArray*)array {
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSMutableArray *result = [[NSMutableArray alloc] init];

    for (DoctorModel *doctor in array) {
        for (NSString *word in words) {
            NSString* text = [NSString stringWithFormat:@"^%@", [word lowercaseString]];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:text options:0 error:NULL];
            NSTextCheckingResult *matchFirst = [regex firstMatchInString:[doctor.firstName lowercaseString] options:0 range:NSMakeRange(0, doctor.firstName.length)];
            NSTextCheckingResult *matchLast = [regex firstMatchInString:[doctor.lastName lowercaseString] options:0 range:NSMakeRange(0, doctor.lastName.length)];
            
            if (matchFirst || matchLast) {
                [result addObject:doctor];
            }
        }
    }

    return result;
}

- (NSArray*)applyDisciplineFilter:(NSArray*)discipline forArray:(NSArray*)array {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    if ([[discipline objectAtIndex:0] intValue] == 0) {
        result = [[NSMutableArray alloc] initWithArray:array];
    } else {
        NSString *disciplineString = [discipline objectAtIndex:1];
        
        for (DoctorModel *doctor in array) {
            if ([doctor.discipline isEqualToString:disciplineString]) {
                [result addObject: doctor];
            }
        }
    }

    return result;
}

- (NSString *)formatDistance:(NSInteger)distance
{
    if (distance < 1000)
        return [NSString stringWithFormat:@"%g m", roundf(distance)];
    else if(distance < 10000)
        return [NSString stringWithFormat:@"%g km", roundf(distance/100)/10];
    else
        return [NSString stringWithFormat:@"%g km", roundf(distance/1000)];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.userLocation = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        [self.locationManager stopUpdatingLocation];
        self.userLocation = currentLocation;
        
    }
}

@end
