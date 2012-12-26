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

@interface SearchViewController ()

@property (nonatomic) DoctorModel *chosenDoctor;
@property (nonatomic) NSArray *chosenDiscipline;
@property (nonatomic) NSInteger autocompleteIndex;

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
    
    self.autocompleteIndex = -1;
    self.allDoctors = [[NSMutableArray alloc] init];
    self.disciplines = [[NSMutableArray alloc] init];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Lade Dotorenlisten", @"LOAD DOCTORLIST")];
    [[ApiClient sharedInstance] getPath:@"disciplines.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    [SVProgressHUD dismiss];
                                    
                                    NSArray *tuple = @[@0, @"Alle Fachbereiche"];
                                    
                                    [self.disciplines addObject:tuple];
                                    
                                    //Add all Disciplines from the Backend
                                    for (id disciplineJson in response) {
                                        NSNumber *ident = [disciplineJson valueForKeyPath:@"id"];
                                        NSString *discipline = [disciplineJson valueForKeyPath:@"name"];
                                        tuple = @[ident, discipline];
                                        [self.disciplines addObject:tuple];
                                    }
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD dismiss];
                                    NSLog(@"Error fetching Disciplines!");
                                    NSLog(@"%@", error);
                                    
                                }];
    
    [[ApiClient sharedInstance] getPath:@"doctors.json" parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id response) {
                                    for (id doctorJson in response) {
                                        DoctorModel *doctorModel = [[DoctorModel alloc] initWithDictionary:doctorJson];
                                        [self.allDoctors addObject:doctorModel];
                                    }
                                    self.chosenDoctors = [[NSMutableArray alloc] initWithArray:self.allDoctors copyItems:NO];
                                    
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

- (NSString*)disciplineIdToString:(NSInteger)disciplineId {
    NSString *result;
    
    for (NSArray *tuple in self.disciplines) {
        if ([[tuple objectAtIndex:0] intValue] == disciplineId)
            result = [tuple objectAtIndex:1];
    }
    
    return result;
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

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 0) {
        NSString *postfix = @"";
        if ([searchBar.text characterAtIndex:searchBar.text.length - 1] == ' ') {
            postfix = @" ";
        }
        
        NSString *searchText = searchBar.text;
        searchText =[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSArray *userInput = [searchText componentsSeparatedByString:@" "];
        
        if (self.autocompleteIndex < 0) {
            NSString *lastWord = [userInput lastObject];
            NSString *newLastWord = [self tryToCompleteWord:lastWord];
            if (![lastWord isEqualToString:newLastWord]) {
                self.autocompleteIndex = userInput.count - 1;
            }
            
            NSMutableArray *extendedUserInput = [[NSMutableArray alloc] initWithArray:userInput];
            [extendedUserInput removeLastObject];
            [extendedUserInput addObject:newLastWord];
        
            searchBar.text = [NSString stringWithFormat:@"%@%@", [extendedUserInput componentsJoinedByString:@" "], postfix];
            userInput = extendedUserInput;
        }
        
        [self.chosenDoctors removeAllObjects];
        for (DoctorModel *doctor in self.allDoctors) {
            if ([self matchesDoctor:doctor forInput:userInput]) {
                [self.chosenDoctors addObject:doctor];
            }
        }
        
        [self.tableView reloadData];
    } else {
        [self resetDataSource];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark Private helper methods
- (void)resetDataSource {
    self.autocompleteIndex = -1;
    self.chosenDoctors = [[NSMutableArray alloc] initWithArray:self.allDoctors];
    [self.tableView reloadData];
}

- (NSString*)tryToCompleteWord:(NSString*)word {
    NSString *result;
    NSInteger count = 0;
    
    NSString *pattern = [NSString stringWithFormat:@"^%@", [word lowercaseString]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    
    for (NSArray *array in self.disciplines) {
        NSString *discipline = [array lastObject];
        NSTextCheckingResult *match = [regex firstMatchInString:[discipline lowercaseString] options:0 range:NSMakeRange(0, discipline.length) ];
        
        if (match) {
            result = discipline;
            count++;
        }
        
    }
    return count == 1 ? result : word;
}

- (BOOL) matchesDoctor:(DoctorModel*)doctor forInput:(NSArray*)input {
    
    NSMutableArray *modifiedInput = [[NSMutableArray alloc] initWithArray:input];

    if (self.autocompleteIndex > -1) {
        NSString *discipline = [modifiedInput objectAtIndex:self.autocompleteIndex];
        [modifiedInput removeObjectAtIndex:self.autocompleteIndex];
        
        if (![self matchesString:discipline withOther:doctor.discipline]) {
            return NO;
        } else if (input.count == 1) {
            return YES;
        }
    } else {
        for (NSString *word in modifiedInput) {
            if ([self matchesString:word withOther:doctor.discipline]) {
                return YES;
            }
        }
    }
    
    for (NSString *word in modifiedInput) {
        if ([self matchesString:word withOther:doctor.lastName]) {
            return YES;
        }
    }
    
    for (NSString *word in modifiedInput) {
        if ([self matchesString:word withOther:doctor.lastName]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)matchesString:(NSString*)pattern withOther:(NSString*)other {
    pattern = [NSString stringWithFormat:@"^%@", [pattern lowercaseString]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:[other lowercaseString] options:0 range:NSMakeRange(0, other.length) ];
    
    return match ? YES : NO;
}

@end


