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
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface SearchViewController ()

@property (nonatomic) DoctorModel *chosenDoctor;
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSArray *chosenDoctors;
@property (nonatomic) NSArray *allDoctors;
@property (nonatomic) NSArray *disciplines;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
                                    [self.pickerView reloadAllComponents];
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD dismiss];
                                    NSLog(@"Error fetching Disciplines!");
                                    NSLog(@"%@", error);
                                    
                                }];
    
  /*  [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
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
                                    NSLog(@"Error fetching docs!");
                                    NSLog(@"%@", error);
                                    
                                }]; */
    //filling arrays
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    self.chosenDoctors = [[NSArray alloc] initWithArray:mainDelegate.allDoctors];
    self.allDoctors = [[NSArray alloc] initWithArray:mainDelegate.allDoctors];
    [SVProgressHUD dismiss];
    
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

    cell.textLabel.text = [currentDoctor fullName];

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

#pragma mark UISearchBar Delegate methods

- (void)closeKeyboard {
    [self.searchBar resignFirstResponder];
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

@end
